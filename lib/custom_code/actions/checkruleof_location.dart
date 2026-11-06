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

// Add these imports
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> checkruleofLocation(
  LatLng? farmlocation,
  double? radiusKm,
  LatLng? consumerLocation,
) async {
  // Return false if anything is empty
  if (farmlocation == null) {
    print('checkruleofLocation: FAILED because farmlocation is null.');
    return false;
  }
  if (radiusKm == null || radiusKm <= 0) {
    print(
        'checkruleofLocation: FAILED because radiusKm is null or less than/equal to 0 (Value: $radiusKm).');
    return false;
  }
  if (consumerLocation == null) {
    print('checkruleofLocation: FAILED because consumerLocation is null.');
    return false;
  }

  try {
    // Calculate distance in meters directly between the two points
    final distanceInMeters = Geolocator.distanceBetween(
      farmlocation.latitude,
      farmlocation.longitude,
      consumerLocation.latitude,
      consumerLocation.longitude,
    );

    final isWithinRadius = isWithinDeliveryRadius(distanceInMeters, radiusKm);

    // Detailed debug logs
    print('checkruleofLocation: --- Delivery Rule Check ---');
    print(
        'checkruleofLocation: Farm Coordinates: (${farmlocation.latitude}, ${farmlocation.longitude})');
    print(
        'checkruleofLocation: Consumer Coordinates: (${consumerLocation.latitude}, ${consumerLocation.longitude})');
    print(
        'checkruleofLocation: Calculated Distance: ${(distanceInMeters / 1000).toStringAsFixed(2)} km');
    print('checkruleofLocation: Maximum Allowed Radius: $radiusKm km');
    print('checkruleofLocation: Result -> isWithinRadius: $isWithinRadius');

    return isWithinRadius;
  } catch (e) {
    print('checkruleofLocation: FAILED due to an unexpected exception: $e');
    return false;
  }
}
