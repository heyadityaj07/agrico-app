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

bool checkavaliblity(List<FarmAvailabilityStruct> avaiblity) {
  if (avaiblity.isEmpty) {
    return false;
  }
  int timeInMinutes(DateTime time) {
    return (time.hour * 60) + time.minute;
  }

  bool hasAtLeastOneAvailable = false;

  for (var dayEntry in avaiblity) {
    if (dayEntry.isAvavible == true) {
      if (dayEntry.startTime == null || dayEntry.endtime == null) {
        return false;
      }

      if (dayEntry.isBreak == true) {
        final DateTime? breakStart = dayEntry.breakStart;
        final DateTime? breakEnd = dayEntry.breakEnd;

        if (breakStart == null || breakEnd == null) {
          return false;
        }

        final int breakStartMinutes = timeInMinutes(breakStart);
        final int breakEndMinutes = timeInMinutes(breakEnd);
        final int startMinutes = timeInMinutes(dayEntry.startTime!);
        final int endMinutes = timeInMinutes(dayEntry.endtime!);

        if (breakEndMinutes <= breakStartMinutes) {
          return false;
        }

        if (breakStartMinutes < startMinutes) {
          return false;
        }

        if (breakEndMinutes > endMinutes) {
          return false;
        }
      }

      hasAtLeastOneAvailable = true;
    }
  }

  return hasAtLeastOneAvailable;
}
