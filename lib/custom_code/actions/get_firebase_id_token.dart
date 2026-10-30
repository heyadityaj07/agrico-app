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

import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getFirebaseIdToken() async {
  // Add your function code here!
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('User not logged in');
    return null;
  }

  // ✅ ALWAYS FRESH TOKEN
  final token = await user.getIdToken(true);

  print('Fresh Auth Token: $token');
  return token;
}
