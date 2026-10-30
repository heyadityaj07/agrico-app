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

Future<bool> islocateionselect(
  LatLng? startlocation,
  LatLng? desinationlocation,
) async {
  // Add your function code here!
  final isStartValid = startlocation != null &&
      !(startlocation.latitude == 0.0 && startlocation.longitude == 0.0);

  final isDestinationValid = desinationlocation != null &&
      !(desinationlocation.latitude == 0.0 &&
          desinationlocation.longitude == 0.0);

  return isStartValid && isDestinationValid;
}
