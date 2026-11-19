import 'package:agricou/backend/checkout/checkout_v1_api.dart';
import 'package:agricou/backend/checkout/checkout_v1_attempt_store.dart';
import 'package:agricou/backend/checkout/checkout_v1_client.dart';
import 'package:agricou/backend/checkout/checkout_v1_flow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeApi implements CheckoutV1ApiAdapter {
  _FakeApi({
    required this.createResult,
    this.quoteResult,
    this.bindResult,
    this.cancelResult,
  });

  CheckoutV1ApiResult createResult;
  CheckoutV1ApiResult? quoteResult;
  CheckoutV1ApiResult? bindResult;
  CheckoutV1ApiResult? cancelResult;

  final List<String> calls = <String>[];
  final List<Map<String, dynamic>> createRequests = <Map<String, dynamic>>[];
  final List<String> quoteOrderIds = <String>[];
  final List<String> bindOrderIds = <String>[];
  final List<String> bindQuoteIds = <String>[];

  @override
  Future<CheckoutV1ApiResult> createOrder(Map<String, dynamic> request) async {
    calls.add('create');
    createRequests.add(request);
    return createResult;
  }

  @override
  Future<CheckoutV1ApiResult> getUberQuote(String orderId) async {
    calls.add('quote');
    quoteOrderIds.add(orderId);
    return quoteResult ??
        const CheckoutV1ApiResult(
          statusCode: 500,
          data: <String, dynamic>{'success': false, 'code': 'unexpected'},
        );
  }

  @override
  Future<CheckoutV1ApiResult> bindUberQuote({
    required String orderId,
    required String quoteId,
  }) async {
    calls.add('bind');
    bindOrderIds.add(orderId);
    bindQuoteIds.add(quoteId);
    return bindResult ??
        const CheckoutV1ApiResult(
          statusCode: 500,
          data: <String, dynamic>{'success': false, 'code': 'unexpected'},
        );
  }

  @override
  Future<CheckoutV1ApiResult> cancelOrder(String orderId) async {
    calls.add('cancel');
    return cancelResult ??
        CheckoutV1ApiResult(
          statusCode: 200,
          data: <String, dynamic>{'success': true, 'orderId': orderId},
        );
  }
}

CheckoutV1ApiResult _success(Map<String, dynamic> data) {
  return CheckoutV1ApiResult(statusCode: 200, data: data);
}

CheckoutV1ApiResult _error(String code, {int status = 409}) {
  return CheckoutV1ApiResult(
    statusCode: status,
    data: <String, dynamic>{'success': false, 'code': code, 'error': code},
  );
}

CheckoutAttempt _attempt({
  CheckoutDeliveryMethod method = CheckoutDeliveryMethod.producer,
  String? orderId,
  String? quoteId,
  CheckoutAttemptPhase phase = CheckoutAttemptPhase.preparing,
}) {
  return CheckoutAttempt(
    checkoutRequestId: 'request-1',
    fingerprint: 'v1:abc',
    farmId: 'farm-1',
    currency: 'EUR',
    deliveryMethod: method,
    cartLines: <CapturedCartLine>[
      CapturedCartLine(
        cartDocumentId: 'cart-1',
        productId: 'product-1',
        quantity: 2,
        farmId: 'farm-1',
      ),
    ],
    createdAt: DateTime.utc(2026, 1, 1),
    phase: phase,
    orderId: orderId,
    quoteId: quoteId,
  );
}

Map<String, dynamic> _request() {
  return <String, dynamic>{
    'checkoutRequestId': 'request-1',
    'farmId': 'farm-1',
    'currency': 'EUR',
    'items': <dynamic>[
      <String, dynamic>{'productId': 'product-1', 'quantity': 2},
    ],
    'delivery': <String, dynamic>{
      'method': 'producer',
      'tip': 0,
      'address': <String, dynamic>{
        'fullName': 'Alice',
        'streetAddress': '1 Main Street',
        'city': 'Paris',
        'state': 'IDF',
        'postalCode': '75001',
        'phoneNo': '555-0100',
      },
    },
  };
}

void main() {
  group('checkout-v1 sequence', () {
    test('pickup creates an order and skips Uber quote calls', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'created': true,
          'orderId': 'order-1',
        }),
      );
      final saved = <CheckoutAttempt>[];
      final presented = <String?>[];

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(method: CheckoutDeliveryMethod.pickup),
        request: _request(),
        saveAttempt: (attempt) async => saved.add(attempt),
        presentPayment: (orderId, quoteId, currency) async {
          presented.add(quoteId);
          return 'sheetCompleted';
        },
      );

      expect(api.calls, <String>['create']);
      expect(result.outcome, CheckoutV1FlowOutcome.awaitingFinalization);
      expect(result.orderId, 'order-1');
      expect(result.quoteId, isNull);
      expect(presented.single, isNull);
      expect(saved.last.phase, CheckoutAttemptPhase.awaitingFinalization);
      expect(saved.last.orderId, 'order-1');
    });

    test('uber creates, quotes, binds, then presents the sheet', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'created': true,
          'orderId': 'order-1',
        }),
        quoteResult: _success(<String, dynamic>{
          'success': true,
          'quote': <String, dynamic>{
            'id': 'quote-1',
            'fee': 500,
            'currency': 'EUR',
          },
        }),
        bindResult: _success(<String, dynamic>{
          'success': true,
          'orderId': 'order-1',
          'quoteId': 'quote-1',
          'deliveryFee': 5.0,
          'paymentEligible': true,
        }),
      );
      final saved = <CheckoutAttempt>[];
      final presentedQuotes = <String?>[];

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(method: CheckoutDeliveryMethod.uber),
        request: _request(),
        saveAttempt: (attempt) async => saved.add(attempt),
        presentPayment: (orderId, quoteId, currency) async {
          presentedQuotes.add(quoteId);
          return 'sheetCompleted';
        },
      );

      expect(api.calls, <String>['create', 'quote', 'bind']);
      expect(api.quoteOrderIds.single, 'order-1');
      expect(api.bindOrderIds.single, 'order-1');
      expect(api.bindQuoteIds.single, 'quote-1');
      expect(presentedQuotes.single, 'quote-1');
      expect(result.outcome, CheckoutV1FlowOutcome.awaitingFinalization);
      expect(result.quoteId, 'quote-1');
      expect(result.deliveryFee, 5.0);
      expect(saved.last.phase, CheckoutAttemptPhase.awaitingFinalization);
    });

    test('producer delivery never calls the Uber quote endpoints', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'created': true,
          'orderId': 'order-1',
        }),
      );

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(method: CheckoutDeliveryMethod.producer),
        request: _request(),
        saveAttempt: (_) async {},
        presentPayment: (_, __, ___) async => 'sheetCompleted',
      );

      expect(api.calls, <String>['create']);
      expect(result.outcome, CheckoutV1FlowOutcome.awaitingFinalization);
    });

    test('an ambiguous create keeps the same request ID for retry', () async {
      final api = _FakeApi(
        createResult: const CheckoutV1ApiResult(
          statusCode: 503,
          data: <String, dynamic>{
            'success': false,
            'code': 'checkout_unavailable',
          },
        ),
      );
      final attempt = _attempt();
      final saved = <CheckoutAttempt>[];

      final first = await createCheckoutV1Intent(
        api: api,
        attempt: attempt,
        request: _request(),
        saveAttempt: (value) async => saved.add(value),
        presentPayment: (_, __, ___) async => 'sheetCompleted',
      );

      expect(first.outcome, CheckoutV1FlowOutcome.retryable);
      expect(first.attempt.checkoutRequestId, 'request-1');
      expect(api.calls, <String>['create']);
      expect(saved, isEmpty);

      api.createResult = _success(<String, dynamic>{
        'success': true,
        'created': true,
        'orderId': 'order-1',
      });
      final second = await createCheckoutV1Intent(
        api: api,
        attempt: first.attempt,
        request: _request(),
        saveAttempt: (value) async => saved.add(value),
        presentPayment: (_, __, ___) async => 'sheetCompleted',
      );

      expect(api.createRequests, hasLength(2));
      expect(
        api.createRequests.first['checkoutRequestId'],
        api.createRequests.last['checkoutRequestId'],
      );
      expect(second.orderId, 'order-1');
    });

    test('a quote network failure keeps the order and does not pay', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'created': true,
          'orderId': 'order-1',
        }),
        quoteResult: _error('quote_unavailable', status: 503),
      );

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(method: CheckoutDeliveryMethod.uber),
        request: _request(),
        saveAttempt: (_) async {},
        presentPayment: (_, __, ___) async => 'sheetCompleted',
      );

      expect(api.calls, <String>['create', 'quote']);
      expect(result.outcome, CheckoutV1FlowOutcome.retryable);
      expect(result.orderId, 'order-1');
    });

    test('a terminal quote failure cancels the reservation', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'created': true,
          'orderId': 'order-1',
        }),
        quoteResult: _error('delivery_address_unavailable'),
      );

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(method: CheckoutDeliveryMethod.uber),
        request: _request(),
        saveAttempt: (_) async {},
        presentPayment: (_, __, ___) async => 'sheetCompleted',
      );

      expect(api.calls, <String>['create', 'quote', 'cancel']);
      expect(result.outcome, CheckoutV1FlowOutcome.cancelled);
      expect(result.attempt.phase, CheckoutAttemptPhase.cancelled);
    });

    test(
      'sheet cancellation keeps the attempt when cancellation is ambiguous',
      () async {
        final api = _FakeApi(
          createResult: _success(<String, dynamic>{
            'success': true,
            'created': true,
            'orderId': 'order-1',
          }),
          cancelResult: _error('payment_processing', status: 503),
        );
        final saved = <CheckoutAttempt>[];

        final result = await createCheckoutV1Intent(
          api: api,
          attempt: _attempt(),
          request: _request(),
          saveAttempt: (attempt) async => saved.add(attempt),
          presentPayment: (_, __, ___) async => 'cancelled',
        );

        expect(api.calls, <String>['create', 'cancel']);
        expect(result.outcome, CheckoutV1FlowOutcome.retryable);
        expect(result.orderId, 'order-1');
        expect(result.attempt.orderId, 'order-1');
        expect(result.attempt.cancelRequested, isTrue);
        expect(saved.last.cancelRequested, isTrue);
      },
    );

    test('reopening a bound attempt does not create another order', () async {
      final api = _FakeApi(
        createResult: _success(<String, dynamic>{
          'success': true,
          'orderId': 'unused',
        }),
      );

      final result = await createCheckoutV1Intent(
        api: api,
        attempt: _attempt(
          method: CheckoutDeliveryMethod.uber,
          orderId: 'order-1',
          quoteId: 'quote-1',
          phase: CheckoutAttemptPhase.awaitingFinalization,
        ),
        request: _request(),
        saveAttempt: (_) async {},
        presentPayment: (orderId, quoteId, currency) async {
          expect(orderId, 'order-1');
          expect(quoteId, 'quote-1');
          return 'sheetCompleted';
        },
      );

      expect(api.calls, isEmpty);
      expect(result.orderId, 'order-1');
    });

    test(
      'an already-confirmed backend result still waits for the webhook',
      () async {
        final api = _FakeApi(
          createResult: _success(<String, dynamic>{
            'success': true,
            'created': true,
            'orderId': 'order-1',
          }),
        );

        final result = await createCheckoutV1Intent(
          api: api,
          attempt: _attempt(),
          request: _request(),
          saveAttempt: (_) async {},
          presentPayment: (_, __, ___) async => 'alreadyConfirmed',
        );

        expect(result.outcome, CheckoutV1FlowOutcome.awaitingFinalization);
      },
    );
  });

  group('finalization decisions', () {
    test('awaiting payment is pending, never success', () {
      expect(
        decideCheckoutFinalization(CheckoutFinalizationState.awaitingPayment),
        CheckoutFinalizationDecision.pending,
      );
      expect(
        decideCheckoutFinalization(CheckoutFinalizationState.paymentPending),
        CheckoutFinalizationDecision.pending,
      );
      expect(
        decideCheckoutFinalization(CheckoutFinalizationState.unknown),
        CheckoutFinalizationDecision.pending,
      );
    });

    test('only webhook-confirmed state allows success navigation', () {
      expect(
        decideCheckoutFinalization(CheckoutFinalizationState.paymentConfirmed),
        CheckoutFinalizationDecision.confirmed,
      );
    });

    test('closed and support states are not success', () {
      for (final state in <CheckoutFinalizationState>[
        CheckoutFinalizationState.cancelled,
        CheckoutFinalizationState.expired,
        CheckoutFinalizationState.refunded,
      ]) {
        expect(
          decideCheckoutFinalization(state),
          CheckoutFinalizationDecision.closed,
          reason: state.name,
        );
      }
      for (final state in <CheckoutFinalizationState>[
        CheckoutFinalizationState.refundPending,
        CheckoutFinalizationState.reconciliationRequired,
      ]) {
        expect(
          decideCheckoutFinalization(state),
          CheckoutFinalizationDecision.needsSupport,
          reason: state.name,
        );
      }
    });
  });

  group('cancellation classification', () {
    test('maps known backend cancellation outcomes', () {
      expect(
        classifyCheckoutCancellation(
          _success(<String, dynamic>{'success': true}),
        ),
        CheckoutCancellationOutcome.cancelled,
      );
      expect(
        classifyCheckoutCancellation(_error('payment_already_succeeded')),
        CheckoutCancellationOutcome.orderFinalized,
      );
      expect(
        classifyCheckoutCancellation(_error('order_finalized')),
        CheckoutCancellationOutcome.orderFinalized,
      );
      expect(
        classifyCheckoutCancellation(_error('checkout_expired')),
        CheckoutCancellationOutcome.expired,
      );
      expect(
        classifyCheckoutCancellation(_error('payment_cancellation_failed')),
        CheckoutCancellationOutcome.needsSupport,
      );
      expect(
        classifyCheckoutCancellation(
          _error('payment_transfer_already_completed'),
        ),
        CheckoutCancellationOutcome.needsSupport,
      );
      expect(
        classifyCheckoutCancellation(_error('payment_processing', status: 503)),
        CheckoutCancellationOutcome.retryable,
      );
      expect(
        classifyCheckoutCancellation(_error('something_new')),
        CheckoutCancellationOutcome.retryable,
      );
    });
  });

  group('attempt persistence', () {
    const key = 'checkout_v1_attempt_user-1';

    test('absent entry loads as absent, not invalid', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final store = SharedPreferencesCheckoutAttemptStore(ownerUid: 'user-1');

      final loaded = await store.load();

      expect(loaded.isAbsent, isTrue);
      expect(loaded.isInvalid, isFalse);
      expect(loaded.attempt, isNull);
      expect(loaded.rawValue, isNull);

      final otherUser = SharedPreferencesCheckoutAttemptStore(
        ownerUid: 'user-2',
      );
      expect((await otherUser.load()).isAbsent, isTrue);
    });

    test('persists an attempt per authenticated user', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final store = SharedPreferencesCheckoutAttemptStore(ownerUid: 'user-1');
      final attempt = _attempt(
        method: CheckoutDeliveryMethod.uber,
        orderId: 'order-1',
        quoteId: 'quote-1',
        phase: CheckoutAttemptPhase.quoteBound,
      );

      await store.save(attempt);
      final loaded = await store.load();

      expect(loaded.isFound, isTrue);
      expect(loaded.attempt, isNotNull);
      expect(loaded.attempt!.orderId, 'order-1');
      expect(loaded.attempt!.quoteId, 'quote-1');
      expect(loaded.attempt!.phase, CheckoutAttemptPhase.quoteBound);

      await store.clear();
      expect((await store.load()).isAbsent, isTrue);
    });

    test('malformed JSON is invalid and preserved for diagnosis', () async {
      const malformed = '{"checkoutRequestId": ';
      SharedPreferences.setMockInitialValues(<String, Object>{key: malformed});
      final store = SharedPreferencesCheckoutAttemptStore(ownerUid: 'user-1');

      final loaded = await store.load();

      expect(loaded.isInvalid, isTrue);
      expect(loaded.attempt, isNull);
      expect(loaded.rawValue, malformed);
      expect(loaded.invalidReason, 'stored_attempt_malformed_json');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(key), malformed);
      final reloaded = await store.load();
      expect(reloaded.isInvalid, isTrue);
      expect(prefs.getString(key), malformed);
    });

    test('invalid attempt fields are invalid and preserved', () async {
      const invalid = '{"checkoutRequestId":"request-1"}';
      SharedPreferences.setMockInitialValues(<String, Object>{key: invalid});
      final store = SharedPreferencesCheckoutAttemptStore(ownerUid: 'user-1');

      final loaded = await store.load();

      expect(loaded.isInvalid, isTrue);
      expect(loaded.attempt, isNull);
      expect(loaded.rawValue, invalid);
      expect(loaded.invalidReason, 'stored_attempt_invalid_fields');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(key), invalid);
    });

    test('empty stored value is invalid, not absent', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{key: ''});
      final store = SharedPreferencesCheckoutAttemptStore(ownerUid: 'user-1');

      final loaded = await store.load();

      expect(loaded.isInvalid, isTrue);
      expect(loaded.invalidReason, 'stored_attempt_empty');
      expect(loaded.rawValue, '');
    });
  });
}
