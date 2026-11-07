// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

// ---------------------------------------------------------------------------
// Agrico payment environment configuration (P1-08).
// Single source of truth for the checkout payment endpoint and mode.
//
// Only one Firebase project/environment exists today (pre-launch test
// project `agricoo-b9c46`, region `us-central1`). When moving to another
// project/region or going live, change ONLY these three lines:
// 1. `_kPaymentsFunctionBaseUrl` -> new Cloud Functions base URL.
// 2. `_kStripeTestMode` -> false, together with the Stripe publishable key
//    in `lib/backend/stripe/payment_manager.dart` (both must flip together).
// 3. Nothing else in this action needs to change.
// ---------------------------------------------------------------------------
const String _kPaymentsFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kCreateFarmPaymentIntentPath = 'createFarmPaymentIntent';
// Keep this `true` until go-live: Google Pay must use the test environment
// while the publishable key (`pk_test_...`) and backend are in test mode.
const bool _kStripeTestMode = true;

// P1-08 follow-up outcome classification returned by this action:
//  - 'success':   payment sheet completed (or backend reports the payment as
//                 already confirmed) — the caller may complete the order.
//  - 'failed':    confirmed cancellation or a definitive rejection — the
//                 caller may clean up (delete) the freshly created order.
//  - 'ambiguous': the outcome is UNKNOWN (e.g. request timeout, network loss
//                 or malformed response). The caller must NOT report failure
//                 and must NOT delete/recreate the order — retry with the
//                 SAME order so the backend can reuse the original intent.
Future<String> flutterStripeDirect(
  BuildContext context,
  double? amount,
  String? orderId,
  String? customerId,
  String? locallanguage,
  List<dynamic>? vendors,
  String? producerId,
) async {
  try {
    final paymentCurrency =
        FFLocalizations.of(context).languageCode == 'fr' ? 'EUR' : 'USD';

    final currentUser = FirebaseAuth.instance.currentUser;
    final String? idToken = await currentUser?.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      print("No authenticated user; payment cannot be created");
      return 'failed';
    }

    final response = await http
        .post(
          Uri.parse(
              '$_kPaymentsFunctionBaseUrl/$_kCreateFarmPaymentIntentPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({
            "amount": amount ?? 0,
            "locale": locallanguage,
            "customerId": customerId,
            "orderId": orderId,
            "producerId": producerId,
            "currency": paymentCurrency,
            "vendors": vendors
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      final decodedBody = _decodeJson(response.body);
      final errorDetail = decodedBody is Map
          ? (decodedBody['code'] ?? decodedBody['error'] ?? '')
          : '';
      print(
          'createFarmPaymentIntent failed (${response.statusCode})${errorDetail.toString().isEmpty ? '' : ': $errorDetail'}');
      // 5xx or an unresolved/ambiguous backend payment state is not a
      // confirmed failure: classify it ambiguously so the caller never
      // treats it as "payment failed" and never deletes/recreates orders.
      final ambiguousCode = errorDetail == 'payment_processing' ||
          errorDetail == 'payment_intent_unresolved' ||
          errorDetail == 'payment_intent_state_unavailable';
      if (response.statusCode >= 500 || ambiguousCode) {
        return 'ambiguous';
      }
      return 'failed';
    }

    final responseData = _decodeJson(response.body);
    if (responseData is! Map) {
      print("createFarmPaymentIntent returned an unexpected response body");
      return 'ambiguous';
    }

    // P1-08 follow-up: the backend confirmed the payment is already done
    // (e.g. a previous attempt succeeded but the response was lost). The
    // caller should complete the order without presenting the sheet again.
    if (responseData['alreadyConfirmed'] == true) {
      print("Payment already confirmed for this order");
      return 'success';
    }

    final clientSecret = responseData['clientSecret'];

    if (clientSecret == null) {
      print("No clientSecret returned");
      return 'ambiguous';
    }

    // Set merchant identifier before initPaymentSheet to fix Apple Pay assertion
    Stripe.merchantIdentifier = 'merchant.com.agricoo';

    // Ensure clientSecret is treated as a String
    final String? clientSecretStr = clientSecret?.toString();

    if (clientSecretStr == null || clientSecretStr.isEmpty) {
      print("No valid clientSecret returned");
      return 'ambiguous';
    }

    // INIT PAYMENT SHEET
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecretStr,
        merchantDisplayName: 'Agricoo',
        applePay: Platform.isIOS
            ? const PaymentSheetApplePay(
                merchantCountryCode: 'US', // ← Stripe account country
              )
            : null,
        googlePay: Platform.isAndroid
            ? PaymentSheetGooglePay(
                merchantCountryCode: 'US', // ← Stripe account country
                testEnv: _kStripeTestMode, // true while in test mode
                currencyCode: paymentCurrency,
              )
            : null,
      ),
    );

    // PRESENT PAYMENT SHEET
    await Stripe.instance.presentPaymentSheet();

    print("PaymentSheet completed");
    return 'success';
  } on TimeoutException catch (e) {
    // Ambiguous: the backend may still have created (or completed) a
    // PaymentIntent. The caller must not report failure or recreate orders.
    print('Payment request timed out: $e');
    return 'ambiguous';
  } on SocketException catch (e) {
    // Network loss: same ambiguity as a timeout.
    print('Network error during payment: $e');
    return 'ambiguous';
  } on http.ClientException catch (e) {
    // HTTP client connection failure: same ambiguity as a timeout.
    print('HTTP client error during payment: $e');
    return 'ambiguous';
  } on FormatException catch (e) {
    // Malformed/unexpected response body: same ambiguity.
    print('Unexpected payment response: $e');
    return 'ambiguous';
  } on StripeException catch (e) {
    // P1-08 final closure: classify against the concrete flutter_stripe 11.5.0
    // error shape (StripeException.error is a LocalizedErrorMessage with
    // `code: FailureCode{Failed, Canceled, Timeout, Unknown}`,
    // `stripeErrorCode`, `declineCode` and `type`).
    //
    // 1. Confirmed user cancellation (sheet dismissed before confirming) ->
    //    definitive: nothing was charged and the attempted payment is over.
    // 2. Confirmed payment failure (Stripe "card_error" decline) -> definitive:
    //    Stripe refused the attempted charge, no payment was captured and the
    //    intent state is known-failed, so the existing cleanup may run.
    // 3. Everything else (`FailureCode.Timeout`/`Unknown`, connection errors,
    //    in-sheet failures without a decline code) CANNOT tell whether a
    //    charge occurred -> 'ambiguous': never report failure, never delete
    //    the order.
    print('Stripe Error: ${e.error.localizedMessage}');
    if (e.error.code == FailureCode.Canceled) {
      return 'failed';
    }
    if (e.error.type == 'card_error' &&
        e.error.declineCode != null &&
        e.error.declineCode!.isNotEmpty) {
      return 'failed';
    }
    if (e.error.stripeErrorCode == 'card_declined') {
      return 'failed';
    }
    print('Uncertain Stripe failure; classified as ambiguous');
    return 'ambiguous';
  } on StripeConfigException catch (e) {
    // Configuration errors surface before any sheet presentation; the
    // PaymentIntent was never confirmed by the sheet, so the existing
    // failure/cleanup behaviour remains correct.
    print('Stripe configuration error: ${e.message}');
    return 'failed';
  } catch (e) {
    // Unknown/programming errors cannot establish whether the payment
    // went through: treat as ambiguous (the caller keeps the order and may
    // safely retry — the backend reuses the recorded PaymentIntent).
    print('Error: $e');
    return 'ambiguous';
  }
}

// Safely decode a JSON response body; returns the decoded value or null.
dynamic _decodeJson(String body) {
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}
