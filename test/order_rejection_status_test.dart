import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agricou/backend/orders/order_rejection_status.dart';
import 'package:agricou/backend/schema/order_record.dart';

class _FakeDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

OrderRecord _order(Map<String, dynamic> data) =>
    OrderRecord.getDocumentFromData(data, _FakeDocumentReference());

void main() {
  group('OrderRejectionInfo', () {
    test('an ordinary variable-weight refund is not a producer rejection', () {
      final info = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Preparing',
          'refund_status': 'processing',
          'refund_amount': 4.0,
          'refund_due_amount': 4.0,
        }),
      );

      expect(info.hasRejection, isFalse);
      expect(info.blocksNewPayment, isFalse);
      expect(info.refundPhase, OrderRejectionRefundPhase.none);
    });

    test('a successfully cancelled unpaid rejection requires no refund', () {
      final info = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'unpaid',
          'rejection_payment_confirmed': false,
          'rejection_payment_canceled': true,
          'rejection_refund_state': 'not_required',
          'rejection_inventory_state': 'not_required',
        }),
      );

      expect(info.hasRejection, isTrue);
      expect(info.blocksNewPayment, isTrue);
      expect(info.paymentPhase, OrderRejectionPaymentPhase.unpaid);
      expect(info.paymentCollected, isFalse);
      expect(info.paymentCanceled, isTrue);
      expect(info.refundPhase, OrderRejectionRefundPhase.notRequired);
      expect(info.refundCompleted, isFalse);
      expect(info.needsAttention, isFalse);
    });

    test(
      'a pending rejection request is distinguished from a completed one',
      () {
        final requested = OrderRejectionInfo.fromOrder(
          _order({
            'order_status': 'Pending',
            'rejection_state': 'requested',
            'rejection_refund_state': 'awaiting_payment',
          }),
        );
        expect(requested.hasRejection, isTrue);
        expect(requested.rejectionCompleted, isFalse);
        expect(requested.blocksNewPayment, isTrue);

        final completed = OrderRejectionInfo.fromOrder(
          _order({
            'order_status': 'Rejected',
            'rejection_state': 'completed',
            'rejection_refund_state': 'processing',
          }),
        );
        expect(completed.rejectionCompleted, isTrue);
        expect(completed.blocksNewPayment, isTrue);
      },
    );

    test('a generic refund state never becomes the rejection refund state', () {
      final missingRejectionState = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'paid',
          'rejection_payment_confirmed': true,
          // Shared fields that must NOT classify the rejection refund.
          'refund_status': 'succeeded',
          'refund_amount': 10.0,
          'currency': 'USD',
          // No rejection-specific amount or currency.
        }),
      );
      expect(
        missingRejectionState.refundPhase,
        OrderRejectionRefundPhase.unknown,
      );
      expect(missingRejectionState.refundCompleted, isFalse);
      expect(missingRejectionState.hasAmount, isFalse);
      expect(missingRejectionState.refundAmount, 0.0);
      expect(missingRejectionState.refundCurrency, isEmpty);

      final genericSucceededDuringRejectionProcessing =
          OrderRejectionInfo.fromOrder(
            _order({
              'order_status': 'Rejected',
              'rejection_state': 'completed',
              'rejection_payment_state': 'paid',
              'rejection_refund_state': 'processing',
              'rejection_refund_amount': 10.0,
              'rejection_refund_currency': 'EUR',
              'refund_status': 'succeeded',
            }),
          );
      expect(
        genericSucceededDuringRejectionProcessing.refundPhase,
        OrderRejectionRefundPhase.processing,
      );
      expect(
        genericSucceededDuringRejectionProcessing.refundCompleted,
        isFalse,
      );

      final genericFailedAfterRejectionSucceeded = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'paid',
          'rejection_refund_state': 'succeeded',
          'rejection_refund_amount': 10.0,
          'rejection_refund_currency': 'EUR',
          'refund_status': 'failed',
        }),
      );
      expect(
        genericFailedAfterRejectionSucceeded.refundPhase,
        OrderRejectionRefundPhase.completed,
      );
      expect(genericFailedAfterRejectionSucceeded.refundCompleted, isTrue);

      final genericSucceededOnUnpaidRejection = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'unpaid',
          'rejection_refund_state': 'not_required',
          'refund_status': 'succeeded',
        }),
      );
      expect(
        genericSucceededOnUnpaidRejection.refundPhase,
        OrderRejectionRefundPhase.notRequired,
      );
      expect(genericSucceededOnUnpaidRejection.refundCompleted, isFalse);
    });

    test(
      'amount and currency come only from the rejection-specific fields',
      () {
        final info = OrderRejectionInfo.fromOrder(
          _order({
            'order_status': 'Rejected',
            'rejection_state': 'completed',
            'rejection_payment_state': 'paid',
            'rejection_refund_state': 'processing',
            'rejection_refund_amount': 7.5,
            'rejection_refund_currency': 'eur',
            // Generic values must be ignored completely.
            'refund_amount': 99.0,
            'currency': 'usd',
          }),
        );

        expect(info.refundAmount, 7.5);
        expect(info.refundCurrency, 'EUR');
        expect(info.hasAmount, isTrue);
        expect(info.refundPhase, OrderRejectionRefundPhase.processing);
      },
    );

    test('minor units are preferred and a missing rejection currency omits '
        'the amount', () {
      final preferred = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'paid',
          'rejection_refund_state': 'processing',
          'rejection_refund_amount_minor': 2520,
          'rejection_refund_amount': 1.0,
          'rejection_refund_currency': 'eur',
        }),
      );
      expect(preferred.refundAmount, 25.2);
      expect(preferred.refundCurrency, 'EUR');
      expect(preferred.hasAmount, isTrue);

      final noCurrency = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'paid',
          'rejection_refund_state': 'processing',
          'rejection_refund_amount': 7.5,
          'currency': 'USD',
        }),
      );
      expect(noCurrency.refundAmount, 7.5);
      expect(noCurrency.refundCurrency, isEmpty);
      expect(noCurrency.hasAmount, isFalse);
    });

    test('a paid rejection shows pending, then processing, then completed', () {
      final base = <String, dynamic>{
        'order_status': 'Rejected',
        'rejection_state': 'completed',
        'rejection_payment_state': 'paid',
        'rejection_payment_confirmed': true,
        'rejection_refund_amount_minor': 2520,
        'rejection_refund_currency': 'eur',
        'rejection_inventory_state': 'restored',
      };

      final pending = OrderRejectionInfo.fromOrder(
        _order({...base, 'rejection_refund_state': 'pending'}),
      );
      expect(pending.paymentPhase, OrderRejectionPaymentPhase.paid);
      expect(pending.paymentCollected, isTrue);
      expect(pending.refundPhase, OrderRejectionRefundPhase.pending);
      expect(pending.refundAmount, 25.2);
      expect(pending.refundCurrency, 'EUR');

      final processing = OrderRejectionInfo.fromOrder(
        _order({...base, 'rejection_refund_state': 'processing'}),
      );
      expect(processing.refundPhase, OrderRejectionRefundPhase.processing);
      expect(processing.refundCompleted, isFalse);

      final completed = OrderRejectionInfo.fromOrder(
        _order({...base, 'rejection_refund_state': 'succeeded'}),
      );
      expect(completed.refundPhase, OrderRejectionRefundPhase.completed);
      expect(completed.refundCompleted, isTrue);
      expect(completed.needsAttention, isFalse);
    });

    test(
      'failed or ambiguous refunds need attention and never look complete',
      () {
        for (final state in ['failed', 'ambiguous', 'retryable']) {
          final info = OrderRejectionInfo.fromOrder(
            _order({
              'order_status': 'Rejected',
              'rejection_state': 'completed',
              'rejection_payment_state': 'paid',
              'rejection_refund_state': state,
              'rejection_refund_amount': 10.0,
            }),
          );
          expect(info.refundPhase, OrderRejectionRefundPhase.needsAttention);
          expect(info.refundCompleted, isFalse);
          expect(info.needsAttention, isTrue);
        }

        final reconciliation = OrderRejectionInfo.fromOrder(
          _order({
            'order_status': 'Rejected',
            'rejection_state': 'completed',
            'rejection_payment_state': 'paid',
            'rejection_refund_state': 'succeeded',
            'reconciliationRequired': true,
          }),
        );
        expect(reconciliation.refundPhase, OrderRejectionRefundPhase.completed);
        expect(reconciliation.needsAttention, isTrue);
      },
    );

    test('a processing late payment is pending, never paid', () {
      final info = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'processing',
          'rejection_refund_state': 'awaiting_payment',
        }),
      );

      expect(info.paymentPhase, OrderRejectionPaymentPhase.processing);
      expect(info.paymentCollected, isFalse);
      expect(info.refundPhase, OrderRejectionRefundPhase.pending);
      expect(info.refundCompleted, isFalse);
    });

    test('unverified inventory needs producer-facing attention', () {
      final info = OrderRejectionInfo.fromOrder(
        _order({
          'order_status': 'Rejected',
          'rejection_state': 'completed',
          'rejection_payment_state': 'unpaid',
          'rejection_refund_state': 'not_required',
          'rejection_inventory_state': 'unverified',
        }),
      );
      expect(info.needsAttention, isTrue);
    });
  });

  group('canProducerReject', () {
    test('allows a pending order without approval or refund history', () {
      expect(canProducerReject(_order({'order_status': 'Pending'})), isTrue);
      expect(canProducerReject(_order({'order_status': 'pending'})), isTrue);
      expect(canProducerReject(_order({})), isTrue);
    });

    test('denies approved, prepared, dispatched and closed orders', () {
      for (final status in [
        'Approved',
        'Preparing',
        'Picked Up',
        'In Transit',
        'Delivered',
        'Completed',
        'Canceled',
        'Cancelled',
        'Rejected',
      ]) {
        expect(
          canProducerReject(_order({'order_status': status})),
          isFalse,
          reason: status,
        );
      }
    });

    test('denies an order with a confirmation timestamp, suspension or a '
        'foreign refund', () {
      expect(
        canProducerReject(
          _order({
            'order_status': 'Pending',
            'order_confiramtion_time': DateTime.utc(2026, 11, 17),
          }),
        ),
        isFalse,
      );
      expect(
        canProducerReject(
          _order({'order_status': 'Pending', 'is_suspend': true}),
        ),
        isFalse,
      );
      expect(
        canProducerReject(
          _order({'order_status': 'Pending', 'refund_status': 'processing'}),
        ),
        isFalse,
      );
      expect(
        canProducerReject(
          _order({'order_status': 'Pending', 'refund_id': 're_1'}),
        ),
        isFalse,
      );
    });
  });

  group('rejectOrder response classification', () {
    test('only a verified success envelope is success', () {
      expect(
        classifyRejectOrderResponse(200, {
          'success': true,
          'orderId': 'order-1',
          'alreadyRejected': false,
        }),
        RejectOrderOutcome.rejected,
      );
      expect(
        classifyRejectOrderResponse(200, {
          'success': true,
          'orderId': 'order-1',
          'alreadyRejected': true,
        }),
        RejectOrderOutcome.alreadyRejected,
      );
      expect(
        classifyRejectOrderResponse(200, {'success': true}),
        RejectOrderOutcome.ambiguous,
      );
      expect(
        classifyRejectOrderResponse(200, null),
        RejectOrderOutcome.ambiguous,
      );
      expect(
        classifyRejectOrderResponse(200, {'orderId': 'order-1'}),
        RejectOrderOutcome.ambiguous,
      );
    });

    test('maps the actual backend error codes', () {
      expect(
        classifyRejectOrderResponse(409, {
          'code': 'rejection_payment_processing',
        }),
        RejectOrderOutcome.processing,
      );
      expect(
        classifyRejectOrderResponse(409, {'code': 'rejection_after_approval'}),
        RejectOrderOutcome.ineligible,
      );
      expect(
        classifyRejectOrderResponse(409, {'code': 'rejection_refund_conflict'}),
        RejectOrderOutcome.ineligible,
      );
      expect(
        classifyRejectOrderResponse(403, {'code': 'order_forbidden'}),
        RejectOrderOutcome.forbidden,
      );
      expect(
        classifyRejectOrderResponse(401, {'code': 'auth_required'}),
        RejectOrderOutcome.authRequired,
      );
      expect(
        classifyRejectOrderResponse(404, {'code': 'order_not_found'}),
        RejectOrderOutcome.notFound,
      );
      expect(
        classifyRejectOrderResponse(404, null),
        RejectOrderOutcome.ambiguous,
      );
      expect(
        classifyRejectOrderResponse(409, null),
        RejectOrderOutcome.ambiguous,
      );
      expect(
        classifyRejectOrderResponse(400, {'code': 'order_id_required'}),
        RejectOrderOutcome.failed,
      );
      expect(
        classifyRejectOrderResponse(503, {
          'code': 'rejection_state_unavailable',
        }),
        RejectOrderOutcome.ambiguous,
      );
    });

    test(
      'successful outcomes have no error message; failures are explicit',
      () {
        expect(
          rejectOrderErrorMessage(RejectOrderOutcome.rejected, french: false),
          isNull,
        );
        expect(
          rejectOrderErrorMessage(
            RejectOrderOutcome.alreadyRejected,
            french: true,
          ),
          isNull,
        );
        expect(
          rejectOrderErrorMessage(
            RejectOrderOutcome.ineligible,
            french: false,
            serverError: 'This order has already been approved.',
          ),
          'This order has already been approved.',
        );
        expect(
          rejectOrderErrorMessage(RejectOrderOutcome.processing, french: false),
          contains('still being processed'),
        );
        expect(
          rejectOrderErrorMessage(RejectOrderOutcome.ambiguous, french: false),
          contains('could not be confirmed'),
        );
      },
    );
  });

  group('SingleFlightGuard', () {
    test('duplicate taps invoke the request only once', () async {
      final guard = SingleFlightGuard();
      final completer = Completer<int>();
      var calls = 0;

      Future<int> task() {
        calls += 1;
        return completer.future;
      }

      final first = guard.run(task);
      final duplicate = guard.run(task);
      expect(await duplicate, isNull);
      expect(calls, 1);
      expect(guard.busy, isTrue);

      completer.complete(7);
      expect(await first, 7);
      expect(guard.busy, isFalse);

      // After completion a new request is allowed (e.g. retry after failure).
      final retry = await guard.run(() async => 8);
      expect(retry, 8);
    });
  });
}
