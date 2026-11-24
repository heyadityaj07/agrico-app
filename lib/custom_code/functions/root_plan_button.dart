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

String rootPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Root Plan';
  // }

  // if (plan == 'root_plan' || plan == 'root_plan_yearly') {
  //   return 'Current Plan';
  // }

  // if (plan == 'harvest_plan' ||
  //     plan == 'harvest_plan_yearly' ||
  //     plan == 'flavour_plan' ||
  //     plan == 'flavour_plan_yearly') {
  //   return 'Downgrade to Root';
  // }

  // return 'Upgrade to Root';
  //
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
    return t('Upgrade to Root', 'Passer au forfait Racine');
  }

  if ((isYearly && plan == 'root_plan_yearly') ||
      (!isYearly && plan == 'root_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  if (plan == 'harvest_plan' ||
      plan == 'harvest_plan_yearly' ||
      plan == 'flavour_plan' ||
      plan == 'flavour_plan_yearly') {
    return t('Downgrade to Root', 'Passer au forfait Racine');
  }

  return t('Upgrade to Root', 'Passer au forfait Racine');
}
