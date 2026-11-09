/// P2-09 result values returned by `updateOrderFulfilmentStatus`.
const String dispatchOutcomeChanged = 'changed';
const String dispatchOutcomeAlreadyAtStatus = 'alreadyAtStatus';

/// Validates the trusted `updateOrderFulfilmentStatus` HTTP 200 envelope.
///
/// Actual backend success shape:
/// `{ success: true, orderId, orderStatus, previousOrderStatus?,
///   alreadyAtStatus, changed, reason }`
///
/// Returns [dispatchOutcomeChanged], [dispatchOutcomeAlreadyAtStatus], or
/// `null` when the body is empty, malformed or does not prove a successful
/// transition. A `null` result is an ambiguous failure: the caller must not
/// show a success notification or navigate as if the transition succeeded.
String? classifyDispatchSuccessResponse(
  dynamic decodedBody, {
  required String orderId,
  required String expectedStatus,
}) {
  if (decodedBody is! Map) return null;
  if (decodedBody['success'] != true) return null;
  if (decodedBody['orderId'] != orderId) return null;
  if (decodedBody['orderStatus'] != expectedStatus) return null;

  final alreadyAtStatus = decodedBody['alreadyAtStatus'];
  final changed = decodedBody['changed'];

  if (alreadyAtStatus == true) {
    return changed == false ? dispatchOutcomeAlreadyAtStatus : null;
  }

  if (changed == true) {
    return alreadyAtStatus == false ? dispatchOutcomeChanged : null;
  }

  return null;
}

// ─────────────────────────────────────────────
// P4-04 T5 F2/F5 response validation
// ─────────────────────────────────────────────

/// Returns the persisted Uber quote id from a successful quote response.
///
/// Only `{success: true, quote: {id: <non-empty>}}` is accepted. Empty,
/// malformed or contradictory HTTP 200 bodies return `null` and the caller
/// must not attempt delivery creation with an unverified quote.
String? classifyUberQuoteResponse(dynamic decodedBody) {
  if (decodedBody is! Map) return null;
  if (decodedBody['success'] != true) return null;

  final quote = decodedBody['quote'];
  if (quote is! Map) return null;

  final id = quote['id'];
  if (id is! String || id.trim().isEmpty) return null;
  return id.trim();
}

/// Result of a trusted Uber delivery-creation response.
enum UberDeliveryCreateOutcome {
  created,
  alreadyCreated,
  ambiguous,
}

class UberDeliveryCreateResult {
  const UberDeliveryCreateResult(this.outcome, this.deliveryId);

  final UberDeliveryCreateOutcome outcome;
  final String deliveryId;

  bool get succeeded =>
      (outcome == UberDeliveryCreateOutcome.created ||
          outcome == UberDeliveryCreateOutcome.alreadyCreated) &&
      deliveryId.isNotEmpty;
}

/// Validates the `createUberDelivery` HTTP 200 envelope.
///
/// Success requires `success == true`, a matching `orderId` and a non-empty
/// `delivery.id`. `alreadyCreated == true` with the same non-empty id is a
/// successful idempotent retry. Anything else is ambiguous: the caller must
/// not show a success notification or navigate as if dispatch succeeded.
UberDeliveryCreateResult classifyUberDeliveryCreateResponse(
  dynamic decodedBody, {
  required String orderId,
}) {
  const ambiguous = UberDeliveryCreateResult(
    UberDeliveryCreateOutcome.ambiguous,
    '',
  );

  if (decodedBody is! Map) return ambiguous;
  if (decodedBody['success'] != true) return ambiguous;

  final responseOrderId = decodedBody['orderId'];
  if (responseOrderId is! String || responseOrderId != orderId) {
    return ambiguous;
  }

  final delivery = decodedBody['delivery'];
  if (delivery is! Map) return ambiguous;
  final id = delivery['id'];
  if (id is! String || id.trim().isEmpty) return ambiguous;

  return UberDeliveryCreateResult(
    decodedBody['alreadyCreated'] == true
        ? UberDeliveryCreateOutcome.alreadyCreated
        : UberDeliveryCreateOutcome.created,
    id.trim(),
  );
}

/// Reads a machine-readable error code from a non-2xx Uber endpoint body.
String? uberDispatchErrorCode(dynamic decodedBody) {
  if (decodedBody is! Map) return null;
  final code = decodedBody['code'];
  if (code is! String || code.trim().isEmpty) return null;
  return code.trim();
}
