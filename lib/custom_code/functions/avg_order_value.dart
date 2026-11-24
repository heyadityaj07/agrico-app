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

double avgOrderValue(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  double totalRevenue = 0.0;
  int count = 0;

  for (final o in list) {
    // ✅ replace with your order total field
    final amt = (o.totalAmmount ?? 0).toDouble();

    // if you want to ignore 0 amount orders, keep this check
    if (amt <= 0) continue;

    totalRevenue += amt;
    count++;
  }

  if (count == 0) return 0.0;

  final aov = totalRevenue / count;
  return double.parse(aov.toStringAsFixed(2)); // 2 decimals
}
