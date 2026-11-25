// F1–F6 remediation tests: pure decision logic of the checkout-v1 custom
// action (binding validation, bound-quote recovery classification, checkout
// context matching, delivery-method mapping, response acceptance rules).
//
// Flow-level behaviour (network calls, PaymentSheet, navigation) is covered by
// the manual test matrix in the remediation report.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agricou/custom_code/checkout_v1/checkout_v1_logic.dart';

/// Minimal DocumentReference fake: only `id` participates in the pure logic.
class FakeDocRef implements DocumentReference {
  FakeDocRef(this.id);
  @override
  final String id;
  @override
  String get path => 'order/$id';
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

CartLineSnapshot line(
  String productId, {
  int quantity = 1,
  double? minWeight,
  double? maxWeight,
  bool isVariableWeight = false,
}) =>
    CartLineSnapshot(
      productId: productId,
      farmId: 'farm-1',
      quantity: quantity,
      price: 10,
      minWeight: minWeight,
      maxWeight: maxWeight,
      isVariableWeight: isVariableWeight,
    );

Map<String, dynamic> uberOrder({
  Map<String, dynamic> Function(Map<String, dynamic>)? overrides,
}) {
  final data = <String, dynamic>{
    'checkout_flow_version': 1,
    'is_agrico_deliver': true,
    'is_farm_pickup': false,
    'delievry_method': 'uber',
    'delievry_address': {
      'street_adress': '12 Market Street',
      'city': 'Paris',
      'postal_code': '75001',
    },
    'delievry_time': '2026-11-25 10:00',
    'currency': 'EUR',
    'farm_ref': FakeDocRef('farm-1'),
    'checkout_state': 'awaiting_payment',
    'uber_quote_state': 'pending',
    'order_items': [
      {
        'product_ref': FakeDocRef('product-1'),
        'total_items': 2,
        'is_variable_weight': false,
      },
    ],
  };
  return overrides?.call(data) ?? data;
}

void main() {
  group('F3/F4 — delivery method mapping', () {
    test('producer selection ("delivery") parses to the producer method', () {
      expect(tryParseCheckoutDeliveryMethod('delivery'),
          CheckoutDeliveryMethod.producer);
      expect(tryParseCheckoutDeliveryMethod('Delivery '),
          CheckoutDeliveryMethod.producer);
    });

    test('pickup and uber selections still parse', () {
      expect(tryParseCheckoutDeliveryMethod('farmpickup'),
          CheckoutDeliveryMethod.pickup);
      expect(tryParseCheckoutDeliveryMethod('uber'),
          CheckoutDeliveryMethod.uber);
      expect(tryParseCheckoutDeliveryMethod('uberdirect'),
          CheckoutDeliveryMethod.uber);
    });

    test('unknown and missing selections do not parse', () {
      expect(tryParseCheckoutDeliveryMethod('teleport'), isNull);
      expect(tryParseCheckoutDeliveryMethod(''), isNull);
      expect(tryParseCheckoutDeliveryMethod(null), isNull);
    });

    test('serializer emits only backend-canonical values', () {
      expect(deliveryMethodToString(CheckoutDeliveryMethod.pickup),
          'farmpickup');
      expect(deliveryMethodToString(CheckoutDeliveryMethod.producer),
          'delivery');
      expect(deliveryMethodToString(CheckoutDeliveryMethod.uber), 'uber');
    });
  });

  group('F1 — bind response acceptance', () {
    final validBody = <String, dynamic>{
      'success': true,
      'orderId': 'order-1',
      'quoteId': 'quote-1',
      'quoteState': 'bound',
      'paymentEligible': true,
      'quoteExpired': false,
      'deliveryFee': 5,
    };

    test('accepts the real backend contract (which has no `bound` field)', () {
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200, body: validBody, requestedQuoteId: 'quote-1'),
        isTrue,
      );
    });

    test('rejects non-200, non-map, and failed responses', () {
      expect(
        checkoutBindResponseAccepted(
            statusCode: 409, body: validBody, requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200, body: null, requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'success': false},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
    });

    test('rejects unbound, ineligible, expired and mismatched echoes', () {
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'quoteState': 'pending'},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'paymentEligible': false},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'quoteExpired': true},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'quoteId': 'quote-2'},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
      expect(
        checkoutBindResponseAccepted(
            statusCode: 200,
            body: {...validBody, 'quoteId': '  '},
            requestedQuoteId: 'quote-1'),
        isFalse,
      );
    });
  });

  group('F2 — bound quote recovery classification', () {
    final now = DateTime(2026, 11, 25, 12, 0);

    test('read failures and missing orders are distinguished', () {
      expect(
        classifyCheckoutQuoteRecovery(orderData: null, orderId: 'o', now: now)
            .outcome,
        CheckoutQuoteRecoveryOutcome.readFailed,
      );
      expect(
        classifyCheckoutQuoteRecovery(
                orderData: {}, orderId: 'o', now: now)
            .outcome,
        CheckoutQuoteRecoveryOutcome.orderInvalid,
      );
    });

    test('non-v1 and non-uber orders are never resumed as Uber checkouts', () {
      final legacy = uberOrder();
      legacy['checkout_flow_version'] = null;
      final nonUber = uberOrder();
      nonUber['is_agrico_deliver'] = false;
      nonUber['delievry_method'] = 'delivery';

      expect(
        classifyCheckoutQuoteRecovery(
                orderData: legacy, orderId: 'o', now: now)
            .outcome,
        CheckoutQuoteRecoveryOutcome.orderInvalid,
      );
      expect(
        classifyCheckoutQuoteRecovery(
                orderData: nonUber, orderId: 'o', now: now)
            .outcome,
        CheckoutQuoteRecoveryOutcome.orderInvalid,
      );
    });

    test('payment initiation is recognised with backend semantics', () {
      for (final override in [
        (Map<String, dynamic> m) => m..['payment_intent_creation_pending'] = true,
        (Map<String, dynamic> m) => m..['payment_intent_id'] = 'pi_1',
        (Map<String, dynamic> m) => m..['payment_state'] = 'initiated',
      ]) {
        final data = uberOrder(overrides: override);
        final recovery = classifyCheckoutQuoteRecovery(
            orderData: data, orderId: 'o', now: now);
        expect(recovery.outcome, CheckoutQuoteRecoveryOutcome.paymentInitiated);
      }
    });

    test('confirmed payment reports initiation with the confirmed state', () {
      final data = uberOrder(overrides: (m) {
        m..['payment_state'] = 'initiated';
        m..['checkout_state'] = 'payment_confirmed';
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = 'quote-1';
        m..['uber_quote_order_id'] = 'o';
        m..['uber_quote_expires_at'] =
            Timestamp.fromDate(now.add(const Duration(minutes: 5)));
        return m;
      });
      final recovery = classifyCheckoutQuoteRecovery(
          orderData: data, orderId: 'o', now: now);
      expect(recovery.outcome, CheckoutQuoteRecoveryOutcome.paymentInitiated);
      expect(recovery.checkoutState, 'payment_confirmed');
      expect(recovery.quoteExpired, isFalse);
    });

    test('initiated payment with an unusable bound quote reports it', () {
      // Expired bound quote (e.g. sheet failed, intent still actionable).
      final expiredQuote = uberOrder(overrides: (m) {
        m..['payment_intent_id'] = 'pi_1';
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = 'quote-1';
        m..['uber_quote_order_id'] = 'o';
        m..['uber_quote_expires_at'] =
            Timestamp.fromDate(now.subtract(const Duration(minutes: 1)));
        return m;
      });
      final expired = classifyCheckoutQuoteRecovery(
          orderData: expiredQuote, orderId: 'o', now: now);
      expect(expired.outcome, CheckoutQuoteRecoveryOutcome.paymentInitiated);
      expect(expired.quoteExpired, isTrue);

      // Payment started but no bound quote at all → unusable.
      final noQuote = uberOrder(overrides: (m) {
        m..['payment_state'] = 'initiated';
        return m;
      });
      final unusable = classifyCheckoutQuoteRecovery(
          orderData: noQuote, orderId: 'o', now: now);
      expect(unusable.outcome, CheckoutQuoteRecoveryOutcome.paymentInitiated);
      expect(unusable.quoteExpired, isTrue);
    });

    test('refund/reconciliation lifecycles are not resumable', () {
      for (final state in ['refund_pending', 'refunded', 'reconciliation_required']) {
        final data = uberOrder(overrides: (m) => m..['checkout_state'] = state);
        expect(
          classifyCheckoutQuoteRecovery(
                  orderData: data, orderId: 'o', now: now)
              .outcome,
          CheckoutQuoteRecoveryOutcome.orderInvalid,
        );
      }
    });

    test('a pending (unbound) quote proceeds to fresh quote+binding', () {
      final recovery = classifyCheckoutQuoteRecovery(
          orderData: uberOrder(), orderId: 'o', now: now);
      expect(recovery.outcome, CheckoutQuoteRecoveryOutcome.noBoundQuote);
    });

    test('a bound quote associated with another order is rejected', () {
      final data = uberOrder(overrides: (m) {
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = 'quote-1';
        m..['uber_quote_order_id'] = 'other-order';
        m..['uber_quote_expires_at'] =
            Timestamp.fromDate(now.add(const Duration(minutes: 5)));
        return m;
      });
      expect(
        classifyCheckoutQuoteRecovery(orderData: data, orderId: 'o', now: now)
            .outcome,
        CheckoutQuoteRecoveryOutcome.orderInvalid,
      );
    });

    test('bound-but-expired quotes are reported as expired', () {
      final past = uberOrder(overrides: (m) {
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = 'quote-1';
        m..['uber_quote_order_id'] = 'o';
        m..['uber_quote_expires_at'] =
            Timestamp.fromDate(now.subtract(const Duration(minutes: 1)));
        return m;
      });
      final missingExpiry = uberOrder(overrides: (m) {
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = 'quote-1';
        m..['uber_quote_order_id'] = 'o';
        m..['uber_quote_expires_at'] = null;
        return m;
      });
      for (final data in [past, missingExpiry]) {
        final recovery = classifyCheckoutQuoteRecovery(
            orderData: data, orderId: 'o', now: now);
        expect(recovery.outcome, CheckoutQuoteRecoveryOutcome.expired);
        expect(recovery.quoteExpired, isTrue);
      }
    });

    test('a valid bound quote is recovered with its ID', () {
      final data = uberOrder(overrides: (m) {
        m..['uber_quote_state'] = 'bound';
        m..['uber_quote_id'] = ' quote-1 ';
        m..['uber_quote_order_id'] = 'o';
        m..['uber_quote_expires_at'] = Timestamp.fromDate(
            now.add(const Duration(minutes: 10)));
        return m;
      });
      final recovery = classifyCheckoutQuoteRecovery(
          orderData: data, orderId: 'o', now: now);
      expect(recovery.outcome, CheckoutQuoteRecoveryOutcome.recovered);
      expect(recovery.quoteId, 'quote-1');
      expect(recovery.hasQuoteId, isTrue);
    });
  });

  group('C1 — canonical create-order address payload', () {
    test('contains exactly the backend-supported fields', () {
      final payload = buildCheckoutAddressPayload(
        fullName: 'Vruti',
        streetAddress: 'Bd André Malraux, 78990 Élancourt, France',
        city: 'Élancourt',
        state: 'IDF',
        postalCode: '78990',
        phoneNo: '+919876543210',
      );
      expect(payload, isNotNull);
      expect(payload!.keys.toSet(),
          {'fullName', 'streetAddress', 'city', 'state', 'postalCode', 'phoneNo'});
    });

    test('unsupported alias fields are absent', () {
      final payload = buildCheckoutAddressPayload(
        fullName: 'Ada',
        streetAddress: '12 Market Street',
        city: 'Paris',
        state: 'IDF',
        postalCode: '75001',
        phoneNo: '+33600000000',
        instruction: 'Ring twice',
      );
      for (final alias in ['contact_name', 'address', 'zip_code', 'contact_phone', 'latLng']) {
        expect(payload!.containsKey(alias), isFalse, reason: alias);
      }
    });

    test('instruction is omitted when empty, included when populated', () {
      final without = buildCheckoutAddressPayload(
        fullName: 'Ada',
        streetAddress: '12 Market Street',
        city: 'Paris',
        postalCode: '75001',
        phoneNo: '+33600000000',
        instruction: '   ',
      );
      expect(without!.containsKey('instruction'), isFalse);

      final withInstruction = buildCheckoutAddressPayload(
        fullName: 'Ada',
        streetAddress: '12 Market Street',
        city: 'Paris',
        postalCode: '75001',
        phoneNo: '+33600000000',
        instruction: '  Ring twice  ',
      );
      expect(withInstruction!['instruction'], 'Ring twice');
    });

    test('values are trimmed and empty optional state is omitted', () {
      final payload = buildCheckoutAddressPayload(
        fullName: '  Ada  ',
        streetAddress: ' 12 Market Street ',
        city: ' Paris ',
        state: '   ',
        postalCode: ' 75001 ',
        phoneNo: ' +33600000000 ',
      );
      expect(payload!['fullName'], 'Ada');
      expect(payload['streetAddress'], '12 Market Street');
      expect(payload['city'], 'Paris');
      expect(payload.containsKey('state'), isFalse);
      expect(payload['postalCode'], '75001');
      expect(payload['phoneNo'], '+33600000000');
    });

    test('the known-good Vrutika payload schema is reproduced exactly', () {
      // Known-good contract (audit §C1): this is the exact key set the
      // backend accepts; the builder must generate the equivalent schema.
      final payload = buildCheckoutAddressPayload(
        fullName: 'Vruti',
        streetAddress: 'Bd André Malraux, 78990 Élancourt, France',
        city: 'Élancourt',
        state: 'IDF',
        postalCode: '78990',
        phoneNo: '+919876543210',
      );
      expect(payload, {
        'fullName': 'Vruti',
        'streetAddress': 'Bd André Malraux, 78990 Élancourt, France',
        'city': 'Élancourt',
        'state': 'IDF',
        'postalCode': '78990',
        'phoneNo': '+919876543210',
      });
    });
  });

  group('C2 — address comparison normalization', () {
    test('normalizeAddressPart trims, collapses whitespace, lowercases', () {
      expect(normalizeAddressPart('  12   Market   Street '.replaceAll('\t', '  ')), '12 market street');
      expect(normalizeAddressPart('Bd André\nMalraux'), 'bd andré malraux');
      expect(normalizeAddressPart('PARIS'), 'paris');
      expect(normalizeAddressPart(' paris '), 'paris');
    });

    test('equivalent addresses match despite whitespace and casing', () {
      bool matchWith(String street, String city, String postal) {
        return checkoutAttemptMatchesOrder(
          orderData: uberOrder(overrides: (m) => m
            ..['delievry_address'] = {
              'street_adress': '12 Market Street',
              'city': 'Paris',
              'postal_code': '75001',
            }),
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: [street, city, postal].join('|'),
          deliveryTime: '2026-11-25 10:00',
          cartLines: [line('product-1', quantity: 2)],
        );
      }

      expect(matchWith('12   Market   Street', 'Paris', '75001'), isTrue);
      expect(matchWith('12\tMarket\tStreet', 'Paris', '75001'), isTrue);
      expect(matchWith('  12 Market Street  ', 'Paris', '75001'), isTrue);
      expect(matchWith('12 market street', 'PARIS', '75001'), isTrue);
      expect(matchWith('12 Market Street', 'paris', '75001'), isTrue);
    });

    test('persisted address with irregular whitespace matches the current key',
        () {
      // The backend collapses internal whitespace when persisting; the
      // current selection still carries the raw text — must match (C2).
      expect(
        checkoutAttemptMatchesOrder(
          orderData: uberOrder(overrides: (m) => m
            ..['delievry_address'] = {
              'street_adress': 'Bd André Malraux', // backend-normalized
              'city': 'Élancourt',
              'postal_code': '78990',
            }),
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: 'bd   André    Malraux|ÉLANCOURT|78990', // raw selection
          deliveryTime: '2026-11-25 10:00',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isTrue,
      );
    });

    test('genuinely different addresses still mismatch', () {
      bool matchWith(String addressKey) {
        return checkoutAttemptMatchesOrder(
          orderData: uberOrder(overrides: (m) => m
            ..['delievry_address'] = {
              'street_adress': '12 Market Street',
              'city': 'Paris',
              'postal_code': '75001',
            }),
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: addressKey,
          deliveryTime: '2026-11-25 10:00',
          cartLines: [line('product-1', quantity: 2)],
        );
      }

      expect(matchWith('12 Market Street|Paris|75001|extra'), isFalse);
      expect(matchWith('99 Changed Street|Paris|75001'), isFalse);
      expect(matchWith('12 Market Street|Lyon|75001'), isFalse);
      expect(matchWith('12 Market Street|Paris|69001'), isFalse);
      expect(matchWith('12 Market Street|Paris|'), isFalse);
    });
  });

  group('F5 — checkout context comparison against the server order', () {
    // Same key the action computes via checkoutAddressKey(): street|city|postal.
    const baseAddressKey = '12 Market Street|Paris|75001';

    test('unchanged context matches', () {
      expect(
        checkoutAttemptMatchesOrder(
          orderData: uberOrder(),
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: baseAddressKey,
          deliveryTime: '2026-11-25 10:00',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isTrue,
      );
    });

    test('a delivery-method change never matches', () {
      expect(
        checkoutAttemptMatchesOrder(
          orderData: uberOrder(),
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'farmpickup', // switched away from Uber
          currency: 'EUR',
          addressKey: baseAddressKey,
          deliveryTime: '2026-11-25 10:00',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isFalse,
      );
    });

    test('farm, currency, address, time and cart changes never match', () {
      bool matchWith(Map<String, dynamic> Function(Map<String, dynamic>) o,
          {String? farmId,
          String? method,
          String? currency,
          String? addressKey,
          String? time,
          List<CartLineSnapshot>? lines}) {
        return checkoutAttemptMatchesOrder(
          orderData: uberOrder(overrides: o),
          orderId: 'order-1',
          farmId: farmId ?? 'farm-1',
          deliveryMethod: method ?? 'uber',
          currency: currency ?? 'EUR',
          addressKey: addressKey ?? baseAddressKey,
          deliveryTime: time ?? '2026-11-25 10:00',
          cartLines: lines ?? [line('product-1', quantity: 2)],
        );
      }

      expect(matchWith((m) => m..['farm_ref'] = FakeDocRef('farm-2')),
          isFalse);
      expect(matchWith((m) => m..['currency'] = 'USD'), isFalse);
      expect(
          matchWith((m) => m
            ..['delievry_address'] = {
              'street_adress': '99 Changed Street',
              'city': 'Paris',
              'postal_code': '75001',
            }),
          isFalse);
      expect(matchWith((m) => m..['delievry_time'] = '11:00'), isFalse);
      expect(
          matchWith((m) => m, lines: [line('product-1', quantity: 3)]),
          isFalse);
      expect(
          matchWith((m) => m,
              lines: [line('product-2', quantity: 2)]),
          isFalse);
    });

    test('multiple lines sharing a product ID match one-to-one', () {
      final data = uberOrder(overrides: (m) => m
        ..['order_items'] = [
          {
            'product_ref': FakeDocRef('product-1'),
            'total_items': 1,
            'is_variable_weight': true,
            'min_weight': 2.0,
            'max_weight': 3.0,
          },
          {
            'product_ref': FakeDocRef('product-1'),
            'total_items': 1,
            'is_variable_weight': true,
            'min_weight': 4.0,
            'max_weight': 5.0,
          },
        ]);
      expect(
        checkoutAttemptMatchesOrder(
          orderData: data,
          orderId: 'order-1',
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: baseAddressKey,
          deliveryTime: '2026-11-25 10:00',
          cartLines: [
            line('product-1',
                quantity: 1, minWeight: 2, maxWeight: 3, isVariableWeight: true),
            line('product-1',
                quantity: 1, minWeight: 4, maxWeight: 5, isVariableWeight: true),
          ],
        ),
        isTrue,
      );
    });
  });

  group('F5/F7 — cancellation response acceptance', () {
    test('accepts success, already-cancelled and already-expired', () {
      expect(
        checkoutCancelResponseAccepted(
            statusCode: 200, body: {'success': true}),
        isTrue,
      );
      expect(
        checkoutCancelResponseAccepted(
            statusCode: 200, body: {'alreadyCancelled': true}),
        isTrue,
      );
      expect(
        checkoutCancelResponseAccepted(
            statusCode: 409, body: {'code': 'checkout_expired'}),
        isTrue,
      );
    });

    test('treats ambiguous responses as not confirmed', () {
      expect(
        checkoutCancelResponseAccepted(
            statusCode: 409, body: {'code': 'payment_processing'}),
        isFalse,
      );
      expect(
        checkoutCancelResponseAccepted(statusCode: 500, body: null),
        isFalse,
      );
    });
  });

  group('F5 — request-id reuse before any order exists', () {
    test('legacy attempts without context keep their request ID', () {
      final legacy = CheckoutAttempt(
        checkoutRequestId: 'req-legacy',
        cartLines: [line('product-1', quantity: 2)],
        phase: 'created',
        createdAt: DateTime.utc(2026, 11, 24),
        updatedAt: DateTime.utc(2026, 11, 24),
      );
      expect(
        checkoutAttemptMatchesRequest(
          attempt: legacy,
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: 'a|b|c',
          deliveryTime: '',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isTrue,
      );
      // A changed cart discards the request ID even for legacy attempts
      // (conflict-loop fix).
      expect(
        checkoutAttemptMatchesRequest(
          attempt: legacy,
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: 'a|b|c',
          deliveryTime: '',
          cartLines: [line('product-1', quantity: 3)],
        ),
        isFalse,
      );
    });

    test('matching context keeps the request ID; changes create a new one', () {
      CheckoutAttempt attemptWith(String method) => CheckoutAttempt(
            checkoutRequestId: 'req-1',
            cartLines: [line('product-1', quantity: 2)],
            phase: 'created',
            createdAt: DateTime.utc(2026, 11, 25),
            updatedAt: DateTime.utc(2026, 11, 25),
            farmId: 'farm-1',
            currency: 'EUR',
            deliveryMethod: method,
            addressKey: '12 Market Street|Paris|75001',
            deliveryTime: '',
          );

      expect(
        checkoutAttemptMatchesRequest(
          attempt: attemptWith('uber'),
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: '12 Market Street|Paris|75001',
          deliveryTime: '',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isTrue,
      );
      // Pickup switched to Uber (scenario 10) and Producer switched to Uber
      // (scenario 11): the stored context no longer matches → new attempt.
      expect(
        checkoutAttemptMatchesRequest(
          attempt: attemptWith('farmpickup'),
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: '12 Market Street|Paris|75001',
          deliveryTime: '',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isFalse,
      );
      expect(
        checkoutAttemptMatchesRequest(
          attempt: attemptWith('delivery'),
          farmId: 'farm-1',
          deliveryMethod: 'uber',
          currency: 'EUR',
          addressKey: '12 Market Street|Paris|75001',
          deliveryTime: '',
          cartLines: [line('product-1', quantity: 2)],
        ),
        isFalse,
      );
    });

    test('conflict-loop fix: same cart matches, changed cart does not', () {
      // Regression for the reservation-limit audit finding: the no-order
      // reuse path must compare the cart, otherwise a cart change after a
      // failed create reuses the request ID and loops on
      // `checkout_request_conflict`.
      CartLineSnapshot snapLine(String productId, int quantity,
              {double? min, double? max, bool variable = false}) =>
          CartLineSnapshot(
            productId: productId,
            farmId: 'farm-1',
            quantity: quantity,
            price: 10,
            minWeight: min,
            maxWeight: max,
            isVariableWeight: variable,
          );

      // Identical cart (even reordered — Firestore query order is unstable):
      // the request ID is reused, preserving idempotency.
      expect(
        checkoutCartLinesMatch(
          [snapLine('product-1', 2), snapLine('product-2', 1)],
          [snapLine('product-2', 1), snapLine('product-1', 2)],
        ),
        isTrue,
      );
      expect(
        checkoutCartLinesMatch(
          [snapLine('product-1', 1, min: 2, max: 3, variable: true)],
          [snapLine('product-1', 1, min: 2, max: 3, variable: true)],
        ),
        isTrue,
      );

      // Changed quantity / bracket / product / size: new request ID.
      expect(
        checkoutCartLinesMatch(
            [snapLine('product-1', 2)], [snapLine('product-1', 3)]),
        isFalse,
      );
      expect(
        checkoutCartLinesMatch(
          [snapLine('product-1', 1, min: 2, max: 3, variable: true)],
          [snapLine('product-1', 1, min: 2, max: 4, variable: true)],
        ),
        isFalse,
      );
      expect(
        checkoutCartLinesMatch(
            [snapLine('product-1', 1)], [snapLine('product-9', 1)]),
        isFalse,
      );
      expect(
        checkoutCartLinesMatch([snapLine('product-1', 2)],
            [snapLine('product-1', 1), snapLine('product-2', 1)]),
        isFalse,
      );
    });
  });

  group('F7 — attempt persistence round-trip', () {
    test('context fields and cancelRequested survive toMap/fromMap', () {
      final attempt = CheckoutAttempt(
        checkoutRequestId: 'req-1',
        orderId: 'order-1',
        quoteId: 'quote-1',
        cartLines: [line('product-1', quantity: 2)],
        phase: 'quoteBound',
        createdAt: DateTime.utc(2026, 11, 25, 10),
        updatedAt: DateTime.utc(2026, 11, 25, 10, 5),
        farmId: 'farm-1',
        currency: 'EUR',
        deliveryMethod: 'uber',
        addressKey: '12 Market Street|Paris|75001',
        deliveryTime: '2026-11-25 10:00',
        cancelRequested: true,
      );
      final restored = CheckoutAttempt.fromMap(attempt.toMap());
      expect(restored.checkoutRequestId, 'req-1');
      expect(restored.orderId, 'order-1');
      expect(restored.quoteId, 'quote-1');
      expect(restored.phase, 'quoteBound');
      expect(restored.farmId, 'farm-1');
      expect(restored.currency, 'EUR');
      expect(restored.deliveryMethod, 'uber');
      expect(restored.addressKey, '12 Market Street|Paris|75001');
      expect(restored.deliveryTime, '2026-11-25 10:00');
      expect(restored.cancelRequested, isTrue);
    });

    test('legacy maps without context fields load safely as unknown', () {
      final restored = CheckoutAttempt.fromMap({
        'checkoutRequestId': 'req-legacy',
        'orderId': 'order-legacy',
        'cartLines': [
          {
            'productId': 'product-1',
            'farmId': 'farm-1',
            'quantity': 2,
            'price': 10.0,
            'isVariableWeight': false,
          }
        ],
        'phase': 'awaitingPayment',
        'createdAt': DateTime.utc(2026, 11, 24).toIso8601String(),
        'updatedAt': DateTime.utc(2026, 11, 24).toIso8601String(),
      });
      expect(restored.farmId, isNull);
      expect(restored.deliveryMethod, isNull);
      expect(restored.cancelRequested, isFalse);
      expect(restored.cartLines.single.productId, 'product-1');
    });
  });
}
