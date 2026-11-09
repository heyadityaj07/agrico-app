import '/backend/schema/order_record.dart';

/// Customer-facing classification of the refund state persisted on an order.
///
/// The backend records `refund_status` as `processing`, `succeeded` or
/// `failed`. A positive `refund_due_amount` with no status means a refund is
/// due but has not been initiated. This helper only classifies the recorded
/// values; it never calculates, infers or upgrades a refund outcome.
enum CustomerRefundState {
  none,
  dueNotInitiated,
  processing,
  succeeded,
  failed,
  unknown,
}

class CustomerRefundInfo {
  const CustomerRefundInfo({
    required this.state,
    required this.amount,
    required this.rawStatus,
    required this.hasRecordedAmount,
  });

  final CustomerRefundState state;

  /// The recorded refund amount, or the recorded refund-due amount when no
  /// refund amount has been written yet. This is never a client calculation.
  final double amount;

  /// The persisted status exactly as stored on the order (trimmed).
  final String rawStatus;

  final bool hasRecordedAmount;

  bool get hasRefund => state != CustomerRefundState.none;
  bool get hasAmount => hasRecordedAmount && amount > 0;
  bool get needsAttention => state == CustomerRefundState.failed;

  factory CustomerRefundInfo.fromOrder(OrderRecord order) {
    final rawStatus = order.refundStatus.trim();
    final normalizedStatus = rawStatus.toLowerCase();
    final refundDueAmount = order.refundDueAmount;
    final refundAmount = order.refundAmount;

    // Display the recorded refund amount when the refund lifecycle has one;
    // otherwise fall back to the recorded refund-due obligation. Both are
    // backend-persisted fields, and no arithmetic is performed here.
    final recordedAmount = refundAmount > 0
        ? refundAmount
        : (refundDueAmount > 0 ? refundDueAmount : 0.0);

    if (normalizedStatus.isEmpty) {
      if (refundDueAmount > 0) {
        return CustomerRefundInfo(
          state: CustomerRefundState.dueNotInitiated,
          amount: recordedAmount,
          rawStatus: rawStatus,
          hasRecordedAmount: recordedAmount > 0,
        );
      }
      return CustomerRefundInfo(
        state: CustomerRefundState.none,
        amount: recordedAmount,
        rawStatus: rawStatus,
        hasRecordedAmount: recordedAmount > 0,
      );
    }

    late final CustomerRefundState state;
    switch (normalizedStatus) {
      case 'processing':
        state = CustomerRefundState.processing;
        break;
      case 'succeeded':
        state = CustomerRefundState.succeeded;
        break;
      case 'failed':
        state = CustomerRefundState.failed;
        break;
      default:
        // Unknown backend values stay unknown: they are never treated as a
        // success or a failure.
        state = CustomerRefundState.unknown;
    }

    return CustomerRefundInfo(
      state: state,
      amount: recordedAmount,
      rawStatus: rawStatus,
      hasRecordedAmount: recordedAmount > 0,
    );
  }
}
