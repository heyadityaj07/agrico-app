// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';

/// P4-04 T5 F7 — resolves the SAME trusted pickup/dropoff addresses the
/// backend builds into the server-owned Uber delivery payload.
///
/// The dispatch quote must use these values verbatim, otherwise creation
/// fails closed with `409 quote_context_mismatch`. This intentionally mirrors
/// the backend fallback order (order fields → farm/customer records) and does
/// not invent a new address source.
Future<Map<String, String>> resolveUberDispatchContext(
  String orderIdOrPath,
) async {
  final orderId = _documentId(orderIdOrPath);
  if (orderId.isEmpty) {
    return const {'pickup_address': '', 'dropoff_address': ''};
  }

  final firestore = FirebaseFirestore.instance;
  final orderSnapshot = await firestore.collection('order').doc(orderId).get();
  final order = orderSnapshot.data() ?? const <String, dynamic>{};

  var pickup = _firstValue(<dynamic>[
    order['uber_pickup_address'],
    order['pickup_address'],
    order['pickupAddress'],
    order['farm_address'],
    order['farmAddress'],
    order['store_address'],
  ]);

  if (pickup == null) {
    final farm = await _readReference(order['farm_ref']);
    if (farm != null) {
      final setup = farm['SelfManagedSetup'];
      pickup = _firstValue(<dynamic>[
        farm['farm_address'],
        farm['farmAddress'],
        farm['address'],
        farm['full_address'],
        farm['fullAddress'],
        farm['location'],
        setup is Map ? setup['Address'] : null,
        setup is Map ? setup['address'] : null,
      ]);
    }
  }

  var dropoff = _firstValue(<dynamic>[
    order['uber_dropoff_address'],
    order['dropoff_address'],
    order['dropoffAddress'],
    order['delivery_address'],
    order['deliveryAddress'],
    order['customer_address'],
    order['customerAddress'],
    order['address'],
  ]);

  if (dropoff == null) {
    for (final key in const ['customer_ref', 'buyer_ref', 'user_ref']) {
      final customer = await _readReference(order[key]);
      if (customer == null) continue;
      dropoff = _firstValue(<dynamic>[
        customer['dropoff_address'],
        customer['dropoffAddress'],
        customer['delivery_address'],
        customer['deliveryAddress'],
        customer['address'],
        customer['full_address'],
        customer['fullAddress'],
        customer['location'],
      ]);
      if (dropoff != null) break;
    }
  }

  return {
    'pickup_address': pickup ?? '',
    'dropoff_address': dropoff ?? '',
  };
}

String _documentId(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return '';
  final segments = trimmed.split('/');
  return segments.isEmpty ? '' : segments.last.trim();
}

Future<Map<String, dynamic>?> _readReference(dynamic value) async {
  if (value is! DocumentReference) return null;
  final snapshot = await value.get();
  if (!snapshot.exists) return null;
  final data = snapshot.data();
  return data is Map ? Map<String, dynamic>.from(data) : null;
}

String? _firstValue(List<dynamic> values) {
  for (final value in values) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    } else if (value is num) {
      return value.toString();
    }
  }
  return null;
}
