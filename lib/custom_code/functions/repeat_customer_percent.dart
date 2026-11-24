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

double repeatCustomerPercent(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  // ✅ change this getter according to your OrderRecord field
  DocumentReference? getUserRef(OrderRecord o) => o.userRef; // or o.buyerRef

  final Map<String, int> counts = {};

  for (final o in list) {
    final ref = getUserRef(o);
    if (ref == null) continue;
    counts[ref.path] = (counts[ref.path] ?? 0) + 1;
  }

  if (counts.isEmpty) return 0.0;

  final totalUniqueCustomers = counts.length;
  final repeatCustomers = counts.values.where((c) => c >= 2).length;

  final pct = (repeatCustomers / totalUniqueCustomers) * 100;
  return double.parse(pct.toStringAsFixed(0));
}
