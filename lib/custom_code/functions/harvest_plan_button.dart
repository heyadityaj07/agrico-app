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

String harvestPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Harvest Plan';
  // }

  // if (plan == 'harvest_plan' || plan == 'harvest_plan_yearly') {
  //   return 'Current Plan';
  // }

  // if (plan == 'root_plan' || plan == 'root_plan_yearly') {
  //   return 'Upgrade to Harvest';
  // }

  // if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
  //   return 'Downgrade to Harvest';
  // }

  // return 'Upgrade to Harvest';
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
    return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
  }

  if ((isYearly && plan == 'harvest_plan_yearly') ||
      (!isYearly && plan == 'harvest_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  if (plan == 'root_plan' || plan == 'root_plan_yearly') {
    return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
  }

  if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
    return t('Downgrade to Harvest', 'Passer au forfait Harvest');
  }

  return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
}
