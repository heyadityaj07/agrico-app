// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart' as actions; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'
    as functions; // Imports custom functions

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/index.dart';

const String _kCreateCheckoutOrderUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/createCheckoutOrder';
const String _kGetUberDeliveryQuoteUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/getUberDeliveryQuote';
const String _kBindCheckoutUberQuoteUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/bindCheckoutUberQuote';
const String _kCancelCheckoutOrderUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/cancelCheckoutOrder';

enum CheckoutDeliveryMethod { pickup, producer, uber }

CheckoutDeliveryMethod? tryParseCheckoutDeliveryMethod(String? raw) {
  if (raw == null) return null;
  final normalized = raw.trim().toLowerCase();
  switch (normalized) {
    case 'farmpickup':
    case 'pickup':
    case 'clickcollect':
      return CheckoutDeliveryMethod.pickup;
    case 'owndelivery':
    case 'producer':
      return CheckoutDeliveryMethod.producer;
    case 'agricoodelivery':
    case 'uber':
      return CheckoutDeliveryMethod.uber;
    default:
      return null;
  }
}

String deliveryMethodToString(CheckoutDeliveryMethod method) {
  switch (method) {
    case CheckoutDeliveryMethod.pickup:
      return 'farmpickup';
    case CheckoutDeliveryMethod.producer:
      return 'owndelivery';
    case CheckoutDeliveryMethod.uber:
      return 'agricoodelivery';
  }
}

class CartLineSnapshot {
  const CartLineSnapshot({
    required this.productId,
    required this.farmId,
    required this.quantity,
    required this.price,
    this.minWeight,
    this.maxWeight,
    this.isVariableWeight = false,
  });

  final String productId;
  final String farmId;
  final int quantity;
  final double price;
  final double? minWeight;
  final double? maxWeight;
  final bool isVariableWeight;

  String? get weightBracket =>
      (minWeight != null && maxWeight != null) ? '$minWeight-$maxWeight' : null;

  Map<String, dynamic>? get weightBracketObject {
    if (minWeight == null || maxWeight == null) return null;
    return {
      'minWeight': minWeight,
      'maxWeight': maxWeight,
    };
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'farmId': farmId,
        'quantity': quantity,
        'price': price,
        if (minWeight != null) 'minWeight': minWeight,
        if (maxWeight != null) 'maxWeight': maxWeight,
        'isVariableWeight': isVariableWeight,
      };

  factory CartLineSnapshot.fromMap(Map<String, dynamic> map) {
    double? minW = (map['minWeight'] ?? map['min_weight']) as double?;
    double? maxW = (map['maxWeight'] ?? map['max_weight']) as double?;
    if (minW == null && maxW == null && map['weightBracket'] is String) {
      final parts = (map['weightBracket'] as String).split('-');
      if (parts.length == 2) {
        minW = double.tryParse(parts[0]);
        maxW = double.tryParse(parts[1]);
      }
    }
    return CartLineSnapshot(
      productId: map['productId'] as String? ?? '',
      farmId: map['farmId'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      minWeight: minW,
      maxWeight: maxW,
      isVariableWeight: map['isVariableWeight'] as bool? ?? false,
    );
  }

  factory CartLineSnapshot.fromCartRecord(CartRecord record) {
    final productRef = record.productRef;
    final productId = productRef?.id ?? '';
    final farmRef = record.farmRef;
    final farmId = farmRef?.id ?? '';
    return CartLineSnapshot(
      productId: productId,
      farmId: farmId,
      quantity: record.quantity,
      price: record.pricePerProduct,
      minWeight: record.hasMinWeight() && record.minWeight > 0
          ? record.minWeight
          : null,
      maxWeight: record.hasMaxWeight() && record.maxWeight > 0
          ? record.maxWeight
          : null,
      isVariableWeight: record.isVariableWeight,
    );
  }
}

class CheckoutAttempt {
  CheckoutAttempt({
    required this.checkoutRequestId,
    this.orderId,
    this.quoteId,
    required this.cartLines,
    required this.phase,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
  });

  final String checkoutRequestId;
  final String? orderId;
  final String? quoteId;
  final List<CartLineSnapshot> cartLines;
  final String phase;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;

  CheckoutAttempt copyWith({
    String? orderId,
    String? quoteId,
    String? phase,
    DateTime? updatedAt,
    DateTime? expiresAt,
  }) =>
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        orderId: orderId ?? this.orderId,
        quoteId: quoteId ?? this.quoteId,
        cartLines: cartLines,
        phase: phase ?? this.phase,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
        expiresAt: expiresAt ?? this.expiresAt,
      );

  Map<String, dynamic> toMap() => {
        'checkoutRequestId': checkoutRequestId,
        if (orderId != null) 'orderId': orderId,
        if (quoteId != null) 'quoteId': quoteId,
        'cartLines': cartLines.map((e) => e.toMap()).toList(),
        'phase': phase,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      };

  factory CheckoutAttempt.fromMap(Map<String, dynamic> map) => CheckoutAttempt(
        checkoutRequestId: map['checkoutRequestId'] as String? ?? '',
        orderId: map['orderId'] as String?,
        quoteId: map['quoteId'] as String?,
        cartLines: ((map['cartLines'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map(CartLineSnapshot.fromMap)
            .toList(),
        phase: map['phase'] as String? ?? 'created',
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
        expiresAt: map['expiresAt'] != null
            ? DateTime.tryParse(map['expiresAt'] as String)
            : null,
      );
}

class SharedPreferencesCheckoutAttemptStore {
  SharedPreferencesCheckoutAttemptStore({required this.ownerUid});
  final String ownerUid;

  String get _key => 'agrico_checkout_attempt_$ownerUid';

  Future<CheckoutAttempt?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return CheckoutAttempt.fromMap(map);
      }
    } catch (_) {}
    return null;
  }

  Future<void> save(CheckoutAttempt attempt) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(attempt.toMap()));
    } catch (_) {}
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}

Future<void> clearPurchasedCartLines({
  required DocumentReference userRef,
  required List<CartLineSnapshot> purchasedLines,
}) async {
  if (purchasedLines.isEmpty) return;

  final cartSnap = await userRef.collection('cart').get();
  final cartCollectionDocs = cartSnap.docs.isNotEmpty
      ? cartSnap.docs
      : (await userRef.collection('Cart').get()).docs;
  if (cartCollectionDocs.isEmpty) return;

  final remainingToDelete = List<CartLineSnapshot>.from(purchasedLines);
  final batch = FirebaseFirestore.instance.batch();
  var batchCount = 0;

  for (final doc in cartCollectionDocs) {
    final data = doc.data();
    final productRef =
        (data['productRef'] ?? data['Product']) as DocumentReference?;
    final productId = productRef?.id ?? '';
    final quantity =
        ((data['quantity'] ?? data['Quantity']) as num?)?.toInt() ?? 0;
    final minWeight = (data['min_weight'] as num?)?.toDouble();
    final maxWeight = (data['max_weight'] as num?)?.toDouble();

    final matchIndex = remainingToDelete.indexWhere((p) {
      if (p.productId != productId) return false;
      if (p.minWeight != minWeight || p.maxWeight != maxWeight) return false;
      return p.quantity == quantity;
    });

    if (matchIndex >= 0) {
      batch.delete(doc.reference);
      batchCount++;
      remainingToDelete.removeAt(matchIndex);
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }
}

/// FlutterFlow Custom Action for Checkout v1 Payment.
/// Self-contained, resilient to retries, zero writes to protected fields.
Future<void> startCheckoutPayment(
  BuildContext context,
  FarmsRecord farm,
  List<CartRecord> selectedCart,
  DeliveryAdressStruct? selectedAddress,
  String? deliveryMethod,
  String? selectedDeliveryTime,
  double? tip,
  String? note,
  String? voucherCode,
) async {
  final userRef = currentUserReference;
  if (userRef == null) {
    _showToast(context, 'Please sign in again to complete checkout.');
    return;
  }

  final parsedMethod =
      tryParseCheckoutDeliveryMethod(deliveryMethod ?? 'farmpickup');
  if (parsedMethod == null) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Please select a delivery method before paying.',
        frText: 'Veuillez sélectionner un mode de livraison avant de payer.',
      ),
    );
    return;
  }

  // Validate farm supports selected method
  final supportsMethod = switch (parsedMethod) {
    CheckoutDeliveryMethod.pickup => farm.selfManagedSetup.clickCollect,
    CheckoutDeliveryMethod.producer => farm.doyouofferyourowndeliveryservice &&
        farm.selfManagedSetup.ownDelivery,
    CheckoutDeliveryMethod.uber => farm.agricooDelivery,
  };

  if (!supportsMethod) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'This delivery method is not available for this farm.',
        frText: "Ce mode de livraison n'est pas disponible pour cette ferme.",
      ),
    );
    return;
  }

  // Address check for delivery methods
  if (parsedMethod != CheckoutDeliveryMethod.pickup) {
    if (selectedAddress == null ||
        selectedAddress.streetAdress.trim().isEmpty) {
      _showToast(
        context,
        FFLocalizations.of(context).getVariableText(
          enText: 'Please select a valid delivery address before paying.',
          frText:
              'Veuillez sélectionner une adresse de livraison valide avant de payer.',
        ),
      );
      return;
    }
  }

  // Validate live cart from Firestore
  final liveCartSnapshot = await queryCartRecordOnce(parent: userRef);
  if (liveCartSnapshot.isEmpty) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Your cart is empty.',
        frText: 'Votre panier est vide.',
      ),
    );
    return;
  }

  final farmId = farm.reference.id;
  final farmCartItems = liveCartSnapshot.where((item) {
    return item.farmRef?.id == farmId;
  }).toList();

  if (farmCartItems.isEmpty) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'No items in cart for this farm.',
        frText: 'Aucun article dans le panier pour cette ferme.',
      ),
    );
    return;
  }

  final cartLines = farmCartItems.map(CartLineSnapshot.fromCartRecord).toList();

  final store = SharedPreferencesCheckoutAttemptStore(ownerUid: userRef.id);
  final existingAttempt = await store.load();

  // Determine checkoutRequestId: reuse if same cart lines and unexpired
  String checkoutRequestId;
  String? existingOrderId;
  if (existingAttempt != null &&
      _sameCartLines(existingAttempt.cartLines, cartLines)) {
    checkoutRequestId = existingAttempt.checkoutRequestId;
    existingOrderId = existingAttempt.orderId;
  } else {
    checkoutRequestId = const Uuid().v4();
    await store.save(
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        cartLines: cartLines,
        phase: 'created',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  final user = FirebaseAuth.instance.currentUser;
  final idToken = await user?.getIdToken(true);
  if (idToken == null || idToken.isEmpty) {
    _showToast(context, 'Authentication required. Please sign in again.');
    return;
  }

  final languageCode = FFLocalizations.of(context).languageCode;
  final currency = languageCode.toLowerCase().startsWith('fr') ? 'EUR' : 'USD';

  // 1. Create or Recover Checkout Order via Cloud Function
  String orderId;
  int? orderExpiresAtMs;
  if (existingOrderId != null && existingOrderId.isNotEmpty) {
    orderId = existingOrderId;
  } else {
    final deliveryPayload = <String, dynamic>{
      'method': deliveryMethodToString(parsedMethod),
      if (selectedDeliveryTime != null && selectedDeliveryTime.isNotEmpty)
        'time': selectedDeliveryTime,
      if (tip != null && tip > 0) 'tip': tip,
      if (parsedMethod != CheckoutDeliveryMethod.pickup &&
          selectedAddress != null)
        'address': {
          'fullName': selectedAddress.fullName,
          'contact_name': selectedAddress.fullName,
          'streetAddress': selectedAddress.streetAdress,
          'address': selectedAddress.streetAdress,
          'city': selectedAddress.city,
          'state': selectedAddress.state,
          'postalCode': selectedAddress.postalCode,
          'zip_code': selectedAddress.postalCode,
          'phoneNo': selectedAddress.phoneNo,
          'contact_phone': selectedAddress.phoneNo,
          if (selectedAddress.instruction.trim().isNotEmpty)
            'instruction': selectedAddress.instruction.trim(),
          if (selectedAddress.location != null)
            'latLng': {
              'latitude': selectedAddress.location!.latitude,
              'longitude': selectedAddress.location!.longitude,
            },
        },
    };

    final orderRequestPayload = {
      'checkoutRequestId': checkoutRequestId,
      'farmId': farmId,
      'currency': currency,
      'delivery': deliveryPayload,
      'items': cartLines
          .map((line) => {
                'productId': line.productId,
                'quantity': line.quantity,
                if (line.weightBracketObject != null)
                  'weightBracket': line.weightBracketObject,
              })
          .toList(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      if (voucherCode != null && voucherCode.trim().isNotEmpty)
        'voucherCode': voucherCode.trim(),
    };

    final createResponse = await http
        .post(
          Uri.parse(_kCreateCheckoutOrderUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode(orderRequestPayload),
        )
        .timeout(const Duration(seconds: 30));

    final dynamic body = jsonDecode(createResponse.body);
    if (createResponse.statusCode != 200 || body is! Map) {
      final err = body is Map ? body['error']?.toString() : null;
      print('Checkout order creation failed: $err');
      _showToast(
        context,
        err ?? 'Checkout order creation failed. Please retry.',
      );
      return;
    }

    orderId = body['orderId'] as String? ?? '';
    if (orderId.isEmpty) {
      _showToast(context, 'Invalid order returned by checkout service.');
      return;
    }

    orderExpiresAtMs = (body['reservation']?['expiresAtMs'] as num?)?.toInt();
    await store.save(
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        orderId: orderId,
        cartLines: cartLines,
        phase: 'awaitingPayment',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: orderExpiresAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(orderExpiresAtMs)
            : null,
      ),
    );

    // Ensure the order document is committed and visible in Firestore before proceeding
    for (var i = 0; i < 10; i++) {
      try {
        final orderDocSnap = await OrderRecord.collection.doc(orderId).get();
        if (orderDocSnap.exists) {
          break;
        }
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  // 2. Uber Quote & Binding if applicable
  String? boundQuoteId;
  if (parsedMethod == CheckoutDeliveryMethod.uber) {
    try {
      final pickupAddress = farm.farmAddress;
      final dropoffAddress = selectedAddress?.streetAdress ?? '';

      final quoteResponse = await http
          .post(
            Uri.parse(_kGetUberDeliveryQuoteUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode({
              'orderId': orderId,
              'pickup_address': pickupAddress,
              'dropoff_address': dropoffAddress,
            }),
          )
          .timeout(const Duration(seconds: 25));

      final dynamic quoteBody = jsonDecode(quoteResponse.body);
      final quoteId = quoteBody is Map
          ? (quoteBody['quote']?['id'] as String? ?? quoteBody['id'] as String?)
          : null;

      if (quoteId != null && quoteId.isNotEmpty) {
        final bindResponse = await http
            .post(
              Uri.parse(_kBindCheckoutUberQuoteUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $idToken',
              },
              body: jsonEncode({
                'orderId': orderId,
                'quoteId': quoteId,
              }),
            )
            .timeout(const Duration(seconds: 25));

        final dynamic bindBody = jsonDecode(bindResponse.body);
        if (bindResponse.statusCode == 200 &&
            bindBody is Map &&
            bindBody['bound'] == true) {
          boundQuoteId = quoteId;
        }
      }
    } catch (_) {}
  }
  // 3. Present Stripe PaymentSheet
  final paymentResult = await actions.flutterStripeDirect(
    context,
    null,
    orderId,
    null,
    languageCode,
    null,
    null,
    false,
    true,
    boundQuoteId,
  );

  if (paymentResult != 'success') {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Payment cancelled or incomplete. Your reservation is held.',
        frText:
            'Paiement annulé ou incomplet. Votre réservation est conservée.',
      ),
    );
    return;
  }

  // 4. Polling for Backend Confirmation (`checkout_state == payment_confirmed`)
  var dialogOpen = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              FFLocalizations.of(context).getVariableText(
                enText: 'Confirming your payment...',
                frText: 'Confirmation de votre paiement...',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    ),
  ).then((_) => dialogOpen = false);

  var confirmed = false;
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < const Duration(seconds: 45)) {
    try {
      final doc = await OrderRecord.collection.doc(orderId).get();
      if (doc.exists) {
        final data = doc.data();
        final checkoutState =
            data is Map ? (data['checkout_state'] as String?)?.trim() : null;
        final status = data is Map ? (data['status'] as String?)?.trim() : null;
        final isPaid = data is Map ? (data['isPaid'] as bool?) ?? false : false;
        if (checkoutState == 'payment_confirmed' ||
            status == 'paid' ||
            status == 'confirmed' ||
            isPaid == true) {
          confirmed = true;
          break;
        }
      }
    } catch (_) {}
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  if (dialogOpen && Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  if (confirmed) {
    await store.clear();
    final orderRef = OrderRecord.collection.doc(orderId);
    FFAppState().orderdocument = orderRef;

    if (context.mounted) {
      context.goNamed(
        CheckoutfinalWidget.routeName,
        queryParameters: {
          'orderRef': serializeParam(orderRef, ParamType.DocumentReference),
        }.withoutNulls,
      );
    }

    // Delay cart cleanup so navigation transition to CheckoutfinalWidget completes
    // cleanly before cart documents are deleted from Firestore.
    Future.delayed(const Duration(milliseconds: 1200), () {
      clearPurchasedCartLines(
        userRef: userRef,
        purchasedLines: cartLines,
      ).catchError((_) {});
    });
  } else {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText:
            'Payment submitted — awaiting confirmation. Your cart is preserved.',
        frText:
            'Paiement soumis — en attente de confirmation. Votre panier est conservé.',
      ),
    );
  }
}

bool _sameCartLines(List<CartLineSnapshot> a, List<CartLineSnapshot> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].productId != b[i].productId ||
        a[i].quantity != b[i].quantity ||
        a[i].minWeight != b[i].minWeight ||
        a[i].maxWeight != b[i].maxWeight) {
      return false;
    }
  }
  return true;
}

void _showToast(BuildContext context, String message) {
  print('Checkout Payment Toast: $message');
  toast(
    context,
    message,
    FlutterFlowTheme.of(context).primarytheme,
  );
}
