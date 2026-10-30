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

import 'package:geocoding/geocoding.dart';

Future<LatLng> getLatLngFromAddress(String address) async {
  // Add your function code here!
  try {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return const LatLng(0, 0);

    final locations = await locationFromAddress(trimmed);
    if (locations.isEmpty) return const LatLng(0, 0);

    final loc = locations.first;
    print(
        "LatLng(loc.latitude, loc.longitude) ${LatLng(loc.latitude, loc.longitude)}");
    return LatLng(loc.latitude, loc.longitude);
  } catch (_) {
    return const LatLng(0, 0);
  }
}
