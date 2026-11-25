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

// F1–F6: all shared checkout-v1 logic (delivery-method mapping, attempt
// model/store, quote recovery, response contracts, cart cleanup) lives in
// this single shared module — one source of truth for both checkout actions.
import '/custom_code/checkout_v1/checkout_v1_logic.dart';

import 'index.dart' as actions; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'
    as functions; // Imports custom functions

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/index.dart';

/// FlutterFlow Custom Action for Checkout v1 Payment.
/// Self-contained, resilient to retries, zero writes to protected fields.

// Thin adapters between FlutterFlow schema types and the shared checkout-v1
// logic. Kept here (not in the logic module) so the logic module imports no
// generated schema barrels and stays unit-testable.
String checkoutAddressKey(DeliveryAdressStruct? address) {
  if (address == null) return '';
  // C2: the key is built from already-normalized parts so it matches the
  // backend-normalized persisted address in checkoutAttemptMatchesOrder.
  return [
    normalizeAddressPart(address.streetAdress),
    normalizeAddressPart(address.city),
    normalizeAddressPart(address.postalCode),
  ].join('|');
}

CartLineSnapshot cartLineFromCartRecord(CartRecord record) {
  final productRef = record.productRef;
  final productId = productRef?.id ?? '';
  final farmRef = record.farmRef;
  final farmId = farmRef?.id ?? '';
  return CartLineSnapshot(
    productId: productId,
    farmId: farmId,
    quantity: record.quantity,
    price: record.pricePerProduct,
    minWeight:
        record.hasMinWeight() && record.minWeight > 0 ? record.minWeight : null,
    maxWeight:
        record.hasMaxWeight() && record.maxWeight > 0 ? record.maxWeight : null,
    isVariableWeight: record.isVariableWeight,
  );
}

Future<void> startCheckoutPayment(
  BuildContext context,
  FarmsRecord farm,
  List<CartRecord> selectedCart,
  DeliveryAdressStruct? selectedAddress,
  String? deliveryMethod,
  String? selectedDeliveryTime,
  double? tip,
  String? note,
  String? voucherCode,
) async {
  final userRef = currentUserReference;
  if (userRef == null) {
    _showToast(context, 'Please sign in again to complete checkout.');
    return;
  }

  // F4: never default a missing selection to pickup — an unknown or missing
  // delivery context must be surfaced, not silently converted.
  final parsedMethod = tryParseCheckoutDeliveryMethod(deliveryMethod);
  if (parsedMethod == null) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Please select a delivery method before paying.',
        frText: 'Veuillez sélectionner un mode de livraison avant de payer.',
      ),
    );
    return;
  }

  // Validate farm supports selected method
  final supportsMethod = switch (parsedMethod) {
    CheckoutDeliveryMethod.pickup => farm.selfManagedSetup.clickCollect,
    CheckoutDeliveryMethod.producer => farm.doyouofferyourowndeliveryservice &&
        farm.selfManagedSetup.ownDelivery,
    CheckoutDeliveryMethod.uber => farm.agricooDelivery,
  };

  if (!supportsMethod) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'This delivery method is not available for this farm.',
        frText: "Ce mode de livraison n'est pas disponible pour cette ferme.",
      ),
    );
    return;
  }

  // Address check for delivery methods
  if (parsedMethod != CheckoutDeliveryMethod.pickup) {
    if (selectedAddress == null ||
        selectedAddress.streetAdress.trim().isEmpty) {
      _showToast(
        context,
        FFLocalizations.of(context).getVariableText(
          enText: 'Please select a valid delivery address before paying.',
          frText:
              'Veuillez sélectionner une adresse de livraison valide avant de payer.',
        ),
      );
      return;
    }
  }

  // Validate live cart from Firestore
  final liveCartSnapshot = await queryCartRecordOnce(parent: userRef);
  if (liveCartSnapshot.isEmpty) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'Your cart is empty.',
        frText: 'Votre panier est vide.',
      ),
    );
    return;
  }

  final farmId = farm.reference.id;
  final farmCartItems = liveCartSnapshot.where((item) {
    return item.farmRef?.id == farmId;
  }).toList();

  if (farmCartItems.isEmpty) {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText: 'No items in cart for this farm.',
        frText: 'Aucun article dans le panier pour cette ferme.',
      ),
    );
    return;
  }

  final cartLines = farmCartItems.map(cartLineFromCartRecord).toList();

  final store = SharedPreferencesCheckoutAttemptStore(ownerUid: userRef.id);
  final existingAttempt = await store.load();

  final user = FirebaseAuth.instance.currentUser;
  final idToken = await user?.getIdToken(true);
  if (idToken == null || idToken.isEmpty) {
    _showToast(context, 'Authentication required. Please sign in again.');
    return;
  }

  // F5: the current checkout identity/context. The backend's persisted order
  // document is the source of truth for comparison (it also covers legacy
  // persisted attempts that predate the local context fields).
  final languageCode = FFLocalizations.of(context).languageCode;
  final currency = languageCode.toLowerCase().startsWith('fr') ? 'EUR' : 'USD';
  final currentMethod = deliveryMethodToString(parsedMethod);
  final currentAddressKey = checkoutAddressKey(selectedAddress);
  final currentDeliveryTime = selectedDeliveryTime?.trim() ?? '';

  // Determine checkoutRequestId: reuse only when the checkout context still
  // matches the persisted server order; otherwise reconcile/cancel safely.
  String checkoutRequestId;
  String? existingOrderId;
  if (existingAttempt != null &&
      existingAttempt.orderId != null &&
      existingAttempt.orderId!.trim().isNotEmpty) {
    final existingOrderIdValue = existingAttempt.orderId!.trim();
    final snapshot = await OrderRecord.collection
        .doc(existingOrderIdValue)
        .get();
    final dynamic rawOrder = snapshot.exists ? snapshot.data() : null;
    final orderData =
        rawOrder is Map ? Map<String, dynamic>.from(rawOrder) : null;

    if (orderData == null) {
      // The associated order no longer exists: start a fresh attempt.
      checkoutRequestId = const Uuid().v4();
    } else if (checkoutAttemptMatchesOrder(
      orderData: orderData,
      orderId: existingOrderIdValue,
      farmId: farmId,
      deliveryMethod: currentMethod,
      currency: currency,
      addressKey: currentAddressKey,
      deliveryTime: currentDeliveryTime,
      cartLines: cartLines,
    )) {
      checkoutRequestId = existingAttempt.checkoutRequestId;
      existingOrderId = existingOrderIdValue;
    } else {
      // Context changed. Reconcile the previous order's payment state first
      // (same lifecycle signals the backend uses) — never cancel blindly.
      final creationPending =
          orderData['payment_intent_creation_pending'] == true;
      final intentId =
          (orderData['payment_intent_id'] as String?)?.trim() ?? '';
      final paymentState =
          (orderData['payment_state'] as String?)?.trim().toLowerCase() ?? '';
      final checkoutState =
          (orderData['checkout_state'] as String?)?.trim().toLowerCase() ?? '';
      final refundState =
          (orderData['checkout_refund_state'] as String?)?.trim().toLowerCase() ??
              '';

      final paymentUnsafe = creationPending ||
          intentId.isNotEmpty ||
          paymentState.isNotEmpty ||
          checkoutState == 'payment_confirmed' ||
          checkoutState == 'refund_pending' ||
          checkoutState == 'refunded' ||
          checkoutState == 'reconciliation_required' ||
          (refundState.isNotEmpty && refundState != 'none');

      if (paymentUnsafe) {
        // Payment started (or a terminal/refund lifecycle): never cancel and
        // never create a replacement order — preserve the attempt.
        _showToast(
          context,
          FFLocalizations.of(context).getVariableText(
            enText:
                'A previous payment for this order is being confirmed. Please wait before starting a new checkout.',
            frText:
                "Un paiement précédent pour cette commande est en cours de confirmation. Veuillez patienter avant de recommencer.",
          ),
        );
        return;
      }

      // Safe to cancel: no payment initiation, checkout still awaiting payment.
      final cancelled = await cancelCheckoutOrderAttempt(
        orderId: existingOrderIdValue,
        idToken: idToken,
      );
      if (!cancelled) {
        // Ambiguous cancellation: keep the attempt, surface recovery.
        _showToast(
          context,
          FFLocalizations.of(context).getVariableText(
            enText:
                'We could not confirm the cancellation yet. Your order is saved — please retry shortly.',
            frText:
                "Nous n'avons pas pu confirmer l'annulation. Votre commande est enregistrée — veuillez réessayer.",
          ),
        );
        return;
      }
      await store.clear();
      checkoutRequestId = const Uuid().v4();
    }
  } else if (existingAttempt != null &&
      checkoutCartLinesMatch(existingAttempt.cartLines, cartLines) &&
      checkoutAttemptMatchesRequest(
        attempt: existingAttempt,
        farmId: farmId,
        deliveryMethod: currentMethod,
        currency: currency,
        addressKey: currentAddressKey,
        deliveryTime: currentDeliveryTime,
        cartLines: cartLines,
      )) {
    // No order yet: preserve the idempotency request ID for a possibly-lost
    // creation response. Legacy attempts without context fields keep their
    // request ID; the backend rejects conflicting replays instead of creating
    // a wrong order.
    checkoutRequestId = existingAttempt.checkoutRequestId;
  } else {
    checkoutRequestId = const Uuid().v4();
  }

  if (existingOrderId == null || existingOrderId.isEmpty) {
    // Persist the attempt (with full context) before creating the order so a
    // lost creation response can be replayed idempotently.
    await store.save(
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        cartLines: cartLines,
        phase: 'created',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        farmId: farmId,
        currency: currency,
        deliveryMethod: currentMethod,
        addressKey: currentAddressKey,
        deliveryTime: currentDeliveryTime,
      ),
    );
  } else {
    // Refresh the attempt with the full context for future resumes.
    await store.save(
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        orderId: existingOrderId,
        cartLines: cartLines,
        phase: existingAttempt?.phase ?? 'awaitingPayment',
        createdAt: existingAttempt?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: existingAttempt?.expiresAt,
        farmId: farmId,
        currency: currency,
        deliveryMethod: currentMethod,
        addressKey: currentAddressKey,
        deliveryTime: currentDeliveryTime,
      ),
    );
  }

  // 1. Create or Recover Checkout Order via Cloud Function
  String orderId;
  int? orderExpiresAtMs;
  if (existingOrderId != null && existingOrderId.isNotEmpty) {
    orderId = existingOrderId;
  } else {
    final deliveryPayload = <String, dynamic>{
      'method': deliveryMethodToString(parsedMethod),
      if (selectedDeliveryTime != null && selectedDeliveryTime.isNotEmpty)
        'time': selectedDeliveryTime,
      if (tip != null && tip > 0) 'tip': tip,
      // C1: only the fields the checkout-v1 backend accepts are sent. The
      // legacy alias keys (`contact_name`, `address`, `zip_code`,
      // `contact_phone`, `latLng`) were rejected with `unsupported_field`
      // and had no consumers anywhere.
      if (parsedMethod != CheckoutDeliveryMethod.pickup &&
          selectedAddress != null)
        'address': buildCheckoutAddressPayload(
          fullName: selectedAddress.fullName,
          streetAddress: selectedAddress.streetAdress,
          city: selectedAddress.city,
          state: selectedAddress.state,
          postalCode: selectedAddress.postalCode,
          phoneNo: selectedAddress.phoneNo,
          instruction: selectedAddress.instruction,
        ),
    };

    final orderRequestPayload = {
      'checkoutRequestId': checkoutRequestId,
      'farmId': farmId,
      'currency': currency,
      'delivery': deliveryPayload,
      'items': cartLines
          .map((line) => {
                'productId': line.productId,
                'quantity': line.quantity,
                if (line.weightBracketObject != null)
                  'weightBracket': line.weightBracketObject,
              })
          .toList(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      if (voucherCode != null && voucherCode.trim().isNotEmpty)
        'voucherCode': voucherCode.trim(),
    };

    final createResponse = await http
        .post(
          Uri.parse(kCreateCheckoutOrderUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode(orderRequestPayload),
        )
        .timeout(const Duration(seconds: 30));

    final dynamic body = jsonDecode(createResponse.body);
    if (createResponse.statusCode != 200 || body is! Map) {
      final err = body is Map ? body['error']?.toString() : null;
      print('Checkout order creation failed: $err');
      _showToast(
        context,
        err ?? 'Checkout order creation failed. Please retry.',
      );
      return;
    }

    orderId = body['orderId'] as String? ?? '';
    if (orderId.isEmpty) {
      _showToast(context, 'Invalid order returned by checkout service.');
      return;
    }

    orderExpiresAtMs = (body['reservation']?['expiresAtMs'] as num?)?.toInt();
    await store.save(
      CheckoutAttempt(
        checkoutRequestId: checkoutRequestId,
        orderId: orderId,
        cartLines: cartLines,
        phase: 'awaitingPayment',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: orderExpiresAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(orderExpiresAtMs)
            : null,
      ),
    );

    // Ensure the order document is committed and visible in Firestore before proceeding
    for (var i = 0; i < 10; i++) {
      try {
        final orderDocSnap = await OrderRecord.collection.doc(orderId).get();
        if (orderDocSnap.exists) {
          break;
        }
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  // Shared confirmation helpers (used by the Uber recovery paths and by the
  // payment result handling below).
  Future<void> finishConfirmedCheckout() async {
    await store.clear();
    final orderRef = OrderRecord.collection.doc(orderId);
    FFAppState().orderdocument = orderRef;

    if (context.mounted) {
      context.goNamed(
        CheckoutfinalWidget.routeName,
        queryParameters: {
          'orderRef': serializeParam(orderRef, ParamType.DocumentReference),
        }.withoutNulls,
      );
    }

    // Delay cart cleanup so navigation completes first (existing behavior).
    Future.delayed(const Duration(milliseconds: 1200), () {
      clearPurchasedCartLines(
        userRef: userRef,
        purchasedLines: cartLines,
      ).catchError((_) {});
    });
  }

  Future<bool> pollBackendConfirmation() async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(seconds: 45)) {
      try {
        final doc = await OrderRecord.collection.doc(orderId).get();
        if (doc.exists) {
          final data = doc.data();
          final checkoutState =
              data is Map ? (data['checkout_state'] as String?)?.trim() : null;
          final status =
              data is Map ? (data['status'] as String?)?.trim() : null;
          final isPaid =
              data is Map ? (data['isPaid'] as bool?) ?? false : false;
          if (checkoutState == 'payment_confirmed' ||
              status == 'paid' ||
              status == 'confirmed' ||
              isPaid == true) {
            return true;
          }
        }
      } catch (_) {}
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    return false;
  }

  // 2. Uber Quote & Binding if applicable
  //
  // F1: binding success is validated against the real backend contract
  // (`success`, `quoteState`, `paymentEligible`, `quoteExpired`, echoed
  // `quoteId`) — the backend never returns a `bound` field.
  // F2: an already-bound quote is recovered from the order document before a
  // fresh quote is requested; failures never fall through to a quote-less
  // payment request.
  String? boundQuoteId;
  if (parsedMethod == CheckoutDeliveryMethod.uber) {
    String quoteSupportMessage() => FFLocalizations.of(context).getVariableText(
          enText:
              'Your checkout needs to be restarted. Please start the checkout again.',
          frText:
              'Votre commande doit être relancée. Veuillez recommencer le passage en caisse.',
        );

    String quoteRetryableMessage() =>
        FFLocalizations.of(context).getVariableText(
          enText:
              'We could not secure the delivery quote. Your order is saved — please retry shortly.',
          frText:
              "Nous n'avons pas pu obtenir le devis de livraison. Votre commande est enregistrée — veuillez réessayer.",
        );

    var recovery = await recoverCheckoutQuoteState(orderId);
    var resolvingFreshQuote =
        recovery.outcome == CheckoutQuoteRecoveryOutcome.noBoundQuote;

    while (true) {
      switch (recovery.outcome) {
        case CheckoutQuoteRecoveryOutcome.recovered:
          // Already-bound, unexpired quote belonging to this order.
          boundQuoteId = recovery.quoteId;
          break;

        case CheckoutQuoteRecoveryOutcome.paymentInitiated:
          if (recovery.checkoutState == 'payment_confirmed') {
            await finishConfirmedCheckout();
            return;
          }
          if (recovery.hasQuoteId && !recovery.quoteExpired) {
            // Reconcile via the idempotent payment endpoint: it reuses the
            // existing PaymentIntent (paymentIntentReused) or reports
            // alreadyConfirmed — it never creates a duplicate intent.
            boundQuoteId = recovery.quoteId;
            break;
          }
          // Payment started but the bound quote is unusable (expired or
          // missing): only the backend cancellation endpoint can safely
          // reconcile this state — it refuses to cancel succeeded/processing
          // payments, so a refusal simply means: keep the attempt and wait
          // for confirmation.
          final cancelled = await cancelCheckoutOrderAttempt(
            orderId: orderId,
            idToken: idToken,
          );
          if (!cancelled) {
            _showToast(context, quoteSupportMessage());
            return;
          }
          await store.clear();
          _showToast(context, quoteSupportMessage());
          return;

        case CheckoutQuoteRecoveryOutcome.noBoundQuote:
          // Request a fresh quote and bind it to this order.
          try {
            final quoteResponse = await http
                .post(
                  Uri.parse(kGetUberDeliveryQuoteUrl),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $idToken',
                  },
                  body: jsonEncode({
                    'orderId': orderId,
                    'pickup_address': farm.farmAddress,
                    'dropoff_address': selectedAddress?.streetAdress ?? '',
                  }),
                )
                .timeout(const Duration(seconds: 25));

            final dynamic quoteBody = jsonDecode(quoteResponse.body);
            final quoteId = quoteBody is Map
                ? (quoteBody['quote']?['id'] as String? ??
                    quoteBody['id'] as String?)
                : null;

            if (quoteId == null || quoteId.trim().isEmpty) {
              final quoteCode =
                  quoteBody is Map ? quoteBody['code']?.toString() : null;
              if (quoteCode == 'quote_already_bound') {
                // The order has a bound quote the app does not know about:
                // recover it instead of requesting another quote.
                recovery = await recoverCheckoutQuoteState(orderId);
                continue;
              }
              // Never continue to payment without a quote for Uber checkout.
              _showToast(context, quoteRetryableMessage());
              return;
            }

            final bindResponse = await http
                .post(
                  Uri.parse(kBindCheckoutUberQuoteUrl),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $idToken',
                  },
                  body: jsonEncode({
                    'orderId': orderId,
                    'quoteId': quoteId,
                  }),
                )
                .timeout(const Duration(seconds: 25));

            final dynamic bindBody = jsonDecode(bindResponse.body);
            final returnedQuoteId = bindBody is Map
                ? (bindBody['quoteId'] as String?)?.trim()
                : null;
            final bindAccepted = checkoutBindResponseAccepted(
              statusCode: bindResponse.statusCode,
              body: bindBody,
              requestedQuoteId: quoteId,
            );

            if (bindAccepted) {
              boundQuoteId = returnedQuoteId;
              await store.save(
                CheckoutAttempt(
                  checkoutRequestId: checkoutRequestId,
                  orderId: orderId,
                  quoteId: boundQuoteId,
                  cartLines: cartLines,
                  phase: 'quoteBound',
                  createdAt: existingAttempt?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                  expiresAt: existingAttempt?.expiresAt,
                  farmId: farmId,
                  currency: currency,
                  deliveryMethod: currentMethod,
                  addressKey: currentAddressKey,
                  deliveryTime: currentDeliveryTime,
                ),
              );
              break;
            }

            final bindCode =
                bindBody is Map ? bindBody['code']?.toString() : null;
            if (bindCode == 'quote_already_bound' ||
                bindCode == 'payment_already_initiated') {
              // Reconcile the order's actual state; a bound quote (possibly
              // bound here before a lost response) is recovered, and payment
              // initiation is handled by the idempotent payment endpoint.
              recovery = await recoverCheckoutQuoteState(orderId);
              if (recovery.outcome == CheckoutQuoteRecoveryOutcome.recovered ||
                  recovery.outcome ==
                      CheckoutQuoteRecoveryOutcome.paymentInitiated) {
                continue;
              }
              if (recovery.outcome == CheckoutQuoteRecoveryOutcome.expired) {
                continue; // handled by the expired case below
              }
              _showToast(context, quoteRetryableMessage());
              return;
            }

            // Retryable binding failures keep the order/reservation; the
            // customer retries and recovery resumes from server state.
            _showToast(context, quoteRetryableMessage());
            return;
          } catch (_) {
            // Timeout/network error during quote or bind: ambiguous — the
            // backend may have bound a quote. Stop and let recovery handle
            // the next attempt; never continue without a quote.
            _showToast(context, quoteRetryableMessage());
            return;
          }

        case CheckoutQuoteRecoveryOutcome.expired:
          // Bound quote expired and payment has NOT started: cancellation is
          // safe and the only supported path (binding is immutable).
          final cancelled = await cancelCheckoutOrderAttempt(
            orderId: orderId,
            idToken: idToken,
          );
          if (!cancelled) {
            _showToast(context, quoteSupportMessage());
            return;
          }
          await store.clear();
          _showToast(context, quoteSupportMessage());
          return;

        case CheckoutQuoteRecoveryOutcome.orderInvalid:
          if (recovery.checkoutState == null) {
            // The order document no longer exists: clear the attempt so the
            // next Pay press starts a fresh checkout.
            await store.clear();
            _showToast(context, quoteSupportMessage());
            return;
          }
          _showToast(context, quoteSupportMessage());
          return;

        case CheckoutQuoteRecoveryOutcome.readFailed:
          // Cannot verify server state: preserve the attempt, retry later.
          _showToast(context, quoteRetryableMessage());
          return;
      }
      break;
    }

    if (resolvingFreshQuote && boundQuoteId == null) {
      // Defensive: a fresh quote/bind run must always yield a quote ID.
      _showToast(context, quoteRetryableMessage());
      return;
    }
  }

  // 3. Present Stripe PaymentSheet
  final paymentResult = await actions.flutterStripeDirect(
    context,
    null,
    orderId,
    null,
    languageCode,
    null,
    null,
    false,
    true,
    boundQuoteId,
  );

  // F6: only authoritative backend confirmation may trigger cart cleanup or
  // success navigation. Cancellation, decline, timeouts and ambiguous
  // outcomes keep the attempt and the cart for safe recovery.
  if (paymentResult == 'success') {
    var dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                FFLocalizations.of(context).getVariableText(
                  enText: 'Confirming your payment...',
                  frText: 'Confirmation de votre paiement...',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ).then((_) => dialogOpen = false);

    final confirmed = await pollBackendConfirmation();

    if (dialogOpen && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (confirmed) {
      await finishConfirmedCheckout();
    } else {
      _showToast(
        context,
        FFLocalizations.of(context).getVariableText(
          enText:
              'Payment submitted — awaiting confirmation. Your cart is preserved.',
          frText:
              'Paiement soumis — en attente de confirmation. Votre panier est conservé.',
        ),
      );
    }
    return;
  }

  if (paymentResult == 'ambiguous') {
    _showToast(
      context,
      FFLocalizations.of(context).getVariableText(
        enText:
            'We could not verify the payment result. Your order is saved — please retry shortly.',
        frText:
            "Nous n'avons pas pu vérifier le résultat du paiement. Votre commande est enregistrée — veuillez réessayer.",
      ),
    );
    return;
  }

  _showToast(
    context,
    FFLocalizations.of(context).getVariableText(
      enText: 'Payment not completed. Your order is saved — you can retry.',
      frText:
          'Paiement non finalisé. Votre commande est enregistrée — vous pouvez réessayer.',
    ),
  );
}

void _showToast(BuildContext context, String message) {
  print('Checkout Payment Toast: $message');
  toast(
    context,
    message,
    FlutterFlowTheme.of(context).primarytheme,
  );
}
