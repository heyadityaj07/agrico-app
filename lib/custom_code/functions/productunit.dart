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

List<String> productunit(String category) {
  Map<String, List<String>> categoryUnits = {
    'Fruits': [
      'kg',
      'g',
      'lbs',
      'oz',
      'Each',
      'Bunch',
      'Liters(L)',
      'mL',
    ],
    'Vegetables': [
      'kg',
      'g',
      'lbs',
      'oz',
      'Each',
      'Bunch',
      'Bag',
      'Meters(m)',
    ],
    'Meat': [
      'kg',
      'Grams (g)',
      'Pounds (lbs)',
      'Ounces (oz)',
      'Each',
      'Pack',
    ],
    'Milk': [
      'Liters(L)',
      'mL',
      'kg', // for powdered milk
      'Carton',
      'Bottle',
    ],
    'Grains': [
      'kg',
      'Grams(g)',
      'Pounds(lbs)',
      'Cups',
      'Bag',
      'Box',
    ],
  };

  // Return the corresponding unit list based on the category
  return categoryUnits[category] ?? [];
}
