import 'package:agricou/flutter_flow/custom_functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('platformFeeAmount', () {
    test('zero product value produces zero fee', () {
      expect(platformFeeAmount(0, 0.0099, 3), 0);
    });

    test('normal product value uses the configured rate', () {
      expect(platformFeeAmount(100, 0.0099, 3), 0.99);
    });

    test('fee is capped at the configured maximum', () {
      expect(platformFeeAmount(1000, 0.0099, 3), 3);
    });

    test('fee at the cap boundary equals the cap', () {
      expect(platformFeeAmount(3 / 0.0099, 0.0099, 3), 3);
    });

    test('different configured rates are honoured', () {
      expect(platformFeeAmount(100, 0.02, 10), 2);
    });

    test('different configured caps are honoured', () {
      expect(platformFeeAmount(1000, 0.0099, 1), 1);
    });

    test('missing configuration falls back to 0.0099 and 3.00', () {
      expect(platformFeeAmount(1000, null, null), 3);
      expect(platformFeeAmount(100, null, null), 0.99);
    });

    test('invalid configuration falls back to the agreed defaults', () {
      expect(platformFeeAmount(100, -1, -1), 0.99);
      expect(platformFeeAmount(1000, 2, 3), 3);
    });

    test('two-decimal currency rounding (EUR/USD) uses minor units', () {
      expect(platformFeeAmount(10.1, 0.0099, 3), 0.1);
      expect(platformFeeAmount(50.5, 0.0099, 3), 0.5);
      expect(platformFeeAmount(0.01, 0.0099, 3), 0);
    });

    test('delivery is not part of the platform-fee contract', () {
      expect(platformFeeAmount(100, 0.0099, 3), 0.99);
      expect(platformFeeAmount(100 + 5, 0.0099, 3), 1.04);
    });
  });

  group('platformfees', () {
    test('formats the authoritative fee to two decimals', () {
      expect(platformfees(100, 0.0099, 3), '0.99');
      expect(platformfees(1000, 0.0099, 3), '3.00');
    });

    test('returns null when the product value is missing', () {
      expect(platformfees(null, 0.0099, 3), isNull);
    });
  });
}
