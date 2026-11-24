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

List<dynamic> convertCartItemsToOrderItems(List<CartRecord> cart) {
  Map<DocumentReference, double> farmAmountMap = {};

  for (var item in cart) {
    if (item.farmRef == null) continue;

    final double itemTotal = (item.quantity ?? 0) * (item.pricePerProduct ?? 0);

    if (farmAmountMap.containsKey(item.farmRef)) {
      farmAmountMap[item.farmRef!] = farmAmountMap[item.farmRef!]! + itemTotal;
    } else {
      farmAmountMap[item.farmRef!] = itemTotal;
    }
  }

  /// Convert to JSON list
  List<dynamic> result = [];

  farmAmountMap.forEach((farmRef, amount) {
    result.add({
      "id": farmRef.id,
      "amount": double.parse(amount.toStringAsFixed(2)),
    });
  });

  return result;
}
