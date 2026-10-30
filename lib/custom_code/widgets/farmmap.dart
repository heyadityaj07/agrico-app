// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;

class Farmmap extends StatefulWidget {
  const Farmmap({
    super.key,
    this.width,
    this.height,
    this.farmref,
  });

  final double? width;
  final double? height;
  final DocumentReference? farmref;

  @override
  State<Farmmap> createState() => _FarmmapState();
}

class _FarmmapState extends State<Farmmap> {
  Completer<google_maps.GoogleMapController> _controller = Completer();

  // Function to move camera smoothly
  Future<void> _moveCamera(google_maps.LatLng target) async {
    final google_maps.GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      google_maps.CameraUpdate.newCameraPosition(
        google_maps.CameraPosition(
          target: target,
          zoom: 17.0,
          tilt: 45.0, // Added tilt for a better "camera angle"
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If no reference is provided, show a fallback static map
    if (widget.farmref == null) {
      return Container(
          child: Center(child: Text("No Farm Reference Provided")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: widget.farmref!.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Extracting data from Firestore
        var data = snapshot.data!.data() as Map<String, dynamic>;
        GeoPoint? geoPoint = data['farm_location'];

        if (geoPoint == null) {
          return Center(child: Text("Location field missing"));
        }

        google_maps.LatLng currentPosition =
            google_maps.LatLng(geoPoint.latitude, geoPoint.longitude);

        // Move camera whenever the location changes in Firestore
        _moveCamera(currentPosition);

        return Container(
          width: widget.width,
          height: widget.height,
          child: google_maps.GoogleMap(
            initialCameraPosition: google_maps.CameraPosition(
              target: currentPosition,
              zoom: 17.0,
            ),
            markers: {
              google_maps.Marker(
                markerId: google_maps.MarkerId('farmMarker'),
                position: currentPosition,
              ),
            },
            onMapCreated: (google_maps.GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
        );
      },
    );
  }
}
