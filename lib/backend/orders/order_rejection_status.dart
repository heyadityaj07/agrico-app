import '/backend/schema/order_record.dart';

/// Read-only classification of the producer-rejection state persisted by the
/// Phase 1 backend (`rejectOrder`, the payment webhook and the shared refund
/// engine).
///
/// The client never writes these fields and never derives a payment or refund
/// outcome from a local action. This helper only reads the trusted order
/// document and mirrors the backend predicate exactly:
///   `order_status == 'Rejected'`
///   or any non-empty `rejection_state` / `rejection_refund_state`
///   or a producer-rejection refund marker.
///
/// In particular a generic `refund_status` value alone is NOT a rejection:
/// ordinary variable-weight overpayment refunds use the same field.
enum OrderRejectionRefundPhase {
  none,
  notRequired,
  pending,
  processing,
  completed,
  needsAttention,
  unknown,
}

enum OrderRejectionPaymentPhase { none, unpaid, processing, paid, unknown }

class OrderRejectionInfo {
  const OrderRejectionInfo({
    required this.isRejection,
    required this.rejectionCompleted,
    required this.rejectionState,
    required this.paymentState,
    required this.paymentConfirmed,
    required this.paymentCanceled,
    required this.refundState,
    required this.refundAmount,
    required this.refundCurrency,
    required this.inventoryState,
    required this.reconciliationRequired,
    required this.refundPhase,
    required this.paymentPhase,
  });

  /// True when the trusted document carries a producer-rejection marker.
  final bool isRejection;
  final bool rejectionCompleted;
  final String rejectionState;
  final String paymentState;
  final bool paymentConfirmed;
  final bool paymentCanceled;
  final String refundState;
  final double refundAmount;
  final String refundCurrency;
  final String inventoryState;
  final bool reconciliationRequired;
  final OrderRejectionRefundPhase refundPhase;
  final OrderRejectionPaymentPhase paymentPhase;

  bool get hasRejection => isRejection;

  /// A rejected or rejection-pending order must never start a new checkout,
  /// balance payment or producer transfer. Mirrors the backend predicate.
  bool get blocksNewPayment => isRejection;

  bool get paymentCollected => paymentPhase == OrderRejectionPaymentPhase.paid;

  bool get refundCompleted =>
      refundPhase == OrderRejectionRefundPhase.completed;

  bool get needsAttention =>
      reconciliationRequired ||
      refundPhase == OrderRejectionRefundPhase.needsAttention ||
      inventoryState.toLowerCase() == 'unverified' ||
      inventoryState.toLowerCase() == 'partial';

  /// True only when the backend persisted both a rejection-specific amount and
  /// currency. Generic `refund_amount`/`currency` are never used.
  bool get hasAmount => refundAmount > 0 && refundCurrency.isNotEmpty;

  factory OrderRejectionInfo.fromOrder(OrderRecord order) {
    final data = order.snapshotData;
    final status = _text(data['order_status']).toLowerCase();
    final rejectionState = _text(data['rejection_state']);
    final rejectionRefundState = _text(data['rejection_refund_state']);
    final rejectionRefundKind = _text(data['rejection_refund_kind']);
    final refundReason = _text(data['refund_reason']);
    final refundKind = _text(data['refund_kind']);

    final isRejection =
        status == 'rejected' ||
        rejectionState.isNotEmpty ||
        rejectionRefundState.isNotEmpty ||
        rejectionRefundKind == 'producer_rejection' ||
        refundReason == 'producer_rejection' ||
        refundKind == 'order_rejection_refund';

    final paymentState = _text(data['rejection_payment_state']).toLowerCase();
    final paymentConfirmed = data['rejection_payment_confirmed'] == true;
    final paymentCanceled = data['rejection_payment_canceled'] == true;

    // Rejection refund classification uses ONLY the rejection-specific state.
    // A generic `refund_status` is shared with ordinary variable-weight
    // refunds and is not guaranteed to describe this rejection (for example on
    // legacy `order_status: 'Rejected'` documents). When the rejection state
    // is missing the outcome stays unknown instead of borrowing a status.
    final effectiveRefundState = rejectionRefundState.toLowerCase();

    final amountMinor = _number(data['rejection_refund_amount_minor']);
    final amount = amountMinor > 0
        ? amountMinor / 100
        : _number(data['rejection_refund_amount']);

    // Only the rejection-specific currency is trusted; generic `currency` is
    // not written by the rejection flow.
    final currency = _text(data['rejection_refund_currency']).toUpperCase();

    final inventoryState = _text(data['rejection_inventory_state']);

    return OrderRejectionInfo(
      isRejection: isRejection,
      rejectionCompleted: status == 'rejected' || rejectionState == 'completed',
      rejectionState: rejectionState.toLowerCase(),
      paymentState: paymentState,
      paymentConfirmed: paymentConfirmed,
      paymentCanceled: paymentCanceled,
      refundState: effectiveRefundState,
      refundAmount: amount,
      refundCurrency: currency,
      inventoryState: inventoryState.toLowerCase(),
      reconciliationRequired: data['reconciliationRequired'] == true,
      refundPhase: _refundPhase(
        isRejection: isRejection,
        paymentState: paymentState,
        paymentConfirmed: paymentConfirmed,
        refundState: effectiveRefundState,
        amount: amount,
      ),
      paymentPhase: _paymentPhase(
        isRejection: isRejection,
        paymentState: paymentState,
        paymentConfirmed: paymentConfirmed,
      ),
    );
  }

  static OrderRejectionPaymentPhase _paymentPhase({
    required bool isRejection,
    required String paymentState,
    required bool paymentConfirmed,
  }) {
    if (!isRejection) return OrderRejectionPaymentPhase.none;
    if (paymentConfirmed || paymentState == 'paid') {
      return OrderRejectionPaymentPhase.paid;
    }
    if (paymentState == 'unpaid') return OrderRejectionPaymentPhase.unpaid;
    if (paymentState == 'processing') {
      return OrderRejectionPaymentPhase.processing;
    }
    return OrderRejectionPaymentPhase.unknown;
  }

  static OrderRejectionRefundPhase _refundPhase({
    required bool isRejection,
    required String paymentState,
    required bool paymentConfirmed,
    required String refundState,
    required double amount,
  }) {
    if (!isRejection) return OrderRejectionRefundPhase.none;
    if (refundState == 'not_required') {
      return OrderRejectionRefundPhase.notRequired;
    }
    if (refundState == 'processing') {
      return OrderRejectionRefundPhase.processing;
    }
    if (refundState == 'succeeded' || refundState == 'completed') {
      return OrderRejectionRefundPhase.completed;
    }
    if (refundState == 'failed' ||
        refundState == 'ambiguous' ||
        refundState == 'retryable') {
      return OrderRejectionRefundPhase.needsAttention;
    }
    if (refundState == 'pending' ||
        refundState == 'not_started' ||
        refundState == 'awaiting_payment') {
      return OrderRejectionRefundPhase.pending;
    }

    if (paymentState == 'processing') {
      return OrderRejectionRefundPhase.pending;
    }
    if ((paymentConfirmed || paymentState == 'paid') && amount > 0) {
      return OrderRejectionRefundPhase.pending;
    }
    if (paymentState == 'unpaid') {
      return OrderRejectionRefundPhase.notRequired;
    }
    return OrderRejectionRefundPhase.unknown;
  }
}

/// UI convenience only. The backend remains authoritative for authorization
/// and eligibility. Mirrors `assertRejectionEligible`.
bool canProducerReject(OrderRecord order) {
  final data = order.snapshotData;
  final info = OrderRejectionInfo.fromOrder(order);
  if (info.hasRejection) return false;
  if (data['is_suspend'] == true) return false;

  final status = _text(data['order_status']).toLowerCase();
  if (status == 'approved' ||
      status == 'preparing' ||
      status == 'picked up' ||
      status == 'in transit' ||
      status == 'delivered' ||
      status == 'completed' ||
      status == 'canceled' ||
      status == 'cancelled' ||
      status == 'rejected') {
    return false;
  }
  if (data['order_confiramtion_time'] != null) return false;

  if (status.isNotEmpty && status != 'pending') return false;
  if (_hasForeignRefundHistory(data, info)) return false;
  return true;
}

bool _hasForeignRefundHistory(
  Map<String, dynamic> data,
  OrderRejectionInfo info,
) {
  if (info.hasRejection) return false;
  final hasHistory =
      _text(data['refund_status']).isNotEmpty ||
      _text(data['refund_id']).isNotEmpty ||
      _number(data['refund_attempt']) >= 1 ||
      (data['refund_attempts'] is List &&
          (data['refund_attempts'] as List).isNotEmpty);
  return hasHistory;
}

String _text(dynamic value) => value is String ? value.trim() : '';

double _number(dynamic value) {
  if (value is num && value.isFinite) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null && parsed.isFinite) return parsed;
  }
  return 0.0;
}

/// Outcome of a `rejectOrder` Cloud Function call. The client never treats an
/// unverified/ambiguous response as success.
enum RejectOrderOutcome {
  rejected,
  alreadyRejected,
  processing,
  ineligible,
  forbidden,
  authRequired,
  notFound,
  failed,
  ambiguous,
}

bool isRejectOrderSuccess(RejectOrderOutcome outcome) =>
    outcome == RejectOrderOutcome.rejected ||
    outcome == RejectOrderOutcome.alreadyRejected;

/// Classifies the actual `rejectOrder` HTTP contract:
///   200 `{ success: true, orderId, alreadyRejected, changed, ... }`
///   4xx `{ error, code }`
///   503 `{ error, code: 'rejection_state_unavailable' }`
RejectOrderOutcome classifyRejectOrderResponse(int statusCode, dynamic body) {
  final map = body is Map ? body : null;
  final code = map == null ? '' : _text(map['code']);

  if (statusCode == 200) {
    if (map == null ||
        map['success'] != true ||
        _text(map['orderId']).isEmpty) {
      return RejectOrderOutcome.ambiguous;
    }
    return map['alreadyRejected'] == true
        ? RejectOrderOutcome.alreadyRejected
        : RejectOrderOutcome.rejected;
  }

  if (statusCode == 401 ||
      code == 'auth_required' ||
      code == 'auth_invalid' ||
      code == 'auth_unavailable') {
    return RejectOrderOutcome.authRequired;
  }
  if (statusCode == 403 ||
      code == 'order_forbidden' ||
      code == 'producer_unavailable') {
    return RejectOrderOutcome.forbidden;
  }
  if (statusCode == 404) {
    if (code == 'order_not_found' || code == 'farm_not_found') {
      return RejectOrderOutcome.notFound;
    }
    // A platform/proxy 404 (for example an undeployed function) is not proof
    // that the order is missing.
    return map == null
        ? RejectOrderOutcome.ambiguous
        : RejectOrderOutcome.failed;
  }
  if (statusCode == 409) {
    if (map == null) return RejectOrderOutcome.ambiguous;
    return code == 'rejection_payment_processing'
        ? RejectOrderOutcome.processing
        : RejectOrderOutcome.ineligible;
  }
  if (statusCode >= 400 && statusCode < 500) {
    return RejectOrderOutcome.failed;
  }
  return RejectOrderOutcome.ambiguous;
}

/// Localized user-facing message. Returns null for successful outcomes; the
/// caller shows its own success confirmation.
String? rejectOrderErrorMessage(
  RejectOrderOutcome outcome, {
  required bool french,
  String? serverError,
}) {
  switch (outcome) {
    case RejectOrderOutcome.rejected:
    case RejectOrderOutcome.alreadyRejected:
      return null;
    case RejectOrderOutcome.processing:
      return french
          ? 'Un paiement ou un virement producteur est encore en cours pour cette commande. Réessayez dans un instant.'
          : 'A payment or producer transfer is still being processed for this order. Please retry shortly.';
    case RejectOrderOutcome.ineligible:
      return _serverOr(
        serverError,
        french
            ? 'Cette commande ne peut plus être refusée car elle a déjà été approuvée, préparée ou fermée.'
            : 'This order can no longer be rejected because it has already been approved, prepared or closed.',
      );
    case RejectOrderOutcome.forbidden:
      return french
          ? 'Seul le propriétaire de la ferme peut refuser cette commande.'
          : 'Only the farm owner can reject this order.';
    case RejectOrderOutcome.authRequired:
      return french
          ? 'Votre session a expiré. Veuillez vous reconnecter.'
          : 'Your session has expired. Please sign in again.';
    case RejectOrderOutcome.notFound:
      return french ? 'Commande introuvable.' : 'Order not found.';
    case RejectOrderOutcome.failed:
      return _serverOr(
        serverError,
        french
            ? 'La commande n’a pas pu être refusée. Aucune modification n’a été apportée ; veuillez réessayer.'
            : 'The order could not be rejected. No changes were made; please retry.',
      );
    case RejectOrderOutcome.ambiguous:
      return french
          ? 'Le résultat du refus n’a pas pu être confirmé. Rouvrez la commande pour vérifier son statut avant de réessayer.'
          : 'The rejection outcome could not be confirmed. Reopen the order to check its status before trying again.';
  }
}

String _serverOr(String? serverError, String fallback) {
  final value = serverError == null ? '' : serverError.trim();
  return value.isEmpty ? fallback : value;
}

/// Small single-flight helper so duplicate taps cannot issue duplicate
/// requests. Returns null when a request is already in flight.
class SingleFlightGuard {
  bool _busy = false;

  bool get busy => _busy;

  Future<T?> run<T>(Future<T> Function() task) async {
    if (_busy) return null;
    _busy = true;
    try {
      return await task();
    } finally {
      _busy = false;
    }
  }
}
