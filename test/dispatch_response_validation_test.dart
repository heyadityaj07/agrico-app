import 'package:agricou/custom_code/actions/dispatch_response_validation.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> validResponse({
  String orderId = 'order-1',
  String orderStatus = 'Picked Up',
  bool changed = true,
}) {
  return {
    'success': true,
    'orderId': orderId,
    'orderStatus': orderStatus,
    'previousOrderStatus': 'Preparing',
    'alreadyAtStatus': !changed,
    'changed': changed,
    'reason': changed ? 'fixed_weight' : 'already_dispatched',
  };
}

void main() {
  group('classifyDispatchSuccessResponse', () {
    test('accepts the changed success shape', () {
      expect(
        classifyDispatchSuccessResponse(
          validResponse(),
          orderId: 'order-1',
          expectedStatus: 'Picked Up',
        ),
        dispatchOutcomeChanged,
      );
    });

    test('accepts the idempotent alreadyAtStatus shape', () {
      expect(
        classifyDispatchSuccessResponse(
          validResponse(changed: false),
          orderId: 'order-1',
          expectedStatus: 'Picked Up',
        ),
        dispatchOutcomeAlreadyAtStatus,
      );
    });

    test('rejects empty, malformed and non-map bodies', () {
      const inputs = <dynamic>[null, '', '{}', [], 200];
      for (final input in inputs) {
        expect(
          classifyDispatchSuccessResponse(
            input,
            orderId: 'order-1',
            expectedStatus: 'Picked Up',
          ),
          isNull,
        );
      }
    });

    test('rejects a missing or non-true success indicator', () {
      final missing = validResponse()..remove('success');
      final falseSuccess = validResponse()..['success'] = false;
      final stringSuccess = validResponse()..['success'] = 'true';

      for (final body in [missing, falseSuccess, stringSuccess]) {
        expect(
          classifyDispatchSuccessResponse(
            body,
            orderId: 'order-1',
            expectedStatus: 'Picked Up',
          ),
          isNull,
        );
      }
    });

    test('rejects a mismatched order or target status', () {
      expect(
        classifyDispatchSuccessResponse(
          validResponse(orderId: 'order-2'),
          orderId: 'order-1',
          expectedStatus: 'Picked Up',
        ),
        isNull,
      );
      expect(
        classifyDispatchSuccessResponse(
          validResponse(orderStatus: 'In Transit'),
          orderId: 'order-1',
          expectedStatus: 'Picked Up',
        ),
        isNull,
      );
    });

    test('rejects contradictory or missing outcome fields', () {
      final contradictoryChanged = validResponse()
        ..['alreadyAtStatus'] = true;
      final contradictoryAlready = validResponse(changed: false)
        ..['changed'] = true;
      final missingChanged = validResponse()..remove('changed');
      final missingAlready = validResponse()..remove('alreadyAtStatus');
      final nonBoolChanged = validResponse()..['changed'] = 1;

      for (final body in [
        contradictoryChanged,
        contradictoryAlready,
        missingChanged,
        missingAlready,
        nonBoolChanged,
      ]) {
        expect(
          classifyDispatchSuccessResponse(
            body,
            orderId: 'order-1',
            expectedStatus: 'Picked Up',
          ),
          isNull,
        );
      }
    });
  });

  group('P4-04 quote response validation', () {
    test('accepts a non-empty quote id only', () {
      expect(
        classifyUberQuoteResponse({
          'success': true,
          'quote': {'id': 'quote-1', 'fee': 500},
        }),
        'quote-1',
      );
      expect(
        classifyUberQuoteResponse({
          'success': true,
          'quote': {'id': '   '},
        }),
        isNull,
      );
      expect(
        classifyUberQuoteResponse({
          'success': false,
          'quote': {'id': 'quote-1'},
        }),
        isNull,
      );
      expect(classifyUberQuoteResponse({'success': true}), isNull);
      expect(classifyUberQuoteResponse(null), isNull);
    });
  });

  group('P4-04 create response validation', () {
    Map<String, dynamic> createResponse({
      String orderId = 'order-1',
      String? deliveryId = 'delivery-1',
      bool alreadyCreated = false,
    }) {
      return {
        'success': true,
        'orderId': orderId,
        if (alreadyCreated) 'alreadyCreated': true,
        'delivery': {if (deliveryId != null) 'id': deliveryId},
      };
    }

    test('accepts a new delivery with a non-empty id', () {
      final result = classifyUberDeliveryCreateResponse(
        createResponse(),
        orderId: 'order-1',
      );
      expect(result.succeeded, isTrue);
      expect(result.outcome, UberDeliveryCreateOutcome.created);
      expect(result.deliveryId, 'delivery-1');
    });

    test('accepts an idempotent alreadyCreated response with the same id', () {
      final result = classifyUberDeliveryCreateResponse(
        createResponse(alreadyCreated: true),
        orderId: 'order-1',
      );
      expect(result.succeeded, isTrue);
      expect(result.outcome, UberDeliveryCreateOutcome.alreadyCreated);
    });

    test('treats empty, malformed or contradictory bodies as ambiguous', () {
      final inputs = <dynamic>[
        null,
        '',
        '{}',
        [],
        {'success': false, 'orderId': 'order-1', 'delivery': {'id': 'x'}},
        {'success': true, 'orderId': 'order-2', 'delivery': {'id': 'x'}},
        {'success': true, 'orderId': 'order-1', 'delivery': <String, dynamic>{}},
        {'success': true, 'orderId': 'order-1', 'delivery': {'id': '  '}},
      ];
      for (final body in inputs) {
        final result = classifyUberDeliveryCreateResponse(
          body,
          orderId: 'order-1',
        );
        expect(result.succeeded, isFalse);
        expect(result.outcome, UberDeliveryCreateOutcome.ambiguous);
      }
    });
  });
}
