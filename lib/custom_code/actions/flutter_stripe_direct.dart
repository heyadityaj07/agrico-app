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
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> flutterStripeDirect(
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
      return false;
    }

    final response = await http.post(
      Uri.parse(
          'https://us-central1-agricoo-b9c46.cloudfunctions.net/createFarmPaymentIntent'),
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
    );

    if (response.statusCode != 200) {
      print("Cloud Function Error: ${response.body}");
      return false;
    }

    final responseData = jsonDecode(response.body);
    final clientSecret = responseData['clientSecret'];

    if (clientSecret == null) {
      print("No clientSecret returned");
      return false;
    }

    // Set merchant identifier before initPaymentSheet to fix Apple Pay assertion
    Stripe.merchantIdentifier = 'merchant.com.agricoo';

    // Ensure clientSecret is treated as a String
    final String? clientSecretStr = clientSecret?.toString();

    if (clientSecretStr == null || clientSecretStr.isEmpty) {
      print("No valid clientSecret returned");
      return false;
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
                testEnv: false, // ← RELEASE mate false
                currencyCode: paymentCurrency,
              )
            : null,
      ),
    );

    // PRESENT PAYMENT SHEET
    await Stripe.instance.presentPaymentSheet();

    print("PaymentSheet completed");
    return true;
  } on StripeException catch (e) {
    print('Stripe Error: ${e.error.localizedMessage}');
    return false;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
