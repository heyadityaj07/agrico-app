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
  final List<String> commonBadges = [
    'Organic',
    'Conventional',
    'Integrated Farming',
    'Regenerative Agriculture',
    'Agroecology',
    'Biodynamic',
    'Traditional Production',
    'Artisanal Production',
    'Non-GMO',
  ];

  final List<String> plantBadges = [
    'Permaculture',
    'Pesticide-Free',
    'No Synthetic Pesticides',
    'No Herbicides',
    'Open Field',
    'Greenhouse Grown',
  ];

  final List<String> animalBadges = [
    'Antibiotic-Free',
    'Raised Without Vaccination',
    'Hormone-Free',
    'Free-Range',
    'Grass-Fed',
    'Pasture-Raised',
  ];

  final Map<String, List<String>> categoryBadges = {
    'Fruits': [
      ...plantBadges,
      'Naturally Ripened',
    ],
    'Vegetables': plantBadges,
    'Grains': plantBadges,
    'Meat': animalBadges,
    'Milk': animalBadges,
    'Eggs': [
      'Free-Range',
      'Antibiotic-Free',
      'Raised Without Vaccination',
    ],
    'Honey': [
      'Raw Honey',
      'Unheated Honey',
    ],
    'Grocery': [
      'Farm Processed',
      'No Added Preservatives',
      'No Added Colors',
      'No Added Sugar',
    ],
  };

  return [
    ...commonBadges,
    ...?categoryBadges[category],
  ].toSet().toList();
}
