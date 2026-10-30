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

import 'index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Mapcomponenet extends StatefulWidget {
  const Mapcomponenet({
    super.key,
    this.width,
    this.height,
    this.farms,
    required this.markertapaction,
    required this.defaultRadius,
    required this.routwidget,
    this.selectedCategory,
    this.selectedFarmingMethods,
    required this.filter,
  });

  final double? width;
  final double? height;
  final List<FarmsRecord>? farms;
  final Future Function() markertapaction;
  final double defaultRadius;
  final Widget Function() routwidget;
  final String? selectedCategory;
  final List<String>? selectedFarmingMethods;
  final Widget Function() filter;

  @override
  State<Mapcomponenet> createState() => _MapcomponenetState();
}

class _MapcomponenetState extends State<Mapcomponenet> {
  google_maps.GoogleMapController? _controller;
  FarmsRecord? selectedFarm;
  LatLng? currentUserLocation;
  LatLng? mapCenter;
  StreamSubscription<Position>? _positionStream;
  bool _isPermissionGranted = false;
  final TextEditingController _searchController = TextEditingController();

  Map<String, google_maps.BitmapDescriptor> _customMarkers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // --- CUSTOM MARKER GENERATION ---
  Future<void> _generateMarkers() async {
    if (widget.farms == null) return;
    for (var farm in widget.farms!) {
      if (!_customMarkers.containsKey(farm.reference.id)) {
        final marker = await _createBubbleMarker(farm.farmName);
        if (mounted) {
          setState(() => _customMarkers[farm.reference.id] = marker);
        }
      }
    }
  }

  Future<google_maps.BitmapDescriptor> _createBubbleMarker(String name) async {
    final double pixelRatio = ui.window.devicePixelRatio;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
            fontSize: 14.0 * pixelRatio,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout();

    final double padding = 12.0 * pixelRatio;
    final double iconSize = 20.0 * pixelRatio;
    final double width = tp.width + iconSize + (padding * 3);
    final double height = tp.height + (padding * 2);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
        RRect.fromLTRBR(
            2, 2, width + 2, height + 2, Radius.circular(height / 2)),
        shadowPaint);

    final paint = Paint()..color = Colors.white;
    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, width, height, Radius.circular(height / 2)),
        paint);

    final iconPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawRRect(
        RRect.fromLTRBR(padding, (height - iconSize) / 2, padding + iconSize,
            (height + iconSize) / 2, Radius.circular(4 * pixelRatio)),
        iconPaint);

    tp.paint(canvas, Offset(padding + iconSize + (8 * pixelRatio), padding));

    final ui.Image image = await recorder
        .endRecording()
        .toImage(width.toInt() + 4, height.toInt() + 4);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return google_maps.BitmapDescriptor.fromBytes(
        byteData!.buffer.asUint8List());
  }

  Future<void> _initLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position;
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _isPermissionGranted = true;
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      position = Position(
          latitude: 21.1702,
          longitude: 72.8311,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0);
    }

    if (mounted) {
      setState(() {
        currentUserLocation = LatLng(position.latitude, position.longitude);
        mapCenter = currentUserLocation;
      });
    }

    _controller?.animateCamera(google_maps.CameraUpdate.newLatLngZoom(
        google_maps.LatLng(position.latitude, position.longitude), 11));
    await _generateMarkers();
  }

  Future<void> _searchAndMove(String address) async {
    if (address.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final target =
            LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          mapCenter = target;
          selectedFarm = null;
        });
        _controller?.animateCamera(google_maps.CameraUpdate.newLatLngZoom(
            google_maps.LatLng(target.latitude, target.longitude), 11));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Location not found")));
    }
  }

  double _calculateDistance(LatLng farmLoc, LatLng center) {
    return Geolocator.distanceBetween(center.latitude, center.longitude,
            farmLoc.latitude, farmLoc.longitude) /
        1000;
  }

  List<FarmsRecord> get _matchingFarms {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty || widget.farms == null) return [];
    return widget.farms!.where((farm) {
      final nameMatch = farm.farmName.toLowerCase().contains(query);
      final stateMatch = farm.state.toLowerCase().contains(query);
      final typeMatch = farm.farmType.toLowerCase().contains(query);
      final aboutMatch = farm.aboutFarm.toLowerCase().contains(query);
      return nameMatch || stateMatch || typeMatch || aboutMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Calculate Filtered List
    final filteredFarms = widget.farms?.where((f) {
          if (f.farmLocation == null || mapCenter == null) return false;
          double dist = _calculateDistance(
              LatLng(f.farmLocation!.latitude, f.farmLocation!.longitude),
              mapCenter!);
          bool isWithinDistance = dist <= widget.defaultRadius;
          bool matchesCategory = (widget.selectedCategory == null ||
              widget.selectedCategory == '' ||
              f.farmType == widget.selectedCategory);
          bool matchesFarmingMethod = true;
          if (widget.selectedFarmingMethods != null &&
              widget.selectedFarmingMethods!.isNotEmpty) {
            var farmMethods = f.farmingMethod
                .toList()
                .map((e) => e.trim().toLowerCase())
                .toList();
            matchesFarmingMethod = widget.selectedFarmingMethods!.every(
                (selected) => farmMethods.contains(selected.toLowerCase()));
          }
          return isWithinDistance && matchesCategory && matchesFarmingMethod;
        }).toList() ??
        [];

    final matchingFarms = _matchingFarms;

    // 2. AUTO-HIDE LOGIC: If selected farm no longer matches filter, close it.
    if (selectedFarm != null) {
      bool stillMatches =
          filteredFarms.any((f) => f.reference == selectedFarm!.reference);
      if (!stillMatches) {
        // Use SchedulerBinding to avoid "setState during build" errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => selectedFarm = null);
        });
      }
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          google_maps.GoogleMap(
            initialCameraPosition: google_maps.CameraPosition(
              target: google_maps.LatLng(mapCenter?.latitude ?? 21.1702,
                  mapCenter?.longitude ?? 72.8311),
              zoom: 11,
            ),
            onMapCreated: (c) => _controller = c,
            myLocationEnabled: _isPermissionGranted,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (camPos) {
              mapCenter =
                  LatLng(camPos.target.latitude, camPos.target.longitude);
            },
            markers: filteredFarms.map((farm) {
              return google_maps.Marker(
                markerId: google_maps.MarkerId(farm.reference.id),
                position: google_maps.LatLng(
                    farm.farmLocation!.latitude, farm.farmLocation!.longitude),
                icon: _customMarkers[farm.reference.id] ??
                    google_maps.BitmapDescriptor.defaultMarkerWithHue(120.0),
                onTap: () => setState(() => selectedFarm = farm),
              );
            }).toSet(),
          ),

          // UI: Search & Controls
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 8)
                            ]),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() {}),
                          onSubmitted: (v) => _searchAndMove(v),
                          decoration: InputDecoration(
                            hintText: "Search Farms Near me",
                            border: InputBorder.none,
                            icon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    })
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    widget.filter(),
                    const SizedBox(width: 12),
                    widget.routwidget(),
                  ],
                ),
                if (_searchController.text.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 260),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.white,
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          children: [
                            if (matchingFarms.isNotEmpty) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 4),
                                child: Text(
                                  'FARMS FOUND (${matchingFarms.length})',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              ...matchingFarms.map((farm) => ListTile(
                                    dense: true,
                                    leading: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.storefront,
                                          color: Color(0xFF4CAF50), size: 20),
                                    ),
                                    title: Text(
                                      farm.farmName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      farm.state.isNotEmpty
                                          ? farm.state
                                          : (farm.farmType.isNotEmpty
                                              ? farm.farmType
                                              : 'Farm'),
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      if (farm.farmLocation != null) {
                                        final target = google_maps.LatLng(
                                          farm.farmLocation!.latitude,
                                          farm.farmLocation!.longitude,
                                        );
                                        _controller?.animateCamera(
                                          google_maps.CameraUpdate
                                              .newLatLngZoom(target, 14),
                                        );
                                        setState(() {
                                          mapCenter = LatLng(target.latitude,
                                              target.longitude);
                                          selectedFarm = farm;
                                        });
                                        FFAppState().farmref = farm.reference;
                                      }
                                    },
                                  )),
                              const Divider(height: 1),
                            ],
                            ListTile(
                              dense: true,
                              leading: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on,
                                    color: Colors.blue, size: 20),
                              ),
                              title: Text(
                                "Search location \"${_searchController.text.trim()}\" on map",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _searchAndMove(_searchController.text.trim());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // UI: Farm Profile Card with Close Button
          if (selectedFarm != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10)
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                    selectedFarm!.farmProfilePhoto,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover)),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () =>
                                    setState(() => selectedFarm = null),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close,
                                      size: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(selectedFarm!.farmName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "${_calculateDistance(LatLng(selectedFarm!.farmLocation!.latitude, selectedFarm!.farmLocation!.longitude), currentUserLocation ?? mapCenter!).toStringAsFixed(1)} km away")),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50)),
                                onPressed: () async {
                                  FFAppState().selectedFarmRef =
                                      selectedFarm!.reference;
                                  await widget.markertapaction();
                                },
                                child: const Text("View Farm",
                                    style: TextStyle(color: Colors.white)))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
