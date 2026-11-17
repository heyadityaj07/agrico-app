import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against re-introducing a client-side rejection implementation.
///
/// The Phase 1 backend owns `order_status = Rejected`, every `rejection_*`
/// field, rejection refund state, inventory restoration evidence and the
/// notification counters. These Firestore fields are protected by rules, so a
/// client write would fail at runtime — but it must not exist in the first
/// place.
void main() {
  test('lib contains no direct client-side rejection/refund writes', () {
    final offenders = <String>[];

    final forbidden = <RegExp>[
      RegExp(r"orderStatus\s*:\s*'Rejected'"),
      RegExp(
        r"'(rejection_state|rejection_previous_status|rejection_requested_at|"
        r"rejection_requested_by|rejection_completed_at|rejection_refund_kind|"
        r"rejection_refund_state|rejection_refund_id|rejection_refund_amount|"
        r"rejection_refund_amount_minor|rejection_refund_currency|"
        r"rejection_payment_state|rejection_payment_confirmed|"
        r"rejection_payment_cancel_attempted|rejection_payment_canceled|"
        r"rejection_delivery_cost_policy|rejection_inventory_state|"
        r"rejection_inventory_completed|rejection_inventory_restoration|"
        r"rejection_inventory_attempts|rejection_notification_counted|"
        r"rejection_customer_notification|inventory_deduction_confirmed|"
        r"inventory_deduction_items|inventory_deduction_source)'\s*:",
      ),
    ];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final source = entity.readAsStringSync();
      if (forbidden.any((pattern) => pattern.hasMatch(source))) {
        offenders.add(entity.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Rejection/refund/inventory evidence must be written by the backend '
          'only. Remove direct writes from: ${offenders.join(', ')}',
    );
  });

  test('the producer rejection action never writes Firestore', () {
    final source = File('lib/custom_code/actions/reject_order.dart')
        .readAsStringSync();

    expect(source.contains('.update('), isFalse);
    expect(source.contains('createOrderRecordData'), isFalse);
    expect(source.contains('FieldValue.increment'), isFalse);
    expect(source.contains('rejectOrder'), isTrue);
  });
}
