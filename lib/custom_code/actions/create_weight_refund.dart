// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const String _kCreateWeightRefundUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net/createWeightRefund';

/// P2-08 producer refund initiation/retry.
///
/// The backend derives the amount from the persisted `refund_due_amount`,
/// owns the Stripe idempotency/attempt lifecycle and finalizes the outcome
/// from the refund webhook. This action never writes Firestore and never
/// claims success from an unverified response.
///
/// Outcomes:
///   `requested`       — a Stripe refund was created and is processing;
///   `alreadyRefunded` — the order is already refunded;
///   `processing`      — a refund is already in progress (safe retry);
///   `failed`          — a definitive request failure; the case remains open;
///   `''`             — network/ambiguous response; reopen the order to verify.
Future<String> createWeightRefund(
  BuildContext context,
  String orderIdOrPath,
) async {
  final orderId = _documentId(orderIdOrPath);
  if (orderId.isEmpty) return '';

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      await _showRefundMessage(context, 'auth_required');
      return '';
    }

    final response = await http
        .post(
          Uri.parse(_kCreateWeightRefundUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'orderId': orderId}),
        )
        .timeout(const Duration(seconds: 30));

    final body = _decodeJson(response.body);

    if (response.statusCode == 200 && body is Map) {
      if (body['alreadyRefunded'] == true) {
        await _showRefundMessage(context, 'alreadyRefunded');
        return 'alreadyRefunded';
      }
      final refundId = body['refundId'];
      if (body['refundRequested'] == true &&
          refundId is String &&
          refundId.trim().isNotEmpty) {
        await _showRefundMessage(context, 'requested');
        return 'requested';
      }
      await _showRefundMessage(context, 'ambiguous');
      return '';
    }

    final code = body is Map ? body['code']?.toString() : null;
    if (response.statusCode == 409 && code == 'refund_processing') {
      await _showRefundMessage(context, 'processing');
      return 'processing';
    }
    if (response.statusCode == 502 && code == 'refund_failed') {
      await _showRefundMessage(context, 'failed');
      return 'failed';
    }
    if (response.statusCode >= 400 && response.statusCode < 500) {
      await _showRefundMessage(
        context,
        'failed',
        serverError: body is Map ? body['error']?.toString() : null,
      );
      return 'failed';
    }

    await _showRefundMessage(context, 'ambiguous');
    return '';
  } on TimeoutException {
    await _showRefundMessage(context, 'ambiguous');
    return '';
  } on SocketException {
    await _showRefundMessage(context, 'ambiguous');
    return '';
  } on http.ClientException {
    await _showRefundMessage(context, 'ambiguous');
    return '';
  } catch (_) {
    await _showRefundMessage(context, 'ambiguous');
    return '';
  }
}

String _documentId(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return '';
  final segments = trimmed.split('/');
  return segments.isEmpty ? '' : segments.last.trim();
}

dynamic _decodeJson(String body) {
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}

Future<void> _showRefundMessage(
  BuildContext context,
  String outcome, {
  String? serverError,
}) async {
  final isFrench = FFLocalizations.of(context).languageCode == 'fr';
  String message;
  Color? toastColor;
  switch (outcome) {
    case 'requested':
      message = isFrench
          ? 'Le remboursement a été lancé et sera traité sur le moyen de paiement d’origine.'
          : 'The refund was submitted and will be returned to the original payment method.';
      toastColor = FlutterFlowTheme.of(context).primarytheme;
      break;
    case 'alreadyRefunded':
      message = isFrench
          ? 'Cette commande a déjà été remboursée.'
          : 'This order has already been refunded.';
      toastColor = FlutterFlowTheme.of(context).primarytheme;
      break;
    case 'processing':
      message = isFrench
          ? 'Un remboursement est déjà en cours. Aucun second remboursement ne sera créé.'
          : 'A refund is already in progress. No second refund will be created.';
      toastColor = FlutterFlowTheme.of(context).primarytheme;
      break;
    case 'failed':
      final fallback = serverError?.trim() ?? '';
      message = fallback.isNotEmpty
          ? fallback
          : (isFrench
              ? 'Le remboursement n’a pas pu être lancé. Le dossier reste ouvert et peut être réessayé.'
              : 'The refund could not be started. The case remains open and can be retried.');
      break;
    case 'auth_required':
      message = isFrench
          ? 'Votre session a expiré. Veuillez vous reconnecter.'
          : 'Your session has expired. Please sign in again.';
      break;
    default:
      message = isFrench
          ? 'Le résultat du remboursement n’a pas pu être confirmé. Rouvrez la commande pour vérifier son statut avant de réessayer.'
          : 'The refund outcome could not be confirmed. Reopen the order to verify its status before trying again.';
  }

  await toast(context, message, toastColor);
}
