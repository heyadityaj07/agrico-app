// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '/backend/orders/order_rejection_status.dart';
import 'toast.dart';

const String _kFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kRejectOrderPath = 'rejectOrder';

/// Phase 2: trusted producer rejection.
///
/// Sends only the order ID. The backend verifies the Firebase ID token,
/// resolves the order/farm producer, enforces the pre-approval eligibility
/// boundary, cancels/refunds through the existing Stripe infrastructure,
/// restores inventory when evidence exists and attempts customer notification.
///
/// This action never writes Firestore and never fabricates rejection, refund
/// or inventory fields. On a successful outcome the caller must close the
/// confirmation dialog; the order screen's Firestore stream reloads the
/// trusted server state.
Future<RejectOrderOutcome> rejectOrder(
  BuildContext context,
  String orderIdOrPath,
) async {
  final orderId = _documentId(orderIdOrPath);
  if (orderId.isEmpty) {
    await toast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Order not found.',
        frText: 'Commande introuvable.',
      ),
    );
    return RejectOrderOutcome.notFound;
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      final outcome = RejectOrderOutcome.authRequired;
      await _showOutcome(context, outcome);
      return outcome;
    }

    final response = await http
        .post(
          Uri.parse('$_kFunctionBaseUrl/$_kRejectOrderPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'orderId': orderId}),
        )
        .timeout(const Duration(seconds: 30));

    final body = _decodeJson(response.body);
    final outcome = classifyRejectOrderResponse(response.statusCode, body);
    await _showOutcome(context, outcome, body);
    return outcome;
  } on TimeoutException {
    const outcome = RejectOrderOutcome.ambiguous;
    await _showOutcome(context, outcome);
    return outcome;
  } on SocketException {
    const outcome = RejectOrderOutcome.ambiguous;
    await _showOutcome(context, outcome);
    return outcome;
  } on http.ClientException {
    const outcome = RejectOrderOutcome.ambiguous;
    await _showOutcome(context, outcome);
    return outcome;
  } catch (_) {
    const outcome = RejectOrderOutcome.ambiguous;
    await _showOutcome(context, outcome);
    return outcome;
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

Future<void> _showOutcome(
  BuildContext context,
  RejectOrderOutcome outcome, [
  dynamic body,
]) async {
  final french = FFLocalizations.of(context).languageCode == 'fr';
  final serverError = body is Map ? body['error']?.toString() : null;
  final message = rejectOrderErrorMessage(
    outcome,
    french: french,
    serverError: serverError,
  );
  if (message == null) return;
  await toast(context, message);
}
