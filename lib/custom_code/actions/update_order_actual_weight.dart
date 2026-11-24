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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// Verified against the tracked Firebase configuration (`agricoo-b9c46`) and
// the existing payment action convention. Cloud Functions use the default
// `us-central1` region.
const String _kFunctionBaseUrl =
    'https://us-central1-agricoo-b9c46.cloudfunctions.net';
const String _kSaveOrderActualWeightPath = 'saveOrderActualWeight';

/// P3-02: persist one actual weight through the trusted backend endpoint.
///
/// The endpoint owns authentication/ownership checks, the `Preparing` and
/// pre-settlement gates, the item snapshot, locking and all financial values.
/// This action only sends the target item and weight; it never writes
/// Firestore and never computes price, balance or clamping.

Future<bool> updateOrderActualWeight(
  BuildContext context,
  String orderPath,
  String productPath,
  String weightText,
  int itemIndex,
) async {
  // Add your function code here!
  final actualWeight = double.tryParse(weightText.trim());
  if (actualWeight == null || actualWeight <= 0) {
    await _showWeightSaveError(context, 'actual_weight_invalid');
    return false;
  }

  final orderId = _orderIdFromValue(orderPath);
  if (orderId.isEmpty) {
    await _showWeightSaveError(context, 'order_not_found');
    return false;
  }

  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    if (token == null || token.isEmpty) {
      await _showWeightSaveError(context, 'auth_required');
      return false;
    }

    final requestBody = <String, dynamic>{
      'orderId': orderId,
      'productRef': productPath,
      'actualWeight': actualWeight,
    };
    if (itemIndex != null) {
      requestBody['itemIndex'] = itemIndex;
    }

    final response = await http
        .post(
          Uri.parse('$_kFunctionBaseUrl/$_kSaveOrderActualWeightPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return true;
    }

    final decodedBody = _decodeJson(response.body);
    final code = decodedBody is Map ? decodedBody['code']?.toString() : null;
    final serverError =
        decodedBody is Map ? decodedBody['error']?.toString() : null;
    await _showWeightSaveError(
      context,
      code ?? 'weight_save_unavailable',
      serverError: serverError,
    );
    return false;
  } on TimeoutException {
    await _showWeightSaveError(context, 'network_timeout');
    return false;
  } on SocketException {
    await _showWeightSaveError(context, 'network_error');
    return false;
  } on http.ClientException {
    await _showWeightSaveError(context, 'network_error');
    return false;
  } on FormatException {
    await _showWeightSaveError(context, 'weight_save_unavailable');
    return false;
  } catch (_) {
    await _showWeightSaveError(context, 'weight_save_unavailable');
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

Future<void> _showWeightSaveError(
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
    case 'weight_save_unavailable':
      message = isFrench
          ? 'Le poids n’a pas pu être enregistré. Aucune modification n’a été apportée ; veuillez réessayer.'
          : 'The actual weight could not be saved. No changes were made; please retry.';
      break;
    case 'order_forbidden':
      message = isFrench
          ? 'Seul le propriétaire de la ferme peut enregistrer le poids réel.'
          : 'Only the farm owner can save actual weights.';
      break;
    case 'order_not_found':
      message = isFrench ? 'Commande introuvable.' : 'Order not found.';
      break;
    case 'order_not_eligible':
      message = isFrench
          ? 'Cette commande ne peut plus accepter de poids réel.'
          : 'This order can no longer accept actual weights.';
      break;
    case 'settlement_started':
      message = isFrench
          ? 'Les poids ne peuvent plus être modifiés après l’envoi de la demande de paiement.'
          : 'Weights cannot be changed after the payment request has been sent.';
      break;
    case 'weight_locked':
      message = isFrench
          ? 'Le poids réel de cet article est verrouillé et ne peut plus être modifié.'
          : 'The actual weight for this item is locked and cannot be changed.';
      break;
    case 'actual_weight_invalid':
      message = isFrench
          ? 'Saisissez un poids valide supérieur à zéro.'
          : 'Enter a valid weight greater than zero.';
      break;
    case 'order_not_variable_weight':
      message = isFrench
          ? 'Cette commande ne contient pas de produits vendus au poids.'
          : 'This order does not contain variable-weight products.';
      break;
    case 'item_index_invalid':
    case 'item_product_mismatch':
    case 'item_not_found':
    case 'item_ambiguous':
    case 'item_not_variable_weight':
      message = isFrench
          ? 'L’article sélectionné n’a pas pu être identifié. Rouvrez la commande et réessayez.'
          : 'The selected item could not be identified. Reopen the order and try again.';
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
              ? 'Le poids n’a pas pu être enregistré. Veuillez réessayer.'
              : 'The actual weight could not be saved. Please retry.');
  }

  await toast(context, message, Colors.red);
}
// final actualWeight = double.tryParse(weightText.trim());
// if (actualWeight == null || actualWeight <= 0) return false;

// final orderRef = FirebaseFirestore.instance.doc(orderPath);
// var updated = false;
// await FirebaseFirestore.instance.runTransaction((transaction) async {
//   final snapshot = await transaction.get(orderRef);
//   final data = snapshot.data() as Map<String, dynamic>?;
//   final rawItems = data?['order_items'];
//   if (rawItems is! List) return;

//   final items = rawItems
//       .map((entry) => Map<String, dynamic>.from(entry as Map))
//       .toList();
//   final itemIndex = items.indexWhere((item) {
//     final ref = item['product_ref'];
//     return ref is DocumentReference && ref.path == productPath;
//   });
//   if (itemIndex < 0) return;

//   items[itemIndex]['actual_weight'] = actualWeight;
//   items[itemIndex]['weight_locked'] = true;
//   final quantity = (items[itemIndex]['total_items'] as num?)?.toInt() ?? 1;
//   final pricePerKg =
//       (items[itemIndex]['price_per_kg'] as num?)?.toDouble() ?? 0;
//   final deposit =
//       (items[itemIndex]['deposit_amount'] as num?)?.toDouble() ?? 0;
//   final finalPrice = actualWeight.clamp(
//           0,
//           (items[itemIndex]['max_weight'] as num?)?.toDouble() ??
//               actualWeight) *
//       pricePerKg *
//       quantity;
//   items[itemIndex]['final_item_price'] = finalPrice;
//   items[itemIndex]['remaining_balance'] =
//       (finalPrice - deposit * quantity).clamp(0, double.infinity);
//   transaction.update(orderRef, {'order_items': items});
//   updated = true;
// });

// return updated;
//}
