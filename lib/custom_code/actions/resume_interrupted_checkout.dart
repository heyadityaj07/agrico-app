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

import 'package:firebase_auth/firebase_auth.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/toast.dart' show toast;
import '/index.dart';

// F7: the resumption action reuses the shared checkout-v1 logic module (the
// attempt store, model, cancellation contract and cart cleanup) so there is
// a single source of truth for the persisted attempt and no duplicated
// endpoint logic across custom actions. See the FlutterFlow handoff notes
// for how this shared module is wired inside FlutterFlow.
import '/custom_code/checkout_v1/checkout_v1_logic.dart'
    show
        SharedPreferencesCheckoutAttemptStore,
        CheckoutAttempt,
        cancelCheckoutOrderAttempt,
        clearPurchasedCartLines;

/// F7 — Interrupted-checkout resumption.
///
/// Wire this action to the checkout page's On Load action. It NEVER creates
/// an order, requests or binds a quote, or initiates a PaymentIntent — it
/// only:
///   1. restores the persisted checkout attempt,
///   2. reconciles the server-side order state (read-only),
///   3. completes an already-confirmed checkout (cleanup + navigation),
///   4. completes a previously requested cancellation,
///   5. otherwise leaves the attempt intact so the existing Pay flow
///      continues idempotently.
///
/// Returns the observed outcome so callers can react if needed:
/// 'none' | 'resumable' | 'confirmed' | 'cancelled' | 'needsSupport'
Future<String> resumeInterruptedCheckout(BuildContext context) async {
  final userRef = currentUserReference;
  if (userRef == null) return 'none';

  // Shared attempt store — same key and JSON format as startCheckoutPayment
  // (single source of truth; the save path stays exclusively in
  // startCheckoutPayment, so there are no conflicting writers).
  final store = SharedPreferencesCheckoutAttemptStore(ownerUid: userRef.id);
  final attempt = await store.load();
  if (attempt == null) return 'none';

  String? orderState;
  if (attempt.orderId != null && attempt.orderId!.trim().isNotEmpty) {
    try {
      final snapshot = await OrderRecord.collection.doc(attempt.orderId!).get();
      if (!snapshot.exists) {
        // The associated order is gone: the attempt cannot be resumed.
        await store.clear();
        _showResumptionToast(
            context,
            'Your previous checkout is no longer active. Please start checkout again.');
        return 'needsSupport';
      }
      final dynamic raw = snapshot.data();
      if (raw is Map) {
        orderState = (raw['checkout_state'] as String?)?.trim().toLowerCase();
      }
    } catch (_) {
      // Unreadable state must stay recoverable — never clear on uncertainty.
      return 'resumable';
    }
  }

  switch (orderState) {
    case 'payment_confirmed':
      // Authoritative confirmation: finish the checkout (cart cleanup and
      // navigation only; no payment actions).
      await store.clear();
      final orderRef = OrderRecord.collection.doc(attempt.orderId!);
      FFAppState().orderdocument = orderRef;
      if (context.mounted) {
        context.goNamed(
          CheckoutfinalWidget.routeName,
          queryParameters: {
            'orderRef': serializeParam(orderRef, ParamType.DocumentReference),
          }.withoutNulls,
        );
      }
      // Delay cart cleanup so the navigation transition completes cleanly.
      Future.delayed(const Duration(milliseconds: 1200), () {
        clearPurchasedCartLines(
          userRef: userRef,
          purchasedLines: attempt.cartLines,
        ).catchError((_) {});
      });
      return 'confirmed';
    case 'cancelled':
    case 'expired':
    case 'refunded':
      await store.clear();
      _showResumptionToast(
          context,
          'Your previous checkout is no longer active. Please start checkout again.');
      return 'cancelled';
    case 'refund_pending':
    case 'reconciliation_required':
      // Terminal-uncertain: requires support, must not be retried or cleared.
      _showResumptionToast(
          context, 'This checkout needs to be reviewed by our support team.');
      return 'needsSupport';
    default:
      break;
  }

  // A previously requested cancellation must be completed before anything new
  // is attempted. The cancellation endpoint is server-verified and safe.
  if (attempt.cancelRequested && attempt.orderId != null) {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken(true);
      if (idToken == null || idToken.isEmpty) return 'resumable';
      final cancelled = await cancelCheckoutOrderAttempt(
        orderId: attempt.orderId!,
        idToken: idToken,
      );
      if (cancelled) {
        await store.clear();
        _showResumptionToast(
            context,
            'Your previous checkout was cancelled. Your reservation was released.');
        return 'cancelled';
      }
      // Ambiguous cancellation: keep the attempt for a later retry.
      return 'needsSupport';
    } catch (_) {
      return 'needsSupport';
    }
  }

  // Order still awaiting payment (or not yet created): the existing Pay flow
  // resumes idempotently — it reuses the same order and recovers any bound
  // Uber quote before payment.
  _showResumptionToast(context,
      'You have an unfinished checkout. Please press Pay to continue.');
  return 'resumable';
}

void _showResumptionToast(BuildContext context, String message) {
  toast(
    context,
    FFLocalizations.of(context).getVariableText(
      enText: message,
      frText: message,
    ),
    FlutterFlowTheme.of(context).primarytheme,
  );
}
