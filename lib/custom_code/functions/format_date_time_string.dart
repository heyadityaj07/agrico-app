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

String formatDateTimeString(String input) {
  try {
    final secondsMatch = RegExp(r'seconds=(\d+)').firstMatch(input);
    final nanosecondsMatch = RegExp(r'nanoseconds=(\d+)').firstMatch(input);

    if (secondsMatch == null || nanosecondsMatch == null) {
      return 'Invalid timestamp format';
    }

    final seconds = int.parse(secondsMatch.group(1)!);
    final nanoseconds = int.parse(nanosecondsMatch.group(1)!);

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + (nanoseconds ~/ 1000000),
    );

    // Format: "10 May 2025, 17:41"
    return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
  } catch (e) {
    return 'Error formatting timestamp';
  }
}
