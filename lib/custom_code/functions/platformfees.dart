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

double? platformfees(
  double? totalamount,
  double platformfee,
  double platformfeecap,
) {
  if (totalamount == null) return null;
  if (!totalamount.isFinite || totalamount < 0) return 0.0;

  const double defaultPlatformFeeRate = 0.0099;
  const double defaultPlatformFeeCap = 3.0;

  // Resolve platform fee rate (default: 0.0099 if not finite, < 0, or > 1)
  final double rate =
      (!platformfee.isFinite || platformfee < 0 || platformfee > 1)
          ? defaultPlatformFeeRate
          : platformfee;

  // Resolve platform fee cap (default: 3.0 if not finite or < 0)
  final double cap = (!platformfeecap.isFinite || platformfeecap < 0)
      ? defaultPlatformFeeCap
      : platformfeecap;

  final double rawFee = totalamount * rate;
  final double cappedFee = rawFee > cap ? cap : rawFee;

  return (cappedFee * 100).round() / 100;
}
