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

Future<List<dynamic>> getAllUserPushNotifications(
    DocumentReference useref) async {
  // Add your function code here!
  try {
    // 1. Get the path and remove the leading slash if present
    // to match "users/AGTKe..." exactly as seen in your screenshot.
    String userPath = useref.path;
    if (userPath.startsWith('/')) {
      userPath = userPath.substring(1);
    }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ff_user_push_notifications')
        .where('user_refs', isEqualTo: userPath) // Field name from your image
        .orderBy('timestamp', descending: true) // Sorting: newest first
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    // optionally print(e);
    return [];
  }
}
