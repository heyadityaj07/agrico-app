import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agricou/backend/schema/order_record.dart';
import 'package:agricou/backend/schema/structs/order_items_struct.dart';

/// The model only stores the reference during parsing/serialization, so a
/// no-op implementation is enough for these data-level round-trip tests.
class _FakeDocumentReference implements DocumentReference<Map<String, dynamic>> {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

void main() {
  final parsedAt = DateTime.utc(2026, 11, 9, 10, 30);
  final orderData = <String, dynamic>{
    'refund_due_amount': 5.25,
    'refund_status': 'processing',
    'refund_amount': 5.25,
    'refund_id': 're_1',
    'refund_attempt': 2,
    'refund_attempts': [
      {
        'attempt': 1,
        'status': 'failed',
        'amount': 5.25,
        'failureReason': 'card_declined',
      },
      {
        'attempt': 2,
        'status': 'processing',
        'amount': 5.25,
        'refundId': 're_1',
      },
    ],
    'refund_transfer_reversal_status': 'failed',
    'refund_transfer_reversal_reason': 'payment_ledger_inconsistent',
    'refund_transfer_reversal_amount': 3.0,
    'refund_transfer_reversal_shortfall_amount': 2.25,
    'refund_transfer_reversal_partial': true,
    'reconciliationRequired': true,
    'reconciliation_issues': {
      'refund_transfer_reversal': {
        'status': 'open',
        'reason': 'transfer_reversal_shortfall',
      },
    },
    'balance_paid_at': parsedAt,
    'balance_payment_state': 'paid',
    'balance_payment_intent_id': 'pi_balance_1',
    'balance_payment_attempt': 1,
    'order_items': [
      {
        'product_ref': null,
        'total_items': 2,
        'price_per_product': 12.5,
        'is_variable_weight': true,
        'min_weight': 2.0,
        'max_weight': 3.0,
        'price_per_kg': 5.0,
        'actual_weight': 2.6,
        'deposit_amount': 3.75,
        'final_item_price': 26.0,
        'remaining_balance': 18.5,
        'weight_locked': true,
        'refund_due': 3.25,
        'weight_below_minimum': true,
        'weight_above_maximum': false,
      },
    ],
  };

  group('OrderRecord refund/reconciliation alignment', () {
    OrderRecord recordFrom(Map<String, dynamic> data) =>
        OrderRecord.getDocumentFromData(data, _FakeDocumentReference());

    test('classifies valid and malformed legacy settlement snapshots', () {
      final valid = recordFrom({
        'final_balance_amount': 10.0,
        'refund_due_amount': 4.0,
      });
      expect(valid.settlementFormat, SettlementFormat.legacy);
      expect(valid.settlementBalanceAmount(), 10.0);
      expect(valid.settlementRefundAmount(), 4.0);

      for (final data in [
        {'final_balance_amount': 10.0},
        {'refund_due_amount': 4.0},
        {'final_balance_amount': -1.0, 'refund_due_amount': 0.0},
        {'final_balance_amount': double.nan, 'refund_due_amount': 0.0},
        {'final_balance_amount': 10.0, 'refund_due_amount': double.infinity},
      ]) {
        final malformed = recordFrom(data);
        expect(malformed.settlementFormat, SettlementFormat.malformed);
        expect(malformed.settlementBalanceAmount(), isNull);
        expect(malformed.settlementRefundAmount(), isNull);
      }
    });

    test('requires complete arithmetic for new-format settlements', () {
      final valid = recordFrom({
        'final_balance_amount': 10.0,
        'refund_due_amount': 4.0,
        'refund_credit_applied_amount': 4.0,
        'net_balance_due_amount': 6.0,
        'remaining_refund_due_amount': 0.0,
        'settlement_version': 0,
      });
      expect(valid.settlementFormat, SettlementFormat.newFormat);
      expect(valid.settlementBalanceAmount(), 6.0);
      expect(valid.settlementRefundAmount(), 0.0);

      for (final data in [
        {
          'settlement_version': 0,
          'final_balance_amount': 10.0,
          'refund_due_amount': 4.0,
        },
        {
          'settlement_outcome': 'underpaid',
          'final_balance_amount': 10.0,
          'refund_due_amount': 4.0,
        },
        {
          'final_balance_amount': 10.0,
          'refund_due_amount': 4.0,
          'refund_credit_applied_amount': 3.0,
          'net_balance_due_amount': 7.0,
          'remaining_refund_due_amount': 1.0,
          'settlement_version': 0,
        },
        {
          'final_balance_amount': 10.0,
          'refund_due_amount': 4.0,
          'refund_credit_applied_amount': 4.0,
          'net_balance_due_amount': 6.0,
          'remaining_refund_due_amount': 1.0,
          'settlement_version': 0,
        },
      ]) {
        final malformed = recordFrom(data);
        expect(malformed.settlementFormat, SettlementFormat.malformed);
        expect(malformed.settlementBalanceAmount(), isNull);
        expect(malformed.settlementRefundAmount(), isNull);
      }
    });

    test('parses the server-owned refund, reversal and balance fields', () {
      final record = OrderRecord.getDocumentFromData(
        orderData,
        _FakeDocumentReference(),
      );

      expect(record.refundDueAmount, 5.25);
      expect(record.refundStatus, 'processing');
      expect(record.refundAmount, 5.25);
      expect(record.refundId, 're_1');
      expect(record.refundAttempt, 2);
      expect(record.refundAttempts, hasLength(2));
      expect(record.refundTransferReversalStatus, 'failed');
      expect(record.refundTransferReversalReason,
          'payment_ledger_inconsistent');
      expect(record.refundTransferReversalAmount, 3.0);
      expect(record.refundTransferReversalShortfallAmount, 2.25);
      expect(record.refundTransferReversalPartial, true);
      expect(record.reconciliationRequired, true);
      expect(record.reconciliationIssues['refund_transfer_reversal']['status'],
          'open');
      expect(record.balancePaidAt, parsedAt);
      expect(record.balancePaymentState, 'paid');
      expect(record.balancePaymentIntentId, 'pi_balance_1');
      expect(record.balancePaymentAttempt, 1);
    });

    test('parses the item-level refund and weight-warning fields', () {
      final record = OrderRecord.getDocumentFromData(
        orderData,
        _FakeDocumentReference(),
      );
      final item = record.orderItems.single;

      expect(item.refundDue, 3.25);
      expect(item.weightBelowMinimum, true);
      expect(item.weightAboveMaximum, false);
    });

    test('serializes the new fields with the existing Firestore names', () {
      final serialized = createOrderRecordData(
        refundDueAmount: 5.25,
        refundStatus: 'processing',
        refundAmount: 5.25,
        refundId: 're_1',
        refundAttempt: 2,
        refundAttempts: [
          {'attempt': 1, 'status': 'failed'},
        ],
        refundTransferReversalStatus: 'failed',
        refundTransferReversalReason: 'payment_ledger_inconsistent',
        refundTransferReversalAmount: 3.0,
        refundTransferReversalShortfallAmount: 2.25,
        refundTransferReversalPartial: true,
        reconciliationRequired: true,
        reconciliationIssues: {
          'refund_transfer_reversal': {'status': 'open'},
        },
        balancePaidAt: parsedAt,
        balancePaymentState: 'paid',
        balancePaymentIntentId: 'pi_balance_1',
        balancePaymentAttempt: 1,
      );

      expect(serialized['refund_due_amount'], 5.25);
      expect(serialized['refund_status'], 'processing');
      expect(serialized['refund_amount'], 5.25);
      expect(serialized['refund_id'], 're_1');
      expect(serialized['refund_attempt'], 2);
      expect(serialized['refund_attempts'], hasLength(1));
      expect(serialized['refund_transfer_reversal_status'], 'failed');
      expect(serialized['refund_transfer_reversal_reason'],
          'payment_ledger_inconsistent');
      expect(serialized['refund_transfer_reversal_amount'], 3.0);
      expect(serialized['refund_transfer_reversal_shortfall_amount'], 2.25);
      expect(serialized['refund_transfer_reversal_partial'], true);
      expect(serialized['reconciliationRequired'], true);
      expect(serialized['reconciliation_issues'], isA<Map>());
      expect(serialized['balance_paid_at'], parsedAt);
      expect(serialized['balance_payment_state'], 'paid');
      expect(serialized['balance_payment_intent_id'], 'pi_balance_1');
      expect(serialized['balance_payment_attempt'], 1);
    });

    test('round-trip preserves the new order and item fields', () {
      final record = OrderRecord.getDocumentFromData(
        orderData,
        _FakeDocumentReference(),
      );
      final serialized = createOrderRecordData(
        refundDueAmount: record.refundDueAmount,
        refundStatus: record.refundStatus,
        refundAmount: record.refundAmount,
        refundId: record.refundId,
        refundAttempt: record.refundAttempt,
        refundAttempts: record.refundAttempts,
        refundTransferReversalStatus: record.refundTransferReversalStatus,
        refundTransferReversalReason: record.refundTransferReversalReason,
        refundTransferReversalAmount: record.refundTransferReversalAmount,
        refundTransferReversalShortfallAmount:
            record.refundTransferReversalShortfallAmount,
        refundTransferReversalPartial: record.refundTransferReversalPartial,
        reconciliationRequired: record.reconciliationRequired,
        reconciliationIssues: record.reconciliationIssues,
        balancePaidAt: record.balancePaidAt,
        balancePaymentState: record.balancePaymentState,
        balancePaymentIntentId: record.balancePaymentIntentId,
        balancePaymentAttempt: record.balancePaymentAttempt,
      );
      final reparsed = OrderRecord.getDocumentFromData(
        serialized,
        _FakeDocumentReference(),
      );

      expect(reparsed.refundDueAmount, record.refundDueAmount);
      expect(reparsed.refundStatus, record.refundStatus);
      expect(reparsed.refundAmount, record.refundAmount);
      expect(reparsed.refundId, record.refundId);
      expect(reparsed.refundAttempt, record.refundAttempt);
      expect(reparsed.refundAttempts, record.refundAttempts);
      expect(reparsed.refundTransferReversalStatus,
          record.refundTransferReversalStatus);
      expect(reparsed.refundTransferReversalReason,
          record.refundTransferReversalReason);
      expect(reparsed.refundTransferReversalAmount,
          record.refundTransferReversalAmount);
      expect(reparsed.refundTransferReversalShortfallAmount,
          record.refundTransferReversalShortfallAmount);
      expect(reparsed.refundTransferReversalPartial,
          record.refundTransferReversalPartial);
      expect(reparsed.reconciliationRequired, record.reconciliationRequired);
      expect(reparsed.reconciliationIssues, record.reconciliationIssues);
      expect(reparsed.balancePaidAt, record.balancePaidAt);
      expect(reparsed.balancePaymentState, record.balancePaymentState);
      expect(reparsed.balancePaymentIntentId,
          record.balancePaymentIntentId);
      expect(reparsed.balancePaymentAttempt, record.balancePaymentAttempt);

      // Two parses of the same document remain equal under the generated
      // document equality (the map/list fields are compared deeply).
      final secondParse = OrderRecord.getDocumentFromData(
        orderData,
        _FakeDocumentReference(),
      );
      expect(
        const OrderRecordDocumentEquality().equals(record, secondParse),
        true,
      );

      final item = record.orderItems.single;
      final reparsedItem = OrderItemsStruct.fromMap(item.toMap());
      expect(reparsedItem, item);
    });

    test('missing/null values remain backward compatible', () {
      final record = OrderRecord.getDocumentFromData(
        <String, dynamic>{},
        _FakeDocumentReference(),
      );

      expect(record.hasRefundDueAmount(), false);
      expect(record.refundDueAmount, 0.0);
      expect(record.hasRefundStatus(), false);
      expect(record.refundStatus, '');
      expect(record.hasRefundAmount(), false);
      expect(record.refundAmount, 0.0);
      expect(record.hasRefundId(), false);
      expect(record.refundId, '');
      expect(record.hasRefundAttempt(), false);
      expect(record.refundAttempt, 0);
      expect(record.hasRefundAttempts(), false);
      expect(record.refundAttempts, isEmpty);
      expect(record.hasRefundTransferReversalStatus(), false);
      expect(record.refundTransferReversalStatus, '');
      expect(record.hasRefundTransferReversalReason(), false);
      expect(record.refundTransferReversalReason, '');
      expect(record.hasRefundTransferReversalAmount(), false);
      expect(record.refundTransferReversalAmount, 0.0);
      expect(record.hasRefundTransferReversalShortfallAmount(), false);
      expect(record.refundTransferReversalShortfallAmount, 0.0);
      expect(record.hasRefundTransferReversalPartial(), false);
      expect(record.refundTransferReversalPartial, false);
      expect(record.hasReconciliationRequired(), false);
      expect(record.reconciliationRequired, false);
      expect(record.hasReconciliationIssues(), false);
      expect(record.reconciliationIssues, isEmpty);
      expect(record.hasBalancePaidAt(), false);
      expect(record.balancePaidAt, isNull);
      expect(record.hasBalancePaymentState(), false);
      expect(record.balancePaymentState, '');
      expect(record.hasBalancePaymentIntentId(), false);
      expect(record.balancePaymentIntentId, '');
      expect(record.hasBalancePaymentAttempt(), false);
      expect(record.balancePaymentAttempt, 0);

      final nullRecord = OrderRecord.getDocumentFromData(
        <String, dynamic>{
          'refund_due_amount': null,
          'refund_status': null,
          'refund_attempts': null,
          'reconciliation_issues': null,
          'balance_paid_at': null,
        },
        _FakeDocumentReference(),
      );
      expect(nullRecord.hasRefundDueAmount(), false);
      expect(nullRecord.hasRefundStatus(), false);
      expect(nullRecord.hasRefundAttempts(), false);
      expect(nullRecord.hasReconciliationIssues(), false);
      expect(nullRecord.hasBalancePaidAt(), false);

      final item = OrderItemsStruct.fromMap(<String, dynamic>{});
      expect(item.hasRefundDue(), false);
      expect(item.refundDue, 0.0);
      expect(item.hasWeightBelowMinimum(), false);
      expect(item.weightBelowMinimum, false);
      expect(item.hasWeightAboveMaximum(), false);
      expect(item.weightAboveMaximum, false);
    });
  });
}
