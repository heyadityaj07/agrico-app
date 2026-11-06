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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';

Future<List<String>> getDeliveryAreas(
  LatLng location,
  double miles,
) async {
  List<String> areaNames = [];
  double lat = location.latitude;
  double lng = location.longitude;

  // 1. Calculate the radius
  double radiusInMiles = math.sqrt(miles / math.pi);
  double radiusInKm = radiusInMiles * 1.60934;

  debugPrint('--- Large Area Search Started ---');

  for (int i = 0; i < 360; i += 45) {
    double bearing = i * math.pi / 180;
    double earthRadius = 6371.0;

    double targetLat = math.asin(
        math.sin(lat * math.pi / 180) * math.cos(radiusInKm / earthRadius) +
            math.cos(lat * math.pi / 180) *
                math.sin(radiusInKm / earthRadius) *
                math.cos(bearing));

    double targetLng = (lng * math.pi / 180) +
        math.atan2(
            math.sin(bearing) *
                math.sin(radiusInKm / earthRadius) *
                math.cos(lat * math.pi / 180),
            math.cos(radiusInKm / earthRadius) -
                math.sin(lat * math.pi / 180) * math.sin(targetLat));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          targetLat * 180 / math.pi, targetLng * 180 / math.pi);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // HIERARCHY LOGIC:
        // 1. Try Neighborhood (Adajan)
        // 2. Try Town/City (Olpad/Sayan)
        // 3. Try District/Area (Surat District)
        String? name = place.subLocality;

        if (name == null || name.isEmpty || name == place.locality) {
          name = place.locality; // City/Town level
        }

        if (name == null || name.isEmpty) {
          name = place.subAdministrativeArea; // District level
        }

        if (name != null && name.isNotEmpty && !areaNames.contains(name)) {
          areaNames.add(name);
          debugPrint('Point $i°: Found $name');
        }
      }
    } catch (e) {
      continue;
    }
  }

  debugPrint('Final List: ${areaNames.join(", ")}');
  // Fallback if still empty
  return areaNames.isNotEmpty ? areaNames : [" "];
}
