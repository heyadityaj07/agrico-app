import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agricou/backend/refunds/customer_refund_status.dart';
import 'package:agricou/backend/schema/order_record.dart';

class _FakeDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

OrderRecord _order({
  double? refundDueAmount,
  String? refundStatus,
  double? refundAmount,
  bool? isSuspend,
}) {
  return OrderRecord.getDocumentFromData(
    <String, dynamic>{
      if (refundDueAmount != null) 'refund_due_amount': refundDueAmount,
      if (refundStatus != null) 'refund_status': refundStatus,
      if (refundAmount != null) 'refund_amount': refundAmount,
      if (isSuspend != null) 'is_suspend': isSuspend,
    },
    _FakeDocumentReference(),
  );
}

void main() {
  group('CustomerRefundInfo', () {
    test('positive refund due with no lifecycle status is not initiated', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(refundDueAmount: 12.5),
      );

      expect(info.state, CustomerRefundState.dueNotInitiated);
      expect(info.hasRefund, isTrue);
      expect(info.hasAmount, isTrue);
      expect(info.amount, 12.5);
      expect(info.rawStatus, isEmpty);
    });

    test('suspended orders with a refund remain visible to the classifier', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(
          refundDueAmount: 12.5,
          refundStatus: 'processing',
          isSuspend: true,
        ),
      );

      expect(info.state, CustomerRefundState.processing);
      expect(info.hasRefund, isTrue);
    });

    test('missing or zero refund due with no status means no refund', () {
      expect(
        CustomerRefundInfo.fromOrder(_order()).state,
        CustomerRefundState.none,
      );
      expect(
        CustomerRefundInfo.fromOrder(_order(refundDueAmount: 0)).state,
        CustomerRefundState.none,
      );
    });

    test('processing status is never treated as success', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(refundDueAmount: 10, refundStatus: 'processing'),
      );

      expect(info.state, CustomerRefundState.processing);
      expect(info.state, isNot(CustomerRefundState.succeeded));
      expect(info.hasRefund, isTrue);
    });

    test('succeeded requires the persisted backend status', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(
          refundDueAmount: 10,
          refundStatus: 'succeeded',
          refundAmount: 10,
        ),
      );

      expect(info.state, CustomerRefundState.succeeded);
      expect(info.amount, 10);
    });

    test('failed status needs attention and is not successful', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(
          refundDueAmount: 10,
          refundStatus: 'failed',
          refundAmount: 10,
        ),
      );

      expect(info.state, CustomerRefundState.failed);
      expect(info.needsAttention, isTrue);
      expect(info.state, isNot(CustomerRefundState.succeeded));
    });

    test('unknown backend status stays unknown and keeps the raw value', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(refundDueAmount: 10, refundStatus: 'manual_review'),
      );

      expect(info.state, CustomerRefundState.unknown);
      expect(info.rawStatus, 'manual_review');
      expect(info.state, isNot(CustomerRefundState.succeeded));
      expect(info.state, isNot(CustomerRefundState.failed));
    });

    test('status matching is trimmed and case-insensitive', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(refundStatus: '  SUCCEEDED  ', refundAmount: 4),
      );

      expect(info.state, CustomerRefundState.succeeded);
      expect(info.rawStatus, 'SUCCEEDED');
    });

    test('recorded refund amount is preferred, otherwise refund due is shown',
        () {
      final recorded = CustomerRefundInfo.fromOrder(
        _order(
          refundDueAmount: 9,
          refundStatus: 'processing',
          refundAmount: 8.75,
        ),
      );
      final dueOnly = CustomerRefundInfo.fromOrder(
        _order(refundDueAmount: 9, refundStatus: 'processing'),
      );

      expect(recorded.amount, 8.75);
      expect(dueOnly.amount, 9);
    });

    test('missing amounts do not create a misleading amount', () {
      final info = CustomerRefundInfo.fromOrder(
        _order(refundStatus: 'processing'),
      );

      expect(info.hasAmount, isFalse);
      expect(info.amount, 0);
    });
  });
}
