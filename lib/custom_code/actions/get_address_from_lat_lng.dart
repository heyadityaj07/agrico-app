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

import 'index.dart'; // Imports other custom actions

import 'index.dart'; // Imports other custom actions

import 'package:geocoding/geocoding.dart';

import 'index.dart'; // Imports other custom actions

Future<String> getAddressFromLatLng(LatLng address) async {
  // Add your function code here!
  print("address $address");
  try {
    final placemarks = await placemarkFromCoordinates(
      address.latitude,
      address.longitude,
    );

    if (placemarks.isEmpty) return "";

    final p = placemarks.first;

    // ✅ street = [street or name, thoroughfare, subLocality]
    final streetParts = <String>[
      ((p.street ?? "").trim().isNotEmpty)
          ? (p.street ?? "").trim()
          : (p.name ?? "").trim(),
      (p.thoroughfare ?? "").trim(),
      (p.subLocality ?? "").trim(),
    ].where((x) => x.isNotEmpty).toList();

    final street = streetParts.join(", ");

    final city = (p.locality ?? "").trim();
    final state = (p.administrativeArea ?? "").trim();
    final zip = (p.postalCode ?? "").trim();
    final country = (p.country ?? "").trim();

    // ✅ full address string (optional)
    final fullParts = <String>[
      street,
      city,
      state,
      zip,
      country,
    ].where((x) => x.isNotEmpty).toList();

    final fullAddress = fullParts.join(", ");
    debugPrint("fullAddress: $fullAddress");

    // ✅ Save in AppState
    FFAppState().updateFarmlocationStruct((e) => e
      ..street = street
      ..city = city
      ..state = state
      ..zipcode = zip
      ..country = country);
    debugPrint("fullAddress $fullAddress");
    return fullAddress;
  } catch (_) {
    return "";
  }
}
