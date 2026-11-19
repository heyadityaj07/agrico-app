/// Backend-owned checkout-v1 sequence.
///
/// The flow is deliberately free of Flutter widgets so the order → quote →
/// bind → PaymentSheet sequence, cancellation classification and retry rules
/// can be unit-tested. The PaymentSheet itself is injected by the caller.
library;

import 'checkout_v1_api.dart';
import 'checkout_v1_client.dart';

typedef CheckoutPaymentSheetRunner = Future<String> Function(
  String orderId,
  String? quoteId,
  String currency,
);
typedef CheckoutAttemptSaver = Future<void> Function(CheckoutAttempt attempt);

enum CheckoutV1FlowOutcome {
  /// The order/quote exist and the PaymentSheet was presented. The backend
  /// webhook remains the authority for success.
  awaitingFinalization,

  /// No duplicate order should be created. Retry the same attempt.
  retryable,

  /// The backend confirmed cancellation (or the order was already cancelled).
  cancelled,

  /// The backend reports the reservation expired.
  expired,

  /// A definitive error before payment; no charge can result from this attempt.
  terminal,

  /// The backend reports refund/reconciliation. Do not retry automatically.
  needsSupport,
}

class CheckoutV1FlowResult {
  const CheckoutV1FlowResult({
    required this.outcome,
    required this.attempt,
    this.orderId,
    this.quoteId,
    this.deliveryFee,
    this.errorCode,
    this.message,
  });

  final CheckoutV1FlowOutcome outcome;
  final CheckoutAttempt attempt;
  final String? orderId;
  final String? quoteId;
  final double? deliveryFee;
  final String? errorCode;
  final String? message;

  bool get shouldObserveOrder =>
      outcome == CheckoutV1FlowOutcome.awaitingFinalization && orderId != null;
}

enum CheckoutFinalizationDecision { confirmed, pending, closed, needsSupport }

/// Decides what the UI may do for an observed backend-owned order state.
///
/// Only `confirmed` permits clearing the purchased cart lines and showing
/// success.
CheckoutFinalizationDecision decideCheckoutFinalization(
  CheckoutFinalizationState state,
) {
  if (checkoutFinalizationIsConfirmed(state)) {
    return CheckoutFinalizationDecision.confirmed;
  }
  if (checkoutFinalizationNeedsSupport(state)) {
    return CheckoutFinalizationDecision.needsSupport;
  }
  if (checkoutFinalizationIsClosed(state)) {
    return CheckoutFinalizationDecision.closed;
  }
  return CheckoutFinalizationDecision.pending;
}

/// Runs order creation, Uber quote/bind and the injected PaymentSheet step.
///
/// Callers must pass the persisted [attempt]. The flow starts from whatever
/// step is incomplete, so a timed-out or interrupted attempt never creates a
/// second order:
///   * `orderId != null` skips `createCheckoutOrder`;
///   * a bound `quoteId` skips quote generation/binding.
Future<CheckoutV1FlowResult> createCheckoutV1Intent({
  required CheckoutV1ApiAdapter api,
  required CheckoutAttempt attempt,
  required Map<String, dynamic> request,
  required CheckoutPaymentSheetRunner presentPayment,
  required CheckoutAttemptSaver saveAttempt,
}) async {
  var current = attempt;

  if (current.orderId == null) {
    final created = await api.createOrder(request);
    if (!created.isSuccess || created.orderId == null) {
      if (created.isAmbiguous) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.retryable,
          attempt: current,
          errorCode: created.code,
          message: created.message,
        );
      }

      final classified = classifyCheckoutErrorCode(created.code);
      if (classified == CheckoutPaymentOutcome.alreadyConfirmed) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.awaitingFinalization,
          attempt: current,
          errorCode: created.code,
          message: created.message,
        );
      }
      if (classified == CheckoutPaymentOutcome.needsSupport) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.needsSupport,
          attempt: current,
          errorCode: created.code,
          message: created.message,
        );
      }
      if (classified == CheckoutPaymentOutcome.terminal) {
        final failed = current.copyWith(phase: CheckoutAttemptPhase.failed);
        await saveAttempt(failed);
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.terminal,
          attempt: failed,
          errorCode: created.code,
          message: created.message,
        );
      }

      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.retryable,
        attempt: current,
        errorCode: created.code,
        message: created.message,
      );
    }

    current = current.copyWith(
      phase: CheckoutAttemptPhase.orderCreated,
      orderId: created.orderId,
    );
    await saveAttempt(current);
  }

  final orderId = current.orderId!;
  double? deliveryFee;

  if (current.deliveryMethod == CheckoutDeliveryMethod.uber &&
      current.quoteId == null) {
    final quote = await api.getUberQuote(orderId);
    if (!quote.isSuccess || quote.quoteId == null) {
      if (quote.isAmbiguous) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.retryable,
          attempt: current,
          orderId: orderId,
          errorCode: quote.code,
          message: quote.message,
        );
      }

      final classified = classifyCheckoutErrorCode(quote.code);
      if (classified == CheckoutPaymentOutcome.retryable) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.retryable,
          attempt: current,
          orderId: orderId,
          errorCode: quote.code,
          message: quote.message,
        );
      }

      return cancelCheckoutV1Attempt(
        api: api,
        attempt: current,
        saveAttempt: saveAttempt,
        errorCode: quote.code,
        message: quote.message,
      );
    }

    final bound = await api.bindUberQuote(
      orderId: orderId,
      quoteId: quote.quoteId!,
    );
    if (!bound.isSuccess) {
      if (bound.isAmbiguous) {
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.retryable,
          attempt: current,
          orderId: orderId,
          errorCode: bound.code,
          message: bound.message,
        );
      }
      if (bound.data?['paymentInitiated'] == true) {
        final observing = current.copyWith(
          phase: CheckoutAttemptPhase.awaitingFinalization,
        );
        await saveAttempt(observing);
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.awaitingFinalization,
          attempt: observing,
          orderId: orderId,
          errorCode: bound.code,
          message: bound.message,
        );
      }
      if (bound.quoteExpired ||
          bound.code == 'quote_expired' ||
          bound.code == 'quote_unavailable' ||
          bound.code == 'quote_not_bound') {
        // Keep the order/reservation and request a fresh quote next time.
        return CheckoutV1FlowResult(
          outcome: CheckoutV1FlowOutcome.retryable,
          attempt: current,
          orderId: orderId,
          errorCode: bound.code,
          message: bound.message,
        );
      }

      return cancelCheckoutV1Attempt(
        api: api,
        attempt: current,
        saveAttempt: saveAttempt,
        errorCode: bound.code,
        message: bound.message,
      );
    }

    if (!bound.quotePaymentEligible || bound.quoteExpired) {
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.retryable,
        attempt: current,
        orderId: orderId,
        errorCode: bound.code,
        message: bound.message,
      );
    }

    deliveryFee = bound.deliveryFee;
    current = current.copyWith(
      phase: CheckoutAttemptPhase.quoteBound,
      quoteId: bound.quoteId ?? quote.quoteId,
    );
    await saveAttempt(current);
  }

  // Persist the observing phase before presenting the sheet: the PaymentIntent
  // may already exist even if the app is interrupted while the sheet is open.
  current = current.copyWith(phase: CheckoutAttemptPhase.awaitingFinalization);
  await saveAttempt(current);

  final paymentResult = await presentPayment(
    orderId,
    current.quoteId,
    current.currency,
  );
  final paymentOutcome = classifyCheckoutPaymentResult(paymentResult);

  switch (paymentOutcome) {
    case CheckoutPaymentOutcome.confirmed:
    case CheckoutPaymentOutcome.paymentSheetCompleted:
    case CheckoutPaymentOutcome.alreadyConfirmed:
    case CheckoutPaymentOutcome.retryable:
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.awaitingFinalization,
        attempt: current,
        orderId: orderId,
        quoteId: current.quoteId,
        deliveryFee: deliveryFee,
        errorCode: paymentResult,
      );

    case CheckoutPaymentOutcome.cancelled:
    case CheckoutPaymentOutcome.declined:
    case CheckoutPaymentOutcome.terminal:
    case CheckoutPaymentOutcome.needsSupport:
      return cancelCheckoutV1Attempt(
        api: api,
        attempt: current,
        saveAttempt: saveAttempt,
        errorCode: paymentResult,
      );
  }
}

Future<CheckoutV1FlowResult> cancelCheckoutV1Attempt({
  required CheckoutV1ApiAdapter api,
  required CheckoutAttempt attempt,
  required CheckoutAttemptSaver saveAttempt,
  String? errorCode,
  String? message,
}) async {
  final orderId = attempt.orderId;
  if (orderId == null) {
    final failed = attempt.copyWith(phase: CheckoutAttemptPhase.failed);
    await saveAttempt(failed);
    return CheckoutV1FlowResult(
      outcome: CheckoutV1FlowOutcome.terminal,
      attempt: failed,
      errorCode: errorCode,
      message: message,
    );
  }

  final requested = attempt.copyWith(
    phase: CheckoutAttemptPhase.awaitingFinalization,
    cancelRequested: true,
  );
  await saveAttempt(requested);

  final cancelled = await api.cancelOrder(orderId);
  if (cancelled.isSuccess) {
    final closed = requested.copyWith(phase: CheckoutAttemptPhase.cancelled);
    await saveAttempt(closed);
    return CheckoutV1FlowResult(
      outcome: CheckoutV1FlowOutcome.cancelled,
      attempt: closed,
      orderId: orderId,
      errorCode: errorCode,
      message: message,
    );
  }

  switch (classifyCheckoutCancellation(cancelled)) {
    case CheckoutCancellationOutcome.cancelled:
      final closed = requested.copyWith(phase: CheckoutAttemptPhase.cancelled);
      await saveAttempt(closed);
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.cancelled,
        attempt: closed,
        orderId: orderId,
        errorCode: cancelled.code ?? errorCode,
        message: cancelled.message ?? message,
      );
    case CheckoutCancellationOutcome.orderFinalized:
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.awaitingFinalization,
        attempt: requested,
        orderId: orderId,
        errorCode: cancelled.code ?? errorCode,
        message: cancelled.message ?? message,
      );
    case CheckoutCancellationOutcome.expired:
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.expired,
        attempt: requested.copyWith(phase: CheckoutAttemptPhase.failed),
        orderId: orderId,
        errorCode: cancelled.code ?? errorCode,
        message: cancelled.message ?? message,
      );
    case CheckoutCancellationOutcome.needsSupport:
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.needsSupport,
        attempt: requested.copyWith(phase: CheckoutAttemptPhase.needsReview),
        orderId: orderId,
        errorCode: cancelled.code ?? errorCode,
        message: cancelled.message ?? message,
      );
    case CheckoutCancellationOutcome.retryable:
      return CheckoutV1FlowResult(
        outcome: CheckoutV1FlowOutcome.retryable,
        attempt: requested,
        orderId: orderId,
        errorCode: cancelled.code ?? errorCode,
        message: cancelled.message ?? message,
      );
  }
}

enum CheckoutCancellationOutcome {
  cancelled,
  orderFinalized,
  expired,
  needsSupport,
  retryable,
}

CheckoutCancellationOutcome classifyCheckoutCancellation(
  CheckoutV1ApiResult result,
) {
  if (result.isSuccess) return CheckoutCancellationOutcome.cancelled;

  switch (result.code) {
    case 'payment_already_succeeded':
    case 'order_finalized':
      return CheckoutCancellationOutcome.orderFinalized;
    case 'checkout_expired':
      return CheckoutCancellationOutcome.expired;
    case 'payment_cancellation_failed':
    case 'payment_transfer_already_completed':
      return CheckoutCancellationOutcome.needsSupport;
    default:
      return CheckoutCancellationOutcome.retryable;
  }
}
