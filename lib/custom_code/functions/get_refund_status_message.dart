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

String getRefundStatusMessage(
  String? status,
  double? amount,
  String? languageCode,
) {
  final isFrench = (languageCode ?? '').toLowerCase() == 'fr';
  final refundAmt = (amount ?? 0.0).toStringAsFixed(2);
  final s = status?.trim() ?? '';

  if (s == 'refunded' || s == 'alreadyRefunded') {
    return isFrench
        ? 'Remboursement de €$refundAmt effectué sur votre moyen de paiement d’origine.'
        : 'Refund of €$refundAmt completed to your original payment method.';
  } else if (s == 'requested' || s == 'processing') {
    return isFrench
        ? 'Remboursement de €$refundAmt en cours de traitement vers votre moyen de paiement d’origine.'
        : 'Refund of €$refundAmt is processing to your original payment method.';
  } else if (s == 'failed') {
    return isFrench
        ? 'Le remboursement de €$refundAmt a rencontré un problème. Le producteur va réessayer.'
        : 'Refund of €$refundAmt encountered an issue. The producer will retry.';
  } else {
    return isFrench
        ? 'Remboursement de €$refundAmt dû suite à la pesée finale.'
        : 'Refund of €$refundAmt due based on final verified weight.';
  }
}
