/// Authenticated HTTP client for the backend-owned checkout-v1 endpoints.
///
/// This deliberately reuses the same Firebase project base URL and bearer-token
/// pattern as the existing `flutterStripeDirect` custom action. It never creates
/// or mutates orders through Firestore and never sends prices, fees, totals,
/// vendor splits or producer identity.
library;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const String _kCheckoutFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kCreateCheckoutOrderPath = 'createCheckoutOrder';
const String _kGetUberDeliveryQuotePath = 'getUberDeliveryQuote';
const String _kBindCheckoutUberQuotePath = 'bindCheckoutUberQuote';
const String _kCancelCheckoutOrderPath = 'cancelCheckoutOrder';
const Duration _kRequestTimeout = Duration(seconds: 30);

class CheckoutV1ApiResult {
  const CheckoutV1ApiResult({
    required this.statusCode,
    this.data,
    this.transportError,
  });

  final int? statusCode;
  final Map<String, dynamic>? data;
  final String? transportError;

  bool get isSuccess {
    final status = statusCode;
    if (status == null || status < 200 || status >= 300) return false;
    final body = data;
    if (body == null) return false;
    return body['success'] != false;
  }

  /// A network timeout/loss or 5xx response cannot prove the backend did not
  /// perform the operation, so callers must keep the same attempt.
  bool get isAmbiguous {
    final status = statusCode;
    return status == null || status >= 500;
  }

  String? get code => _readString(data?['code']);

  String? get message {
    final value = data?['error'] ?? transportError;
    return _readString(value);
  }

  String? get orderId => _readString(data?['orderId']);

  bool get created => data?['created'] == true;

  String? get quoteId {
    final quote = data?['quote'];
    if (quote is Map) return _readString(quote['id']);
    return _readString(data?['quoteId']);
  }

  int? get quoteFeeMinorUnits {
    final quote = data?['quote'];
    if (quote is Map) return _readInt(quote['fee']);
    return _readInt(data?['deliveryFeeMinorUnits']);
  }

  String? get quoteCurrency {
    final quote = data?['quote'];
    if (quote is Map) return _readString(quote['currency']);
    return _readString(data?['currency']);
  }

  double? get deliveryFee => _readDouble(data?['deliveryFee']);

  bool get quotePaymentEligible => data?['paymentEligible'] != false;

  bool get quoteExpired => data?['quoteExpired'] == true;

  bool get alreadyConfirmed => data?['alreadyConfirmed'] == true;

  bool get cancelledSuccessfully => data?['success'] == true;

  bool get alreadyCancelled => data?['alreadyCancelled'] == true;

  bool get refundRequired => data?['refundRequired'] == true;

  bool get reconciliationRequired => data?['reconciliationRequired'] == true;

  String? get checkoutState => _readString(data?['checkoutState']);

  String? get cancellationState => _readString(data?['cancellationState']);

  String? get reservationStatus => _readString(data?['reservationStatus']);
}

/// Minimal seam so the checkout sequence can be unit-tested without HTTP.
abstract class CheckoutV1ApiAdapter {
  Future<CheckoutV1ApiResult> createOrder(Map<String, dynamic> request);

  Future<CheckoutV1ApiResult> getUberQuote(String orderId);

  Future<CheckoutV1ApiResult> bindUberQuote({
    required String orderId,
    required String quoteId,
  });

  Future<CheckoutV1ApiResult> cancelOrder(String orderId);
}

class CheckoutV1Api implements CheckoutV1ApiAdapter {
  CheckoutV1Api({http.Client? client, FirebaseAuth? auth})
    : _client = client ?? http.Client(),
      _auth = auth ?? FirebaseAuth.instance;

  final http.Client _client;
  final FirebaseAuth _auth;

  @override
  Future<CheckoutV1ApiResult> createOrder(Map<String, dynamic> request) {
    return _post(_kCreateCheckoutOrderPath, request);
  }

  @override
  Future<CheckoutV1ApiResult> getUberQuote(String orderId) {
    return _post(_kGetUberDeliveryQuotePath, <String, dynamic>{
      'orderId': orderId,
    });
  }

  @override
  Future<CheckoutV1ApiResult> bindUberQuote({
    required String orderId,
    required String quoteId,
  }) {
    return _post(_kBindCheckoutUberQuotePath, <String, dynamic>{
      'orderId': orderId,
      'quoteId': quoteId,
    });
  }

  @override
  Future<CheckoutV1ApiResult> cancelOrder(String orderId) {
    return _post(_kCancelCheckoutOrderPath, <String, dynamic>{
      'orderId': orderId,
    });
  }

  Future<CheckoutV1ApiResult> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      return const CheckoutV1ApiResult(
        statusCode: 401,
        data: <String, dynamic>{
          'success': false,
          'code': 'auth_required',
          'error': 'Authentication is required.',
        },
      );
    }

    final String? token;
    try {
      token = await user.getIdToken(true);
    } catch (_) {
      return const CheckoutV1ApiResult(
        statusCode: 401,
        data: <String, dynamic>{
          'success': false,
          'code': 'auth_invalid',
          'error': 'Invalid or expired authentication token.',
        },
      );
    }

    if (token == null || token.isEmpty) {
      return const CheckoutV1ApiResult(
        statusCode: 401,
        data: <String, dynamic>{
          'success': false,
          'code': 'auth_required',
          'error': 'Authentication is required.',
        },
      );
    }

    try {
      final response = await _client
          .post(
            Uri.parse('$_kCheckoutFunctionBaseUrl/$path'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(_kRequestTimeout);

      Map<String, dynamic>? decoded;
      try {
        final value = jsonDecode(response.body);
        if (value is Map) {
          decoded = value.cast<String, dynamic>();
        }
      } catch (_) {
        decoded = null;
      }

      return CheckoutV1ApiResult(
        statusCode: response.statusCode,
        data: decoded,
        transportError: decoded == null
            ? 'The checkout service returned an unreadable response.'
            : null,
      );
    } on TimeoutException {
      return const CheckoutV1ApiResult(
        statusCode: null,
        transportError: 'The checkout request timed out.',
      );
    } on http.ClientException catch (error) {
      return CheckoutV1ApiResult(
        statusCode: null,
        transportError: error.message,
      );
    } on FormatException {
      return const CheckoutV1ApiResult(
        statusCode: null,
        transportError: 'The checkout response was invalid.',
      );
    } catch (error) {
      return CheckoutV1ApiResult(
        statusCode: null,
        transportError: error.toString(),
      );
    }
  }
}

String? _readString(Object? value) {
  if (value is! String) return null;
  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}

int? _readInt(Object? value) {
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.roundToDouble()) {
    return value.toInt();
  }
  return null;
}

double? _readDouble(Object? value) {
  if (value is num && value.isFinite) return value.toDouble();
  return null;
}
