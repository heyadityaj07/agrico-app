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

Future<dynamic> getStripePrice(String priceId) async {
  // Add your function code here!
  final String secretKey =
      "sk_test_51Sh2mnIYY44SaFSAO98whlAohi97uCucxI8Hk3NaLXQ9G3Grwate4ago10yeXlvMieh3kb0yt6jBKow5L558zUwN00Ua0i8trp";

  final url = Uri.parse(
    "https://api.stripe.com/v1/prices/$priceId?expand[]=currency_options",
  );

  try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print("Stripe Error: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}
