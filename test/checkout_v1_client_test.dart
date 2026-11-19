import 'package:agricou/backend/checkout/checkout_v1_client.dart';
import 'package:agricou/backend/schema/cart_record.dart';
import 'package:agricou/backend/schema/structs/delivery_adress_struct.dart';
import 'package:agricou/backend/schema/users_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

// Mirrors the lightweight DocumentReference fixture used by the existing
// model tests. Only `id`/`path` are read by the pure helpers.
// ignore: subtype_of_sealed_class
class _FakeDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  _FakeDocumentReference(this.id, [String? path]) : path = path ?? 'test/$id';

  @override
  final String id;

  @override
  final String path;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

DeliveryAdressStruct _address(String label) {
  return DeliveryAdressStruct(
    label: label,
    fullName: 'Customer $label',
    streetAdress: '$label Main Street',
    city: 'City',
    state: 'State',
    phoneNo: '555-0100',
    postalCode: '10000',
  );
}

Map<String, dynamic> _addressMap(String label) => _address(label).toMap();

UsersRecord _user({List<Map<String, dynamic>>? addresses, int? defaultIndex}) {
  return UsersRecord.getDocumentFromData(<String, dynamic>{
    if (addresses != null) 'delivery_Addresses': addresses,
    if (defaultIndex != null) 'default_adress': defaultIndex,
  }, _FakeDocumentReference('user-1'));
}

CartRecord _cartLine({
  required String documentId,
  required String productId,
  required String farmId,
  required int quantity,
  bool variable = false,
  double minWeight = 1,
  double maxWeight = 2,
}) {
  return CartRecord.getDocumentFromData(<String, dynamic>{
    'productRef': _FakeDocumentReference(productId),
    'quantity': quantity,
    'farm_ref': _FakeDocumentReference(farmId),
    'is_variable_weight': variable,
    if (variable) 'min_weight': minWeight,
    if (variable) 'max_weight': maxWeight,
  }, _FakeDocumentReference(documentId));
}

CheckoutAddress _checkoutAddress({
  String fullName = 'Alice',
  String street = '1 Main Street',
  String city = 'Paris',
  String postal = '75001',
  String phone = '555-0100',
}) {
  return CheckoutAddress(
    fullName: fullName,
    streetAddress: street,
    city: city,
    state: 'IDF',
    postalCode: postal,
    phoneNo: phone,
  );
}

CheckoutPayload _payload({
  String farmId = 'farm-1',
  String currency = 'EUR',
  CheckoutDeliveryMethod method = CheckoutDeliveryMethod.producer,
  String? deliveryTime = 'Tomorrow',
  String? note = 'Leave at door',
  String? voucherCode,
  double? tip = 0,
  CheckoutAddress? address,
  List<CheckoutItem>? items,
}) {
  return CheckoutPayload(
    farmId: farmId,
    currency: currency,
    deliveryMethod: method,
    deliveryTime: deliveryTime,
    note: note,
    voucherCode: voucherCode,
    tip: tip,
    address: address ?? _checkoutAddress(),
    items:
        items ??
        <CheckoutItem>[CheckoutItem(productId: 'product-1', quantity: 2)],
  );
}

List<CapturedCartLine> _capturedLines() {
  return <CapturedCartLine>[
    CapturedCartLine(
      cartDocumentId: 'cart-1',
      productId: 'product-1',
      quantity: 2,
      farmId: 'farm-1',
    ),
  ];
}

void main() {
  group('checkout payload fingerprint', () {
    test('identical normalized payloads produce the same fingerprint', () {
      final first = _payload(
        currency: 'eur',
        voucherCode: 'save10',
        note: '  leave   at door ',
        address: _checkoutAddress(fullName: ' Alice ', street: '1 main street'),
      );
      final second = _payload(
        currency: ' EUR ',
        voucherCode: ' SAVE10 ',
        note: 'leave at door',
        address: _checkoutAddress(fullName: 'alice', street: '1 Main Street'),
      );

      expect(first.fingerprint, second.fingerprint);
    });

    test(
      'item order and duplicate aggregation do not change the fingerprint',
      () {
        final first = _payload(
          items: <CheckoutItem>[
            CheckoutItem(productId: 'product-b', quantity: 1),
            CheckoutItem(productId: 'product-a', quantity: 1),
            CheckoutItem(productId: 'product-a', quantity: 2),
          ],
        );
        final second = _payload(
          items: <CheckoutItem>[
            CheckoutItem(productId: 'product-a', quantity: 3),
            CheckoutItem(productId: 'product-b', quantity: 1),
          ],
        );

        expect(first.fingerprint, second.fingerprint);
      },
    );

    test('meaningful changes produce different fingerprints', () {
      final base = _payload();

      expect(base.fingerprint, isNot(_payload(tip: 2.5).fingerprint));
      expect(
        base.fingerprint,
        isNot(_payload(note: 'Leave at door NOW').fingerprint),
      );
      expect(
        base.fingerprint,
        isNot(_payload(deliveryTime: 'Today').fingerprint),
      );
      expect(base.fingerprint, isNot(_payload(currency: 'USD').fingerprint));
      expect(base.fingerprint, isNot(_payload(farmId: 'farm-2').fingerprint));
      expect(
        base.fingerprint,
        isNot(
          _payload(
            items: <CheckoutItem>[
              CheckoutItem(productId: 'product-1', quantity: 3),
            ],
          ).fingerprint,
        ),
      );
      expect(
        base.fingerprint,
        isNot(_payload(method: CheckoutDeliveryMethod.uber).fingerprint),
      );
      expect(
        base.fingerprint,
        isNot(_payload(address: _checkoutAddress(city: 'Lyon')).fingerprint),
      );
      expect(
        base.fingerprint,
        isNot(
          _payload(
            items: <CheckoutItem>[
              CheckoutItem(
                productId: 'product-1',
                quantity: 2,
                weightBracket: CheckoutWeightBracket(
                  minWeight: 1,
                  maxWeight: 2,
                ),
              ),
            ],
          ).fingerprint,
        ),
      );
    });

    test('delivery-method aliases canonicalize consistently', () {
      expect(
        tryParseCheckoutDeliveryMethod('farmpickup'),
        CheckoutDeliveryMethod.pickup,
      );
      expect(
        tryParseCheckoutDeliveryMethod('producer_delivery'),
        CheckoutDeliveryMethod.producer,
      );
      expect(
        tryParseCheckoutDeliveryMethod('uber_direct'),
        CheckoutDeliveryMethod.uber,
      );
      expect(tryParseCheckoutDeliveryMethod('unknown'), isNull);
    });
  });

  group('checkout attempt reuse', () {
    test(
      'retry with the same payload and cart lines reuses the request ID',
      () {
        final payload = _payload();
        final lines = _capturedLines();
        final existing = resolveCheckoutAttempt(
          existing: null,
          payload: payload,
          cartLines: lines,
          createdAt: DateTime.utc(2026, 1, 1),
          requestIdFactory: () => 'request-old',
        );

        expect(existing.reused, isFalse);
        expect(existing.attempt.checkoutRequestId, 'request-old');

        final retry = resolveCheckoutAttempt(
          existing: existing.attempt,
          payload: payload,
          cartLines: lines,
          requestIdFactory: () => 'request-new',
        );

        expect(retry.reused, isTrue);
        expect(retry.attempt.checkoutRequestId, 'request-old');
      },
    );

    test('changed payload gets a new attempt and request ID', () {
      final lines = _capturedLines();
      final existing = resolveCheckoutAttempt(
        existing: null,
        payload: _payload(),
        cartLines: lines,
        requestIdFactory: () => 'request-old',
      );

      final changed = resolveCheckoutAttempt(
        existing: existing.attempt,
        payload: _payload(tip: 3),
        cartLines: lines,
        requestIdFactory: () => 'request-new',
      );

      expect(changed.reused, isFalse);
      expect(changed.attempt.checkoutRequestId, 'request-new');
      expect(changed.attempt.fingerprint, isNot(existing.attempt.fingerprint));
    });

    test('a closed attempt starts a new attempt with a new request ID', () {
      final payload = _payload();
      final lines = _capturedLines();
      final existing = resolveCheckoutAttempt(
        existing: null,
        payload: payload,
        cartLines: lines,
        requestIdFactory: () => 'request-old',
      ).attempt.copyWith(phase: CheckoutAttemptPhase.confirmed);

      final next = resolveCheckoutAttempt(
        existing: existing,
        payload: payload,
        cartLines: lines,
        requestIdFactory: () => 'request-new',
      );

      expect(next.reused, isFalse);
      expect(next.attempt.checkoutRequestId, 'request-new');
    });

    test('changed cart lines cannot silently reuse the old attempt', () {
      final payload = _payload();
      final existing = resolveCheckoutAttempt(
        existing: null,
        payload: payload,
        cartLines: _capturedLines(),
        requestIdFactory: () => 'request-old',
      );

      final changed = resolveCheckoutAttempt(
        existing: existing.attempt,
        payload: payload,
        cartLines: <CapturedCartLine>[
          CapturedCartLine(
            cartDocumentId: 'cart-1',
            productId: 'product-1',
            quantity: 3,
            farmId: 'farm-1',
          ),
        ],
        requestIdFactory: () => 'request-new',
      );

      expect(changed.reused, isFalse);
      expect(changed.attempt.checkoutRequestId, 'request-new');
    });
  });

  group('delivery address resolution', () {
    test('missing user returns null', () {
      expect(resolveSelectedDeliveryAddress(null), isNull);
    });

    test('empty address list returns null', () {
      expect(
        resolveSelectedDeliveryAddress(
          _user(addresses: const <Map<String, dynamic>>[]),
        ),
        isNull,
      );
    });

    test('missing default index selects the first address', () {
      final user = _user(
        addresses: <Map<String, dynamic>>[_addressMap('A'), _addressMap('B')],
      );

      expect(resolveSelectedDeliveryAddress(user)?.label, 'A');
    });

    test('negative index selects the first address', () {
      final user = _user(
        addresses: <Map<String, dynamic>>[_addressMap('A'), _addressMap('B')],
        defaultIndex: -2,
      );

      expect(resolveSelectedDeliveryAddress(user)?.label, 'A');
    });

    test('out-of-range index selects the first address', () {
      final user = _user(
        addresses: <Map<String, dynamic>>[_addressMap('A'), _addressMap('B')],
        defaultIndex: 9,
      );

      expect(resolveSelectedDeliveryAddress(user)?.label, 'A');
    });

    test('valid index selects the expected address', () {
      final user = _user(
        addresses: <Map<String, dynamic>>[_addressMap('A'), _addressMap('B')],
        defaultIndex: 1,
      );

      expect(resolveSelectedDeliveryAddress(user)?.label, 'B');
    });
  });

  group('delivery address index updates', () {
    test('delete before default decrements the default', () {
      final update = removeDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 0,
        defaultIndex: 2,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['B', 'C']);
      expect(update.defaultIndex, 1);
    });

    test('delete the default selects a valid remaining index', () {
      final update = removeDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 1,
        defaultIndex: 1,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A', 'C']);
      expect(update.defaultIndex, 1);
      expect(update.defaultIndex, lessThan(update.addresses.length));
    });

    test('delete after default keeps the default', () {
      final update = removeDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 2,
        defaultIndex: 0,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A', 'B']);
      expect(update.defaultIndex, 0);
    });

    test('delete the final address clamps the default', () {
      final update = removeDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[_address('A'), _address('B')],
        index: 1,
        defaultIndex: 1,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A']);
      expect(update.defaultIndex, 0);
    });

    test('delete the only address resets the default to zero', () {
      final update = removeDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[_address('A')],
        index: 0,
        defaultIndex: 0,
      );

      expect(update, isNotNull);
      expect(update!.addresses, isEmpty);
      expect(update.defaultIndex, 0);
    });

    test('edit before default preserves order and default', () {
      final update = replaceDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 0,
        replacement: _address('A2'),
        defaultIndex: 2,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A2', 'B', 'C']);
      expect(update.defaultIndex, 2);
    });

    test('edit the default preserves order and default', () {
      final update = replaceDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 1,
        replacement: _address('B2'),
        defaultIndex: 1,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A', 'B2', 'C']);
      expect(update.defaultIndex, 1);
    });

    test('edit after default preserves order and default', () {
      final update = replaceDeliveryAddressAt(
        addresses: <DeliveryAdressStruct>[
          _address('A'),
          _address('B'),
          _address('C'),
        ],
        index: 2,
        replacement: _address('C2'),
        defaultIndex: 0,
      );

      expect(update, isNotNull);
      expect(update!.addresses.map((e) => e.label), <String>['A', 'B', 'C2']);
      expect(update.defaultIndex, 0);
    });
  });

  group('stale address selection guards', () {
    final a = _address('A');
    final b = _address('B');
    final c = _address('C');

    test('delete does not apply when the selected address moved', () {
      final latest = <DeliveryAdressStruct>[b, a, c];
      final result = removeDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        defaultIndex: 0,
      );

      expect(result, isNull);
      expect(latest, <DeliveryAdressStruct>[b, a, c]);
      expect(identical(latest.first, b), isTrue);
    });

    test('delete does not apply when the selected address was removed', () {
      final latest = <DeliveryAdressStruct>[a, c];
      final result = removeDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        defaultIndex: 0,
      );

      expect(result, isNull);
      expect(latest, <DeliveryAdressStruct>[a, c]);
      expect(latest.contains(b), isFalse);
    });

    test('edit does not apply when the selected address moved', () {
      final latest = <DeliveryAdressStruct>[b, a, c];
      final result = replaceDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        replacement: _address('B2'),
        defaultIndex: 0,
      );

      expect(result, isNull);
      expect(latest, <DeliveryAdressStruct>[b, a, c]);
      expect(identical(latest.first, b), isTrue);
      expect(identical(latest[1], a), isTrue);
    });

    test('edit does not apply when the selected address was removed', () {
      final latest = <DeliveryAdressStruct>[a, c];
      final result = replaceDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        replacement: _address('B2'),
        defaultIndex: 0,
      );

      expect(result, isNull);
      expect(latest, <DeliveryAdressStruct>[a, c]);
      expect(identical(latest[1], c), isTrue);
    });

    test('valid delete still applies when the selected address matches', () {
      final latest = <DeliveryAdressStruct>[a, b, c];
      final result = removeDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        defaultIndex: 2,
      );

      expect(result, isNotNull);
      expect(result!.addresses.map((e) => e.label), <String>['A', 'C']);
      expect(result.defaultIndex, 1);
    });

    test('valid edit still applies when the selected address matches', () {
      final latest = <DeliveryAdressStruct>[a, b, c];
      final replacement = _address('B2');
      final result = replaceDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        replacement: replacement,
        defaultIndex: 2,
      );

      expect(result, isNotNull);
      expect(result!.addresses.map((e) => e.label), <String>['A', 'B2', 'C']);
      expect(identical(result.addresses[1], replacement), isTrue);
      expect(result.defaultIndex, 2);
    });

    test('edit reports a repaired invalid default index', () {
      final latest = <DeliveryAdressStruct>[a, b, c];
      final result = replaceDeliveryAddressAtIfMatches(
        addresses: latest,
        index: 1,
        expected: b,
        replacement: _address('B2'),
        defaultIndex: 9,
      );

      expect(result, isNotNull);
      expect(result!.defaultIndex, 0);
    });
  });

  group('transactional address mutations', () {
    final a = _address('A');
    final b = _address('B');
    final c = _address('C');

    UsersRecord userWith(
      List<DeliveryAdressStruct> addresses, {
      int? defaultIndex,
    }) {
      return _user(
        addresses: addresses.map((address) => address.toMap()).toList(),
        defaultIndex: defaultIndex,
      );
    }

    test('valid delete stages one complete write', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyDeleteDeliveryAddress(
        user: userWith(<DeliveryAdressStruct>[a, b, c], defaultIndex: 2),
        index: 1,
        expected: b,
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.updated);
      expect(writes, hasLength(1));
      expect(writes.single['delivery_Addresses'], hasLength(2));
      expect(writes.single['default_adress'], 1);
    });

    test('stale delete stages no write', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyDeleteDeliveryAddress(
        user: userWith(<DeliveryAdressStruct>[b, a, c]),
        index: 1,
        expected: b,
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.stale);
      expect(writes, isEmpty);
    });

    test('valid edit stages one write and preserves a valid default', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyEditDeliveryAddress(
        user: userWith(<DeliveryAdressStruct>[a, b, c], defaultIndex: 2),
        index: 1,
        expected: b,
        replacement: _address('B2'),
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.updated);
      expect(writes, hasLength(1));
      expect(writes.single['delivery_Addresses'], hasLength(3));
      expect(writes.single.containsKey('default_adress'), isFalse);
    });

    test('valid edit repairs an invalid default in the same write', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyEditDeliveryAddress(
        user: userWith(<DeliveryAdressStruct>[a, b, c], defaultIndex: 9),
        index: 1,
        expected: b,
        replacement: _address('B2'),
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.updated);
      expect(writes.single['default_adress'], 0);
    });

    test('stale edit stages no write', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyEditDeliveryAddress(
        user: userWith(<DeliveryAdressStruct>[b, a, c]),
        index: 1,
        expected: b,
        replacement: _address('B2'),
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.stale);
      expect(writes, isEmpty);
    });

    test('missing user stages no write', () {
      final writes = <Map<String, dynamic>>[];
      final result = applyDeleteDeliveryAddress(
        user: null,
        index: 0,
        expected: a,
        write: writes.add,
      );

      expect(result, DeliveryAddressMutationResult.userMissing);
      expect(writes, isEmpty);
    });

    test('retry after concurrent modification discards the stale attempt', () {
      final initial = userWith(<DeliveryAdressStruct>[a, b, c]);
      final changed = userWith(<DeliveryAdressStruct>[b, a, c]);

      // First callback attempt sees the old list and stages a write, but the
      // transaction loses the race. Firestore discards that attempt and reruns
      // the callback. The second attempt must reject the now-stale index.
      final firstAttemptWrites = <Map<String, dynamic>>[];
      final firstResult = applyDeleteDeliveryAddress(
        user: initial,
        index: 1,
        expected: b,
        write: firstAttemptWrites.add,
      );
      expect(firstResult, DeliveryAddressMutationResult.updated);
      expect(firstAttemptWrites, hasLength(1));

      final retryWrites = <Map<String, dynamic>>[];
      final retryResult = applyDeleteDeliveryAddress(
        user: changed,
        index: 1,
        expected: b,
        write: retryWrites.add,
      );
      expect(retryResult, DeliveryAddressMutationResult.stale);
      expect(retryWrites, isEmpty);
    });
  });

  group('cart-line snapshots', () {
    test('only selected-farm lines are captured', () {
      final lines = captureCartLines(<CartRecord>[
        _cartLine(
          documentId: 'cart-1',
          productId: 'product-1',
          farmId: 'farm-1',
          quantity: 2,
        ),
        _cartLine(
          documentId: 'cart-2',
          productId: 'product-2',
          farmId: 'farm-2',
          quantity: 1,
        ),
      ], farmId: 'farm-1');

      expect(lines, hasLength(1));
      expect(lines.single.cartDocumentId, 'cart-1');
      expect(lines.single.farmId, 'farm-1');
    });

    test('fixed-weight line captures identity and quantity', () {
      final line = captureCartLine(
        _cartLine(
          documentId: 'cart-1',
          productId: 'product-1',
          farmId: 'farm-1',
          quantity: 3,
        ),
        farmId: 'farm-1',
      );

      expect(line, isNotNull);
      expect(line!.cartDocumentId, 'cart-1');
      expect(line.productId, 'product-1');
      expect(line.quantity, 3);
      expect(line.weightBracket, isNull);
    });

    test('variable-weight line captures the bracket', () {
      final line = captureCartLine(
        _cartLine(
          documentId: 'cart-1',
          productId: 'product-1',
          farmId: 'farm-1',
          quantity: 1,
          variable: true,
          minWeight: 1.5,
          maxWeight: 2.5,
        ),
        farmId: 'farm-1',
      );

      expect(line, isNotNull);
      expect(line!.weightBracket, isNotNull);
      expect(line.weightBracket!.minWeight, 1.5);
      expect(line.weightBracket!.maxWeight, 2.5);
    });
  });

  group('cart-clearing plan', () {
    CapturedCartLine purchased({bool variable = false}) {
      return CapturedCartLine(
        cartDocumentId: 'cart-1',
        productId: 'product-1',
        quantity: 2,
        farmId: 'farm-1',
        weightBracket: variable
            ? CheckoutWeightBracket(minWeight: 1, maxWeight: 2)
            : null,
      );
    }

    CartLineCurrentState current({
      String farmId = 'farm-1',
      String productId = 'product-1',
      int quantity = 2,
      CheckoutWeightBracket? weightBracket,
    }) {
      return CartLineCurrentState(
        cartDocumentId: 'cart-1',
        productId: productId,
        farmId: farmId,
        quantity: quantity,
        weightBracket: weightBracket,
      );
    }

    test('missing document is skipped', () {
      final decision = planCartLineClear(purchased: purchased(), current: null);

      expect(decision.action, CartClearAction.skip);
    });

    test('different product is skipped', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(productId: 'product-2'),
      );

      expect(decision.action, CartClearAction.skip);
    });

    test('different farm is skipped', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(farmId: 'farm-2'),
      );

      expect(decision.action, CartClearAction.skip);
    });

    test('missing farm reference is skipped', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(farmId: ''),
      );

      expect(decision.action, CartClearAction.skip);
    });

    test('different variable bracket is skipped', () {
      final decision = planCartLineClear(
        purchased: purchased(variable: true),
        current: current(
          weightBracket: CheckoutWeightBracket(minWeight: 2, maxWeight: 3),
        ),
      );

      expect(decision.action, CartClearAction.skip);
    });

    test('equal quantity deletes the line', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(),
      );

      expect(decision.action, CartClearAction.delete);
      expect(decision.decrementBy, isNull);
    });

    test('greater quantity decrements by the purchased quantity', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(quantity: 5),
      );

      expect(decision.action, CartClearAction.decrement);
      expect(decision.decrementBy, 2);
    });

    test('lower quantity is skipped and produces no document write', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(quantity: 1),
      );

      expect(decision.action, CartClearAction.skip);
      expect(decision.decrementBy, isNull);

      final writes = buildCartClearWrites(
        decisions: <CartClearDecision>[decision],
        currentByDocumentId: <String, CartLineCurrentState?>{
          'cart-1': current(quantity: 1),
        },
      );

      expect(writes.single.action, CartClearWriteAction.skip);
      expect(writes.single.quantity, isNull);
      expect(
        writes.where((write) => write.action != CartClearWriteAction.skip),
        isEmpty,
      );
    });

    test('greater quantity writes only the remaining quantity', () {
      final decision = planCartLineClear(
        purchased: purchased(),
        current: current(quantity: 5),
      );

      final writes = buildCartClearWrites(
        decisions: <CartClearDecision>[decision],
        currentByDocumentId: <String, CartLineCurrentState?>{
          'cart-1': current(quantity: 5),
        },
      );

      expect(writes.single.action, CartClearWriteAction.setQuantity);
      expect(writes.single.quantity, 3);
    });
  });

  group('finalization classifier', () {
    test('maps all known backend checkout states', () {
      final cases = <String, CheckoutFinalizationState>{
        'awaiting_payment': CheckoutFinalizationState.awaitingPayment,
        'payment_pending': CheckoutFinalizationState.paymentPending,
        'payment_confirmed': CheckoutFinalizationState.paymentConfirmed,
        'cancelled': CheckoutFinalizationState.cancelled,
        'expired': CheckoutFinalizationState.expired,
        'refund_pending': CheckoutFinalizationState.refundPending,
        'refunded': CheckoutFinalizationState.refunded,
        'reconciliation_required':
            CheckoutFinalizationState.reconciliationRequired,
      };

      for (final entry in cases.entries) {
        expect(
          classifyCheckoutFinalization(<String, dynamic>{
            'checkout_state': entry.key,
          }),
          entry.value,
          reason: entry.key,
        );
      }
    });

    test('reconciliation flag overrides non-final states', () {
      expect(
        classifyCheckoutFinalization(<String, dynamic>{
          'checkout_state': 'awaiting_payment',
          'checkout_reconciliation_required': true,
        }),
        CheckoutFinalizationState.reconciliationRequired,
      );
    });

    test('missing or unknown state is unknown', () {
      expect(
        classifyCheckoutFinalization(null),
        CheckoutFinalizationState.unknown,
      );
      expect(
        classifyCheckoutFinalization(<String, dynamic>{}),
        CheckoutFinalizationState.unknown,
      );
      expect(
        classifyCheckoutFinalization(<String, dynamic>{
          'checkout_state': 'not_a_state',
        }),
        CheckoutFinalizationState.unknown,
      );
    });
  });

  group('error and payment outcome classifier', () {
    test('known safe outcomes map explicitly', () {
      expect(
        classifyCheckoutErrorCode('payment_processing'),
        CheckoutPaymentOutcome.retryable,
      );
      expect(
        classifyCheckoutErrorCode('payment_intent_unresolved'),
        CheckoutPaymentOutcome.retryable,
      );
      expect(
        classifyCheckoutErrorCode('quote_expired'),
        CheckoutPaymentOutcome.retryable,
      );
      expect(
        classifyCheckoutErrorCode('order_not_payable'),
        CheckoutPaymentOutcome.terminal,
      );
      expect(
        classifyCheckoutErrorCode('delivery_address_unavailable'),
        CheckoutPaymentOutcome.terminal,
      );
      expect(
        classifyCheckoutErrorCode('payment_already_succeeded'),
        CheckoutPaymentOutcome.alreadyConfirmed,
      );
      expect(
        classifyCheckoutErrorCode('payment_transfer_already_completed'),
        CheckoutPaymentOutcome.needsSupport,
      );
      expect(
        classifyCheckoutErrorCode('payment_cancellation_failed'),
        CheckoutPaymentOutcome.needsSupport,
      );
    });

    test('unknown or missing error code is never a definitive failure', () {
      expect(classifyCheckoutErrorCode(null), CheckoutPaymentOutcome.retryable);
      expect(classifyCheckoutErrorCode(''), CheckoutPaymentOutcome.retryable);
      expect(
        classifyCheckoutErrorCode('a_brand_new_backend_code'),
        CheckoutPaymentOutcome.retryable,
      );
    });

    test('payment sheet result strings map safely', () {
      expect(
        classifyCheckoutPaymentResult('success'),
        CheckoutPaymentOutcome.paymentSheetCompleted,
      );
      expect(
        classifyCheckoutPaymentResult('alreadyConfirmed'),
        CheckoutPaymentOutcome.alreadyConfirmed,
      );
      expect(
        classifyCheckoutPaymentResult('cancelled'),
        CheckoutPaymentOutcome.cancelled,
      );
      expect(
        classifyCheckoutPaymentResult('failed'),
        CheckoutPaymentOutcome.terminal,
      );
      expect(
        classifyCheckoutPaymentResult('ambiguous'),
        CheckoutPaymentOutcome.retryable,
      );
      expect(
        classifyCheckoutPaymentResult('something_new'),
        CheckoutPaymentOutcome.retryable,
      );
    });
  });

  group('strict checkout cart validation', () {
    test('empty cart is rejected', () {
      final result = validateCheckoutCart(
        selectedCart: const <CartRecord>[],
        currentCart: const <CartRecord>[],
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'cart_empty');
    });

    test('malformed line is rejected instead of skipped', () {
      final malformed = CartRecord.getDocumentFromData(<String, dynamic>{
        'quantity': 1,
        'farm_ref': _FakeDocumentReference('farm-1'),
      }, _FakeDocumentReference('cart-bad'));

      final result = validateCheckoutCart(
        selectedCart: <CartRecord>[malformed],
        currentCart: <CartRecord>[malformed],
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'cart_line_invalid');
      expect(result.problemCartDocumentId, 'cart-bad');
    });

    test('multi-farm cart is rejected', () {
      final selected = <CartRecord>[
        _cartLine(
          documentId: 'cart-1',
          productId: 'product-1',
          farmId: 'farm-1',
          quantity: 1,
        ),
        _cartLine(
          documentId: 'cart-2',
          productId: 'product-2',
          farmId: 'farm-2',
          quantity: 1,
        ),
      ];

      final result = validateCheckoutCart(
        selectedCart: selected,
        currentCart: selected,
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'multi_farm_cart');
    });

    test('valid variable-weight cart keeps the bracket selection', () {
      final line = _cartLine(
        documentId: 'cart-1',
        productId: 'beef',
        farmId: 'farm-1',
        quantity: 2,
        variable: true,
        minWeight: 2,
        maxWeight: 3,
      );

      final result = validateCheckoutCart(
        selectedCart: <CartRecord>[line],
        currentCart: <CartRecord>[line],
        farmId: 'farm-1',
      );

      expect(result.isValid, isTrue);
      expect(result.lines.single.quantity, 2);
      expect(result.lines.single.weightBracket?.minWeight, 2);
      expect(result.lines.single.weightBracket?.maxWeight, 3);
    });

    test('a selected line missing from the live cart fails checkout', () {
      final line = _cartLine(
        documentId: 'cart-1',
        productId: 'product-1',
        farmId: 'farm-1',
        quantity: 1,
      );

      final result = validateCheckoutCart(
        selectedCart: <CartRecord>[line],
        currentCart: const <CartRecord>[],
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'checkout_cart_changed');
    });

    test('a quantity change fails instead of silently repricing', () {
      final selected = _cartLine(
        documentId: 'cart-1',
        productId: 'product-1',
        farmId: 'farm-1',
        quantity: 1,
      );
      final current = _cartLine(
        documentId: 'cart-1',
        productId: 'product-1',
        farmId: 'farm-1',
        quantity: 2,
      );

      final result = validateCheckoutCart(
        selectedCart: <CartRecord>[selected],
        currentCart: <CartRecord>[current],
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'checkout_cart_changed');
    });

    test('a same-farm line added after review fails checkout', () {
      final selected = _cartLine(
        documentId: 'cart-1',
        productId: 'product-1',
        farmId: 'farm-1',
        quantity: 1,
      );
      final added = _cartLine(
        documentId: 'cart-2',
        productId: 'product-2',
        farmId: 'farm-1',
        quantity: 1,
      );

      final result = validateCheckoutCart(
        selectedCart: <CartRecord>[selected],
        currentCart: <CartRecord>[selected, added],
        farmId: 'farm-1',
      );

      expect(result.isValid, isFalse);
      expect(result.errorCode, 'checkout_cart_changed');
    });
  });

  group('checkout order request mapping', () {
    test('sends only identifiers, quantities, delivery and notes', () {
      final payload = _payload(
        voucherCode: 'save10',
        items: <CheckoutItem>[
          CheckoutItem(productId: 'product-1', quantity: 2),
          CheckoutItem(
            productId: 'beef',
            quantity: 1,
            weightBracket: CheckoutWeightBracket(minWeight: 2, maxWeight: 3),
          ),
        ],
      );

      final request = buildCheckoutOrderRequest(
        checkoutRequestId: 'request-1',
        payload: payload,
      );

      expect(request['checkoutRequestId'], 'request-1');
      expect(request['farmId'], 'farm-1');
      expect(request['currency'], 'EUR');
      expect(request['voucherCode'], 'SAVE10');
      expect(request['items'], <dynamic>[
        <String, dynamic>{
          'productId': 'beef',
          'quantity': 1,
          'weightBracket': <String, dynamic>{
            'minWeight': 2.0,
            'maxWeight': 3.0,
          },
        },
        <String, dynamic>{'productId': 'product-1', 'quantity': 2},
      ]);
      expect(request.containsKey('amount'), isFalse);
      expect(request.containsKey('subTotal'), isFalse);
      expect(request.containsKey('vendors'), isFalse);
      expect(request.containsKey('producerId'), isFalse);
      expect(
        (request['delivery'] as Map<String, dynamic>)['address'],
        isA<Map<String, dynamic>>(),
      );
    });

    test('pickup omits the delivery address', () {
      final payload = _payload(method: CheckoutDeliveryMethod.pickup);

      final request = buildCheckoutOrderRequest(
        checkoutRequestId: 'request-1',
        payload: payload,
      );

      final delivery = request['delivery'] as Map<String, dynamic>;
      expect(delivery['method'], 'pickup');
      expect(delivery.containsKey('address'), isFalse);
    });

    test('PaymentIntent request never carries client financial fields', () {
      final request = buildCheckoutV1PaymentIntentRequest(
        orderId: 'order-1',
        currency: 'eur',
        locale: 'fr',
        quoteId: ' quote-1 ',
      );

      expect(request, <String, dynamic>{
        'orderId': 'order-1',
        'currency': 'EUR',
        'locale': 'fr',
        'useOrderTotals': true,
        'quoteId': 'quote-1',
      });
      expect(request.containsKey('amount'), isFalse);
      expect(request.containsKey('vendors'), isFalse);
      expect(request.containsKey('producerId'), isFalse);
      expect(request.containsKey('deliveryFee'), isFalse);
    });

    test('PaymentIntent request omits a quote for non-Uber delivery', () {
      final request = buildCheckoutV1PaymentIntentRequest(
        orderId: 'order-1',
        currency: 'USD',
      );

      expect(request.containsKey('quoteId'), isFalse);
      expect(request['useOrderTotals'], isTrue);
    });

    test('incomplete delivery address is rejected before submit', () {
      final address = CheckoutAddress(
        fullName: 'Alice',
        streetAddress: '',
        city: 'Paris',
        state: 'IDF',
        postalCode: '75001',
        phoneNo: '555-0100',
      );

      expect(validateCheckoutAddress(address), 'delivery_address_invalid');
      expect(validateCheckoutAddress(null), 'delivery_address_required');
    });
  });

  group('checkout attempt persistence fields', () {
    test('round-trips order, quote and phase data', () {
      final attempt = CheckoutAttempt(
        checkoutRequestId: 'request-1',
        fingerprint: 'v1:abc',
        farmId: 'farm-1',
        currency: 'EUR',
        deliveryMethod: CheckoutDeliveryMethod.uber,
        cartLines: _capturedLines(),
        createdAt: DateTime.utc(2026, 1, 1),
        phase: CheckoutAttemptPhase.quoteBound,
        orderId: 'order-1',
        quoteId: 'quote-1',
        cancelRequested: true,
      );

      final restored = CheckoutAttempt.maybeFromJson(attempt.toJson());

      expect(restored, isNotNull);
      expect(restored!.checkoutRequestId, 'request-1');
      expect(restored.orderId, 'order-1');
      expect(restored.quoteId, 'quote-1');
      expect(restored.phase, CheckoutAttemptPhase.quoteBound);
      expect(restored.cancelRequested, isTrue);
      expect(restored.cartLines.single.cartDocumentId, 'cart-1');
      expect(restored.isOpen, isTrue);
    });

    test('closed phases are not reused', () {
      final attempt = CheckoutAttempt(
        checkoutRequestId: 'request-1',
        fingerprint: 'v1:abc',
        farmId: 'farm-1',
        currency: 'EUR',
        deliveryMethod: CheckoutDeliveryMethod.producer,
        cartLines: _capturedLines(),
        createdAt: DateTime.utc(2026, 1, 1),
        phase: CheckoutAttemptPhase.confirmed,
      );

      expect(attempt.isOpen, isFalse);
    });

    test('malformed persisted data is ignored', () {
      expect(CheckoutAttempt.maybeFromJson(null), isNull);
      expect(CheckoutAttempt.maybeFromJson(<String, dynamic>{}), isNull);
      expect(
        CheckoutAttempt.maybeFromJson(<String, dynamic>{
          'checkoutRequestId': 'request-1',
          'fingerprint': 'v1:abc',
          'farmId': 'farm-1',
          'currency': 'EUR',
          'deliveryMethod': 'not-a-method',
          'cartLines': <dynamic>[],
          'createdAt': '2026-01-01T00:00:00.000Z',
        }),
        isNull,
      );
    });
  });

  group('backend finalization is authoritative', () {
    test('only payment_confirmed is a success', () {
      expect(
        checkoutFinalizationIsConfirmed(
          classifyCheckoutFinalization(<String, dynamic>{
            'checkout_state': 'payment_confirmed',
            'payment_state': 'paid',
            'inventory_deduction_confirmed': true,
          }),
        ),
        isTrue,
      );
      expect(
        checkoutFinalizationIsConfirmed(
          classifyCheckoutFinalization(<String, dynamic>{
            'checkout_state': 'awaiting_payment',
          }),
        ),
        isFalse,
      );
      expect(
        checkoutFinalizationIsConfirmed(
          classifyCheckoutFinalization(<String, dynamic>{
            'checkout_state': 'payment_pending',
          }),
        ),
        isFalse,
      );
    });

    test('cancelled, expired and refunded attempts are closed', () {
      for (final state in <String>['cancelled', 'expired', 'refunded']) {
        expect(
          checkoutFinalizationIsClosed(
            classifyCheckoutFinalization(<String, dynamic>{
              'checkout_state': state,
            }),
          ),
          isTrue,
          reason: state,
        );
      }
    });

    test('refund and reconciliation require support', () {
      for (final state in <String>[
        'refund_pending',
        'reconciliation_required',
      ]) {
        expect(
          checkoutFinalizationNeedsSupport(
            classifyCheckoutFinalization(<String, dynamic>{
              'checkout_state': state,
            }),
          ),
          isTrue,
          reason: state,
        );
      }
    });
  });
}
