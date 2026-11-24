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

String greeting(String languageCode) {
  final hour = DateTime.now().hour;
  String timeOfDay;

  if (hour < 12) {
    timeOfDay = 'Good morning';
  } else if (hour < 18) {
    timeOfDay = 'Good afternoon';
  } else {
    timeOfDay = 'Good evening';
  }

  // Map translations based on language code
  switch (languageCode) {
    case 'es': // Spanish
      if (timeOfDay == 'Good morning') return '¡Buen día!';
      if (timeOfDay == 'Good afternoon') return '¡Buenas tardes!';
      return '¡Buenas noches!';
    case 'fr': // French
      if (timeOfDay == 'Good morning') return 'Bonjour';
      if (timeOfDay == 'Good afternoon') return 'Bon après-midi';
      return 'Bonne soirée';
    default: // Default to English
      if (timeOfDay == 'Good morning') return 'Good Morning';
      if (timeOfDay == 'Good afternoon') return 'Good Afternoon';
      return 'Good Evening';
  }
}
