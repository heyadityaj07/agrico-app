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

double totalsales(List<CartRecord>? cart) {
  // if (totalammount == null) return 0.0; // Return 0 if the list is null
  // return totalammount
  //     .where((amount) => amount != null)
  //     .fold(0.0, (sum, amount) => sum + amount);
  if (cart == null || cart.isEmpty) return 0.0;

  return cart.fold(0.0, (sum, item) {
    final quantity = item.quantity ?? 0;
    final itemAmount = item.isVariableWeight
        ? (item.depositAmount ?? 0) * quantity
        : (item.pricePerProduct ?? 0) * quantity;
    return sum + itemAmount;
  });
}
