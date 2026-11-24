import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/auth/firebase_auth/auth_util.dart';

List<ProductRecord>? nearProductsfunction(
  List<ProductRecord>? products,
  LatLng? currentlocation,
) {
  if (products == null || products.isEmpty) return [];
  if (currentlocation == null) return [];

  double deg2rad(double deg) => deg * (math.pi / 180.0);

  double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = deg2rad(lat2 - lat1);
    final dLng = deg2rad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  final out = <ProductRecord>[];

  for (final p in products) {
    final farmLoc = p.farmLocation;
    if (farmLoc == null) continue;

    final km = distanceKm(
      currentlocation.latitude,
      currentlocation.longitude,
      farmLoc.latitude,
      farmLoc.longitude,
    );

    if (km <= 2.0) out.add(p);
  }

  return out;
}
