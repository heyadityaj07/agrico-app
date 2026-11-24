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

double? newCustomFunction2(
  double? totalamount,
  double platformfee,
) {
  // create the total amount + 5 % platform add and reurn double value  totalamount arguement
  if (totalamount == null) return null; // Check for null input
  double platformFee1 = totalamount * platformfee; // Calculate 5% platform fee
  double totalWithFee = totalamount + platformFee1; // Add fee to total amount
  return totalWithFee; // Return formatted string
}
