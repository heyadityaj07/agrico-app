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

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'index.dart'; // Imports other custom actions

Future attachPaymentAndUpdateCustomer(
  String? paymentMethodId,
  String priceid,
  String? uid,
  String sf,
) async {
  // Add your function code here!
  final client = http.Client();
  DocumentSnapshot customer =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  String customerId = customer.get('stripe_user_id');
  Map<String, String> headers = {
    'Authorization':
        'Bearer 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_tst',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  final String url =
      'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
  var response = await client.post(
    Uri.parse(url),
    headers: headers,
    body: {
      'customer': customerId,
    },
  );
  if (response.statusCode == 200) {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      final String url = 'https://api.stripe.com/v1/subscriptions';

      Map<String, dynamic> body = {
        'off_session': 'true',
        'customer': customerId,
        'items[0][price]': priceid,
      };

      var response =
          await client.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(json.decode(response.body));
        throw 'Failed to register as a subscriber.';
      }
    } else {
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  } else {
    print(json.decode(response.body));
    throw 'Failed to attach PaymentMethod.';
  }
}
