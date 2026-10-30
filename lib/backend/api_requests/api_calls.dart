import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class CloudFunctionCallCall {
  static Future<ApiCallResponse> call({
    String? priceId = '',
    String? successUrl = '',
    String? cancelUrl = '',
    String? userId = '',
    String? planName = '',
    String? locallanguage = '',
    String? currency = '',
    String? productId = '',
    String? interval = '',
  }) async {
    final ffApiRequestBody = '''
{
"user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
 "productId": ${productId == null ? 'null' : '"${escapeStringForJson(productId)}"'},
    "interval": ${interval == null ? 'null' : '"${escapeStringForJson(interval)}"'},
  "priceId": ${priceId == null ? 'null' : '"${escapeStringForJson(priceId)}"'},
    "currency": ${currency == null ? 'null' : '"${escapeStringForJson(currency)}"'},
  "successUrl": ${successUrl == null ? 'null' : '"${escapeStringForJson(successUrl)}"'},
  "cancelUrl": ${cancelUrl == null ? 'null' : '"${escapeStringForJson(cancelUrl)}"'},
  "plan_name": ${planName == null ? 'null' : '"${escapeStringForJson(planName)}"'},
  "locale": ${locallanguage == null ? 'null' : '"${escapeStringForJson(locallanguage)}"'}
  
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cloud function call',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createSubscriptionCheckout',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.url''',
      ));
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? sessionid(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.sessionId''',
      ));
}

class CreateConnectAccountCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
  "user_id" : ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "country": "US",
  "businessType": "individual"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'create  Connect Account',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createConnectAccount',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteConnectAccountCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'delete connect account',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/deleteConnectAccount',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static bool? issuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
}

class GetSubscriptionCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getSubscription',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/getSubscription',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ResumeSubscriptionCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'resume Subscription',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/resumeSubscription',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateSubscriptionCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? newPriceId = '',
    String? successUrl = '',
    String? cancelUrl = '',
    String? planName = '',
    String? locallanguage = '',
    String? newProductId = '',
    String? interval = '',
    String? currency = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
 "newProductId": ${newProductId == null ? 'null' : '"${escapeStringForJson(newProductId)}"'},
    "interval": ${interval == null ? 'null' : '"${escapeStringForJson(interval)}"'},
    "currency": ${currency == null ? 'null' : '"${escapeStringForJson(currency)}"'},
  "successUrl": ${successUrl == null ? 'null' : '"${escapeStringForJson(successUrl)}"'},
  "cancelUrl": ${cancelUrl == null ? 'null' : '"${escapeStringForJson(cancelUrl)}"'},
"plan_name" : ${planName == null ? 'null' : '"${escapeStringForJson(planName)}"'},
"locale": ${locallanguage == null ? 'null' : '"${escapeStringForJson(locallanguage)}"'}
  
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'update Subscription',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/updateSubscription',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CancelSubscriptionCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "cancelAtPeriodEnd": false
}''';
    return ApiManager.instance.makeApiCall(
      callName: ' cancel Subscription',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/cancelSubscription',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateSubscriptionCheckoutCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? sucessUrl = '',
    String? cancelUrl = '',
    String? token = '',
    String? planName = '',
  }) async {
    final ffApiRequestBody = '''
{
  "priceId": "price_1SjviOIYY44SaFSAFXfPzLYC",
  "successUrl": ${sucessUrl == null ? 'null' : '"${escapeStringForJson(sucessUrl)}"'},
  "cancelUrl": ${cancelUrl == null ? 'null' : '"${escapeStringForJson(cancelUrl)}"'},
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "plan_name": ${planName == null ? 'null' : '"${escapeStringForJson(planName)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createSubscriptionCheckout',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createSubscriptionCheckout',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateConnectAccountAPICall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? userId = '',
    String? countrycode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
  "country": ${countrycode == null ? 'null' : '"${escapeStringForJson(countrycode)}"'},
  "businessType": "individual"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createConnectAccountAPI',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createConnectAccount',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateConnectDashboardLinkAPiCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
    "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createConnectDashboardLinkAPi',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createConnectDashboardLink',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.url''',
      ));
}

class CreateAccountLinkapiCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? refreshUrl = '',
    String? returnUrl = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
  "refreshUrl": ${refreshUrl == null ? 'null' : '"${escapeStringForJson(refreshUrl)}"'},
  "returnUrl": ${returnUrl == null ? 'null' : '"${escapeStringForJson(returnUrl)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createAccountLinkapi',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createAccountLink',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.url''',
      ));
}

class GetConnectAccountStatusAPiCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getConnectAccountStatusAPi',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/getConnectAccountStatus',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? hasaccount(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.hasAccount''',
      ));
  static bool? detailssubmited(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.detailsSubmitted''',
      ));
  static bool? chargesEnabled(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.chargesEnabled''',
      ));
  static bool? payoutsEnabled(dynamic response) =>
      castToType<bool>(getJsonField(
        response,
        r'''$.payoutsEnabled''',
      ));
}

class CreateFarmCheckoutSessionAPICall {
  static Future<ApiCallResponse> call({
    double? amount,
    String? productName = '',
    String? customerId = '',
    String? successUrl = '',
    String? cancelUrl = '',
    dynamic? vendorsJson,
    String? orderId = '',
  }) async {
    final vendors = _serializeJson(vendorsJson, true);
    final ffApiRequestBody = '''
{
  "amount": ${amount},
  "productName": ${productName == null ? 'null' : '"${escapeStringForJson(productName)}"'},
  "customerId": ${customerId == null ? 'null' : '"${escapeStringForJson(customerId)}"'},
  "successUrl": ${successUrl == null ? 'null' : '"${escapeStringForJson(successUrl)}"'},
  "cancelUrl": ${cancelUrl == null ? 'null' : '"${escapeStringForJson(cancelUrl)}"'},
  "vendors": ${vendors},
  "orderId": ${orderId == null ? 'null' : '"${escapeStringForJson(orderId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createFarmCheckoutSessionAPI',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createFarmCheckoutSession',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatesubscriptionapiCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'updatesubscriptionapi',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/updateSubscription',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PriceApiCall {
  static Future<ApiCallResponse> call({
    String? expand = '',
    String? key = '',
    String? active = '',
    String? lookupKeys = '',
    String? currency = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'price api',
      apiUrl: 'https://api.stripe.com/v1/prices',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${key}',
      },
      params: {
        'expand': expand,
        'lookup_keys': lookupKeys,
        'active': active,
        'currency': currency,
        'expand[]': "data.currency_options",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic? currency(dynamic response) => getJsonField(
        response,
        r'''$.currency_options''',
      );
  static int? usdAmmount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.currency_options.usd.unit_amount''',
      ));
  static int? eurAmmount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.currency_options.eur.unit_amount''',
      ));
}

class CreateCustomerPortalSessionAPICall {
  static Future<ApiCallResponse> call({
    String? returnUrl = '',
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
    "user_id": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'},
    "returnUrl": ${returnUrl == null ? 'null' : '"${escapeStringForJson(returnUrl)}"'}
 }''';
    return ApiManager.instance.makeApiCall(
      callName: 'createCustomerPortalSessionAPI',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createCustomerPortalSession',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ValidateAccessCall {
  static Future<ApiCallResponse> call({
    String? address = '',
  }) async {
    final ffApiRequestBody = '''
{
  "address": ${address == null ? 'null' : '"${escapeStringForJson(address)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validateAccess',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/validateUberAccess',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static bool? issupported(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSupported''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class GetDeliveryQuoteCall {
  static Future<ApiCallResponse> call({
    String? pickupAddress = '',
    String? dropoffAddress = '',
  }) async {
    final ffApiRequestBody = '''
{
  "pickup_address": ${pickupAddress == null ? 'null' : '"${escapeStringForJson(pickupAddress)}"'},
  "dropoff_address": ${dropoffAddress == null ? 'null' : '"${escapeStringForJson(dropoffAddress)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getDeliveryQuote',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/getUberDeliveryQuote',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? id(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.quote.id''',
      ));
  static int? fee(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.quote.fee''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class CreateDeliveryCall {
  static Future<ApiCallResponse> call({
    String? pickupAddress = '',
    String? dropoffAddress = '',
    String? pickupName = '',
    String? pickupPhoneNumber = '',
    String? dropoffName = '',
    String? dropoffPhoneNumber = '',
    dynamic? manifestItemsJson,
  }) async {
    final manifestItems = _serializeJson(manifestItemsJson, true);
    final ffApiRequestBody = '''
{
  "pickup_address": ${pickupAddress == null ? 'null' : '"${escapeStringForJson(pickupAddress)}"'},
  "pickup_name": ${pickupName == null ? 'null' : '"${escapeStringForJson(pickupName)}"'},
  "pickup_phone_number": ${pickupPhoneNumber == null ? 'null' : '"${escapeStringForJson(pickupPhoneNumber)}"'},
  "dropoff_address": ${dropoffAddress == null ? 'null' : '"${escapeStringForJson(dropoffAddress)}"'},
  "dropoff_name": ${dropoffName == null ? 'null' : '"${escapeStringForJson(dropoffName)}"'},
  "dropoff_phone_number": ${dropoffPhoneNumber == null ? 'null' : '"${escapeStringForJson(dropoffPhoneNumber)}"'},
  "manifest_items": ${manifestItems}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createDelivery',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createUberDelivery',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? uberDeliveryId(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.id''',
      ));
  static String? trackingUrl(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.tracking_url''',
      ));
  static String? deliveryStatus(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.status''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class CreateDeliveryCopyCall {
  static Future<ApiCallResponse> call({
    String? pickupAddress = '',
    String? dropoffAddress = '',
    String? pickupName = '',
    String? pickupPhoneNumber = '',
    String? dropoffName = '',
    String? dropoffPhoneNumber = '',
    dynamic? manifestItemsJson,
    String? orderId = '',
  }) async {
    final manifestItems = _serializeJson(manifestItemsJson, true);
    final ffApiRequestBody = '''
{
  "pickup_address": ${pickupAddress == null ? 'null' : '"${escapeStringForJson(pickupAddress)}"'},
  "pickup_name": ${pickupName == null ? 'null' : '"${escapeStringForJson(pickupName)}"'},
  "pickup_phone_number": ${pickupPhoneNumber == null ? 'null' : '"${escapeStringForJson(pickupPhoneNumber)}"'},
  "dropoff_address": ${dropoffAddress == null ? 'null' : '"${escapeStringForJson(dropoffAddress)}"'},
  "dropoff_name": ${dropoffName == null ? 'null' : '"${escapeStringForJson(dropoffName)}"'},
  "dropoff_phone_number": ${dropoffPhoneNumber == null ? 'null' : '"${escapeStringForJson(dropoffPhoneNumber)}"'},
  "manifest_items": ${manifestItems},
  "test_specifications": {
    "robo_courier_specification": {
      "mode": "auto"
    }
  },
  "manifest_reference": ${orderId == null ? 'null' : '"${escapeStringForJson(orderId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createDelivery Copy',
      apiUrl:
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createUberDelivery',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? uberDeliveryId(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.id''',
      ));
  static String? trackingUrl(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.tracking_url''',
      ));
  static String? deliveryStatus(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.delivery.status''',
      ));
  static String? error(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}
