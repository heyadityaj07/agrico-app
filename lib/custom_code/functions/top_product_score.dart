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

double topProductScore(
  int sold,
  int maxSold,
  int stockQuantity,
  int maxStockQuantity,
  int discount,
  DateTime? createdAt,
) {
  final soldScore = maxSold > 0 ? sold / maxSold : 0.0;
  final stockScore =
      maxStockQuantity > 0 ? stockQuantity / maxStockQuantity : 0.0;
  final discountScore = discount.clamp(0, 100) / 100.0;

  double freshnessScore = 0.0;
  if (createdAt != null) {
    final ageDays = DateTime.now().difference(createdAt).inDays;
    freshnessScore = ((30 - ageDays).clamp(0, 30)) / 30.0;
  }

  final score = (soldScore * 0.45) +
      (stockScore * 0.15) +
      (discountScore * 0.10) +
      (freshnessScore * 0.10);

  return double.parse((score * 100).toStringAsFixed(2));
}
