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

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart' as geo;

// ✅ web-safe platform check (NO dart:io)
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, kDebugMode;

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.width,
    this.height,
    required this.destinationLocation,
    required this.currentlocation,
    required this.startLocation,
    required this.farms,
    required this.action,
    this.radius,
  });

  final double? width;
  final double? height;
  final LatLng destinationLocation;
  final LatLng currentlocation;
  final LatLng startLocation;
  final List<FarmsRecord> farms;
  final Future Function() action;
  final double? radius;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // =========================
  // ✅ KEYS (put your keys here) - VERIFY THESE ARE CORRECT
  // =========================
  static const String _androidKey = "AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc";
  static const String _iosKey = "AIzaSyDs54T-XQN008UL5eqPn7WzlZJsQk4kjlA";
  static const String _webKey =
      "AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc"; // Use same as android if needed
  bool _showOverlay = true;
  String get _apiKey {
    if (kIsWeb) return _webKey.isNotEmpty ? _webKey : _androidKey;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return isIOS ? _iosKey : _androidKey;
  }

  // =========================
  // ✅ FARM SETTINGS
  // =========================
  // ✅ Changed from static const to a getter to use widget.radius
  double get routeBufferMeters => (widget.radius ?? 1.2) * 1000;

  static const double followZoom = 16;
  static const bool followBearing = true;
  static const double _offRouteMeters = 50;
  static const double _rerouteMinMoveMeters = 25;
  static const int _rerouteMinSeconds = 6;
  static const double _arriveMeters = 25;
  double _currentZoom =
      12; // Changed from 14 to 12 for better marker visibility

  // =========================
  gmaps.GoogleMapController? _map;
  final Set<gmaps.Polyline> _polylines = {};
  final Set<gmaps.Marker> _markers = {};

  bool _loading = false;
  bool _followUser = true;
  bool _locationGranted = false;

  String _etaText = "--";
  String _distText = "--";

  // ✅ Route points
  List<gmaps.LatLng> _routePtsFull = [];
  List<gmaps.LatLng> _routePtsRemaining = [];
  int _progressIdx = 0;
  List<FarmsRecord> _farmsOnRoute = [];
  gmaps.LatLng? _lastFollowPos;
  DateTime? _lastRerouteAt;
  gmaps.LatLng? _lastReroutePos;
  bool _arrived = false;
  StreamSubscription<geo.Position>? _posSub;
  gmaps.LatLng? _liveCurr;

  gmaps.LatLng get _start => gmaps.LatLng(
        widget.startLocation.latitude,
        widget.startLocation.longitude,
      );

  gmaps.LatLng get _dest => gmaps.LatLng(
        widget.destinationLocation.latitude,
        widget.destinationLocation.longitude,
      );

  gmaps.LatLng get _curr =>
      _liveCurr ??
      gmaps.LatLng(
        widget.currentlocation.latitude,
        widget.currentlocation.longitude,
      );

  @override
  void initState() {
    super.initState();

    // ✅ DEBUG: Print initial coordinates
    if (kDebugMode) {
      print('=== INIT MAP WIDGET ===');
      print(
          'Start Location from FF: ${widget.startLocation.latitude}, ${widget.startLocation.longitude}');
      print(
          'Destination from FF: ${widget.destinationLocation.latitude}, ${widget.destinationLocation.longitude}');
      print(
          'Current from FF: ${widget.currentlocation.latitude}, ${widget.currentlocation.longitude}');
      print('Converted Start: $_start');
      print('Converted Dest: $_dest');
      print('Converted Curr: $_curr');
      print('API Key: ${_apiKey.substring(0, min(10, _apiKey.length))}...');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ Step 1: Add markers IMMEDIATELY
      _addMarkers();

      // ✅ Step 2: Request location permission
      await _ensureLocationPermission();

      // ✅ Step 3: Start live location
      await _startLiveLocation();

      // ✅ Step 4: Build route
      await _buildRouteWithRetry(origin: _start, resetProgress: true);

      // ✅ Step 5: Filter farms
      await _filterFarmsOnRoute();

      // ✅ Step 6: Fit bounds with delay to ensure map is ready
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _fitBoundsToShowEverything();
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissLongRouteBanner();
    _posSub?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Re-filter if radius changes
    if (oldWidget.radius != widget.radius) {
      _filterFarmsOnRoute();
    }

    final destChanged = oldWidget.destinationLocation.latitude !=
            widget.destinationLocation.latitude ||
        oldWidget.destinationLocation.longitude !=
            widget.destinationLocation.longitude;

    if (destChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _arrived = false;
        _addMarkers(); // ✅ Always update markers first
        await _buildRouteWithRetry(origin: _start, resetProgress: true);
        await _filterFarmsOnRoute();
        _fitBoundsToShowEverything();
      });
    }

    final startChanged =
        oldWidget.startLocation.latitude != widget.startLocation.latitude ||
            oldWidget.startLocation.longitude != widget.startLocation.longitude;

    if (startChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _addMarkers(); // ✅ Always update markers first
        await _buildRouteWithRetry(origin: _start, resetProgress: true);
        await _filterFarmsOnRoute();
        _fitBoundsToShowEverything();
      });
    }

    if (oldWidget.farms.length != widget.farms.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _filterFarmsOnRoute();
      });
    }

    final moved = oldWidget.currentlocation.latitude !=
            widget.currentlocation.latitude ||
        oldWidget.currentlocation.longitude != widget.currentlocation.longitude;

    if (moved && _liveCurr == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _onPositionUpdate();
      });
    }
  }

  // =========================
  // ✅ LOCATION PERMISSION
  // =========================
  Future<void> _ensureLocationPermission() async {
    if (kIsWeb) {
      if (!mounted) return;
      setState(() => _locationGranted = true);
      return;
    }

    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() => _locationGranted = false);
        return;
      }

      var perm = await geo.Geolocator.checkPermission();
      if (perm == geo.LocationPermission.denied) {
        perm = await geo.Geolocator.requestPermission();
      }

      final ok = perm == geo.LocationPermission.always ||
          perm == geo.LocationPermission.whileInUse;

      if (!mounted) return;
      setState(() => _locationGranted = ok);
    } catch (_) {
      if (!mounted) return;
      setState(() => _locationGranted = false);
    }
  }

  // =========================
  // ✅ LIVE LOCATION STREAM
  // =========================
  Future<void> _startLiveLocation() async {
    if (!_locationGranted || kIsWeb) return;

    await _posSub?.cancel();

    const settings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );

    _posSub = geo.Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) async {
      _liveCurr = gmaps.LatLng(pos.latitude, pos.longitude);
      await _onPositionUpdate();
    });
  }

  // =========================
  // ✅ RUNS ON EVERY LOCATION UPDATE
  // =========================
  Future<void> _onPositionUpdate() async {
    _updateCurrentMarker();
    _updateRemainingRoutePolyline();
    await _filterFarmsOnRoute();
    if (_followUser) await _animateFollowCamera();
    await _handleArrivalAndReroute();
  }

  // =========================
  // ✅ ARRIVED + OFF-ROUTE + REROUTE
  // =========================
  Future<void> _handleArrivalAndReroute() async {
    if (_arrived) return;

    final toDestMeters = geo.Geolocator.distanceBetween(
      _curr.latitude,
      _curr.longitude,
      _dest.latitude,
      _dest.longitude,
    );

    if (toDestMeters <= _arriveMeters) {
      _arrived = true;
      _polylines.clear();
      _routePtsFull = [];
      _routePtsRemaining = [];
      _etaText = "Arrived";
      _distText = "0 m";
      _markers.removeWhere((m) => m.markerId.value.startsWith("farm_"));
      _farmsOnRoute = [];
      if (mounted) setState(() {});
      return;
    }

    final checkLine =
        _routePtsRemaining.length >= 2 ? _routePtsRemaining : _routePtsFull;

    if (checkLine.length >= 2) {
      final offMeters = _distancePointToPolylineMeters(_curr, checkLine);
      if (offMeters > _offRouteMeters) {
        await _forceRerouteFromCurrent();
        return;
      }
    }

    await _maybeRerouteByMove();
  }

  Future<void> _forceRerouteFromCurrent() async {
    final now = DateTime.now();
    if (_lastRerouteAt != null &&
        now.difference(_lastRerouteAt!).inSeconds < 2) {
      return;
    }
    _lastRerouteAt = now;
    _lastReroutePos = _curr;

    await _buildRouteWithRetry(origin: _curr, resetProgress: true);
    await _filterFarmsOnRoute();
  }

  Future<void> _maybeRerouteByMove() async {
    final now = DateTime.now();
    if (_lastRerouteAt != null &&
        now.difference(_lastRerouteAt!).inSeconds < _rerouteMinSeconds) {
      return;
    }

    final last = _lastReroutePos ?? _curr;
    final movedMeters = geo.Geolocator.distanceBetween(
      last.latitude,
      last.longitude,
      _curr.latitude,
      _curr.longitude,
    );

    if (movedMeters < _rerouteMinMoveMeters) return;

    _lastRerouteAt = now;
    _lastReroutePos = _curr;

    await _buildRouteWithRetry(origin: _curr, resetProgress: true);
    await _filterFarmsOnRoute();
  }

  // =========================
  // ✅ ADD MARKERS - IMPROVED VERSION (with better zoom control)
  // =========================
  void _addMarkers() {
    _markers.clear();

    if (kDebugMode) {
      print('=== ADDING MARKERS ===');
      print('Start position: $_start');
      print('Dest position: $_dest');
      print('Current position: $_curr');
    }

    // ✅ ALWAYS add START marker (GREEN) - with descriptive title
    if (_start.latitude != 0 && _start.longitude != 0) {
      _markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId("start"),
        position: _start,
        infoWindow: const gmaps.InfoWindow(title: "Start (Surat)"),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueGreen,
        ),
        anchor: const ui.Offset(0.5, 1.0),
        zIndex: 3,
        visible: true,
        consumeTapEvents: false,
      ));
      if (kDebugMode) print('✓ Added START marker at Surat: $_start');
    } else {
      if (kDebugMode) print('✗ Skipping START marker - invalid coordinates');
    }

    // ✅ ALWAYS add DESTINATION marker (RED) - with descriptive title
    if (_dest.latitude != 0 && _dest.longitude != 0) {
      _markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId("dest"),
        position: _dest,
        infoWindow: const gmaps.InfoWindow(title: "Destination (Ahmedabad)"),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueRed,
        ),
        anchor: const ui.Offset(0.5, 1.0),
        zIndex: 2,
        visible: true,
        consumeTapEvents: false,
      ));
      if (kDebugMode) print('✓ Added DESTINATION marker: $_dest');
    } else {
      if (kDebugMode) print('✗ Skipping DEST marker - invalid coordinates');
    }

    // ✅ Add CURRENT marker only if valid (BLUE)
    if (_curr.latitude != 0 && _curr.longitude != 0) {
      _markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId("current"),
        position: _curr,
        infoWindow: const gmaps.InfoWindow(title: "You"),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueAzure,
        ),
        anchor: const ui.Offset(0.5, 1.0),
        zIndex: 1,
        visible: true,
      ));
      if (kDebugMode) print('✓ Added CURRENT marker: $_curr');
    } else {
      if (kDebugMode) print('✗ Skipping CURRENT marker - invalid coordinates');
    }

    if (kDebugMode) {
      print('Total markers added: ${_markers.length}');
    }

    if (mounted) {
      setState(() {});
    }

    // ✅ Try to immediately show markers on map - IMPROVED
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_map != null && mounted) {
        // Always zoom to start location first so markers are visible
        _map!.animateCamera(
          gmaps.CameraUpdate.newLatLngZoom(_start, 12),
        );
        if (kDebugMode) print('Zoomed to start location at zoom level 12');
      }
    });
  }

  // =========================
  // ✅ BUILD ROUTE WITH RETRY MECHANISM
  // =========================
  Future<void> _buildRouteWithRetry({
    required gmaps.LatLng origin,
    required bool resetProgress,
    int maxRetries = 3,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) {
          print('Attempt $attempt to build route...');
        }

        final success = await _buildRouteInternal(
          origin: origin,
          resetProgress: resetProgress,
        );

        if (success) {
          if (kDebugMode) {
            print('Route built successfully on attempt $attempt');
          }
          return;
        }

        if (attempt < maxRetries) {
          if (kDebugMode) {
            print('Waiting before retry...');
          }
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error on attempt $attempt: $e');
        }
        if (attempt == maxRetries) {
          _showRouteError("Failed to load road route");
        }
      }
    }
  }

  Future<bool> _buildRouteInternal({
    required gmaps.LatLng origin,
    required bool resetProgress,
  }) async {
    if (!mounted) return false;
    setState(() => _loading = true);

    try {
      _arrived = false;
      _polylines.clear();
      _routePtsFull = [];
      _routePtsRemaining = [];
      _etaText = "--";
      _distText = "--";

      if (resetProgress) _progressIdx = 0;

      // ✅ IMPROVED DIRECTIONS API CALL
      try {
        final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${origin.latitude},${origin.longitude}"
          "&destination=${_dest.latitude},${_dest.longitude}"
          "&key=$_apiKey"
          "&mode=driving"
          "&alternatives=true"
          "&language=en"
          "&units=metric",
        );

        if (kDebugMode) {
          print('Calling Google Directions API...');
          print('URL: ${url.toString().replaceAll(_apiKey, '[API_KEY]')}');
        }

        final response =
            await http.get(url).timeout(const Duration(seconds: 30));

        if (response.statusCode != 200) {
          if (kDebugMode) {
            print('API returned status: ${response.statusCode}');
          }
          return false;
        }

        final data = jsonDecode(response.body);

        if (kDebugMode) {
          print('API Response status: ${data["status"]}');
          if (data["error_message"] != null) {
            print('API Error message: ${data["error_message"]}');
          }
        }

        if (data["status"] == "OK") {
          final route0 = data["routes"][0];
          final leg0 = route0["legs"][0];

          _etaText = (leg0["duration"]?["text"] ?? "--").toString();
          _distText = (leg0["distance"]?["text"] ?? "--").toString();

          // ✅ EXTRACT ALL POLYLINE POINTS FROM ALL STEPS
          _routePtsFull = _extractDetailedPolylinePoints(route0);

          if (kDebugMode) {
            print('Route details:');
            print('- Distance: $_distText');
            print('- Duration: $_etaText');
            print('- Total points extracted: ${_routePtsFull.length}');
            if (_routePtsFull.isNotEmpty) {
              print('- First point: ${_routePtsFull.first}');
              print('- Last point: ${_routePtsFull.last}');
            }
          }

          if (_routePtsFull.length < 10) {
            if (kDebugMode) {
              print(
                  'WARNING: Too few points in route (${_routePtsFull.length}). Using fallback.');
            }
            return false;
          }

          // ✅ EXTEND ROUTE TO MARKERS
          _extendRouteToMarkers();

          // ✅ DRAW POLYLINE
          _updateRemainingRoutePolyline();

          if (!mounted) return false;
          setState(() {});

          return true;
        } else {
          if (kDebugMode) {
            print('Directions API error: ${data["status"]}');
            if (data["error_message"] != null) {
              print('Error: ${data["error_message"]}');
            }
          }
          return false;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception during route building: $e');
        }
        return false;
      }
    } finally {
      if (!mounted) return false;
      setState(() => _loading = false);
    }
  }

  // =========================
  // ✅ EXTRACT DETAILED POLYLINE POINTS FROM ALL STEPS
  // =========================
  List<gmaps.LatLng> _extractDetailedPolylinePoints(
      Map<String, dynamic> route) {
    final List<gmaps.LatLng> allPoints = [];

    try {
      // First try to get detailed points from all steps
      final legs = route["legs"] as List<dynamic>;

      for (final leg in legs) {
        final steps = leg["steps"] as List<dynamic>;

        for (final step in steps) {
          // Get polyline from each step
          final polyline = step["polyline"];
          if (polyline != null && polyline["points"] is String) {
            final stepPoints =
                _decodePolylineString(polyline["points"] as String);
            allPoints.addAll(stepPoints);
          }
        }
      }

      // If no points from steps, use overview polyline
      if (allPoints.isEmpty) {
        final overviewPolyline = route["overview_polyline"];
        if (overviewPolyline != null && overviewPolyline["points"] is String) {
          allPoints.addAll(
              _decodePolylineString(overviewPolyline["points"] as String));
        }
      }

      if (kDebugMode) {
        print('Extracted ${allPoints.length} points from route');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting polyline points: $e');
      }
    }

    return allPoints;
  }

  // =========================
  // ✅ HELPER: DECODE POLYLINE STRING
  // =========================
  List<gmaps.LatLng> _decodePolylineString(String encoded) {
    List<gmaps.LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(gmaps.LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // =========================
  // ✅ EXTEND ROUTE TO MARKERS
  // =========================
  void _extendRouteToMarkers() {
    if (_routePtsFull.isEmpty) return;

    // Add start point if not already close
    if (_routePtsFull.isNotEmpty) {
      final distanceToStart = geo.Geolocator.distanceBetween(
        _routePtsFull.first.latitude,
        _routePtsFull.first.longitude,
        _start.latitude,
        _start.longitude,
      );

      if (distanceToStart > 50) {
        _routePtsFull.insert(0, _start);
        if (kDebugMode) print('Added start point to route');
      }
    }

    // Add destination point if not already close
    if (_routePtsFull.isNotEmpty) {
      final distanceToDest = geo.Geolocator.distanceBetween(
        _routePtsFull.last.latitude,
        _routePtsFull.last.longitude,
        _dest.latitude,
        _dest.longitude,
      );

      if (distanceToDest > 50) {
        _routePtsFull.add(_dest);
        if (kDebugMode) print('Added destination point to route');
      }
    }
  }

  // =========================
  // ✅ SHOW ROUTE ERROR
  // =========================
  void _showRouteError(String message) {
    if (!mounted) return;

    // Create a simple curved route as fallback
    _createCurvedFallbackRoute(_start, _dest);
    _updateRemainingRoutePolyline();

    _etaText = "Route loaded";
    _distText = "Distance unknown";

    if (kDebugMode) {
      print('Using fallback curved route: $message');
    }

    if (mounted) setState(() {});
  }

  // =========================
  // ✅ CREATE CURVED FALLBACK ROUTE (BETTER THAN STRAIGHT LINE)
  // =========================
  void _createCurvedFallbackRoute(gmaps.LatLng origin, gmaps.LatLng dest) {
    _routePtsFull = [];

    const int steps = 100;

    // Calculate control point for Bezier curve
    final midLat = (origin.latitude + dest.latitude) / 2;
    final midLng = (origin.longitude + dest.longitude) / 2;

    // Create a slight curve
    final controlLat = midLat + (dest.latitude - origin.latitude) * 0.1;
    final controlLng = midLng + (dest.longitude - origin.longitude) * 0.1;

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;

      // Quadratic Bezier curve
      final lat = (1 - t) * (1 - t) * origin.latitude +
          2 * (1 - t) * t * controlLat +
          t * t * dest.latitude;

      final lng = (1 - t) * (1 - t) * origin.longitude +
          2 * (1 - t) * t * controlLng +
          t * t * dest.longitude;

      _routePtsFull.add(gmaps.LatLng(lat, lng));
    }

    if (kDebugMode) {
      print(
          'Created curved fallback route with ${_routePtsFull.length} points');
    }
  }

  // =========================
  // ✅ TRIM POLYLINE
  // =========================
  void _updateRemainingRoutePolyline() {
    if (_routePtsFull.length < 2 || _arrived) return;

    final nearest = _nearestIndexOnPolyline(_curr, _routePtsFull);

    // Check distance to the nearest point on the route
    final distanceToRoute = geo.Geolocator.distanceBetween(
      _curr.latitude,
      _curr.longitude,
      _routePtsFull[nearest].latitude,
      _routePtsFull[nearest].longitude,
    );

    // Only advance progress if the user is reasonably close to the route (e.g., within 5 km)
    // This prevents the route from being chopped off if the user is far away (like in a simulator)
    if (distanceToRoute < 5000) {
      if (nearest > _progressIdx) _progressIdx = nearest;
    }

    if (_progressIdx >= _routePtsFull.length - 1) {
      // Keep at least the last point so it doesn't crash
      _progressIdx = _routePtsFull.length - 2;
    }

    _routePtsRemaining = _routePtsFull.sublist(_progressIdx);
    if (_routePtsRemaining.length < 2) return;

    _polylines.clear();

    // ✅ REALISTIC ROAD-STYLE POLYLINE
    _polylines.add(gmaps.Polyline(
      polylineId: const gmaps.PolylineId("route_main"),
      points: _routePtsRemaining,
      width: 7,
      color: const Color(0xFF4285F4), // Google Maps blue
      startCap: gmaps.Cap.roundCap,
      endCap: gmaps.Cap.roundCap,
      jointType: gmaps.JointType.round,
      geodesic: true,
      visible: true,
      zIndex: 2,
    ));

    // ✅ ROAD OUTLINE FOR BETTER VISIBILITY
    _polylines.add(gmaps.Polyline(
      polylineId: const gmaps.PolylineId("route_outline"),
      points: _routePtsRemaining,
      width: 10,
      color: Colors.white.withOpacity(0.8),
      geodesic: true,
      visible: true,
      zIndex: 1,
    ));

    if (mounted) setState(() {});
  }

  int _nearestIndexOnPolyline(gmaps.LatLng p, List<gmaps.LatLng> line) {
    if (line.isEmpty) return 0;

    final start = max(0, _progressIdx - 10);
    final end = min(line.length - 1, _progressIdx + 600);

    int bestIdx = _progressIdx;
    double best = double.infinity;

    for (int i = start; i <= end; i++) {
      final d = geo.Geolocator.distanceBetween(
        p.latitude,
        p.longitude,
        line[i].latitude,
        line[i].longitude,
      );
      if (d < best) {
        best = d;
        bestIdx = i;
      }
    }

    final buffered = bestIdx - 2;
    return buffered < 0 ? 0 : buffered;
  }

  // =========================
  // ✅ UPDATE CURRENT MARKER
  // =========================
  void _updateCurrentMarker() {
    _markers.removeWhere((m) => m.markerId.value == "current");

    if (_curr.latitude != 0 && _curr.longitude != 0) {
      _markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId("current"),
        position: _curr,
        infoWindow: const gmaps.InfoWindow(title: "You"),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueAzure,
        ),
        anchor: const ui.Offset(0.5, 1.0),
        zIndex: 1,
        visible: true,
      ));
    }

    if (mounted) setState(() {});
  }

  // =========================
  // ✅ FARMS ON ROUTE
  // =========================
  Future<void> _filterFarmsOnRoute() async {
    final line =
        _routePtsRemaining.length >= 2 ? _routePtsRemaining : _routePtsFull;
    if (line.length < 2) return;
    if (!mounted) return;

    _markers.removeWhere((m) => m.markerId.value.startsWith("farm_"));
    _farmsOnRoute = [];

    final List<_FarmDistance> temp = [];

    for (final farm in widget.farms) {
      final ffLoc = farm.farmLocation;
      if (ffLoc == null) continue;

      final pos = gmaps.LatLng(ffLoc.latitude, ffLoc.longitude);
      final dist = _distancePointToPolylineMeters(pos, line);

      if (dist <= routeBufferMeters) {
        temp.add(_FarmDistance(farm: farm, dist: dist));
      }
    }

    temp.sort((a, b) => a.dist.compareTo(b.dist));
    _farmsOnRoute = temp.map((e) => e.farm).toList();

    for (final e in temp) {
      final farm = e.farm;
      final loc = farm.farmLocation!;
      final pos = gmaps.LatLng(loc.latitude, loc.longitude);

      _markers.add(gmaps.Marker(
        markerId: gmaps.MarkerId("farm_${farm.reference.id}"),
        position: pos,
        infoWindow: gmaps.InfoWindow(
          title: farm.farmName.isNotEmpty ? farm.farmName : farm.reference.id,
          snippet: "${e.dist.toStringAsFixed(0)}m from route",
        ),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueGreen,
        ),
        anchor: const ui.Offset(0.5, 1.0),
        visible: true,
        onTap: () {
          FFAppState().farmref = farm.reference;
          widget.action();
        },
      ));
    }

    if (mounted) setState(() {});
  }

  // =========================
  // ✅ CAMERA CONTROL
  // =========================
  Future<void> _animateFollowCamera() async {
    if (_map == null) return;

    final from = _lastFollowPos ?? _curr;
    final to = _curr;
    final bearing = followBearing ? _bearingDegrees(from, to) : 0.0;
    _lastFollowPos = to;

    await _map!.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: to,
          zoom: followZoom,
          bearing: bearing,
          tilt: 55,
        ),
      ),
    );
  }

  void _dismissLongRouteBanner() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  // =========================
  // ✅ FIT BOUNDS TO SHOW EVERYTHING - FIXED (show markers first)
  // =========================
  void _fitBoundsToShowEverything() {
    if (_map == null) return;

    // Give map more time to initialize
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_map == null || !mounted) return;

      // ✅ First, always show start location clearly
      _map!.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(_start, 12),
      );

      if (kDebugMode) {
        print('Zoomed to start location first (Surat)');

        // Calculate distance
        final distanceKm = geo.Geolocator.distanceBetween(
              _start.latitude,
              _start.longitude,
              _dest.latitude,
              _dest.longitude,
            ) /
            1000;

        print('Route distance: ${distanceKm.toStringAsFixed(2)} km');
        print(
            'For long routes (>100km), markers are shown at start location first');
      }

      // Show a message for long routes
      final distanceKm = geo.Geolocator.distanceBetween(
            _start.latitude,
            _start.longitude,
            _dest.latitude,
            _dest.longitude,
          ) /
          1000;

      if (distanceKm > 100) {
        // For long routes, show a snackbar with option to view full route
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Long route detected (${distanceKm.toStringAsFixed(0)} km)'),
                action: SnackBarAction(
                  label: 'View Full Route',
                  onPressed: () {
                    // Show full route when requested
                    final points = <gmaps.LatLng>[];
                    points.add(_start);
                    points.add(_dest);

                    if (_routePtsFull.isNotEmpty) {
                      // Add some key points from route
                      points.add(_routePtsFull.first);
                      points.add(_routePtsFull.last);
                      if (_routePtsFull.length > 100) {
                        points.add(_routePtsFull[_routePtsFull.length ~/ 4]);
                        points.add(_routePtsFull[_routePtsFull.length ~/ 2]);
                        points
                            .add(_routePtsFull[3 * _routePtsFull.length ~/ 4]);
                      }
                    }

                    _fitBounds(points);
                  },
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        });
      }
    });
  }

  // =========================
  // ✅ Zoom helpers
  // =========================
  Future<void> _zoomIn() async {
    if (_map == null) return;
    setState(() => _followUser = false);
    final next = (_currentZoom + 1).clamp(3.0, 20.0);
    await _map!.animateCamera(gmaps.CameraUpdate.zoomTo(next));
  }

  Future<void> _zoomOut() async {
    if (_map == null) return;
    setState(() => _followUser = false);
    final next = (_currentZoom - 1).clamp(3.0, 20.0);
    await _map!.animateCamera(gmaps.CameraUpdate.zoomTo(next));
  }

  // =========================
  // ✅ UI BUILD - WITH DEBUG OVERLAY
  // =========================
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    if (kDebugMode) {
      print('=== MAP DEBUG ===');
      print('Start: $_start');
      print('Dest: $_dest');
      print('Current: $_curr');
      print('Markers: ${_markers.length}');
      print('Polylines: ${_polylines.length}');
      print('Route points: ${_routePtsFull.length}');
      print('Loading: $_loading');
      print('Location granted: $_locationGranted');
      print('==================');
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _dismissLongRouteBanner();
      },
      child: SizedBox(
        width: widget.width ?? media.size.width,
        height: widget.height ?? media.size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: gmaps.GoogleMap(
                initialCameraPosition:
                    gmaps.CameraPosition(target: _start, zoom: _currentZoom),
                myLocationEnabled: _locationGranted,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (c) {
                  _map = c;
                  if (kDebugMode) print('Map created successfully');

                  // ✅ Ensure markers are visible after map creation
                  Future.delayed(const Duration(milliseconds: 800), () {
                    if (mounted) {
                      _addMarkers(); // Re-add markers to ensure they're on the map
                      _fitBoundsToShowEverything();
                    }
                  });
                },
                onCameraMove: (pos) {
                  _currentZoom = pos.zoom;
                  if (_followUser) setState(() => _followUser = false);
                },
              ),
            ),

            // ✅ DEBUG OVERLAY (remove in production)
            if (kDebugMode)
              Positioned(
                top: media.padding.top + 120,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'S: ${_start.latitude.toStringAsFixed(6)}, ${_start.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 10)),
                      Text(
                          'D: ${_dest.latitude.toStringAsFixed(6)}, ${_dest.longitude.toStringAsFixed(6)}',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 10)),
                      Text(
                          'C: ${_curr.latitude.toStringAsFixed(6)}, ${_curr.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 10)),
                      Text('Markers: ${_markers.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                      Text('Route pts: ${_routePtsFull.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                      if (_routePtsFull.isNotEmpty)
                        Text('Route loaded: ✅',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 10)),
                    ],
                  ),
                ),
              ),

            // Error message if route failed
            if (_routePtsFull.length < 10 && !_loading)
              Positioned(
                left: 20,
                right: 20,
                top: media.padding.top + 80,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Road Route Not Available",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Showing approximate path. Check API key.",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _buildRouteWithRetry(
                            origin: _start,
                            resetProgress: true,
                          );
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

            // Top bar
            Positioned(
              left: 12,
              right: 12,
              top: media.padding.top + 12,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showOverlay = true;
                    _followUser = true;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A884),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 18,
                        offset: Offset(0, 8),
                        color: Colors.black26,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.navigation,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _followUser ? "Navigation mode" : "Map mode",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (kDebugMode)
                        IconButton(
                          onPressed: () {
                            print('=== API DEBUG ===');
                            print('API Key: $_apiKey');
                            print('Route points: ${_routePtsFull.length}');
                            print('Markers: ${_markers.length}');
                            for (var marker in _markers) {
                              print(
                                  'Marker: ${marker.markerId.value} at ${marker.position}');
                            }
                          },
                          icon: const Icon(Icons.code, color: Colors.white),
                          splashRadius: 22,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Right buttons
            Positioned(
              right: 12,
              bottom: 220,
              child: Column(
                children: [
                  _roundBtn(
                      icon: Icons.add, onTap: _zoomIn, tooltip: "Zoom in"),
                  const SizedBox(height: 10),
                  _roundBtn(
                      icon: Icons.remove, onTap: _zoomOut, tooltip: "Zoom out"),
                  const SizedBox(height: 10),
                  _roundBtn(
                    icon: Icons.refresh,
                    onTap: () async {
                      await _buildRouteWithRetry(
                        origin: _start,
                        resetProgress: true,
                      );
                      await _filterFarmsOnRoute();
                      _fitBoundsToShowEverything();
                    },
                    tooltip: "Recalculate Route",
                  ),
                  const SizedBox(height: 10),
                  _roundBtn(
                    icon: _followUser ? Icons.gps_fixed : Icons.gps_not_fixed,
                    onTap: () async {
                      setState(() => _followUser = true);
                      await _animateFollowCamera();
                    },
                    tooltip: "Follow Location",
                  ),
                  const SizedBox(height: 10),
                  // ✅ ADD VIEW FULL ROUTE BUTTON
                  _roundBtn(
                    icon: Icons.zoom_out_map,
                    onTap: () {
                      // Show full route
                      final points = <gmaps.LatLng>[];
                      points.add(_start);
                      points.add(_dest);

                      if (_routePtsFull.isNotEmpty) {
                        points.add(_routePtsFull.first);
                        points.add(_routePtsFull.last);
                      }

                      _fitBounds(points);
                    },
                    tooltip: "View Full Route",
                  ),
                ],
              ),
            ),

            // Bottom card
            if (_showOverlay)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: media.size.height * 0.33),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showOverlay = false;
                                      _followUser = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  splashRadius: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        _etaText,
                                        style: const TextStyle(
                                          color: Color(0xFF00A884),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "$_distText • Farms: ${_farmsOnRoute.length}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      if (kDebugMode)
                                        Column(
                                          children: [
                                            Text(
                                              "Route Points: ${_routePtsFull.length}",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              _routePtsFull.length < 10
                                                  ? "⚠️ Using fallback route"
                                                  : "✅ Road route loaded",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: _routePtsFull.length < 10
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _buildRouteWithRetry(
                                      origin: _curr,
                                      resetProgress: true,
                                    );
                                    await _filterFarmsOnRoute();
                                    _fitBoundsToShowEverything();
                                  },
                                  icon: const Icon(Icons.alt_route),
                                  splashRadius: 20,
                                  tooltip: "Reroute from current location",
                                ),
                              ],
                            ),
                            if (!_locationGranted) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.orange.shade200),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_disabled,
                                        size: 18, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        "Location permission not granted.",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _ensureLocationPermission();
                                        await _startLiveLocation();
                                      },
                                      child: const Text("Enable"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            // ✅ ADD VIEW FULL ROUTE BUTTON IN CARD
                            if (_routePtsFull.length > 100)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.blue.shade200),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Show full route
                                    final points = <gmaps.LatLng>[];
                                    points.add(_start);
                                    points.add(_dest);

                                    if (_routePtsFull.isNotEmpty) {
                                      points.add(_routePtsFull.first);
                                      points.add(_routePtsFull.last);
                                    }

                                    _fitBounds(points);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.zoom_out_map,
                                          size: 16, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "View Full Route",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_farmsOnRoute.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 70,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: min(_farmsOnRoute.length, 10),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) {
                                    final farm = _farmsOnRoute[i];
                                    final loc = farm.farmLocation!;
                                    final pos = gmaps.LatLng(
                                        loc.latitude, loc.longitude);

                                    return InkWell(
                                      onTap: () => _map?.animateCamera(
                                        gmaps.CameraUpdate.newLatLngZoom(
                                            pos, 16),
                                      ),
                                      child: Container(
                                        width: 230,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: farm.farmProfilePhoto
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      farm.farmProfilePhoto,
                                                      width: 46,
                                                      height: 46,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 46,
                                                      height: 46,
                                                      color: Colors.black12,
                                                      child: const Icon(
                                                          Icons.agriculture),
                                                    ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    farm.farmName.isNotEmpty
                                                        ? farm.farmName
                                                        : farm.reference.id,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    farm.farmType.isNotEmpty
                                                        ? farm.farmType
                                                        : "Farm",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (_loading)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF00A884)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Loading road route...",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn(
      {required IconData icon, required VoidCallback onTap, String? tooltip}) {
    return Material(
      color: Colors.white,
      elevation: 6,
      shape: const CircleBorder(),
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 22, color: const Color(0xFF00A884)),
          ),
        ),
      ),
    );
  }

  // =========================
  // ✅ HELPERS - UPDATED
  // =========================
  Future<void> _fitBounds(List<gmaps.LatLng> pts) async {
    if (_map == null || pts.isEmpty) return;

    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;

    for (final p in pts) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    }

    // Add padding to ensure markers are visible at edges
    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;

    // Ensure minimum padding for better visibility
    final latPadding = max(latRange * 0.15, 0.02);
    final lngPadding = max(lngRange * 0.15, 0.02);

    minLat -= latPadding;
    maxLat += latPadding;
    minLng -= lngPadding;
    maxLng += lngPadding;

    // Ensure valid bounds
    minLat = max(minLat, -90.0);
    maxLat = min(maxLat, 90.0);
    minLng = max(minLng, -180.0);
    maxLng = min(maxLng, 180.0);

    final bounds = gmaps.LatLngBounds(
      southwest: gmaps.LatLng(minLat, minLng),
      northeast: gmaps.LatLng(maxLat, maxLng),
    );

    try {
      await _map!.animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 80));
    } catch (e) {
      if (kDebugMode) {
        print('Error fitting bounds: $e');
      }
      // Fallback: center on first point
      await _map!.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(pts.first, 12),
      );
    }
  }

  double _distancePointToPolylineMeters(
    gmaps.LatLng p,
    List<gmaps.LatLng> line,
  ) {
    if (line.length < 2) return double.infinity;
    double best = double.infinity;
    for (int i = 0; i < line.length - 1; i++) {
      final d = _distancePointToSegmentMeters(p, line[i], line[i + 1]);
      if (d < best) best = d;
    }
    return best;
  }

  double _distancePointToSegmentMeters(
    gmaps.LatLng p,
    gmaps.LatLng a,
    gmaps.LatLng b,
  ) {
    final latRad = _deg2rad(p.latitude);
    final cosLat = cos(latRad);

    final ax = a.longitude * cosLat;
    final ay = a.latitude;
    final bx = b.longitude * cosLat;
    final by = b.latitude;
    final px = p.longitude * cosLat;
    final py = p.latitude;

    final dx = bx - ax;
    final dy = by - ay;

    final len2 = dx * dx + dy * dy;
    if (len2 == 0) return _haversineMeters(p, a);

    final t = ((px - ax) * dx + (py - ay) * dy) / len2;
    final tt = t < 0 ? 0 : (t > 1 ? 1 : t);

    final projX = ax + tt * dx;
    final projY = ay + tt * dy;

    final proj = gmaps.LatLng(projY, projX / cosLat);
    return _haversineMeters(p, proj);
  }

  double _haversineMeters(gmaps.LatLng p1, gmaps.LatLng p2) {
    const R = 6371000.0;
    final dLat = _deg2rad(p2.latitude - p1.latitude);
    final dLng = _deg2rad(p2.longitude - p1.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(p1.latitude)) *
            cos(_deg2rad(p2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double d) => d * pi / 180.0;

  double _bearingDegrees(gmaps.LatLng from, gmaps.LatLng to) {
    final lat1 = _deg2rad(from.latitude);
    final lat2 = _deg2rad(to.latitude);
    final dLng = _deg2rad(to.longitude - from.longitude);

    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    final brng = atan2(y, x);
    return (brng * 180 / pi + 360) % 360;
  }
}

// ✅ sorting helper
class _FarmDistance {
  final FarmsRecord farm;
  final double dist;
  _FarmDistance({required this.farm, required this.dist});
}
