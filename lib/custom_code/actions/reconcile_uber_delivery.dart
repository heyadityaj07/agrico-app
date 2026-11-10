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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const String _kReconcileFunctionUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/reconcileUberDelivery';

/// P4-04 T5 F8 — authenticated reconciliation of an uncertain/stale Uber
/// dispatch claim.
///
/// This is intentionally a manual operator/producer recovery action. It must
/// not be auto-called after an ambiguous create; a producer retry affordance
/// or P4-05 admin visibility owns when it is invoked.
///
/// Returns one of:
///   `reconciled` — Uber state was found and applied;
///   `notFound`   — no matching Uber delivery exists;
///   `blocked`    — nothing to reconcile / not the order producer;
///   `''`         — network, auth or ambiguous response; no UI success claim.
Future<String> reconcileUberDelivery(
  String orderIdOrPath, {
  String? deliveryId,
}) async {
  final orderId = _documentId(orderIdOrPath);
  if (orderId.isEmpty) return '';

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) return '';

    final response = await http
        .post(
          Uri.parse(_kReconcileFunctionUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'orderId': orderId,
            if (deliveryId != null && deliveryId.trim().isNotEmpty)
              'deliveryId': deliveryId.trim(),
          }),
        )
        .timeout(const Duration(seconds: 30));

    final body = _decodeJson(response.body);
    if (response.statusCode == 200 && body is Map) {
      if (body['reconciled'] == true) return 'reconciled';
    }

    // The backend communicates definite non-reconciled outcomes with error
    // codes, not boolean flags. Map only the contract-proven codes; anything
    // else (5xx/timeout/malformed body) stays ambiguous.
    final code = body is Map ? body['code']?.toString() : null;
    switch (code) {
      case 'delivery_not_found':
      case 'not_found':
        return 'notFound';
      case 'order_id_required':
      case 'order_not_found':
      case 'order_forbidden':
      case 'farm_unavailable':
      case 'farm_not_found':
      case 'producer_unavailable':
      case 'dispatch_claim_timestamp_unavailable':
      case 'dispatch_in_progress':
      case 'reconciliation_in_progress':
      case 'delivery_id_mismatch':
      case 'delivery_id_unavailable':
      case 'delivery_reconciliation_rejected':
      case 'delivery_order_mismatch':
      case 'delivery_quote_mismatch':
      case 'delivery_order_unverified':
        return 'blocked';
    }
    return '';
  } catch (_) {
    return '';
  }
}

String _documentId(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return '';
  final segments = trimmed.split('/');
  return segments.isEmpty ? '' : segments.last.trim();
}

dynamic _decodeJson(String body) {
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}
