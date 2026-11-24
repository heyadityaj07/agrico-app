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

String flavourPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Flavour Plan';
  // }

  // if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
  //   return 'Current Plan';
  // }

  // return 'Upgrade to Flavour';
  String t(String en, String fr) {
    switch (lancode) {
      case 'fr':
        return fr;
      case 'en':
      default:
        return en;
    }
  }

  if (isActive != true) {
    return t('Upgrade to Flavour', 'Passer au forfait Flavour supérieur');
  }

  if ((isYearly && plan == 'flavour_plan_yearly') ||
      (!isYearly && plan == 'flavour_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  return t('Upgrade to Flavour', 'Passer au forfait Flavour supérieur');
}
