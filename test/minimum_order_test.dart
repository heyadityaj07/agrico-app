import 'package:agricou/flutter_flow/custom_functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('meetsFarmMinimumOrder', () {
    test('is false below the configured minimum', () {
      expect(meetsFarmMinimumOrder(24.99, 25), isFalse);
    });

    test('is true at the configured minimum', () {
      expect(meetsFarmMinimumOrder(25, 25), isTrue);
    });

    test('is true above the configured minimum', () {
      expect(meetsFarmMinimumOrder(25.01, 25), isTrue);
    });

    test('compares at currency minor-unit precision', () {
      expect(meetsFarmMinimumOrder(24.995, 25), isTrue);
      expect(meetsFarmMinimumOrder(24.994, 25), isFalse);
    });

    test('treats a missing minimum as no configured requirement', () {
      expect(meetsFarmMinimumOrder(1, null), isTrue);
    });

    test('treats zero as a valid no-minimum configuration', () {
      expect(meetsFarmMinimumOrder(1, 0), isTrue);
    });

    test('invalid minimum configuration fails closed instead of no minimum', () {
      expect(meetsFarmMinimumOrder(1, double.nan), isFalse);
      expect(meetsFarmMinimumOrder(1, -5), isFalse);
      expect(meetsFarmMinimumOrder(1, double.infinity), isFalse);
      expect(meetsFarmMinimumOrder(1, double.negativeInfinity), isFalse);
    });

    test('rejects an invalid product subtotal', () {
      expect(meetsFarmMinimumOrder(-1, 25), isFalse);
      expect(meetsFarmMinimumOrder(double.nan, 25), isFalse);
    });
  });

  group('selfManagedDeliveryFee', () {
    test('charges the flat fee below the free-delivery threshold', () {
      expect(selfManagedDeliveryFee(49.99, 50, 5), 5);
    });

    test('waives the fee at the free-delivery threshold', () {
      expect(selfManagedDeliveryFee(50, 50, 5), 0);
    });

    test('waives the fee above the free-delivery threshold', () {
      expect(selfManagedDeliveryFee(50.01, 50, 5), 0);
    });
  });

  group('isWithinDeliveryRadius', () {
    test('accepts a distance inside the radius', () {
      expect(isWithinDeliveryRadius(9999, 10), isTrue);
    });

    test('accepts a distance exactly on the radius boundary', () {
      expect(isWithinDeliveryRadius(10000, 10), isTrue);
    });

    test('rejects a distance outside the radius', () {
      expect(isWithinDeliveryRadius(10001, 10), isFalse);
    });

    test('rejects a missing or invalid radius', () {
      expect(isWithinDeliveryRadius(100, null), isFalse);
      expect(isWithinDeliveryRadius(100, 0), isFalse);
      expect(isWithinDeliveryRadius(100, -1), isFalse);
    });
  });
}
