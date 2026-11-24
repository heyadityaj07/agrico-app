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

List<String> productbadges(String category) {
  final Map<String, List<String>> categoryBadges = {
    'Fruits': [
      'Organic',
      'Pesticide-Free',
      'Local Harvest',
      'Naturally Ripened',
      'Seasonal',
      'Farm Fresh',
    ],
    'Vegetables': [
      'Organic',
      'Pesticide-Free',
      'Local Harvest',
      'Seasonal',
      'Farm Fresh',
    ],
    'Meat': [
      'Organic',
      'Antibiotic-Free',
      'Hormone-Free',
      'Free-Range',
      'Grass-Fed',
      'Local Harvest',
      'Farm Fresh',
    ],
    'Milk': [
      'Organic',
      'Hormone-Free',
      'Grass-Fed',
      'Local Harvest',
      'Farm Fresh',
    ],
    'Grains': [
      'Organic',
      'Pesticide-Free',
      'Non-GMO',
      'Local Harvest',
      'Seasonal',
    ],
  };

  return categoryBadges[category] ??
      [
        'Organic',
        'Pesticide-Free',
        'Local Harvest',
        'Seasonal',
        'Farm Fresh',
      ];
}
