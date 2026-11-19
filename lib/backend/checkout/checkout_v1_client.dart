/// Pure client-side foundation for the upcoming backend-owned checkout flow.
///
/// This module deliberately contains no Flutter widgets, no network calls and
/// no Firestore writes. It exists so the checkout-v1 migration can be built and
/// tested in small pieces before the Pay button is switched over.
///
/// Normalization notes (kept intentionally close to the backend request
/// contract, but not assumed to be byte-identical to the backend request hash):
///   * Text is trimmed and internal whitespace is collapsed.
///   * Currency is uppercased.
///   * Voucher codes are uppercased.
///   * Delivery method aliases are canonicalized to pickup / producer / uber.
///   * Delivery address text is lowercased for the fingerprint only. Location
///     is excluded because the backend request hash also excludes it.
///   * Duplicate product/bracket lines are aggregated and sorted, matching the
///     backend's order-line aggregation for idempotency.
///   * Tips are normalized to currency minor units (cents) for the fingerprint.
///   * `note` and `deliveryTime` keep their original case.
library;

import 'dart:convert';
import 'dart:math';

import '/backend/schema/cart_record.dart';
import '/backend/schema/structs/delivery_adress_struct.dart';
import '/backend/schema/users_record.dart';

/// Bump this if the local canonicalization changes so old fingerprints are
/// not mistaken for current ones.
const int checkoutPayloadFingerprintVersion = 1;

/// The backend accepts checkout request IDs up to this length.
const int maxCheckoutRequestIdLength = 200;

// ---------------------------------------------------------------------------
// Delivery method
// ---------------------------------------------------------------------------

enum CheckoutDeliveryMethod { pickup, producer, uber }

extension CheckoutDeliveryMethodWireValue on CheckoutDeliveryMethod {
  String get wireValue {
    switch (this) {
      case CheckoutDeliveryMethod.pickup:
        return 'pickup';
      case CheckoutDeliveryMethod.producer:
        return 'producer';
      case CheckoutDeliveryMethod.uber:
        return 'uber';
    }
  }
}

/// Mirrors the backend's accepted delivery-method aliases.
CheckoutDeliveryMethod? tryParseCheckoutDeliveryMethod(String? value) {
  final normalized = _normalizeOptionalText(value)?.toLowerCase();
  if (normalized == null) return null;

  switch (normalized) {
    case 'farmpickup':
    case 'farm_pickup':
    case 'pickup':
      return CheckoutDeliveryMethod.pickup;
    case 'delivery':
    case 'producer':
    case 'producer_delivery':
    case 'producermanaged':
    case 'producer-managed':
      return CheckoutDeliveryMethod.producer;
    case 'uber':
    case 'uberdirect':
    case 'uber_direct':
    case 'agrico':
      return CheckoutDeliveryMethod.uber;
    default:
      return null;
  }
}

CheckoutDeliveryMethod parseCheckoutDeliveryMethod(String? value) {
  final method = tryParseCheckoutDeliveryMethod(value);
  if (method == null) {
    throw ArgumentError.value(value, 'value', 'Unsupported delivery method');
  }
  return method;
}

// ---------------------------------------------------------------------------
// Address
// ---------------------------------------------------------------------------

/// A normalized checkout address.
///
/// The constructor preserves display casing. Canonical lowercasing is applied
/// only when building the fingerprint payload.
class CheckoutAddress {
  CheckoutAddress({
    required String fullName,
    required String streetAddress,
    required String city,
    required String state,
    required String postalCode,
    required String phoneNo,
    String? instruction,
  })  : fullName = _normalizeText(fullName),
        streetAddress = _normalizeText(streetAddress),
        city = _normalizeText(city),
        state = _normalizeText(state),
        postalCode = _normalizeText(postalCode),
        phoneNo = _normalizeText(phoneNo),
        instruction = _normalizeOptionalText(instruction);

  factory CheckoutAddress.fromDeliveryAdress(DeliveryAdressStruct address) {
    return CheckoutAddress(
      fullName: address.fullName,
      streetAddress: address.streetAdress,
      city: address.city,
      state: address.state,
      postalCode: address.postalCode,
      phoneNo: address.phoneNo,
      instruction: address.instruction,
    );
  }

  final String fullName;
  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
  final String phoneNo;
  final String? instruction;

  /// Canonical payload used by the local fingerprint. Do not send this shape
  /// directly to the backend: the backend contract uses camelCase and its own
  /// validation/normalization.
  Map<String, Object?> toCanonicalJson() {
    return <String, Object?>{
      'fullName': _canonicalText(fullName),
      'streetAddress': _canonicalText(streetAddress),
      'city': _canonicalText(city),
      'state': _canonicalText(state),
      'postalCode': _canonicalText(postalCode),
      'phoneNo': _canonicalText(phoneNo),
      'instruction': _canonicalText(instruction),
    };
  }
}

// ---------------------------------------------------------------------------
// Items and payload
// ---------------------------------------------------------------------------

class CheckoutWeightBracket {
  CheckoutWeightBracket({required double minWeight, required double maxWeight})
      : minWeight = _finiteNumber(minWeight, 'minWeight'),
        maxWeight = _finiteNumber(maxWeight, 'maxWeight') {
    if (this.minWeight <= 0 || this.maxWeight < this.minWeight) {
      throw ArgumentError(
        'Weight bracket must have minWeight > 0 and maxWeight >= minWeight',
      );
    }
  }

  final double minWeight;
  final double maxWeight;

  String get key => '${_numberKey(minWeight)}|${_numberKey(maxWeight)}';

  Map<String, Object?> toCanonicalJson() {
    return <String, Object?>{
      'minWeight': _canonicalNumber(minWeight),
      'maxWeight': _canonicalNumber(maxWeight),
    };
  }

  bool matches(CheckoutWeightBracket? other) {
    if (other == null) return false;
    return minWeight == other.minWeight && maxWeight == other.maxWeight;
  }
}

class CheckoutItem {
  CheckoutItem({
    required String productId,
    required int quantity,
    CheckoutWeightBracket? weightBracket,
  })  : productId = _requiredText(productId, 'productId'),
        quantity = _positiveQuantity(quantity),
        weightBracket = weightBracket;

  final String productId;
  final int quantity;
  final CheckoutWeightBracket? weightBracket;

  String get key => weightBracket == null
      ? '$productId|fixed'
      : '$productId|${weightBracket!.key}';

  Map<String, Object?> toCanonicalJson() {
    return <String, Object?>{
      'productId': productId,
      'quantity': quantity,
      'weightBracket': weightBracket?.toCanonicalJson(),
    };
  }
}

/// Aggregates duplicate product/bracket lines and sorts them so equivalent
/// carts produce the same fingerprint.
List<CheckoutItem> normalizeCheckoutItems(Iterable<CheckoutItem> items) {
  final merged = <String, CheckoutItem>{};
  for (final item in items) {
    final existing = merged[item.key];
    if (existing == null) {
      merged[item.key] = item;
    } else {
      merged[item.key] = CheckoutItem(
        productId: existing.productId,
        quantity: existing.quantity + item.quantity,
        weightBracket: existing.weightBracket,
      );
    }
  }

  final normalized = merged.values.toList()
    ..sort((left, right) {
      final product = left.productId.compareTo(right.productId);
      if (product != 0) return product;
      final leftMin = left.weightBracket?.minWeight ?? -1;
      final rightMin = right.weightBracket?.minWeight ?? -1;
      if (leftMin != rightMin) return leftMin.compareTo(rightMin);
      final leftMax = left.weightBracket?.maxWeight ?? -1;
      final rightMax = right.weightBracket?.maxWeight ?? -1;
      return leftMax.compareTo(rightMax);
    });
  return List.unmodifiable(normalized);
}

/// The checkout fields that determine order creation and therefore the local
/// attempt fingerprint.
class CheckoutPayload {
  CheckoutPayload({
    required String farmId,
    required String currency,
    required CheckoutDeliveryMethod deliveryMethod,
    required Iterable<CheckoutItem> items,
    CheckoutAddress? address,
    String? deliveryTime,
    double? tip,
    String? note,
    String? voucherCode,
  })  : farmId = _requiredText(farmId, 'farmId'),
        currency = _requiredText(currency, 'currency').toUpperCase(),
        deliveryMethod = deliveryMethod,
        items = normalizeCheckoutItems(items),
        address = address,
        deliveryTime = _normalizeOptionalText(deliveryTime),
        tip = _normalizeTip(tip),
        note = _normalizeOptionalText(note),
        voucherCode = _normalizeOptionalText(voucherCode)?.toUpperCase();

  final String farmId;
  final String currency;
  final CheckoutDeliveryMethod deliveryMethod;
  final List<CheckoutItem> items;
  final CheckoutAddress? address;
  final String? deliveryTime;
  final double tip;
  final String? note;
  final String? voucherCode;

  String get fingerprint => fingerprintCheckoutPayload(this);

  Map<String, Object?> toCanonicalJson() {
    return <String, Object?>{
      'version': checkoutPayloadFingerprintVersion,
      'farmId': farmId,
      'currency': currency,
      'delivery': <String, Object?>{
        'method': deliveryMethod.wireValue,
        'time': deliveryTime,
        'address': address?.toCanonicalJson(),
        'tipMinorUnits': _toMinorUnits(tip),
      },
      'items': items.map((item) => item.toCanonicalJson()).toList(),
      'note': note,
      'voucherCode': voucherCode,
    };
  }
}

/// Stable, non-cryptographic 64-bit fingerprint of the canonical payload.
///
/// This is used only to decide whether an existing local checkout attempt can
/// be retried. It is not a security hash and is not claimed to equal the
/// backend's SHA-256 request hash.
String fingerprintCheckoutPayload(CheckoutPayload payload) {
  return 'v$checkoutPayloadFingerprintVersion:${_fnv1a64(jsonEncode(payload.toCanonicalJson()))}';
}

String _fnv1a64(String value) {
  final mask = (BigInt.one << 64) - BigInt.one;
  var hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final prime = BigInt.parse('100000001b3', radix: 16);

  for (final byte in utf8.encode(value)) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }

  return hash.toRadixString(16).padLeft(16, '0');
}

// ---------------------------------------------------------------------------
// Captured cart lines
// ---------------------------------------------------------------------------

class CapturedCartLine {
  CapturedCartLine({
    required String cartDocumentId,
    required String productId,
    required int quantity,
    required String farmId,
    CheckoutWeightBracket? weightBracket,
  })  : cartDocumentId = _requiredText(cartDocumentId, 'cartDocumentId'),
        productId = _requiredText(productId, 'productId'),
        quantity = _positiveQuantity(quantity),
        farmId = _requiredText(farmId, 'farmId'),
        weightBracket = weightBracket;

  final String cartDocumentId;
  final String productId;
  final int quantity;
  final String farmId;
  final CheckoutWeightBracket? weightBracket;

  String get key => weightBracket == null
      ? '$cartDocumentId|$productId|fixed'
      : '$cartDocumentId|$productId|${weightBracket!.key}';
}

/// Captures one cart line for the selected farm. Returns null when the line is
/// missing identity/quantity data or belongs to another farm.
CapturedCartLine? captureCartLine(CartRecord cart, {required String farmId}) {
  final productId = cart.productRef?.id;
  final lineFarmId = cart.farmRef?.id;
  if (productId == null || productId.isEmpty) return null;
  if (lineFarmId == null || lineFarmId != farmId) return null;
  if (cart.quantity <= 0) return null;

  CheckoutWeightBracket? weightBracket;
  if (cart.isVariableWeight == true) {
    try {
      weightBracket = CheckoutWeightBracket(
        minWeight: cart.minWeight,
        maxWeight: cart.maxWeight,
      );
    } on ArgumentError {
      return null;
    }
  }

  return CapturedCartLine(
    cartDocumentId: cart.reference.id,
    productId: productId,
    quantity: cart.quantity,
    farmId: lineFarmId,
    weightBracket: weightBracket,
  );
}

/// Captures all selected-farm lines. Lines that cannot be represented safely
/// are skipped; this helper never mutates cart documents.
List<CapturedCartLine> captureCartLines(
  Iterable<CartRecord> cart, {
  required String farmId,
}) {
  final lines = <CapturedCartLine>[];
  for (final item in cart) {
    final captured = captureCartLine(item, farmId: farmId);
    if (captured != null) lines.add(captured);
  }
  return normalizeCapturedCartLines(lines);
}

List<CapturedCartLine> normalizeCapturedCartLines(
  Iterable<CapturedCartLine> lines,
) {
  final sorted = lines.toList()
    ..sort((left, right) {
      final id = left.cartDocumentId.compareTo(right.cartDocumentId);
      if (id != 0) return id;
      final product = left.productId.compareTo(right.productId);
      if (product != 0) return product;
      return left.key.compareTo(right.key);
    });
  return List.unmodifiable(sorted);
}

/// Result of strictly validating the cart the customer actually selected.
///
/// Unlike [captureCartLines], this never silently drops a line. Any malformed,
/// unidentifiable, foreign-farm or changed line fails the whole checkout so the
/// customer cannot be charged for a cart they did not review.
class CheckoutCartValidation {
  CheckoutCartValidation._({
    required Iterable<CapturedCartLine> lines,
    this.errorCode,
    this.problemCartDocumentId,
  }) : lines = List.unmodifiable(lines);

  CheckoutCartValidation.valid(Iterable<CapturedCartLine> lines)
      : this._(lines: lines);

  CheckoutCartValidation.error(String code, {String? cartDocumentId})
      : this._(
          lines: const <CapturedCartLine>[],
          errorCode: code,
          problemCartDocumentId: cartDocumentId,
        );

  final List<CapturedCartLine> lines;
  final String? errorCode;
  final String? problemCartDocumentId;

  bool get isValid => errorCode == null;
}

/// Validates [selectedCart] against the live [currentCart] and captures every
/// selected line exactly once.
///
/// A line may not disappear, change product/bracket/farm or change quantity
/// between review and order creation. The customer must refresh the checkout
/// instead of being charged for a different cart.
CheckoutCartValidation validateCheckoutCart({
  required Iterable<CartRecord> selectedCart,
  required Iterable<CartRecord> currentCart,
  required String farmId,
}) {
  final selected = selectedCart.toList();
  if (selected.isEmpty) {
    return CheckoutCartValidation.error('cart_empty');
  }

  final normalizedFarmId = farmId.trim();
  if (normalizedFarmId.isEmpty) {
    return CheckoutCartValidation.error('cart_line_invalid');
  }

  final selectedIds = <String>{};
  final lines = <CapturedCartLine>[];
  for (final line in selected) {
    final documentId = line.reference.id;
    if (!selectedIds.add(documentId)) {
      return CheckoutCartValidation.error(
        'cart_line_invalid',
        cartDocumentId: documentId,
      );
    }

    final productId = line.productRef?.id;
    final lineFarmId = line.farmRef?.id;
    if (productId == null ||
        productId.trim().isEmpty ||
        lineFarmId == null ||
        lineFarmId.trim().isEmpty ||
        line.quantity <= 0) {
      return CheckoutCartValidation.error(
        'cart_line_invalid',
        cartDocumentId: documentId,
      );
    }

    if (lineFarmId != normalizedFarmId) {
      return CheckoutCartValidation.error(
        'multi_farm_cart',
        cartDocumentId: documentId,
      );
    }

    CheckoutWeightBracket? bracket;
    if (line.isVariableWeight == true) {
      try {
        bracket = CheckoutWeightBracket(
          minWeight: line.minWeight,
          maxWeight: line.maxWeight,
        );
      } on ArgumentError {
        return CheckoutCartValidation.error(
          'cart_line_invalid',
          cartDocumentId: documentId,
        );
      }
    }

    lines.add(
      CapturedCartLine(
        cartDocumentId: documentId,
        productId: productId,
        quantity: line.quantity,
        farmId: lineFarmId,
        weightBracket: bracket,
      ),
    );
  }

  final currentById = <String, CartRecord>{};
  for (final line in currentCart) {
    final documentId = line.reference.id;
    final lineFarmId = line.farmRef?.id;
    if (lineFarmId == null || lineFarmId.trim().isEmpty) {
      return CheckoutCartValidation.error(
        'cart_line_invalid',
        cartDocumentId: documentId,
      );
    }
    if (lineFarmId != normalizedFarmId) {
      return CheckoutCartValidation.error(
        'multi_farm_cart',
        cartDocumentId: documentId,
      );
    }
    currentById[documentId] = line;
  }

  // A same-farm line added after review is also a change: it must not be
  // charged without the customer seeing the updated cart.
  if (currentById.keys.any((id) => !selectedIds.contains(id))) {
    return CheckoutCartValidation.error('checkout_cart_changed');
  }

  for (final captured in lines) {
    final current = currentById[captured.cartDocumentId];
    if (current == null) {
      return CheckoutCartValidation.error(
        'checkout_cart_changed',
        cartDocumentId: captured.cartDocumentId,
      );
    }
    if (current.productRef?.id != captured.productId ||
        current.farmRef?.id != captured.farmId ||
        current.quantity != captured.quantity) {
      return CheckoutCartValidation.error(
        'checkout_cart_changed',
        cartDocumentId: captured.cartDocumentId,
      );
    }

    CheckoutWeightBracket? currentBracket;
    if (current.isVariableWeight == true) {
      try {
        currentBracket = CheckoutWeightBracket(
          minWeight: current.minWeight,
          maxWeight: current.maxWeight,
        );
      } on ArgumentError {
        return CheckoutCartValidation.error(
          'cart_line_invalid',
          cartDocumentId: captured.cartDocumentId,
        );
      }
    }
    if (!_sameBracket(currentBracket, captured.weightBracket)) {
      return CheckoutCartValidation.error(
        'checkout_cart_changed',
        cartDocumentId: captured.cartDocumentId,
      );
    }
  }

  return CheckoutCartValidation.valid(normalizeCapturedCartLines(lines));
}

/// Returns a backend error code when the selected delivery address is not
/// complete enough to submit, or null when it is usable.
String? validateCheckoutAddress(CheckoutAddress? address) {
  if (address == null) return 'delivery_address_required';
  if (_normalizeOptionalText(address.fullName) == null ||
      _normalizeOptionalText(address.streetAddress) == null ||
      _normalizeOptionalText(address.city) == null ||
      _normalizeOptionalText(address.postalCode) == null ||
      _normalizeOptionalText(address.phoneNo) == null) {
    return 'delivery_address_invalid';
  }
  return null;
}

/// Builds the exact checkout-v1 PaymentIntent request body.
///
/// The server derives the amount from the persisted order/quote. Client amount,
/// vendor splits, delivery fee, platform fee and producer identity are never
/// included.
Map<String, dynamic> buildCheckoutV1PaymentIntentRequest({
  required String orderId,
  required String currency,
  String? locale,
  String? quoteId,
}) {
  final normalizedQuoteId = _normalizeOptionalText(quoteId);
  return <String, dynamic>{
    'orderId': orderId.trim(),
    'currency': _requiredText(currency, 'currency').toUpperCase(),
    if (_normalizeOptionalText(locale) != null)
      'locale': _normalizeOptionalText(locale),
    'useOrderTotals': true,
    if (normalizedQuoteId != null) 'quoteId': normalizedQuoteId,
  };
}

/// Builds the exact `createCheckoutOrder` request body.
///
/// Only identifiers, quantities, bracket selection, delivery context and
/// customer notes are sent. Prices, fees, totals, vendor splits and producer
/// identity are never client-supplied.
Map<String, dynamic> buildCheckoutOrderRequest({
  required String checkoutRequestId,
  required CheckoutPayload payload,
}) {
  final delivery = <String, dynamic>{
    'method': payload.deliveryMethod.wireValue,
    'tip': payload.tip,
    if (payload.deliveryTime != null) 'time': payload.deliveryTime,
  };

  if (payload.deliveryMethod != CheckoutDeliveryMethod.pickup &&
      payload.address != null) {
    delivery['address'] = <String, dynamic>{
      'fullName': payload.address!.fullName,
      'streetAddress': payload.address!.streetAddress,
      'city': payload.address!.city,
      'state': payload.address!.state,
      'postalCode': payload.address!.postalCode,
      'phoneNo': payload.address!.phoneNo,
      if (payload.address!.instruction != null)
        'instruction': payload.address!.instruction,
    };
  }

  return <String, dynamic>{
    'checkoutRequestId': validateCheckoutRequestId(checkoutRequestId),
    'farmId': payload.farmId,
    'currency': payload.currency,
    'items': payload.items
        .map(
          (item) => <String, dynamic>{
            'productId': item.productId,
            'quantity': item.quantity,
            if (item.weightBracket != null)
              'weightBracket': <String, dynamic>{
                'minWeight': item.weightBracket!.minWeight,
                'maxWeight': item.weightBracket!.maxWeight,
              },
          },
        )
        .toList(),
    'delivery': delivery,
    if (payload.note != null) 'note': payload.note,
    if (payload.voucherCode != null) 'voucherCode': payload.voucherCode,
  };
}

// ---------------------------------------------------------------------------
// Checkout attempt
// ---------------------------------------------------------------------------

enum CheckoutAttemptPhase {
  preparing,
  orderCreated,
  quoteBound,
  paymentIntentCreated,
  awaitingFinalization,
  confirmed,
  cancelled,
  failed,
  needsReview,
}

class CheckoutAttempt {
  CheckoutAttempt({
    required String checkoutRequestId,
    required this.fingerprint,
    required this.farmId,
    required this.currency,
    required this.deliveryMethod,
    required Iterable<CapturedCartLine> cartLines,
    required this.createdAt,
    this.phase = CheckoutAttemptPhase.preparing,
    this.orderId,
    this.quoteId,
    this.paymentIntentId,
    this.cancelRequested = false,
  })  : checkoutRequestId = validateCheckoutRequestId(checkoutRequestId),
        cartLines = normalizeCapturedCartLines(cartLines) {
    if (this.cartLines.any((line) => line.farmId != this.farmId)) {
      throw ArgumentError(
        'Captured cart lines must all belong to the attempt farm',
      );
    }
  }

  /// Restores a persisted attempt. Returns null for malformed or unsafe data
  /// instead of throwing into the checkout UI.
  static CheckoutAttempt? maybeFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      final phaseName = json['phase'] as String?;
      final phase = phaseName == null
          ? CheckoutAttemptPhase.preparing
          : CheckoutAttemptPhase.values.byName(phaseName);
      final createdAtText = json['createdAt'] as String?;
      if (createdAtText == null) return null;
      final lines = <CapturedCartLine>[];
      final rawLines = json['cartLines'];
      if (rawLines is! List) return null;
      for (final raw in rawLines) {
        if (raw is! Map) return null;
        final line = _capturedCartLineFromJson(raw.cast<String, dynamic>());
        if (line == null) return null;
        lines.add(line);
      }
      final method = tryParseCheckoutDeliveryMethod(
        json['deliveryMethod'] as String?,
      );
      if (method == null) return null;
      final checkoutRequestId = json['checkoutRequestId'] as String? ?? '';
      final fingerprint = json['fingerprint'] as String? ?? '';
      final farmId = json['farmId'] as String? ?? '';
      final currency = json['currency'] as String? ?? '';
      if (checkoutRequestId.trim().isEmpty ||
          fingerprint.trim().isEmpty ||
          farmId.trim().isEmpty ||
          currency.trim().isEmpty) {
        return null;
      }
      return CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        fingerprint: fingerprint,
        farmId: farmId,
        currency: currency,
        deliveryMethod: method,
        cartLines: lines,
        createdAt: DateTime.parse(createdAtText).toUtc(),
        phase: phase,
        orderId: _normalizeOptionalText(json['orderId'] as String?),
        quoteId: _normalizeOptionalText(json['quoteId'] as String?),
        paymentIntentId: _normalizeOptionalText(
          json['paymentIntentId'] as String?,
        ),
        cancelRequested: json['cancelRequested'] == true,
      );
    } catch (_) {
      return null;
    }
  }

  final String checkoutRequestId;
  final String fingerprint;
  final String farmId;
  final String currency;
  final CheckoutDeliveryMethod deliveryMethod;
  final List<CapturedCartLine> cartLines;
  final DateTime createdAt;
  final CheckoutAttemptPhase phase;
  final String? orderId;
  final String? quoteId;
  final String? paymentIntentId;
  final bool cancelRequested;

  bool get isOpen => !_isClosedAttemptPhase(phase);

  CheckoutAttempt copyWith({
    CheckoutAttemptPhase? phase,
    String? orderId,
    String? quoteId,
    String? paymentIntentId,
    bool? cancelRequested,
  }) {
    return CheckoutAttempt(
      checkoutRequestId: checkoutRequestId,
      fingerprint: fingerprint,
      farmId: farmId,
      currency: currency,
      deliveryMethod: deliveryMethod,
      cartLines: cartLines,
      createdAt: createdAt,
      phase: phase ?? this.phase,
      orderId: orderId ?? this.orderId,
      quoteId: quoteId ?? this.quoteId,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      cancelRequested: cancelRequested ?? this.cancelRequested,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'checkoutRequestId': checkoutRequestId,
      'fingerprint': fingerprint,
      'farmId': farmId,
      'currency': currency,
      'deliveryMethod': deliveryMethod.wireValue,
      'cartLines': cartLines
          .map(
            (line) => <String, dynamic>{
              'cartDocumentId': line.cartDocumentId,
              'productId': line.productId,
              'quantity': line.quantity,
              'farmId': line.farmId,
              if (line.weightBracket != null)
                'weightBracket': line.weightBracket!.toCanonicalJson(),
            },
          )
          .toList(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'phase': phase.name,
      if (orderId != null) 'orderId': orderId,
      if (quoteId != null) 'quoteId': quoteId,
      if (paymentIntentId != null) 'paymentIntentId': paymentIntentId,
      'cancelRequested': cancelRequested,
    };
  }
}

CapturedCartLine? _capturedCartLineFromJson(Map<String, dynamic> json) {
  try {
    final bracketJson = json['weightBracket'];
    CheckoutWeightBracket? bracket;
    if (bracketJson is Map) {
      final min = bracketJson['minWeight'];
      final max = bracketJson['maxWeight'];
      if (min is! num || max is! num) return null;
      bracket = CheckoutWeightBracket(
        minWeight: min.toDouble(),
        maxWeight: max.toDouble(),
      );
    }
    return CapturedCartLine(
      cartDocumentId: json['cartDocumentId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : (json['quantity'] as num?)?.toInt() ?? 0,
      farmId: json['farmId'] as String? ?? '',
      weightBracket: bracket,
    );
  } catch (_) {
    return null;
  }
}

typedef CheckoutRequestIdFactory = String Function();

class CheckoutAttemptResolution {
  const CheckoutAttemptResolution({
    required this.attempt,
    required this.reused,
  });

  final CheckoutAttempt attempt;
  final bool reused;
}

/// Returns the existing attempt when the payload and captured cart lines are
/// unchanged and the attempt is not closed. Confirmed, cancelled and failed
/// attempts always receive a new request ID. This helper never changes phase or
/// performs persistence.
CheckoutAttemptResolution resolveCheckoutAttempt({
  required CheckoutAttempt? existing,
  required CheckoutPayload payload,
  required Iterable<CapturedCartLine> cartLines,
  DateTime? createdAt,
  CheckoutRequestIdFactory? requestIdFactory,
}) {
  final normalizedLines = normalizeCapturedCartLines(cartLines);
  if (normalizedLines.any((line) => line.farmId != payload.farmId)) {
    throw ArgumentError(
      'Captured cart lines must all belong to the payload farm',
    );
  }

  if (existing != null &&
      !_isClosedAttemptPhase(existing.phase) &&
      existing.fingerprint == payload.fingerprint &&
      _sameCapturedCartLines(existing.cartLines, normalizedLines)) {
    return CheckoutAttemptResolution(attempt: existing, reused: true);
  }

  final requestId = (requestIdFactory ?? defaultCheckoutRequestId)();
  final attempt = CheckoutAttempt(
    checkoutRequestId: requestId,
    fingerprint: payload.fingerprint,
    farmId: payload.farmId,
    currency: payload.currency,
    deliveryMethod: payload.deliveryMethod,
    cartLines: normalizedLines,
    createdAt: (createdAt ?? DateTime.now()).toUtc(),
  );
  return CheckoutAttemptResolution(attempt: attempt, reused: false);
}

String defaultCheckoutRequestId() {
  final now = DateTime.now().toUtc().microsecondsSinceEpoch;
  final random = Random.secure();
  final suffix = List.generate(
    16,
    (_) => random.nextInt(16).toRadixString(16),
  ).join();
  return validateCheckoutRequestId('checkout_${now}_$suffix');
}

String validateCheckoutRequestId(String value) {
  final id = value.trim();
  if (id.isEmpty ||
      id.length > maxCheckoutRequestIdLength ||
      id.contains('/') ||
      id == '.' ||
      id == '..') {
    throw ArgumentError.value(value, 'value', 'Invalid checkout request ID');
  }
  return id;
}

bool _isClosedAttemptPhase(CheckoutAttemptPhase phase) {
  return phase == CheckoutAttemptPhase.confirmed ||
      phase == CheckoutAttemptPhase.cancelled ||
      phase == CheckoutAttemptPhase.failed;
}

bool _sameCapturedCartLines(
  List<CapturedCartLine> left,
  List<CapturedCartLine> right,
) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    final a = left[index];
    final b = right[index];
    if (a.cartDocumentId != b.cartDocumentId ||
        a.productId != b.productId ||
        a.quantity != b.quantity ||
        a.farmId != b.farmId ||
        !_sameBracket(a.weightBracket, b.weightBracket)) {
      return false;
    }
  }
  return true;
}

bool _sameBracket(CheckoutWeightBracket? left, CheckoutWeightBracket? right) {
  if (left == null || right == null) return left == null && right == null;
  return left.matches(right);
}

enum CheckoutAttemptLoadStatus { absent, found, invalid }

/// Distinguishes a genuinely absent attempt from a stored value that exists but
/// cannot be decoded or validated.
///
/// Invalid entries must fail closed: the caller stops, preserves
/// [rawValue] for diagnosis, and must not generate a new request ID or
/// overwrite/delete the entry.
class CheckoutAttemptLoadResult {
  const CheckoutAttemptLoadResult._({
    required this.status,
    this.attempt,
    this.rawValue,
    this.invalidReason,
  });

  const CheckoutAttemptLoadResult.absent()
    : this._(status: CheckoutAttemptLoadStatus.absent);

  const CheckoutAttemptLoadResult.found(CheckoutAttempt attempt)
    : this._(status: CheckoutAttemptLoadStatus.found, attempt: attempt);

  const CheckoutAttemptLoadResult.invalid({
    required String rawValue,
    required String reason,
  }) : this._(
         status: CheckoutAttemptLoadStatus.invalid,
         rawValue: rawValue,
         invalidReason: reason,
       );

  final CheckoutAttemptLoadStatus status;
  final CheckoutAttempt? attempt;
  final String? rawValue;
  final String? invalidReason;

  bool get isAbsent => status == CheckoutAttemptLoadStatus.absent;

  bool get isFound => status == CheckoutAttemptLoadStatus.found;

  bool get isInvalid => status == CheckoutAttemptLoadStatus.invalid;
}

/// Minimal persistence seam for a future adapter (for example SharedPreferences
/// or FFAppState). No production storage is wired in this batch.
abstract class CheckoutAttemptStore {
  Future<CheckoutAttemptLoadResult> load();

  Future<void> save(CheckoutAttempt attempt);

  Future<void> clear();
}

/// Test/in-memory implementation of [CheckoutAttemptStore].
class InMemoryCheckoutAttemptStore implements CheckoutAttemptStore {
  CheckoutAttempt? _attempt;

  @override
  Future<void> clear() async {
    _attempt = null;
  }

  @override
  Future<CheckoutAttemptLoadResult> load() async {
    final attempt = _attempt;
    return attempt == null
        ? const CheckoutAttemptLoadResult.absent()
        : CheckoutAttemptLoadResult.found(attempt);
  }

  @override
  Future<void> save(CheckoutAttempt attempt) async {
    _attempt = attempt;
  }
}

// ---------------------------------------------------------------------------
// Delivery-address selection and index maintenance
// ---------------------------------------------------------------------------

/// Returns a safe index for [addressCount]. Missing, negative and out-of-range
/// values fall back to the first address. An empty list returns 0; callers must
/// still check the list length before indexing.
int resolveDeliveryAddressIndex({
  required int addressCount,
  required int? defaultIndex,
}) {
  if (addressCount <= 0) return 0;
  if (defaultIndex == null ||
      defaultIndex < 0 ||
      defaultIndex >= addressCount) {
    return 0;
  }
  return defaultIndex;
}

/// Resolves the selected address without throwing for a missing user, an empty
/// list or a stale default index.
DeliveryAdressStruct? resolveSelectedDeliveryAddress(UsersRecord? user) {
  if (user == null) return null;
  final addresses = user.deliveryAddresses;
  if (addresses.isEmpty) return null;
  final index = resolveDeliveryAddressIndex(
    addressCount: addresses.length,
    defaultIndex: user.defaultAdress,
  );
  return addresses[index];
}

class AddressIndexUpdate {
  AddressIndexUpdate({
    required Iterable<DeliveryAdressStruct> addresses,
    required this.defaultIndex,
  }) : addresses = List.unmodifiable(addresses);

  final List<DeliveryAdressStruct> addresses;
  final int defaultIndex;
}

/// Confirms that the address at [index] is still the address the user selected.
///
/// `DeliveryAdressStruct` equality is the existing project convention and
/// compares all persisted address fields. A moved, replaced or removed address
/// therefore fails this check instead of letting a stale index modify a
/// different address.
bool deliveryAddressAtMatches({
  required Iterable<DeliveryAdressStruct> addresses,
  required int index,
  required DeliveryAdressStruct? expected,
}) {
  if (expected == null) return false;
  if (index < 0 || index >= addresses.length) return false;
  return addresses.elementAt(index) == expected;
}

/// Removes one address and returns the list plus the corrected default index.
/// Returns null when [index] is not a valid address index.
AddressIndexUpdate? removeDeliveryAddressAt({
  required Iterable<DeliveryAdressStruct> addresses,
  required int index,
  required int defaultIndex,
}) {
  final current = addresses.toList();
  if (index < 0 || index >= current.length) return null;

  final next = List<DeliveryAdressStruct>.of(current)..removeAt(index);
  if (next.isEmpty) {
    return AddressIndexUpdate(addresses: const [], defaultIndex: 0);
  }

  int nextDefault;
  if (defaultIndex < 0) {
    nextDefault = 0;
  } else if (index < defaultIndex) {
    nextDefault = defaultIndex - 1;
  } else if (index == defaultIndex) {
    // Prefer the address that shifted into the deleted slot, or the new last
    // address when the deleted address was last.
    nextDefault = index < next.length ? index : next.length - 1;
  } else {
    nextDefault = defaultIndex;
  }

  nextDefault = nextDefault.clamp(0, next.length - 1);
  return AddressIndexUpdate(addresses: next, defaultIndex: nextDefault);
}

/// Deletes only when the address at [index] is still [expected].
///
/// Returns null for an invalid index or a stale address selection; callers must
/// treat null as "no Firestore write".
AddressIndexUpdate? removeDeliveryAddressAtIfMatches({
  required Iterable<DeliveryAdressStruct> addresses,
  required int index,
  required DeliveryAdressStruct? expected,
  required int defaultIndex,
}) {
  if (!deliveryAddressAtMatches(
    addresses: addresses,
    index: index,
    expected: expected,
  )) {
    return null;
  }
  return removeDeliveryAddressAt(
    addresses: addresses,
    index: index,
    defaultIndex: defaultIndex,
  );
}

/// Replaces one address in place. Order and a valid default index are
/// preserved. Returns null when [index] is not a valid address index.
AddressIndexUpdate? replaceDeliveryAddressAt({
  required Iterable<DeliveryAdressStruct> addresses,
  required int index,
  required DeliveryAdressStruct replacement,
  required int defaultIndex,
}) {
  final next = addresses.toList();
  if (index < 0 || index >= next.length) return null;

  next[index] = replacement;
  final normalizedDefault = resolveDeliveryAddressIndex(
    addressCount: next.length,
    defaultIndex: defaultIndex,
  );
  return AddressIndexUpdate(addresses: next, defaultIndex: normalizedDefault);
}

/// Edits only when the address at [index] is still [expected].
///
/// Returns null for an invalid index or a stale address selection; callers must
/// treat null as "no Firestore write". The returned [AddressIndexUpdate]
/// reports a repaired default index when the stored index was invalid.
AddressIndexUpdate? replaceDeliveryAddressAtIfMatches({
  required Iterable<DeliveryAdressStruct> addresses,
  required int index,
  required DeliveryAdressStruct? expected,
  required DeliveryAdressStruct replacement,
  required int defaultIndex,
}) {
  if (!deliveryAddressAtMatches(
    addresses: addresses,
    index: index,
    expected: expected,
  )) {
    return null;
  }
  return replaceDeliveryAddressAt(
    addresses: addresses,
    index: index,
    replacement: replacement,
    defaultIndex: defaultIndex,
  );
}

enum DeliveryAddressMutationResult { updated, stale, userMissing }

/// Applies a guarded delete inside a transaction callback.
///
/// The caller supplies the already-read [user] snapshot and a [write] callback
/// that must only stage `transaction.update(...)`. No UI side effects belong
/// here because Firestore may retry the enclosing callback.
DeliveryAddressMutationResult applyDeleteDeliveryAddress({
  required UsersRecord? user,
  required int index,
  required DeliveryAdressStruct? expected,
  required void Function(Map<String, dynamic> data) write,
}) {
  if (user == null) return DeliveryAddressMutationResult.userMissing;

  final update = removeDeliveryAddressAtIfMatches(
    addresses: user.deliveryAddresses,
    index: index,
    expected: expected,
    defaultIndex: user.defaultAdress,
  );
  if (update == null) return DeliveryAddressMutationResult.stale;

  write(<String, dynamic>{
    'delivery_Addresses': getDeliveryAdressListFirestoreData(update.addresses),
    'default_adress': update.defaultIndex,
  });
  return DeliveryAddressMutationResult.updated;
}

/// Applies a guarded edit inside a transaction callback.
///
/// A repaired invalid default index is included in the same staged write. A
/// valid default is preserved and is not written. No UI side effects belong
/// here because Firestore may retry the enclosing callback.
DeliveryAddressMutationResult applyEditDeliveryAddress({
  required UsersRecord? user,
  required int index,
  required DeliveryAdressStruct? expected,
  required DeliveryAdressStruct replacement,
  required void Function(Map<String, dynamic> data) write,
}) {
  if (user == null) return DeliveryAddressMutationResult.userMissing;

  final update = replaceDeliveryAddressAtIfMatches(
    addresses: user.deliveryAddresses,
    index: index,
    expected: expected,
    replacement: replacement,
    defaultIndex: user.defaultAdress,
  );
  if (update == null) return DeliveryAddressMutationResult.stale;

  final data = <String, dynamic>{
    'delivery_Addresses': getDeliveryAdressListFirestoreData(update.addresses),
  };
  if (update.defaultIndex != user.defaultAdress) {
    data['default_adress'] = update.defaultIndex;
  }
  write(data);
  return DeliveryAddressMutationResult.updated;
}

// ---------------------------------------------------------------------------
// Cart-clearing plan
// ---------------------------------------------------------------------------

enum CartClearAction { skip, delete, decrement }

class CartLineCurrentState {
  CartLineCurrentState({
    required String cartDocumentId,
    required String productId,
    required String farmId,
    required int quantity,
    CheckoutWeightBracket? weightBracket,
  })  : cartDocumentId = _requiredText(cartDocumentId, 'cartDocumentId'),
        productId = _requiredText(productId, 'productId'),
        farmId = farmId.trim(),
        quantity = quantity,
        weightBracket = weightBracket;

  final String cartDocumentId;
  final String productId;
  final String farmId;
  final int quantity;
  final CheckoutWeightBracket? weightBracket;
}

class CartClearDecision {
  const CartClearDecision({
    required this.cartDocumentId,
    required this.action,
    this.decrementBy,
  });

  final String cartDocumentId;
  final CartClearAction action;
  final int? decrementBy;
}

/// Classifies one purchased line against its current cart state.
///
/// Assumptions:
///   * Cart documents are per line and their IDs are captured before checkout.
///   * A missing document has already been cleared or deleted.
///   * A changed farm/product/bracket means the document no longer represents
///     the purchased line, so it is left alone.
///   * A larger current quantity means the customer added units during
///     checkout; only the purchased quantity is removed.
///   * An equal quantity removes the line.
///   * A smaller quantity is left untouched: the client cannot establish
///     whether the customer removed units before or after checkout.
CartClearDecision planCartLineClear({
  required CapturedCartLine purchased,
  required CartLineCurrentState? current,
}) {
  if (current == null) {
    return CartClearDecision(
      cartDocumentId: purchased.cartDocumentId,
      action: CartClearAction.skip,
    );
  }

  if (current.farmId.isEmpty ||
      current.farmId != purchased.farmId ||
      current.cartDocumentId != purchased.cartDocumentId ||
      current.productId != purchased.productId ||
      !_sameBracket(current.weightBracket, purchased.weightBracket)) {
    return CartClearDecision(
      cartDocumentId: purchased.cartDocumentId,
      action: CartClearAction.skip,
    );
  }

  if (current.quantity > purchased.quantity) {
    return CartClearDecision(
      cartDocumentId: purchased.cartDocumentId,
      action: CartClearAction.decrement,
      decrementBy: purchased.quantity,
    );
  }

  if (current.quantity == purchased.quantity) {
    return CartClearDecision(
      cartDocumentId: purchased.cartDocumentId,
      action: CartClearAction.delete,
    );
  }

  // Current quantity is smaller than the purchased quantity. Preserve the
  // remaining line; deleting it could remove units the customer changed after
  // the checkout snapshot.
  return CartClearDecision(
    cartDocumentId: purchased.cartDocumentId,
    action: CartClearAction.skip,
  );
}

List<CartClearDecision> planCartClear({
  required Iterable<CapturedCartLine> purchasedLines,
  required Map<String, CartLineCurrentState?> currentByDocumentId,
}) {
  final decisions = <CartClearDecision>[];
  for (final purchased in normalizeCapturedCartLines(purchasedLines)) {
    decisions.add(
      planCartLineClear(
        purchased: purchased,
        current: currentByDocumentId[purchased.cartDocumentId],
      ),
    );
  }
  return List.unmodifiable(decisions);
}

enum CartClearWriteAction { skip, delete, setQuantity }

class CartClearWrite {
  const CartClearWrite({
    required this.cartDocumentId,
    required this.action,
    this.quantity,
  });

  final String cartDocumentId;
  final CartClearWriteAction action;
  final int? quantity;
}

/// Converts clear decisions into the exact transaction writes.
///
/// A `skip` decision produces a `skip` write and therefore no Firestore
/// mutation. Callers must not turn a skipped decision into a delete.
List<CartClearWrite> buildCartClearWrites({
  required Iterable<CartClearDecision> decisions,
  required Map<String, CartLineCurrentState?> currentByDocumentId,
}) {
  final writes = <CartClearWrite>[];
  for (final decision in decisions) {
    switch (decision.action) {
      case CartClearAction.skip:
        writes.add(
          CartClearWrite(
            cartDocumentId: decision.cartDocumentId,
            action: CartClearWriteAction.skip,
          ),
        );
        break;
      case CartClearAction.delete:
        writes.add(
          CartClearWrite(
            cartDocumentId: decision.cartDocumentId,
            action: CartClearWriteAction.delete,
          ),
        );
        break;
      case CartClearAction.decrement:
        final current = currentByDocumentId[decision.cartDocumentId];
        final remaining =
            (current?.quantity ?? 0) - (decision.decrementBy ?? 0);
        if (remaining <= 0) {
          writes.add(
            CartClearWrite(
              cartDocumentId: decision.cartDocumentId,
              action: CartClearWriteAction.delete,
            ),
          );
        } else {
          writes.add(
            CartClearWrite(
              cartDocumentId: decision.cartDocumentId,
              action: CartClearWriteAction.setQuantity,
              quantity: remaining,
            ),
          );
        }
        break;
    }
  }
  return List.unmodifiable(writes);
}

// ---------------------------------------------------------------------------
// Finalization and payment/checkout outcome classifiers
// ---------------------------------------------------------------------------

enum CheckoutFinalizationState {
  awaitingPayment,
  paymentPending,
  paymentConfirmed,
  cancelled,
  expired,
  refundPending,
  refunded,
  reconciliationRequired,
  unknown,
}

/// Classifies the backend-owned order fields without granting any client-side
/// financial authority. Only the backend writes these fields.
CheckoutFinalizationState classifyCheckoutFinalization(
  Map<String, dynamic>? orderData,
) {
  if (orderData == null) return CheckoutFinalizationState.unknown;

  final state = _normalizeStatus(orderData['checkout_state']);
  final reconciliationRequired =
      orderData['checkout_reconciliation_required'] == true;

  switch (state) {
    case 'awaiting_payment':
      return reconciliationRequired
          ? CheckoutFinalizationState.reconciliationRequired
          : CheckoutFinalizationState.awaitingPayment;
    case 'payment_pending':
      return reconciliationRequired
          ? CheckoutFinalizationState.reconciliationRequired
          : CheckoutFinalizationState.paymentPending;
    case 'payment_confirmed':
      return CheckoutFinalizationState.paymentConfirmed;
    case 'cancelled':
      return CheckoutFinalizationState.cancelled;
    case 'expired':
      return CheckoutFinalizationState.expired;
    case 'refund_pending':
      return CheckoutFinalizationState.refundPending;
    case 'refunded':
      return CheckoutFinalizationState.refunded;
    case 'reconciliation_required':
      return CheckoutFinalizationState.reconciliationRequired;
    default:
      return reconciliationRequired
          ? CheckoutFinalizationState.reconciliationRequired
          : CheckoutFinalizationState.unknown;
  }
}

/// Only the backend-owned `payment_confirmed` state allows the client to
/// clear the purchased cart lines and show success.
bool checkoutFinalizationIsConfirmed(CheckoutFinalizationState state) {
  return state == CheckoutFinalizationState.paymentConfirmed;
}

/// States where the attempt is closed and no successful cart clearing or
/// navigation may happen.
bool checkoutFinalizationIsClosed(CheckoutFinalizationState state) {
  return state == CheckoutFinalizationState.cancelled ||
      state == CheckoutFinalizationState.expired ||
      state == CheckoutFinalizationState.refunded;
}

/// States that require support/reconciliation instead of an automatic retry.
bool checkoutFinalizationNeedsSupport(CheckoutFinalizationState state) {
  return state == CheckoutFinalizationState.refundPending ||
      state == CheckoutFinalizationState.reconciliationRequired;
}

enum CheckoutPaymentOutcome {
  confirmed,
  paymentSheetCompleted,
  alreadyConfirmed,
  cancelled,
  declined,
  retryable,
  terminal,
  needsSupport,
}

const Set<String> _alreadyConfirmedErrorCodes = <String>{
  'payment_already_succeeded',
  'order_finalized',
};

const Set<String> _needsSupportErrorCodes = <String>{
  'payment_transfer_already_completed',
  'payment_cancellation_failed',
  'checkout_reconciliation_required',
  'checkout_cancellation_reconciliation_required',
};

const Set<String> _terminalErrorCodes = <String>{
  'active_checkout_limit_reached',
  'checkout_expired',
  'checkout_flow_unsupported',
  'checkout_request_conflict',
  'currency_invalid',
  'currency_mismatch',
  'delivery_address_required',
  'delivery_address_invalid',
  'delivery_address_unavailable',
  'delivery_fee_invalid',
  'delivery_fee_mismatch',
  'delivery_quote_unexpected',
  'farm_not_available',
  'farm_not_found',
  'insufficient_stock',
  'minimum_order_not_met',
  'multi_farm_cart',
  'order_changed',
  'order_currency_invalid',
  'order_forbidden',
  'order_id_required',
  'order_not_found',
  'order_not_payable',
  'order_owner_unavailable',
  'order_subtotal_mismatch',
  'order_total_mismatch',
  'platform_fee_mismatch',
  'producer_id_mismatch',
  'producer_unavailable',
  'product_availability_invalid',
  'product_brackets_missing',
  'product_not_available',
  'product_not_found',
  'product_price_invalid',
  'product_reservation_state_invalid',
  'product_stock_invalid',
  'quote_id_required',
  'quote_unexpected',
  'use_order_totals_required',
  'weight_bracket_invalid',
  'weight_bracket_not_found',
  'weight_bracket_required',
  'weight_bracket_unexpected',
  'weight_deposit_rate_unavailable',
};

const Set<String> _retryableErrorCodes = <String>{
  'auth_invalid',
  'auth_required',
  'auth_unavailable',
  'checkout_cancel_unavailable',
  'checkout_cancellation_in_progress',
  'checkout_operation_in_progress',
  'checkout_order_unavailable',
  'checkout_transfer_claim_lost',
  'checkout_transfer_processing',
  'checkout_unavailable',
  'delivery_context_changed',
  'delivery_quote_required',
  'payment_already_initiated',
  'payment_intent_state_unavailable',
  'payment_intent_unresolved',
  'payment_processing',
  'payment_state_unavailable',
  'quote_already_bound',
  'quote_binding_unavailable',
  'quote_context_mismatch',
  'quote_context_unavailable',
  'quote_expired',
  'quote_not_bound',
  'quote_order_mismatch',
  'quote_persistence_unavailable',
  'quote_unavailable',
  'server_time_invalid',
};

/// Maps a backend error code to a safe client outcome.
///
/// Unknown and empty codes are retryable. They must never be treated as a
/// definitive payment failure.
CheckoutPaymentOutcome classifyCheckoutErrorCode(String? code) {
  final normalized = _normalizeStatus(code);
  if (normalized.isEmpty) return CheckoutPaymentOutcome.retryable;
  if (_alreadyConfirmedErrorCodes.contains(normalized)) {
    return CheckoutPaymentOutcome.alreadyConfirmed;
  }
  if (_needsSupportErrorCodes.contains(normalized)) {
    return CheckoutPaymentOutcome.needsSupport;
  }
  if (_terminalErrorCodes.contains(normalized)) {
    return CheckoutPaymentOutcome.terminal;
  }
  if (_retryableErrorCodes.contains(normalized)) {
    return CheckoutPaymentOutcome.retryable;
  }
  return CheckoutPaymentOutcome.retryable;
}

/// Maps the string result of the existing PaymentSheet action.
///
/// `failed` is treated as a terminal attempt outcome, not as proof that the
/// PaymentIntent was cancelled. Callers must use the backend/cancellation
/// classification before releasing anything.
CheckoutPaymentOutcome classifyCheckoutPaymentResult(String? result) {
  switch (_normalizeStatus(result)) {
    case 'alreadyconfirmed':
      return CheckoutPaymentOutcome.alreadyConfirmed;
    case 'ambiguous':
    case 'pending':
    case 'processing':
      return CheckoutPaymentOutcome.retryable;
    case 'canceled':
    case 'cancelled':
      return CheckoutPaymentOutcome.cancelled;
    case 'declined':
      return CheckoutPaymentOutcome.declined;
    case 'failed':
      return CheckoutPaymentOutcome.terminal;
    case 'needssupport':
      return CheckoutPaymentOutcome.needsSupport;
    case 'sheetcompleted':
    case 'success':
      return CheckoutPaymentOutcome.paymentSheetCompleted;
    default:
      return CheckoutPaymentOutcome.retryable;
  }
}

// ---------------------------------------------------------------------------
// Shared normalization helpers
// ---------------------------------------------------------------------------

String _normalizeText(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

String _requiredText(String? value, String fieldName) {
  final normalized = _normalizeOptionalText(value);
  if (normalized == null) {
    throw ArgumentError.value(
      value,
      fieldName,
      'A non-empty value is required',
    );
  }
  return normalized;
}

String? _normalizeOptionalText(String? value) {
  if (value == null) return null;
  final normalized = _normalizeText(value);
  return normalized.isEmpty ? null : normalized;
}

String? _canonicalText(String? value) {
  final normalized = _normalizeOptionalText(value);
  return normalized?.toLowerCase();
}

double _normalizeTip(double? value) {
  if (value == null) return 0;
  if (!value.isFinite || value < 0) {
    throw ArgumentError.value(
      value,
      'tip',
      'Tip must be finite and non-negative',
    );
  }
  return value;
}

double _finiteNumber(double value, String fieldName) {
  if (!value.isFinite) {
    throw ArgumentError.value(value, fieldName, 'A finite number is required');
  }
  return value;
}

int _positiveQuantity(int value) {
  if (value <= 0) {
    throw ArgumentError.value(value, 'quantity', 'Quantity must be positive');
  }
  return value;
}

int _toMinorUnits(double value) => (value * 100).round();

num _canonicalNumber(double value) {
  return value == value.roundToDouble() ? value.toInt() : value;
}

String _numberKey(double value) => _canonicalNumber(value).toString();

String _normalizeStatus(Object? value) {
  if (value is! String) return '';
  return value.trim().toLowerCase();
}
