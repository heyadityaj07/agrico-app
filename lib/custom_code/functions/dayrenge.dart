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

String dayrenge(List<String>? days) {
  if (days == null || days.isEmpty) return "";

  const order = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  String fmt(String d) => d[0] + d.substring(1).toLowerCase();

  final set = days.map((e) => e.trim().toUpperCase()).toSet();

  final pickedIdx = <int>[];
  for (int i = 0; i < order.length; i++) {
    if (set.contains(order[i])) pickedIdx.add(i);
  }
  if (pickedIdx.isEmpty) return "";

  final ranges = <String>[];
  final notAvailable = <String>[];

  int start = pickedIdx[0];
  int prev = pickedIdx[0];

  void closeRange(int s, int e) {
    ranges.add(s == e ? fmt(order[s]) : "${fmt(order[s])}-${fmt(order[e])}");
  }

  for (int k = 1; k < pickedIdx.length; k++) {
    final cur = pickedIdx[k];

    if (cur == prev + 1) {
      prev = cur;
      continue;
    }

    // gap => missing days
    for (int miss = prev + 1; miss < cur; miss++) {
      notAvailable.add(fmt(order[miss]));
    }

    closeRange(start, prev);
    start = cur;
    prev = cur;
  }
  closeRange(start, prev);

  final rangeText = ranges.join(", ");
  if (notAvailable.isEmpty) return rangeText;

  return "$rangeText (Not Available: ${notAvailable.join(", ")})";
}
