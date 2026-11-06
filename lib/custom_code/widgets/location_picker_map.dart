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

import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class LocationPickerMap extends StatefulWidget {
  const LocationPickerMap({
    super.key,
    this.width,
    this.height,
    required this.onConfirm,
  });

  final double? width;
  final double? height;
  final Future Function(String address) onConfirm;

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  google_maps.GoogleMapController? _mapController;
  google_maps.LatLng? _selectedLocation;
  String _address = "Move map to select location";

  static const String _androidKey = "AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc";
  static const String _iosKey = "AIzaSyDs54T-XQN008UL5eqPn7WzlZJsQk4kjlA";
  static const String _webKey =
      "AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc"; // Use same as android if needed

  static const google_maps.CameraPosition _initialCamera =
      google_maps.CameraPosition(
    target: google_maps.LatLng(20.5937, 78.9629),
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    _getDeviceLocation();
  }

  // ================= DEVICE LOCATION =================

  Future<void> _getDeviceLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    google_maps.LatLng current = google_maps.LatLng(
      position.latitude,
      position.longitude,
    );

    _moveCamera(current);
    _updateAddress(current);
  }

  // ================= MOVE CAMERA =================

  void _moveCamera(google_maps.LatLng location) {
    _mapController?.animateCamera(
      google_maps.CameraUpdate.newLatLngZoom(location, 16),
    );
  }

  // ================= REVERSE GEOCODE =================

  Future<void> _updateAddress(google_maps.LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.first;

      setState(() {
        _selectedLocation = position;
        _address =
            "${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
      });
    } catch (e) {}
  }

  // ================= SEARCH PLACE =================

  Future<void> _searchPlace() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: isAndroid
          ? _androidKey
          : isiOS
              ? _iosKey
              : _webKey,
      mode: Mode.overlay,
      language: "en",
    );

    if (prediction != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
          apiKey: isAndroid
              ? _androidKey
              : isiOS
                  ? _iosKey
                  : _webKey);

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(prediction.placeId!);

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      final newPosition = google_maps.LatLng(lat, lng);

      _moveCamera(newPosition);
      _updateAddress(newPosition);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          google_maps.GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              _selectedLocation = position.target;
              _updateAddress(position.target);
            },
            onCameraIdle: () {
              if (_selectedLocation != null) {
                _updateAddress(_selectedLocation!);
              }
            },
          ),

          // 🔴 CENTER RED MARKER
          const Center(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 45,
            ),
          ),

          // 🔎 SEARCH BAR
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: GestureDetector(
              onTap: _searchPlace,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6)
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text("Search address"),
                  ],
                ),
              ),
            ),
          ),

          // 📍 CURRENT LOCATION BUTTON
          Positioned(
            top: 115,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getDeviceLocation,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // 🧾 BOTTOM CONFIRM CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _address,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedLocation != null) {
                          FFAppState().Selectedlocation = LatLng(
                            _selectedLocation!.latitude,
                            _selectedLocation!.longitude,
                          );
                          debugPrint(
                              "location ${FFAppState().Selectedlocation}");
                          await widget.onConfirm(_address);
                        }
                      },
                      child: const Text("Confirm Address"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
