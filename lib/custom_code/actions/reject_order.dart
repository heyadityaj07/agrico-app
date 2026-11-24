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

import 'index.dart' as actions; // Imports other custom actions

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const String _kFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kRejectOrderPath = 'rejectOrder';

enum RejectOrderOutcome {
  rejected,
  alreadyRejected,
  processing,
  ineligible,
  forbidden,
  authRequired,
  notFound,
  failed,
  ambiguous,
}

bool isRejectOrderSuccess(String outcome) =>
    outcome == 'rejected' || outcome == 'alreadyRejected';

RejectOrderOutcome classifyRejectOrderResponse(int statusCode, dynamic body) {
  final map = body is Map ? body : null;
  final code = map == null ? '' : (map['code']?.toString().trim() ?? '');

  if (statusCode == 200) {
    if (map == null ||
        map['success'] != true ||
        (map['orderId']?.toString().trim() ?? '').isEmpty) {
      return RejectOrderOutcome.ambiguous;
    }
    return map['alreadyRejected'] == true
        ? RejectOrderOutcome.alreadyRejected
        : RejectOrderOutcome.rejected;
  }

  if (statusCode == 401 ||
      code == 'auth_required' ||
      code == 'auth_invalid' ||
      code == 'auth_unavailable') {
    return RejectOrderOutcome.authRequired;
  }
  if (statusCode == 403 ||
      code == 'order_forbidden' ||
      code == 'producer_unavailable') {
    return RejectOrderOutcome.forbidden;
  }
  if (statusCode == 404) {
    if (code == 'order_not_found' || code == 'farm_not_found') {
      return RejectOrderOutcome.notFound;
    }
    return map == null
        ? RejectOrderOutcome.ambiguous
        : RejectOrderOutcome.failed;
  }
  if (statusCode == 409) {
    if (map == null) return RejectOrderOutcome.ambiguous;
    return code == 'rejection_payment_processing'
        ? RejectOrderOutcome.processing
        : RejectOrderOutcome.ineligible;
  }
  if (statusCode >= 400 && statusCode < 500) {
    return RejectOrderOutcome.failed;
  }
  return RejectOrderOutcome.ambiguous;
}

String? rejectOrderErrorMessage(
  RejectOrderOutcome outcome, {
  required bool french,
  String? serverError,
}) {
  switch (outcome) {
    case RejectOrderOutcome.rejected:
    case RejectOrderOutcome.alreadyRejected:
      return null;
    case RejectOrderOutcome.processing:
      return french
          ? 'Un paiement ou un virement producteur est encore en cours pour cette commande. Réessayez dans un instant.'
          : 'A payment or producer transfer is still being processed for this order. Please retry shortly.';
    case RejectOrderOutcome.ineligible:
      return serverError ??
          (french
              ? 'Cette commande ne peut plus être refusée car elle a déjà été approuvée, préparée ou fermée.'
              : 'This order can no longer be rejected because it has already been approved, prepared or closed.');
    case RejectOrderOutcome.forbidden:
      return french
          ? 'Seul le propriétaire de la ferme peut refuser cette commande.'
          : 'Only the farm owner can reject this order.';
    case RejectOrderOutcome.authRequired:
      return french
          ? 'Votre session a expiré. Veuillez vous reconnecter.'
          : 'Your session has expired. Please sign in again.';
    case RejectOrderOutcome.notFound:
      return french ? 'Commande introuvable.' : 'Order not found.';
    case RejectOrderOutcome.failed:
      return serverError ??
          (french
              ? 'La commande n’a pas pu être refusée. Aucune modification n’a été apportée ; veuillez réessayer.'
              : 'The order could not be rejected. No changes were made; please retry.');
    case RejectOrderOutcome.ambiguous:
      return french
          ? 'Le résultat du refus n’a pas pu être confirmé. Rouvrez la commande pour vérifier son statut avant de réessayer.'
          : 'The rejection outcome could not be confirmed. Reopen the order to check its status before trying again.';
  }
}

/// Producer rejection custom action.
/// Sends orderId to the secure rejectOrder Cloud Function.
/// The backend handles status change, Stripe refund, inventory restoration,
/// and customer notification server-side.
Future<String> rejectOrder(
  BuildContext context,
  String orderIdOrPath,
) async {
  final orderId = _documentId(orderIdOrPath);
  if (orderId.isEmpty) {
    if (context.mounted) {
      await actions.toast(
        context,
        FFLocalizations.of(context).getVariableText(
          enText: 'Order not found.',
          frText: 'Commande introuvable.',
        ),
        FlutterFlowTheme.of(context).error,
      );
    }
    return 'notFound';
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      final outcome = RejectOrderOutcome.authRequired;
      if (context.mounted) {
        await _showOutcome(context, outcome);
      }
      return 'authRequired';
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
    if (context.mounted) {
      await _showOutcome(context, outcome, body);
    }
    return outcome.name;
  } on TimeoutException {
    const outcome = RejectOrderOutcome.ambiguous;
    if (context.mounted) {
      await _showOutcome(context, outcome);
    }
    return 'ambiguous';
  } on SocketException {
    const outcome = RejectOrderOutcome.ambiguous;
    if (context.mounted) {
      await _showOutcome(context, outcome);
    }
    return 'ambiguous';
  } on http.ClientException {
    const outcome = RejectOrderOutcome.ambiguous;
    if (context.mounted) {
      await _showOutcome(context, outcome);
    }
    return 'ambiguous';
  } catch (_) {
    const outcome = RejectOrderOutcome.ambiguous;
    if (context.mounted) {
      await _showOutcome(context, outcome);
    }
    return 'ambiguous';
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
  await actions.toast(
    context,
    message,
    FlutterFlowTheme.of(context).error,
  );
}
