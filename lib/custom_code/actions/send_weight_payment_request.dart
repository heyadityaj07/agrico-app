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

import '/backend/currency/currency_utils.dart';

// Verified against the tracked Firebase configuration (`agricoo-b9c46`) and
// the existing payment action convention. Cloud Functions use the default
// `us-central1` region.
const String _kFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kSendWeightPaymentRequestPath = 'sendWeightPaymentRequest';

/// P3-02: send the single consolidated weight-settlement payment request.
///
/// Only the order ID is sent. The backend verifies ownership, requires every
/// variable-weight item to have a valid actual weight, computes the settlement
/// and writes all order-level financial state. This action never writes
/// Firestore and never sends amounts, weights or client calculations.
Future<bool> sendWeightPaymentRequest(
  BuildContext context,
  String orderIdOrPath,
) async {
  final orderId = _orderIdFromValue(orderIdOrPath);
  if (orderId.isEmpty) {
    await _showPaymentRequestError(context, 'order_not_found');
    return false;
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      await _showPaymentRequestError(context, 'auth_required');
      return false;
    }

    final response = await http
        .post(
          Uri.parse('$_kFunctionBaseUrl/$_kSendWeightPaymentRequestPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'orderId': orderId}),
        )
        .timeout(const Duration(seconds: 30));

    final decodedBody = _decodeJson(response.body);

    if (response.statusCode == 200) {
      await _showPaymentRequestSuccess(context, decodedBody);
      return true;
    }

    final code = decodedBody is Map ? decodedBody['code']?.toString() : null;
    final serverError =
        decodedBody is Map ? decodedBody['error']?.toString() : null;
    await _showPaymentRequestError(
      context,
      code ?? 'settlement_unavailable',
      serverError: serverError,
    );
    return false;
  } on TimeoutException {
    await _showPaymentRequestError(context, 'network_timeout');
    return false;
  } on SocketException {
    await _showPaymentRequestError(context, 'network_error');
    return false;
  } on http.ClientException {
    await _showPaymentRequestError(context, 'network_error');
    return false;
  } on FormatException {
    await _showPaymentRequestError(context, 'settlement_unavailable');
    return false;
  } catch (_) {
    await _showPaymentRequestError(context, 'settlement_unavailable');
    return false;
  }
}

String _orderIdFromValue(String value) {
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

double? _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

Future<void> _showPaymentRequestSuccess(
  BuildContext context,
  dynamic decodedBody,
) async {
  final languageCode = FFLocalizations.of(context).languageCode;
  final isFrench = languageCode == 'fr';

  if (decodedBody is! Map) {
    await toast(
      context,
      isFrench ? 'Demande de paiement envoyée.' : 'Payment request sent.',
    );
    return;
  }

  if (decodedBody['alreadyPaid'] == true) {
    await toast(
      context,
      isFrench ? 'Le solde est déjà payé.' : 'Balance already paid.',
    );
    return;
  }

  if (decodedBody['alreadyRequested'] == true) {
    await toast(
      context,
      isFrench
          ? 'La demande de paiement a déjà été envoyée.'
          : 'Payment request already sent.',
    );
    return;
  }

  final outcome = decodedBody['settlement_outcome']?.toString();
  final balanceAmount = _asDouble(decodedBody['final_balance_amount']);
  final refundDueAmount = _asDouble(decodedBody['refund_due_amount']);
  final formattedBalance = balanceAmount == null
      ? null
      : formatLanguageCurrency(balanceAmount, languageCode);
  final formattedRefund = refundDueAmount == null
      ? null
      : formatLanguageCurrency(refundDueAmount, languageCode);

  if (outcome == 'underpaid') {
    await toast(
      context,
      formattedBalance == null
          ? (isFrench
              ? 'Demande de paiement du solde envoyée.'
              : 'Outstanding balance payment request sent.')
          : (isFrench
              ? 'Demande de paiement du solde envoyée. $formattedBalance à régler.'
              : 'Outstanding balance payment request sent. $formattedBalance due.'),
    );
    return;
  }

  if (outcome == 'overpaid') {
    await toast(
      context,
      formattedRefund == null
          ? (isFrench
              ? 'Remboursement dû. Aucun paiement supplémentaire n’est requis.'
              : 'Refund due. No additional payment is required.')
          : (isFrench
              ? 'Remboursement dû : $formattedRefund. Aucun paiement supplémentaire n’est requis.'
              : 'Refund due: $formattedRefund. No additional payment is required.'),
    );
    return;
  }

  if (outcome == 'equal') {
    await toast(
      context,
      isFrench
          ? 'Aucun paiement supplémentaire n’est requis.'
          : 'No additional payment required.',
    );
    return;
  }

  await toast(
    context,
    isFrench ? 'Demande de paiement envoyée.' : 'Payment request sent.',
  );
}

Future<void> _showPaymentRequestError(
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
    case 'weight_deposit_rate_unavailable':
    case 'settlement_unavailable':
      message = isFrench
          ? 'La demande n’a pas pu être effectuée. Aucune modification n’a été apportée ; veuillez réessayer.'
          : 'The request could not be completed. No changes were made; please retry.';
      break;
    case 'order_forbidden':
      message = isFrench
          ? 'Seul le propriétaire de la ferme peut envoyer cette demande.'
          : 'Only the farm owner can send this request.';
      break;
    case 'order_not_found':
      message = isFrench ? 'Commande introuvable.' : 'Order not found.';
      break;
    case 'order_not_eligible':
      message = isFrench
          ? 'Cette commande ne peut plus être réglée.'
          : 'This order can no longer be settled.';
      break;
    case 'order_not_variable_weight':
      message = isFrench
          ? 'Cette commande ne contient pas de produits vendus au poids.'
          : 'This order does not contain variable-weight products.';
      break;
    case 'actual_weight_missing':
      message = isFrench
          ? 'Ajoutez d’abord le poids réel de chaque produit vendu au poids.'
          : 'Add the actual weight for every weight-based product first.';
      break;
    case 'weight_snapshot_invalid':
    case 'deposit_amount_mismatch':
    case 'order_fees_invalid':
      message = isFrench
          ? 'Les données de la commande n’ont pas pu être réglées. Veuillez contacter le support.'
          : 'The order data could not be settled. Please contact support.';
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
              ? 'La demande de paiement n’a pas pu être envoyée. Veuillez réessayer.'
              : 'The payment request could not be sent. Please retry.');
  }

  await toast(context, message);
}
