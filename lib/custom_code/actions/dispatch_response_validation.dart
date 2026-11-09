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
