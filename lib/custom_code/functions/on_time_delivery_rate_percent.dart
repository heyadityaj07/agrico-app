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

double onTimeDeliveryRatePercent(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  int deliveredCount = 0;
  int onTimeCount = 0;

  int promisedDays(String? deliveryTime) {
    final v = (deliveryTime ?? '').trim().toLowerCase();
    if (v == 'tomorrow') return 1;
    if (v == 'day after tomorrow' || v == 'day after tommorow') return 2;
    return 0;
  }

  DateTime endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  for (final o in list) {
    final DateTime? createdAt = o.createdAt;
    final String? deliveryTime = o.delievryTime;

    final DateTime? deliveredAt = o.deliveredTime;

    if (createdAt == null || deliveredAt == null) continue;

    deliveredCount++;

    final days = promisedDays(deliveryTime);

    final createdDateOnly =
        DateTime(createdAt.year, createdAt.month, createdAt.day);
    final promisedDate = createdDateOnly.add(Duration(days: days));
    final deadline = endOfDay(promisedDate);

    if (!deliveredAt.isAfter(deadline)) {
      onTimeCount++;
    }
  }

  if (deliveredCount == 0) return 0.0;

  final pct = (onTimeCount / deliveredCount) * 100;
  return double.parse(pct.toStringAsFixed(0));
}
