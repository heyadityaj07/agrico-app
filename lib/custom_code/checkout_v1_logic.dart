/// Shared, FlutterFlow-reproducible checkout-v1 logic.
///
/// Single source of truth for everything BOTH checkout custom actions need:
/// the delivery-method mapping (F3/F4), the persisted checkout attempt
/// (model + SharedPreferences store), the cart-cleanup contract, the Uber
/// bound-quote recovery classifier (F2) and the response acceptance rules
/// (F1). The two custom actions (`startCheckoutPayment`,
/// `resumeInterruptedCheckout`) import this file — there are no duplicated
/// stores, serializers or conflicting checkout state.
///
/// This file deliberately imports ONLY: cloud_firestore, http,
/// shared_preferences and dart:convert — never `flutter_flow_util`,
/// `backend.dart` or the app barrel — so it stays unit-testable and
/// FlutterFlow-custom-code friendly. Thin adapters that convert FlutterFlow
/// schema types (CartRecord, DeliveryAdressStruct) live in the actions.
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String kCreateCheckoutOrderUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/createCheckoutOrder';
const String kGetUberDeliveryQuoteUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/getUberDeliveryQuote';
const String kBindCheckoutUberQuoteUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/bindCheckoutUberQuote';
const String kCancelCheckoutOrderUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/cancelCheckoutOrder';

enum CheckoutDeliveryMethod { pickup, producer, uber }

CheckoutDeliveryMethod? tryParseCheckoutDeliveryMethod(String? raw) {
  if (raw == null) return null;
  final normalized = raw.trim().toLowerCase();
  print('tryParseCheckoutDeliveryMethod: raw="$raw" normalized="$normalized"');
  switch (normalized) {
    case 'farmpickup':
      return CheckoutDeliveryMethod.pickup;
    // F4: the checkout UI represents Producer-managed Delivery as
    // 'delivery' (checkout_widget delivery tile). It must parse to the
    // producer method; it must never fall through as unknown.
    case 'delivery':
      return CheckoutDeliveryMethod.producer;

    case 'uber':
    case 'uberdirect':
      return CheckoutDeliveryMethod.uber;
    default:
      return null;
  }
}

/// F3: the only wire values accepted by the checkout-v1 backend
/// (`DELIVERY_METHOD_ALIASES` → persisted `delievry_method`).
/// 'owndelivery' / 'agricoodelivery' are NOT accepted by the backend.
String deliveryMethodToString(CheckoutDeliveryMethod method) {
  switch (method) {
    case CheckoutDeliveryMethod.pickup:
      return 'farmpickup';
    case CheckoutDeliveryMethod.producer:
      return 'delivery';
    case CheckoutDeliveryMethod.uber:
      return 'uber';
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
    // F5: checkout identity/context. Nullable for backward compatibility with
    // attempts persisted before these fields existed (legacy entries are
    // reconciled against the server order instead of being trusted).
    this.farmId,
    this.currency,
    this.deliveryMethod,
    this.addressKey,
    this.deliveryTime,
    // F7: set when the customer (or reconciliation) requested cancellation
    // that has not been confirmed completed yet.
    this.cancelRequested = false,
  });

  final String checkoutRequestId;
  final String? orderId;
  final String? quoteId;
  final List<CartLineSnapshot> cartLines;
  final String phase;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final String? farmId;
  final String? currency;
  final String? deliveryMethod;
  final String? addressKey;
  final String? deliveryTime;
  final bool cancelRequested;

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
        if (farmId != null) 'farmId': farmId,
        if (currency != null) 'currency': currency,
        if (deliveryMethod != null) 'deliveryMethod': deliveryMethod,
        if (addressKey != null) 'addressKey': addressKey,
        if (deliveryTime != null) 'deliveryTime': deliveryTime,
        'cancelRequested': cancelRequested,
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
        // Legacy attempts may not carry the context fields; null means
        // "unknown" and callers must reconcile against the server order.
        farmId: map['farmId'] as String?,
        currency: map['currency'] as String?,
        deliveryMethod: map['deliveryMethod'] as String?,
        addressKey: map['addressKey'] as String?,
        deliveryTime: map['deliveryTime'] as String?,
        cancelRequested: map['cancelRequested'] as bool? ?? false,
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

// ---------------------------------------------------------------------------
// F2 — structured recovery of an already-bound Uber quote.
//
// Mirrors the backend checkout-v1 lifecycle semantics (Batch 8A):
//   - payment initiation state uses the same three signals the backend's
//     `paymentInitiationState` uses: `payment_intent_creation_pending`,
//     `payment_intent_id`, `payment_state`;
//   - a bound quote is usable only while unexpired and associated with this
//     exact order;
//   - an expired bound quote is immutable and can never be re-quoted; the
//     caller must reconcile via the cancellation endpoint (which is safe and
//     server-verified) before any new attempt.
// ---------------------------------------------------------------------------
enum CheckoutQuoteRecoveryOutcome {
  recovered,
  noBoundQuote,
  expired,
  paymentInitiated,
  orderInvalid,
  readFailed,
}

class CheckoutQuoteRecovery {
  const CheckoutQuoteRecovery({
    required this.outcome,
    this.quoteId,
    this.checkoutState,
    this.quoteExpired = false,
  });

  final CheckoutQuoteRecoveryOutcome outcome;

  /// Quote ID when a bound quote exists on the order (recovered/
  /// paymentInitiated cases).
  final String? quoteId;

  /// Persisted `checkout_state` of the order, when readable.
  final String? checkoutState;

  /// True when a bound quote exists but has expired.
  final bool quoteExpired;

  bool get hasQuoteId => quoteId != null && quoteId!.trim().isNotEmpty;
}

/// Pure classifier over the raw order document data so the decision logic is
/// unit-testable without Firestore.
CheckoutQuoteRecovery classifyCheckoutQuoteRecovery({
  required Map<String, dynamic>? orderData,
  required String orderId,
  required DateTime now,
}) {
  if (orderData == null) {
    return CheckoutQuoteRecovery(
        outcome: CheckoutQuoteRecoveryOutcome.readFailed);
  }
  if (orderData.isEmpty) {
    // Document does not exist.
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.orderInvalid,
    );
  }

  // Checkout-v1 + Uber Direct only. Anything else must not be resumed as an
  // Uber checkout (this also guards against delivery-method changes).
  if (orderData['checkout_flow_version'] != 1 ||
      orderData['is_agrico_deliver'] != true) {
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.orderInvalid,
      checkoutState: orderData['checkout_state'] as String?,
    );
  }

  final checkoutState =
      (orderData['checkout_state'] as String?)?.trim().toLowerCase() ?? '';

  // Payment-initiation semantics — identical to the backend's
  // `paymentInitiationState` (bindCheckoutUberQuoteHandler.js:93-104).
  final creationPending = orderData['payment_intent_creation_pending'] == true;
  final intentId = (orderData['payment_intent_id'] as String?)?.trim() ?? '';
  final paymentState =
      (orderData['payment_state'] as String?)?.trim().toLowerCase() ?? '';
  final paymentInitiated =
      creationPending || intentId.isNotEmpty || paymentState.isNotEmpty;

  final quoteId = (orderData['uber_quote_id'] as String?)?.trim() ?? '';
  final quoteOrderId =
      (orderData['uber_quote_order_id'] as String?)?.trim() ?? '';
  final quoteState =
      (orderData['uber_quote_state'] as String?)?.trim().toLowerCase() ?? '';

  if (paymentInitiated) {
    // Determine whether the bound quote (if any) is still usable so the
    // caller can distinguish a resumable payment (valid quote → the
    // idempotent payment endpoint reuses the existing intent) from one whose
    // only safe path is the backend cancellation endpoint.
    bool quoteUsable = false;
    if (quoteState == 'bound' &&
        quoteId.isNotEmpty &&
        quoteOrderId == orderId) {
      final expiryRaw = orderData['uber_quote_expires_at'];
      DateTime? expiry;
      if (expiryRaw is Timestamp) expiry = expiryRaw.toDate();
      if (expiryRaw is DateTime) expiry = expiryRaw;
      quoteUsable = expiry != null && expiry.isAfter(now);
    }
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.paymentInitiated,
      quoteId: quoteId.isEmpty ? null : quoteId,
      checkoutState: checkoutState,
      quoteExpired: !quoteUsable,
    );
  }

  // Refund/reconciliation lifecycles are never resumable as payments.
  if (checkoutState == 'refund_pending' ||
      checkoutState == 'refunded' ||
      checkoutState == 'reconciliation_required') {
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.orderInvalid,
      checkoutState: checkoutState,
    );
  }

  if (quoteState != 'bound' || quoteId.isEmpty) {
    // Normal pre-binding state for a fresh Uber order.
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.noBoundQuote,
      checkoutState: checkoutState,
    );
  }

  if (quoteOrderId != orderId) {
    // Inconsistent server state: stop, never bind/quote over it.
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.orderInvalid,
      quoteId: quoteId,
      checkoutState: checkoutState,
    );
  }

  final expiryRaw = orderData['uber_quote_expires_at'];
  DateTime? expiry;
  if (expiryRaw is Timestamp) expiry = expiryRaw.toDate();
  if (expiryRaw is DateTime) expiry = expiryRaw;
  final expired = expiry == null || !expiry.isAfter(now);

  if (expired) {
    return CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.expired,
      quoteId: quoteId,
      checkoutState: checkoutState,
      quoteExpired: true,
    );
  }

  return CheckoutQuoteRecovery(
    outcome: CheckoutQuoteRecoveryOutcome.recovered,
    quoteId: quoteId,
    checkoutState: checkoutState,
  );
}

/// Reads the order document and classifies its bound-quote state (F2).
/// Uses the plain `order` collection (identical to `OrderRecord.collection`)
/// so this module does not depend on the generated schema barrels.
Future<CheckoutQuoteRecovery> recoverCheckoutQuoteState(String orderId) async {
  try {
    final snap =
        await FirebaseFirestore.instance.collection('order').doc(orderId).get();
    if (!snap.exists) {
      return const CheckoutQuoteRecovery(
        outcome: CheckoutQuoteRecoveryOutcome.orderInvalid,
      );
    }
    final dynamic raw = snap.data();
    if (raw is! Map) {
      return const CheckoutQuoteRecovery(
        outcome: CheckoutQuoteRecoveryOutcome.readFailed,
      );
    }
    return classifyCheckoutQuoteRecovery(
      orderData: Map<String, dynamic>.from(raw),
      orderId: orderId,
      now: DateTime.now(),
    );
  } catch (e) {
    print('recoverCheckoutQuoteState error for order $orderId: $e');
    return const CheckoutQuoteRecovery(
      outcome: CheckoutQuoteRecoveryOutcome.readFailed,
    );
  }
}

// ---------------------------------------------------------------------------
// F5 — checkout context comparison.
//
// The server order document is the source of truth: the current selection is
// compared against the persisted order fields (`delievry_method`,
// `delievry_address`, `delievry_time`, `currency`, `farm_ref` and
// `order_items`). This also handles legacy persisted attempts that predate
// the local context fields, and prevents an order created under one delivery
// method from being reused after the customer changes the method.
// ---------------------------------------------------------------------------

/// C2 — canonical address-part normalization. The backend collapses internal
/// whitespace and trims when persisting address text (`normalizeText` in
/// `utils/checkoutOrder.js`), so the client comparison must apply the same
/// normalization (plus case-insensitivity) or equivalent addresses can be
/// misjudged as changed, causing unnecessary cancel/recreate cycles.
String normalizeAddressPart(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}

/// Normalizes a whole `street|city|postal` composite key part-wise so the
/// persisted (backend-normalized) address and the current selection compare
/// equal when only whitespace/casing differs.
String normalizeAddressKey(String key) {
  return key.split('|').map(normalizeAddressPart).join('|');
}

String _normalizeContextValue(String? value) => value?.trim() ?? '';

/// True when the current checkout selection still matches the persisted
/// order (and the captured cart lines still match the order items).
bool checkoutAttemptMatchesOrder({
  required Map<String, dynamic>? orderData,
  required String orderId,
  required String farmId,
  required String deliveryMethod,
  required String currency,
  required String addressKey,
  required String deliveryTime,
  required List<CartLineSnapshot> cartLines,
}) {
  if (orderData == null || orderData.isEmpty) return false;

  final farmRef = orderData['farm_ref'];
  final orderFarmId = farmRef is DocumentReference ? farmRef.id : null;
  if (orderFarmId != farmId) return false;

  final orderMethod =
      _normalizeContextValue(orderData['delievry_method'] as String?);
  if (orderMethod != _normalizeContextValue(deliveryMethod)) return false;

  final orderCurrency =
      _normalizeContextValue(orderData['currency'] as String?).toUpperCase();
  if (orderCurrency != _normalizeContextValue(currency).toUpperCase()) {
    return false;
  }

  // Address: compare the persisted struct's text against the current key,
  // both normalized the same way (C2) — whitespace collapsed and
  // case-insensitive — so equivalent addresses never look changed.
  final addressStruct = orderData['delievry_address'];
  String orderAddressKey = '';
  if (addressStruct is Map) {
    final street = _normalizeContextValue((addressStruct['street_adress'] ??
        addressStruct['streetAddress'] ??
        '') as String?);
    final city = _normalizeContextValue(addressStruct['city'] as String?);
    final postal =
        _normalizeContextValue(addressStruct['postal_code'] as String?);
    orderAddressKey = [street, city, postal].join('|');
  }
  if (normalizeAddressKey(orderAddressKey) != normalizeAddressKey(addressKey)) {
    return false;
  }

  // Delivery time is optional on both sides; empty matches empty/absent.
  final orderTime =
      _normalizeContextValue(orderData['delievry_time'] as String?);
  if (orderTime != _normalizeContextValue(deliveryTime)) return false;

  // Cart lines vs persisted order items: every persisted item must match one
  // captured line (product, quantity, bracket) and vice versa. Lines are
  // matched one-to-one because several lines may share a product ID with
  // different brackets.
  final rawItems = orderData['order_items'];
  if (rawItems is! List || rawItems.length != cartLines.length) return false;
  final consumed = List<bool>.filled(cartLines.length, false);
  for (final item in rawItems) {
    if (item is! Map) return false;
    final productRef = item['product_ref'];
    final productId = productRef is DocumentReference ? productRef.id : '';
    final quantity = (item['total_items'] as num?)?.toInt();
    final itemVariable = item['is_variable_weight'] == true;
    final minW = itemVariable ? (item['min_weight'] as num?)?.toDouble() : null;
    final maxW = itemVariable ? (item['max_weight'] as num?)?.toDouble() : null;

    var matchIndex = -1;
    for (var i = 0; i < cartLines.length; i++) {
      if (consumed[i]) continue;
      final line = cartLines[i];
      if (line.productId != productId || line.quantity != quantity) continue;
      if (itemVariable != line.isVariableWeight) continue;
      if (itemVariable && (line.minWeight != minW || line.maxWeight != maxW)) {
        continue;
      }
      matchIndex = i;
      break;
    }
    if (matchIndex < 0) return false;
    consumed[matchIndex] = true;
  }
  return consumed.every((c) => c);
}

/// True when a locally persisted attempt (without an order yet) matches the
/// current selection. Legacy attempts without context fields return true so
/// the idempotency request ID is preserved; the backend rejects a conflicting
/// replay (`checkout_request_conflict`) instead of creating a wrong order.
bool checkoutAttemptMatchesRequest({
  required CheckoutAttempt? attempt,
  required String farmId,
  required String deliveryMethod,
  required String currency,
  required String addressKey,
  required String deliveryTime,
  required List<CartLineSnapshot> cartLines,
}) {
  if (attempt == null) return false;
  // The cart must be unchanged as well: the checkout request ID is bound to
  // the exact request hash server-side (`checkout_request_conflict` on a
  // replay with a different payload), so a changed cart can never reuse a
  // request ID that has not produced an order yet.
  if (!checkoutCartLinesMatch(attempt.cartLines, cartLines)) return false;
  final hasContext = attempt.farmId != null || attempt.deliveryMethod != null;
  if (!hasContext) return true;
  return _normalizeContextValue(attempt.farmId) ==
          _normalizeContextValue(farmId) &&
      _normalizeContextValue(attempt.deliveryMethod) ==
          _normalizeContextValue(deliveryMethod) &&
      _normalizeContextValue(attempt.currency).toUpperCase() ==
          _normalizeContextValue(currency).toUpperCase() &&
      _normalizeContextValue(attempt.addressKey) ==
          _normalizeContextValue(addressKey) &&
      _normalizeContextValue(attempt.deliveryTime) ==
          _normalizeContextValue(deliveryTime);
}

/// Order-insensitive one-to-one cart-line comparison (product, quantity,
/// weight bracket). Cart documents come back from Firestore queries whose
/// ordering is not guaranteed to be stable between presses, so index-wise
/// comparison would falsely report a change for an identical, reordered cart
/// and discard an idempotent request ID.
bool checkoutCartLinesMatch(
  List<CartLineSnapshot> existingLines,
  List<CartLineSnapshot> currentLines,
) {
  if (existingLines.length != currentLines.length) return false;
  final consumed = List<bool>.filled(existingLines.length, false);
  for (final current in currentLines) {
    var matchIndex = -1;
    for (var i = 0; i < existingLines.length; i++) {
      if (consumed[i]) continue;
      final existing = existingLines[i];
      if (existing.productId != current.productId ||
          existing.quantity != current.quantity ||
          existing.isVariableWeight != current.isVariableWeight) {
        continue;
      }
      if (current.isVariableWeight &&
          (existing.minWeight != current.minWeight ||
              existing.maxWeight != current.maxWeight)) {
        continue;
      }
      matchIndex = i;
      break;
    }
    if (matchIndex < 0) return false;
    consumed[matchIndex] = true;
  }
  return true;
}

/// F1 — pure validation of a `bindCheckoutUberQuote` response against the
/// actual backend contract (`bindCheckoutUberQuoteHandler.js:179-208`):
/// the backend returns `success`/`quoteState`/`paymentEligible`/`quoteExpired`
/// and echoes `quoteId`. It NEVER returns a `bound` field, so HTTP 200 alone
/// (or a `bound` check) can never establish a successful binding.
///
/// A binding is accepted only when every condition holds; the echoed quote ID
/// must match the quote ID that was submitted.
bool checkoutBindResponseAccepted({
  required int statusCode,
  required dynamic body,
  required String requestedQuoteId,
}) {
  if (statusCode != 200) return false;
  if (body is! Map) return false;
  if (body['success'] != true) return false;
  if (body['quoteState'] != 'bound') return false;
  if (body['paymentEligible'] != true) return false;
  if (body['quoteExpired'] == true) return false;
  final returnedQuoteId = (body['quoteId'] as String?)?.trim() ?? '';
  if (returnedQuoteId.isEmpty) return false;
  return returnedQuoteId == requestedQuoteId.trim();
}

// ---------------------------------------------------------------------------
// C1 — canonical create-order address payload.
//
// The backend accepts exactly: fullName, streetAddress, city, state,
// postalCode, phoneNo (+ optional instruction). The legacy alias keys the
// previous implementation sent (`contact_name`, `address`, `zip_code`,
// `contact_phone`, `latLng`) are rejected with `unsupported_field` and have
// no consumers anywhere. Values are trimmed; `state` and `instruction` are
// included only when non-empty. Returns null when there is no address data
// at all (the caller omits the `address` key — valid for farm pickup).
// ---------------------------------------------------------------------------
Map<String, dynamic>? buildCheckoutAddressPayload({
  String? fullName,
  String? streetAddress,
  String? city,
  String? state,
  String? postalCode,
  String? phoneNo,
  String? instruction,
}) {
  String? trimmed(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }

  final map = <String, dynamic>{
    'fullName': trimmed(fullName),
    'streetAddress': trimmed(streetAddress),
    'city': trimmed(city),
    'postalCode': trimmed(postalCode),
    'phoneNo': trimmed(phoneNo),
  }..removeWhere((key, value) => value == null);

  final stateValue = trimmed(state);
  if (stateValue != null) map['state'] = stateValue;
  final instructionValue = trimmed(instruction);
  if (instructionValue != null) map['instruction'] = instructionValue;

  return map.isEmpty ? null : map;
}

/// Pure acceptance rule for a `cancelCheckoutOrder` response: cancellation is
/// confirmed on success / already-cancelled (HTTP 200), or on the definitive
/// terminal answer `code: 'checkout_expired'` (the backend reports an already
/// expired reservation as 409 — the order can no longer be paid, so this is
/// a safe, terminal state). Anything else is ambiguous.
bool checkoutCancelResponseAccepted({
  required int statusCode,
  required dynamic body,
}) {
  if (body is! Map) return false;
  if (body['success'] == true || body['alreadyCancelled'] == true) {
    return statusCode == 200;
  }
  if (body['code'] == 'checkout_expired') return true;
  return false;
}

/// Public so the resumption action (F7) can reuse the identical cancellation
/// contract — no duplicated endpoint logic across custom actions.
///
/// True when the backend confirms the checkout order was cancelled (or was
/// already cancelled / already expired). Ambiguous outcomes return false so
/// callers keep the attempt instead of creating a replacement order.
Future<bool> cancelCheckoutOrderAttempt({
  required String orderId,
  required String idToken,
}) async {
  try {
    final response = await http
        .post(
          Uri.parse(kCancelCheckoutOrderUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({'orderId': orderId}),
        )
        .timeout(const Duration(seconds: 25));
    final dynamic body = jsonDecode(response.body);
    return checkoutCancelResponseAccepted(
      statusCode: response.statusCode,
      body: body,
    );
  } catch (_) {
    return false;
  }
}

/// FlutterFlow Custom Action for Checkout v1 Payment.
