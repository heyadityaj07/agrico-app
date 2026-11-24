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

List<DeliveryAdressStruct> deliveryaddresssorting(
  List<DeliveryAdressStruct>? delievryaddress,
  int? defultindex,
) {
  if (delievryaddress == null || delievryaddress.isEmpty) return [];

  final list = List<DeliveryAdressStruct>.from(delievryaddress);

  final idx = defultindex;
  if (idx == null || idx < 0 || idx >= list.length) return list;

  final defaultItem = list.removeAt(idx);
  list.insert(0, defaultItem);

  print("defaultIndex = $idx");
  print("sorted labels = ${list.map((e) => e.label).toList()}");

  return list;
}
