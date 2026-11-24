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

String checkavaliblitymsg(List<FarmAvailabilityStruct> avaiblity) {
  // 1. Check if the list itself is empty
  if (avaiblity.isEmpty) {
    return "Please select at least one day of availability.";
  }
  int timeInMinutes(DateTime time) {
    return (time.hour * 60) + time.minute;
  }

  bool hasAtLeastOneAvailable = false;

  for (var dayEntry in avaiblity) {
    // Check the toggle status
    if (dayEntry.isAvavible == true) {
      // 2. If toggled ON, check if either time is missing
      if (dayEntry.startTime == null || dayEntry.endtime == null) {
        // Returns a specific error mentioning the day (e.g., "Set time for Monday")
        return "Please set start and end times for ${dayEntry.day}.";
      }
      if (dayEntry.isBreak == true) {
        final DateTime? breakStart = dayEntry.breakStart;
        final DateTime? breakEnd = dayEntry.breakEnd;

        if (breakStart == null || breakEnd == null) {
          return "Please set break start and end times for  ${dayEntry.day}.";
        }

        final int breakStartMinutes = timeInMinutes(breakStart);
        final int breakEndMinutes = timeInMinutes(breakEnd);
        final int startMinutes = timeInMinutes(dayEntry.startTime!);
        final int endMinutes = timeInMinutes(dayEntry.endtime!);

        if (breakEndMinutes <= breakStartMinutes) {
          return "Break end time must be after break start time for ${dayEntry.day}.";
        }

        if (breakStartMinutes < startMinutes) {
          return "Break start time must be within working hours for ${dayEntry.day}.";
        }

        if (breakEndMinutes > endMinutes) {
          return "Break end time must be within working hours for ${dayEntry.day}.";
        }
      }
      hasAtLeastOneAvailable = true;
    }
  }

  // 3. Final check: If no days were toggled ON at all
  if (!hasAtLeastOneAvailable) {
    return "Please select at least one day to be available.";
  }

  // 4. Everything is correct, return an empty string
  return "";
}
