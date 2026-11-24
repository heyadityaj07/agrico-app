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

const String _kFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kUpdateOrderFulfilmentStatusPath = 'updateOrderFulfilmentStatus';

const Set<String> _kDispatchStatuses = {
  'Picked Up',
  'In Transit',
  'Delivered',
};

const String dispatchOutcomeChanged = 'changed';
const String dispatchOutcomeAlreadyAtStatus = 'alreadyAtStatus';

/// Validates the trusted `updateOrderFulfilmentStatus` HTTP 200 envelope.
String? classifyDispatchSuccessResponse(
  dynamic decodedBody, {
  required String orderId,
  required String expectedStatus,
}) {
  if (decodedBody is! Map) return null;
  if (decodedBody['success'] != true) return null;
  if (decodedBody['orderId'] != orderId) return null;
  if (decodedBody['orderStatus'] != expectedStatus) return null;

  final alreadyAtStatus = decodedBody['alreadyAtStatus'];
  final changed = decodedBody['changed'];

  if (alreadyAtStatus == true) {
    return changed == false ? dispatchOutcomeAlreadyAtStatus : null;
  }

  if (changed == true) {
    return alreadyAtStatus == false ? dispatchOutcomeChanged : null;
  }

  return null;
}

/// Updates order fulfilment status (Preparing -> Picked Up -> In Transit -> Delivered)
/// via the trusted backend endpoint.
///
/// Returns:
///   `'changed'`         — the server applied the transition
///   `'alreadyAtStatus'` — the order was already at the requested status
///   `''`              — the request failed; toast was shown, do not send push notification
Future<String> updateOrderFulfilmentStatus(
  BuildContext context,
  String orderIdOrPath,
  String orderStatus,
) async {
  final orderId = _orderIdFromValue(orderIdOrPath);
  if (orderId.isEmpty) {
    await _showDispatchError(context, 'order_not_found');
    return '';
  }

  final normalizedStatus = _canonicalDispatchStatus(orderStatus);
  if (normalizedStatus == null) {
    await _showDispatchError(context, 'dispatch_status_invalid');
    return '';
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      await _showDispatchError(context, 'auth_required');
      return '';
    }

    final response = await http
        .post(
          Uri.parse('$_kFunctionBaseUrl/$_kUpdateOrderFulfilmentStatusPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'orderId': orderId,
            'orderStatus': normalizedStatus,
          }),
        )
        .timeout(const Duration(seconds: 30));

    final decodedBody = _decodeJson(response.body);

    if (response.statusCode == 200) {
      final outcome = classifyDispatchSuccessResponse(
        decodedBody,
        orderId: orderId,
        expectedStatus: normalizedStatus,
      );
      if (outcome == null) {
        await _showDispatchError(context, 'dispatch_response_invalid');
        return '';
      }
      return outcome;
    }

    final code = decodedBody is Map ? decodedBody['code']?.toString() : null;
    final serverError =
        decodedBody is Map ? decodedBody['error']?.toString() : null;
    await _showDispatchError(
      context,
      code ?? 'dispatch_state_unavailable',
      serverError: serverError,
    );
    return '';
  } on TimeoutException {
    await _showDispatchError(context, 'network_timeout');
    return '';
  } on SocketException {
    await _showDispatchError(context, 'network_error');
    return '';
  } on http.ClientException {
    await _showDispatchError(context, 'network_error');
    return '';
  } on FormatException {
    await _showDispatchError(context, 'dispatch_state_unavailable');
    return '';
  } catch (_) {
    await _showDispatchError(context, 'dispatch_state_unavailable');
    return '';
  }
}

String _orderIdFromValue(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return '';
  final segments = trimmed.split('/');
  return segments.isEmpty ? '' : segments.last.trim();
}

String? _canonicalDispatchStatus(String value) {
  final trimmed = value.trim();
  for (final status in _kDispatchStatuses) {
    if (status.toLowerCase() == trimmed.toLowerCase()) return status;
  }
  return null;
}

dynamic _decodeJson(String body) {
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}

Future<void> _showDispatchError(
  BuildContext context,
  String code, {
  String? serverError,
}) async {
  final isFrench = FFLocalizations.of(context).languageCode == 'fr';
  String message;

  switch (code) {
    case 'auth_required':
    case 'auth_invalid':
      message = isFrench
          ? 'Votre session a expiré. Veuillez vous reconnecter.'
          : 'Your session has expired. Please sign in again.';
      break;
    case 'auth_unavailable':
    case 'dispatch_state_unavailable':
      message = isFrench
          ? 'Le statut n’a pas pu être mis à jour. Aucune modification n’a été apportée ; veuillez réessayer.'
          : 'The status could not be updated. No changes were made; please retry.';
      break;
    case 'dispatch_response_invalid':
      message = isFrench
          ? 'La mise à jour du statut n’a pas pu être confirmée. Rouvrez la commande pour vérifier son statut avant de réessayer.'
          : 'The status update could not be confirmed. Reopen the order to check its current status before trying again.';
      break;
    case 'order_forbidden':
      message = isFrench
          ? 'Seul le propriétaire de la ferme peut mettre à jour le statut de cette commande.'
          : 'Only the farm owner can update this order status.';
      break;
    case 'order_not_found':
      message = isFrench ? 'Commande introuvable.' : 'Order not found.';
      break;
    case 'order_transition_invalid':
      message = isFrench
          ? 'Le statut de la commande a déjà changé. Rouvrez la commande et réessayez.'
          : 'The order status has already changed. Reopen the order and try again.';
      break;
    case 'settlement_pending':
      message = isFrench
          ? 'Cette commande vendue au poids doit d’abord être réglée et le solde payé avant l’expédition.'
          : 'This weight-based order must be settled and its balance paid before dispatch.';
      break;
    case 'balance_payment_requested':
    case 'balance_payment_failed':
      message = isFrench
          ? 'Le client doit régler le solde restant avant l’expédition.'
          : 'The customer must pay the outstanding balance before dispatch.';
      break;
    case 'dispatch_status_invalid':
    case 'order_id_required':
      message = isFrench
          ? 'Ce changement de statut n’est pas pris en charge.'
          : 'This status change is not supported.';
      break;
    case 'network_timeout':
      message = isFrench
          ? 'La demande a expiré. Veuillez réessayer.'
          : 'The request timed out. Please retry.';
      break;
    case 'network_error':
      message = isFrench
          ? 'Erreur réseau. Vérifiez votre connexion et réessayez.'
          : 'Network error. Please check your connection and retry.';
      break;
    default:
      final fallback = serverError?.trim();
      message = fallback != null && fallback.isNotEmpty
          ? fallback
          : (isFrench
              ? 'Le statut de la commande n’a pas pu être mis à jour. Veuillez réessayer.'
              : 'The order status could not be updated. Please retry.');
  }

  await toast(context, message, Colors.red);
}
