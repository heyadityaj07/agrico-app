import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/checkout/checkout_v1_api.dart';
import '/backend/checkout/checkout_v1_attempt_store.dart';
import '/backend/checkout/checkout_v1_cart_cleanup.dart';
import '/backend/checkout/checkout_v1_client.dart';
import '/backend/checkout/checkout_v1_flow.dart';
import '/backend/currency/currency_utils.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'checkout_model.dart';
export 'checkout_model.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({
    super.key,
    required this.vouchercode,
    required this.note,
    required this.tip,
  });

  final String? vouchercode;
  final String? note;
  final double? tip;

  static String routeName = 'checkout';
  static String routePath = '/checkout';

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  late CheckoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isResumingAttempt = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckoutModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.farmpickup = null;
      _model.deliveryMethod = null;
      safeSetState(() {});
      await _resumeStoredCheckoutAttempt();
    });

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Checkout-v1 integration
  // -------------------------------------------------------------------------

  Future<void> _startCheckoutV1Payment({
    required FarmsRecord farm,
    required List<CartRecord> selectedCart,
    required DeliveryAdressStruct? selectedAddress,
  }) async {
    final userRef = currentUserReference;
    if (userRef == null) {
      _showCheckoutError('auth_required');
      return;
    }

    final method = tryParseCheckoutDeliveryMethod(_model.deliveryMethod);
    if (method == null) {
      _showCheckoutMessage(
        en: 'Please select a delivery method before paying.',
        fr: 'Veuillez sélectionner un mode de livraison avant de payer.',
      );
      return;
    }

    if (!_farmSupportsMethod(farm, method)) {
      _showCheckoutMessage(
        en: 'This delivery method is no longer available for this farm.',
        fr: "Ce mode de livraison n'est plus disponible pour cette ferme.",
      );
      return;
    }

    final address = method == CheckoutDeliveryMethod.pickup
        ? null
        : (selectedAddress == null
            ? null
            : CheckoutAddress.fromDeliveryAdress(selectedAddress));
    if (method != CheckoutDeliveryMethod.pickup) {
      final addressError = validateCheckoutAddress(address);
      if (addressError != null) {
        _showCheckoutError(addressError);
        return;
      }
    }

    final currentCart = await queryCartRecordOnce(parent: userRef);
    final validation = validateCheckoutCart(
      selectedCart: selectedCart,
      currentCart: currentCart,
      farmId: farm.reference.id,
    );
    if (!validation.isValid) {
      _showCheckoutError(validation.errorCode ?? 'cart_line_invalid');
      return;
    }

    final capturedLines = validation.lines;
    final currency = currencyCodeForLanguage(
      FFLocalizations.of(context).languageCode,
    );
    final payload = CheckoutPayload(
      farmId: farm.reference.id,
      currency: currency,
      deliveryMethod: method,
      items: capturedLines.map(
        (line) => CheckoutItem(
          productId: line.productId,
          quantity: line.quantity,
          weightBracket: line.weightBracket,
        ),
      ),
      address: address,
      deliveryTime: _model.selectedDeliveryTime,
      tip: widget.tip ?? 0,
      note: widget.note,
      voucherCode: widget.vouchercode,
    );

    final store = SharedPreferencesCheckoutAttemptStore(ownerUid: userRef.id);
    final loadedAttempt = await store.load();
    if (loadedAttempt.isInvalid) {
      _showCheckoutAttemptRecoveryMessage(loadedAttempt.invalidReason);
      return;
    }
    final existing = loadedAttempt.attempt;
    final resolution = resolveCheckoutAttempt(
      existing: existing,
      payload: payload,
      cartLines: capturedLines,
    );
    var attempt = resolution.attempt;

    if (attempt.phase == CheckoutAttemptPhase.needsReview) {
      _showCheckoutSupportMessage();
      return;
    }

    if (!resolution.reused &&
        existing != null &&
        existing.isOpen &&
        existing.orderId != null) {
      final canContinue = await _supersedePreviousAttempt(existing, store);
      if (!canContinue) return;
    }

    await store.save(attempt);

    // A bind response can be lost after the backend persisted the quote. Reuse
    // the order's bound, unexpired quote instead of trying to bind a new one.
    if (attempt.orderId != null &&
        method == CheckoutDeliveryMethod.uber &&
        attempt.quoteId == null) {
      final recoveredQuoteId = await _recoverBoundQuoteId(attempt.orderId!);
      if (recoveredQuoteId != null) {
        attempt = attempt.copyWith(quoteId: recoveredQuoteId);
        await store.save(attempt);
      }
    }

    // A previous cancellation request must be completed before any new
    // PaymentIntent is attempted.
    if (attempt.cancelRequested && attempt.orderId != null) {
      await _cancelStoredAttempt(attempt, store);
      return;
    }

    // Reopening an attempt that was already presented to PaymentSheet must
    // first observe the backend-owned order; never assume failure.
    if (attempt.orderId != null &&
        attempt.phase == CheckoutAttemptPhase.awaitingFinalization) {
      final state = await _observeCheckoutOrder(attempt.orderId!);
      final decision = decideCheckoutFinalization(state);
      if (decision == CheckoutFinalizationDecision.confirmed) {
        await _finishConfirmedCheckout(attempt, store);
        return;
      }
      if (decision == CheckoutFinalizationDecision.closed) {
        await store.clear();
        _showCheckoutMessage(
          en: 'The previous checkout is no longer active. Please try again.',
          fr: "La commande précédente n'est plus active. Veuillez réessayer.",
        );
        return;
      }
      if (decision == CheckoutFinalizationDecision.needsSupport) {
        await store.save(
          attempt.copyWith(phase: CheckoutAttemptPhase.needsReview),
        );
        _showCheckoutSupportMessage();
        return;
      }
      // Still pending: retry the same order/PaymentIntent safely below.
    }

    final request = buildCheckoutOrderRequest(
      checkoutRequestId: attempt.checkoutRequestId,
      payload: payload,
    );

    final result = await createCheckoutV1Intent(
      api: CheckoutV1Api(),
      attempt: attempt,
      request: request,
      saveAttempt: store.save,
      presentPayment: (orderId, quoteId, _) async {
        return actions.flutterStripeDirect(
          context,
          null,
          orderId,
          null,
          FFLocalizations.of(context).languageCode,
          null,
          null,
          useOrderTotals: true,
          quoteId: quoteId,
        );
      },
    );

    attempt = result.attempt;
    if (result.deliveryFee != null) {
      _model.fee = result.deliveryFee;
      safeSetState(() {});
    }

    switch (result.outcome) {
      case CheckoutV1FlowOutcome.awaitingFinalization:
        if (result.orderId != null) {
          await _waitForCheckoutFinalization(result.orderId!, attempt, store);
        }
        break;
      case CheckoutV1FlowOutcome.cancelled:
        await store.clear();
        _showCheckoutMessage(
          en: 'Payment cancelled. Your reservation was released.',
          fr: 'Paiement annulé. Votre réservation a été libérée.',
        );
        break;
      case CheckoutV1FlowOutcome.expired:
        await store.clear();
        _showCheckoutMessage(
          en: 'This checkout expired. Please try again.',
          fr: 'Cette commande a expiré. Veuillez réessayer.',
        );
        break;
      case CheckoutV1FlowOutcome.terminal:
        await store.clear();
        _showCheckoutError(result.errorCode ?? 'checkout_unavailable');
        break;
      case CheckoutV1FlowOutcome.needsSupport:
        await store.save(
          attempt.copyWith(phase: CheckoutAttemptPhase.needsReview),
        );
        _showCheckoutSupportMessage();
        break;
      case CheckoutV1FlowOutcome.retryable:
        _showCheckoutMessage(
          en: 'We could not complete the payment request. Your order is saved — please retry shortly.',
          fr: "Nous n'avons pas pu finaliser la demande de paiement. Votre commande est enregistrée — veuillez réessayer.",
        );
        break;
    }
  }

  bool _farmSupportsMethod(FarmsRecord farm, CheckoutDeliveryMethod method) {
    switch (method) {
      case CheckoutDeliveryMethod.pickup:
        return farm.selfManagedSetup.clickCollect;
      case CheckoutDeliveryMethod.producer:
        return farm.doyouofferyourowndeliveryservice &&
            farm.selfManagedSetup.ownDelivery;
      case CheckoutDeliveryMethod.uber:
        return farm.agricooDelivery;
    }
  }

  /// Closes an older open attempt before a changed cart starts a new one.
  ///
  /// A payment that may already be in flight is never cancelled here.
  Future<bool> _supersedePreviousAttempt(
    CheckoutAttempt existing,
    CheckoutAttemptStore store,
  ) async {
    final orderId = existing.orderId;
    if (orderId == null) {
      await store.clear();
      return true;
    }

    final state = await _observeCheckoutOrder(orderId);
    final decision = decideCheckoutFinalization(state);
    if (decision == CheckoutFinalizationDecision.confirmed) {
      await _finishConfirmedCheckout(existing, store);
      return false;
    }
    if (decision == CheckoutFinalizationDecision.closed) {
      await store.clear();
      return true;
    }
    if (decision == CheckoutFinalizationDecision.needsSupport) {
      await store.save(
        existing.copyWith(phase: CheckoutAttemptPhase.needsReview),
      );
      _showCheckoutSupportMessage();
      return false;
    }
    if (existing.phase == CheckoutAttemptPhase.awaitingFinalization) {
      _showCheckoutMessage(
        en: 'A previous payment is still being confirmed. Please wait before starting a new checkout.',
        fr: 'Un paiement précédent est encore en cours de confirmation. Veuillez patienter avant de recommencer.',
      );
      return false;
    }

    final result = await cancelCheckoutV1Attempt(
      api: CheckoutV1Api(),
      attempt: existing,
      saveAttempt: store.save,
      errorCode: 'checkout_cart_changed',
    );

    switch (result.outcome) {
      case CheckoutV1FlowOutcome.cancelled:
      case CheckoutV1FlowOutcome.expired:
        await store.clear();
        return true;
      case CheckoutV1FlowOutcome.awaitingFinalization:
        await _waitForCheckoutFinalization(
          result.orderId ?? orderId,
          result.attempt,
          store,
        );
        return false;
      case CheckoutV1FlowOutcome.needsSupport:
        _showCheckoutSupportMessage();
        return false;
      case CheckoutV1FlowOutcome.terminal:
      case CheckoutV1FlowOutcome.retryable:
        _showCheckoutMessage(
          en: 'Your previous checkout could not be closed safely. Please retry before changing the cart.',
          fr: "Votre commande précédente n'a pas pu être fermée en toute sécurité. Veuillez réessayer avant de modifier le panier.",
        );
        return false;
    }
  }

  Future<void> _cancelStoredAttempt(
    CheckoutAttempt attempt,
    CheckoutAttemptStore store,
  ) async {
    final result = await cancelCheckoutV1Attempt(
      api: CheckoutV1Api(),
      attempt: attempt,
      saveAttempt: store.save,
    );

    switch (result.outcome) {
      case CheckoutV1FlowOutcome.cancelled:
      case CheckoutV1FlowOutcome.expired:
        await store.clear();
        _showCheckoutMessage(
          en: 'Payment cancelled. Your reservation was released.',
          fr: 'Paiement annulé. Votre réservation a été libérée.',
        );
        break;
      case CheckoutV1FlowOutcome.awaitingFinalization:
        await _waitForCheckoutFinalization(
          result.orderId ?? attempt.orderId!,
          result.attempt,
          store,
        );
        break;
      case CheckoutV1FlowOutcome.needsSupport:
        _showCheckoutSupportMessage();
        break;
      case CheckoutV1FlowOutcome.terminal:
      case CheckoutV1FlowOutcome.retryable:
        _showCheckoutMessage(
          en: 'We could not confirm the cancellation yet. Your order is saved — please retry shortly.',
          fr: "Nous n'avons pas pu confirmer l'annulation. Votre commande est enregistrée — veuillez réessayer.",
        );
        break;
    }
  }

  Future<CheckoutFinalizationState> _observeCheckoutOrder(
    String orderId,
  ) async {
    try {
      final snapshot = await OrderRecord.collection.doc(orderId).get();
      final data = snapshot.data();
      return classifyCheckoutFinalization(
        data is Map ? data.cast<String, dynamic>() : null,
      );
    } catch (_) {
      return CheckoutFinalizationState.unknown;
    }
  }

  /// Recovers a quote that the backend bound before the response reached the
  /// app. Expired quotes are deliberately not reused so the flow cancels and
  /// restarts instead of paying against a stale fee.
  Future<String?> _recoverBoundQuoteId(String orderId) async {
    try {
      final snapshot = await OrderRecord.collection.doc(orderId).get();
      final data = snapshot.data();
      if (data is! Map) return null;
      final state =
          (data['uber_quote_state'] as String?)?.trim().toLowerCase();
      final quoteId = data['uber_quote_id'];
      if (state != 'bound' ||
          quoteId is! String ||
          quoteId.trim().isEmpty) {
        return null;
      }

      final expires = data['uber_quote_expires_at'];
      DateTime? expiry;
      if (expires is Timestamp) {
        expiry = expires.toDate();
      } else if (expires is DateTime) {
        expiry = expires;
      }
      if (expiry != null && !expiry.isAfter(DateTime.now())) {
        return null;
      }
      return quoteId.trim();
    } catch (_) {
      return null;
    }
  }

  /// Re-opens an interrupted attempt after an app restart without creating a
  /// new order or PaymentIntent.
  Future<void> _resumeStoredCheckoutAttempt() async {
    if (_isResumingAttempt || !mounted) return;
    final userRef = currentUserReference;
    if (userRef == null) return;

    _isResumingAttempt = true;
    try {
      final store = SharedPreferencesCheckoutAttemptStore(
        ownerUid: userRef.id,
      );
      final loadedAttempt = await store.load();
      if (loadedAttempt.isInvalid) {
        _showCheckoutAttemptRecoveryMessage(loadedAttempt.invalidReason);
        return;
      }
      final attempt = loadedAttempt.attempt;
      if (attempt == null || attempt.orderId == null) return;
      if (attempt.phase != CheckoutAttemptPhase.awaitingFinalization &&
          attempt.phase != CheckoutAttemptPhase.needsReview) {
        return;
      }

      final state = await _observeCheckoutOrder(attempt.orderId!);
      switch (decideCheckoutFinalization(state)) {
        case CheckoutFinalizationDecision.confirmed:
          await _finishConfirmedCheckout(attempt, store);
          break;
        case CheckoutFinalizationDecision.closed:
          await store.clear();
          break;
        case CheckoutFinalizationDecision.needsSupport:
          await store.save(
            attempt.copyWith(phase: CheckoutAttemptPhase.needsReview),
          );
          _showCheckoutSupportMessage();
          break;
        case CheckoutFinalizationDecision.pending:
          _showCheckoutMessage(
            en: 'A payment for this checkout is still being confirmed. Your order is saved.',
            fr: 'Un paiement pour cette commande est encore en cours de confirmation. Votre commande est enregistrée.',
          );
          break;
      }
    } finally {
      _isResumingAttempt = false;
    }
  }

  Future<void> _waitForCheckoutFinalization(
    String orderId,
    CheckoutAttempt attempt,
    CheckoutAttemptStore store,
  ) async {
    var dialogOpen = false;
    if (mounted) {
      dialogOpen = true;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Dialog(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'Confirming payment…',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).whenComplete(() => dialogOpen = false);
    }

    final deadline = DateTime.now().add(const Duration(seconds: 45));
    var state = CheckoutFinalizationState.unknown;
    while (mounted && DateTime.now().isBefore(deadline)) {
      state = await _observeCheckoutOrder(orderId);
      if (decideCheckoutFinalization(state) !=
          CheckoutFinalizationDecision.pending) {
        break;
      }
      await Future<void>.delayed(const Duration(seconds: 2));
    }

    if (dialogOpen && mounted) {
      dialogOpen = false;
      Navigator.of(context, rootNavigator: true).pop();
    }

    switch (decideCheckoutFinalization(state)) {
      case CheckoutFinalizationDecision.confirmed:
        await _finishConfirmedCheckout(attempt, store);
        break;
      case CheckoutFinalizationDecision.closed:
        await store.clear();
        _showCheckoutMessage(
          en: 'This checkout is no longer active.',
          fr: "Cette commande n'est plus active.",
        );
        break;
      case CheckoutFinalizationDecision.needsSupport:
        await store.save(
          attempt.copyWith(phase: CheckoutAttemptPhase.needsReview),
        );
        _showCheckoutSupportMessage();
        break;
      case CheckoutFinalizationDecision.pending:
        _showCheckoutMessage(
          en: 'Payment received. Final confirmation is still processing — your order is saved and will update automatically.',
          fr: 'Paiement reçu. La confirmation finale est en cours — votre commande est enregistrée et sera mise à jour automatiquement.',
        );
        break;
    }
  }

  Future<void> _finishConfirmedCheckout(
    CheckoutAttempt attempt,
    CheckoutAttemptStore store,
  ) async {
    final userRef = currentUserReference;
    final orderId = attempt.orderId;
    if (userRef == null || orderId == null) return;

    try {
      await clearPurchasedCartLines(
        userRef: userRef,
        purchasedLines: attempt.cartLines,
      );
    } catch (_) {
      // Keep the attempt so the same safe cart cleanup can be retried after the
      // app is reopened; the order is already paid and must not be recreated.
      _showCheckoutMessage(
        en: 'Payment confirmed, but the cart could not be cleared yet. Please reopen the app to finish.',
        fr: 'Paiement confirmé, mais le panier n\'a pas encore pu être vidé. Veuillez rouvrir l\'application pour terminer.',
      );
      return;
    }

    await store.clear();
    final orderRef = OrderRecord.collection.doc(orderId);
    FFAppState().orderdocument = orderRef;
    FFAppState().pendingpaymentdocument = null;
    safeSetState(() {});

    if (!mounted) return;
    context.goNamed(
      CheckoutfinalWidget.routeName,
      queryParameters: {
        'orderRef': serializeParam(orderRef, ParamType.DocumentReference),
      }.withoutNulls,
    );
  }

  void _showCheckoutSupportMessage() {
    _showCheckoutMessage(
      en: 'This checkout requires support or reconciliation. Please contact support with your order reference.',
      fr: "Cette commande nécessite une assistance ou une réconciliation. Veuillez contacter le support avec votre référence de commande.",
    );
  }

  void _showCheckoutAttemptRecoveryMessage(String? reason) {
    // The malformed value is deliberately left in local storage for diagnosis.
    // Do not generate a new request ID or overwrite it from the UI.
    if (reason != null) {
      debugPrint('Checkout attempt rejected: $reason');
    }
    _showCheckoutMessage(
      en: 'A saved checkout could not be verified. Please contact support before retrying; the saved checkout data was kept for review.',
      fr: "Une commande enregistrée n'a pas pu être vérifiée. Veuillez contacter le support avant de réessayer ; les données enregistrées ont été conservées pour examen.",
    );
  }

  void _showCheckoutError(String code) {
    final message = switch (code) {
      'cart_empty' => (en: 'Your cart is empty.', fr: 'Votre panier est vide.'),
      'multi_farm_cart' => (
          en: 'Your cart contains items from more than one farm. Please keep one farm per checkout.',
          fr: 'Votre panier contient des articles de plusieurs fermes. Veuillez ne garder qu\'une ferme par commande.',
        ),
      'checkout_cart_changed' => (
          en: 'Your cart changed. Please review it and try again.',
          fr: 'Votre panier a changé. Veuillez le vérifier et réessayer.',
        ),
      'cart_line_invalid' => (
          en: 'One of your cart items is invalid. Please remove it and add it again.',
          fr: 'Un article de votre panier est invalide. Veuillez le retirer et le rajouter.',
        ),
      'delivery_address_required' => (
          en: 'Please add a delivery address.',
          fr: 'Veuillez ajouter une adresse de livraison.',
        ),
      'delivery_address_invalid' => (
          en: 'Please complete your delivery address before paying.',
          fr: 'Veuillez compléter votre adresse de livraison avant de payer.',
        ),
      'auth_required' => (
          en: 'Please sign in again to complete checkout.',
          fr: 'Veuillez vous reconnecter pour finaliser la commande.',
        ),
      _ => (
          en: 'We could not complete the checkout. Please retry shortly.',
          fr: 'Nous n\'avons pas pu finaliser la commande. Veuillez réessayer.',
        ),
    };
    _showCheckoutMessage(en: message.en, fr: message.fr);
  }

  void _showCheckoutMessage({required String en, required String fr}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          FFLocalizations.of(context).getVariableText(enText: en, frText: fr),
          style: TextStyle(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        duration: const Duration(milliseconds: 6000),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).offwhite,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).offwhite,
          automaticallyImplyLeading: true,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pop();
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
            ),
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'fpaalzml' /* Checkout */,
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Satoshi',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              if (false)
                StreamBuilder<List<PaymentsRecord>>(
                  stream: queryPaymentsRecord(
                    queryBuilder: (paymentsRecord) => paymentsRecord.where(
                      'orderId',
                      isEqualTo: FFAppState().orderdocument?.id,
                    ),
                    singleRecord: true,
                  )..listen((snapshot) {
                      List<PaymentsRecord> containerPaymentsRecordList =
                          snapshot;
                      final containerPaymentsRecord =
                          containerPaymentsRecordList.isNotEmpty
                              ? containerPaymentsRecordList.first
                              : null;
                      if (_model.containerPreviousSnapshot != null &&
                          !const ListEquality(PaymentsRecordDocumentEquality())
                              .equals(containerPaymentsRecordList,
                                  _model.containerPreviousSnapshot)) {
                        () async {
                          if (containerPaymentsRecord?.status == 'paid') {
                            await FFAppState().cartdocument!.delete();

                            context.goNamed(
                              CheckoutfinalWidget.routeName,
                              queryParameters: {
                                'orderRef': serializeParam(
                                  FFAppState().orderdocument,
                                  ParamType.DocumentReference,
                                ),
                              }.withoutNulls,
                            );
                          }

                          safeSetState(() {});
                        }();
                      }
                      _model.containerPreviousSnapshot = snapshot;
                    }),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primarytheme,
                            ),
                          ),
                        ),
                      );
                    }
                    List<PaymentsRecord> containerPaymentsRecordList =
                        snapshot.data!;
                    final containerPaymentsRecord =
                        containerPaymentsRecordList.isNotEmpty
                            ? containerPaymentsRecordList.first
                            : null;

                    return Container(
                      width: 0.0,
                      height: 0.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    );
                  },
                ),
              StreamBuilder<UsersRecord>(
                stream: UsersRecord.getDocument(currentUserReference!)
                  ..listen((columnUsersRecord) async {
                    if (_model.columnPreviousSnapshot != null &&
                        !UsersRecordDocumentEquality().equals(
                            columnUsersRecord, _model.columnPreviousSnapshot)) {
                      final selectedAddress =
                          resolveSelectedDeliveryAddress(columnUsersRecord);
                      safeSetState(() {
                        _model.textController1?.text =
                            selectedAddress?.fullName ?? '';
                      });
                      safeSetState(() {
                        _model.textController2?.text =
                            selectedAddress?.streetAdress ?? '';
                      });
                      safeSetState(() {
                        _model.textController3?.text =
                            selectedAddress?.phoneNo ?? '';
                      });

                      safeSetState(() {});
                    }
                    _model.columnPreviousSnapshot = columnUsersRecord;
                  }),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primarytheme,
                          ),
                        ),
                      ),
                    );
                  }

                  final columnUsersRecord = snapshot.data!;
                  final selectedDeliveryAddress =
                      resolveSelectedDeliveryAddress(columnUsersRecord);

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: StreamBuilder<List<ConfigRecord>>(
                          stream: queryConfigRecord(
                            singleRecord: true,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primarytheme,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<ConfigRecord> stackConfigRecordList =
                                snapshot.data!;
                            // Retained from the generated tree; checkout-v1
                            // totals are server-owned, so this local is no
                            // longer read by the Pay action.
                            // ignore: unused_local_variable
                            final stackConfigRecord =
                                stackConfigRecordList.isNotEmpty
                                    ? stackConfigRecordList.first
                                    : null;

                            return Stack(
                              children: [
                                StreamBuilder<List<CartRecord>>(
                                  stream: queryCartRecord(
                                    parent: currentUserReference,
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primarytheme,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<CartRecord> containerCartRecordList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: BoxDecoration(),
                                      child: StreamBuilder<FarmsRecord>(
                                        stream: FarmsRecord.getDocument(
                                            containerCartRecordList
                                                .firstOrNull!.farmRef!),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primarytheme,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          final pageViewFarmsRecord =
                                              snapshot.data!;
                                          final hasFarmDeliverySetup =
                                              pageViewFarmsRecord
                                                  .hasSelfManagedSetup();
                                          final deliveryMinimumMet =
                                              hasFarmDeliverySetup &&
                                                  functions
                                                      .meetsFarmMinimumOrder(
                                            functions.totalsales(
                                                containerCartRecordList
                                                    .toList()),
                                            pageViewFarmsRecord
                                                .selfManagedSetup
                                                .minimumAmmount,
                                          );

                                          if (!deliveryMinimumMet &&
                                              _model.deliveryMethod != null &&
                                              _model.deliveryMethod !=
                                                  'farmpickup') {
                                            SchedulerBinding.instance
                                                .addPostFrameCallback((_) {
                                              if (!mounted) return;
                                              if (pageViewFarmsRecord
                                                  .selfManagedSetup
                                                  .clickCollect) {
                                                _model.farmpickup = 'yes';
                                                _model.deliveryMethod =
                                                    'farmpickup';
                                              } else {
                                                _model.farmpickup = null;
                                                _model.deliveryMethod = null;
                                              }
                                              _model.fee = 0.0;
                                              _model.isAgricodeliver = false;
                                              safeSetState(() {});
                                            });
                                          }

                                          return Container(
                                            width: double.infinity,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 40.0, 0.0, 20.0),
                                                  child: PageView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    controller: _model
                                                            .pageViewController ??=
                                                        PageController(
                                                            initialPage: 0),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      16.0),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .boderdivder,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(-1.0, -1.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'lu0p7nns' /* Delivery Method */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (!deliveryMinimumMet)
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                  border: Border.all(
                                                                                    color: FlutterFlowTheme.of(context).boderdivder,
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(12.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.info_outline,
                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                        size: 20.0,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          FFLocalizations.of(context).getVariableText(
                                                                                            enText: !hasFarmDeliverySetup
                                                                                                ? 'Delivery is currently unavailable for this farm. Please contact the farmer directly.'
                                                                                                : pageViewFarmsRecord.selfManagedSetup.clickCollect
                                                                                                    ? 'Your order is below the farm delivery minimum. Please choose Farm Pickup to continue.'
                                                                                                    : 'Your order is below the farm delivery minimum. Add more items to enable delivery.',
                                                                                            frText: !hasFarmDeliverySetup
                                                                                                ? 'La livraison est actuellement indisponible pour cette ferme. Veuillez contacter directement l\'agriculteur.'
                                                                                                : pageViewFarmsRecord.selfManagedSetup.clickCollect
                                                                                                    ? 'Votre commande est inférieure au minimum de livraison de la ferme. Veuillez choisir le retrait à la ferme pour continuer.'
                                                                                                    : 'Votre commande est inférieure au minimum de livraison de la ferme. Ajoutez des articles pour activer la livraison.',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(width: 10.0)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (pageViewFarmsRecord.doyouofferyourowndeliveryservice
                                                                              ? pageViewFarmsRecord.selfManagedSetup.clickCollect
                                                                              : false)
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 12.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  if ((_model.farmpickup != 'yes') && (_model.deliveryMethod != 'farmpickup')) {
                                                                                    _model.farmpickup = 'yes';
                                                                                    _model.deliveryMethod = 'farmpickup';
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    _model.farmpickup = null;
                                                                                    _model.deliveryMethod = null;
                                                                                    safeSetState(() {});
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color: _model.farmpickup == 'yes' ? Color(0x0D3BB273) : FlutterFlowTheme.of(context).card,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: Border.all(
                                                                                      color: _model.farmpickup == 'yes' ? FlutterFlowTheme.of(context).primarytheme : FlutterFlowTheme.of(context).boderdivder,
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Align(
                                                                                                alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                                child: Builder(
                                                                                                  builder: (context) {
                                                                                                    if (_model.farmpickup == 'yes') {
                                                                                                      return FaIcon(
                                                                                                        FaIconData(const IconData(/* solidDotCircle */ 0xf192, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter')),
                                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                        size: 24.0,
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Container(
                                                                                                        width: 21.0,
                                                                                                        height: 21.0,
                                                                                                        decoration: BoxDecoration(
                                                                                                          shape: BoxShape.circle,
                                                                                                          border: Border.all(
                                                                                                            color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    FFLocalizations.of(context).getText(
                                                                                                      'k3ndusuh' /* Farm Pickup */,
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                                          fontSize: 16.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    FFLocalizations.of(context).getText(
                                                                                                      '7xls1wha' /* Pick up directly */,
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          fontSize: 14.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(height: 5.0)),
                                                                                              ),
                                                                                            ].divide(SizedBox(width: 10.0)),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            '9vc5t66t' /* Free */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Visibility(
                                                                              visible: pageViewFarmsRecord.selfManagedSetup.ownDelivery &&
                                                                                  deliveryMinimumMet,
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  if ((_model.farmpickup != 'no') && (_model.deliveryMethod != 'delivery')) {
                                                                                    _model.farmpickup = 'no';
                                                                                    _model.deliveryMethod = 'delivery';
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    _model.farmpickup = null;
                                                                                    _model.deliveryMethod = null;
                                                                                    safeSetState(() {});
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color: _model.deliveryMethod == 'delivery' ? Color(0x0D3BB273) : FlutterFlowTheme.of(context).card,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: Border.all(
                                                                                      color: _model.deliveryMethod == 'delivery' ? FlutterFlowTheme.of(context).primarytheme : FlutterFlowTheme.of(context).boderdivder,
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Builder(
                                                                                                builder: (context) {
                                                                                                  if (_model.deliveryMethod == 'delivery') {
                                                                                                    return FaIcon(
                                                                                                      FaIconData(const IconData(/* solidDotCircle */ 0xf192, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter')),
                                                                                                      color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                      size: 24.0,
                                                                                                    );
                                                                                                  } else {
                                                                                                    return Container(
                                                                                                      width: 21.0,
                                                                                                      height: 21.0,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        border: Border.all(
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                  }
                                                                                                },
                                                                                              ),
                                                                                              Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    FFLocalizations.of(context).getText(
                                                                                                      'wnwpccca' /* Farm Delivery */,
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                                          fontSize: 16.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    FFLocalizations.of(context).getText(
                                                                                                      'q9iypyxk' /* Delivered by the Farm directly */,
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          fontSize: 14.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.normal,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(height: 5.0)),
                                                                                              ),
                                                                                            ].divide(SizedBox(width: 10.0)),
                                                                                          ),
                                                                                        ),
                                                                                        Align(
                                                                                          alignment: AlignmentDirectional(1.0, 0.0),
                                                                                          child: Text(
                                                                                            FFLocalizations.of(context).getText(
                                                                                              'wlmmuenv' /* Charges */,
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                10.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(),
                                                                              child: Visibility(
                                                                                visible: pageViewFarmsRecord.agricooDelivery &&
                                                                                    deliveryMinimumMet,
                                                                                child: InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    if ((_model.farmpickup != 'no') && (_model.deliveryMethod != 'delivery')) {
                                                                                      _model.farmpickup = 'no';
                                                                                      _model.deliveryMethod = 'uber';
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      _model.farmpickup = null;
                                                                                      _model.deliveryMethod = null;
                                                                                      safeSetState(() {});
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    decoration: BoxDecoration(
                                                                                      color: _model.deliveryMethod == 'uber' ? Color(0x0D3BB273) : FlutterFlowTheme.of(context).card,
                                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                                      border: Border.all(
                                                                                        color: _model.deliveryMethod == 'uber' ? FlutterFlowTheme.of(context).primarytheme : FlutterFlowTheme.of(context).boderdivder,
                                                                                      ),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(12.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Flexible(
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Builder(
                                                                                                  builder: (context) {
                                                                                                    if (_model.deliveryMethod == 'uber') {
                                                                                                      return FaIcon(
                                                                                                        FaIconData(const IconData(/* solidDotCircle */ 0xf192, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter')),
                                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                        size: 24.0,
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Container(
                                                                                                        width: 21.0,
                                                                                                        height: 21.0,
                                                                                                        decoration: BoxDecoration(
                                                                                                          shape: BoxShape.circle,
                                                                                                          border: Border.all(
                                                                                                            color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                                Column(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      FFLocalizations.of(context).getText(
                                                                                                        'fw9wspbp' /* Agricoo delivery */,
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: 'Satoshi',
                                                                                                            color: FlutterFlowTheme.of(context).textprimary,
                                                                                                            fontSize: 16.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                          ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      FFLocalizations.of(context).getText(
                                                                                                        'nrvkre0y' /* Delivered by the Uber directly */,
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: 'Satoshi',
                                                                                                            color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                            fontSize: 14.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FontWeight.normal,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ].divide(SizedBox(height: 5.0)),
                                                                                                ),
                                                                                              ].divide(SizedBox(width: 10.0)),
                                                                                            ),
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: AlignmentDirectional(1.0, 0.0),
                                                                                            child: Text(
                                                                                              FFLocalizations.of(context).getText(
                                                                                                'wv0pqcfi' /* Charges */,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Satoshi',
                                                                                                    color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                    letterSpacing: 0.0,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if ((_model.farmpickup ==
                                                                        'no') &&
                                                                    deliveryMinimumMet &&
                                                                    (pageViewFarmsRecord
                                                                            .selfManagedSetup
                                                                            .ownDelivery ||
                                                                        pageViewFarmsRecord
                                                                            .agricooDelivery))
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .card,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .boderdivder,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Builder(
                                                                      builder:
                                                                          (context) {
                                                                        if ((columnUsersRecord.deliveryAddresses.isNotEmpty) ==
                                                                            true) {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.all(12.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  FFLocalizations.of(context).getText(
                                                                                    '7id364xz' /* Delivery Address */,
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Satoshi',
                                                                                        color: FlutterFlowTheme.of(context).textsecondary,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                        child: Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'lztswhnl' /* Full Name */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: double.infinity,
                                                                                        child: TextFormField(
                                                                                          controller: _model.textController1 ??= TextEditingController(
                                                                                            text: selectedDeliveryAddress?.fullName,
                                                                                          ),
                                                                                          focusNode: _model.textFieldFocusNode1,
                                                                                          autofocus: false,
                                                                                          enabled: true,
                                                                                          readOnly: true,
                                                                                          obscureText: false,
                                                                                          decoration: InputDecoration(
                                                                                            isDense: true,
                                                                                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            hintText: FFLocalizations.of(context).getText(
                                                                                              'enu74j2w' /* Enter your Name */,
                                                                                            ),
                                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            errorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedErrorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            filled: true,
                                                                                            fillColor: Color(0x03000003),
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                          enableInteractiveSelection: true,
                                                                                          validator: _model.textController1Validator.asValidator(context),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 8.0)),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                        child: Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'quj18qj6' /* Street Address */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: double.infinity,
                                                                                        child: TextFormField(
                                                                                          controller: _model.textController2 ??= TextEditingController(
                                                                                            text: selectedDeliveryAddress?.streetAdress,
                                                                                          ),
                                                                                          focusNode: _model.textFieldFocusNode2,
                                                                                          autofocus: false,
                                                                                          enabled: true,
                                                                                          readOnly: true,
                                                                                          obscureText: false,
                                                                                          decoration: InputDecoration(
                                                                                            isDense: true,
                                                                                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            hintText: FFLocalizations.of(context).getText(
                                                                                              'ifh4n7vn' /* Enter Street Address */,
                                                                                            ),
                                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            errorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedErrorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            filled: true,
                                                                                            fillColor: Color(0x03000003),
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                          enableInteractiveSelection: true,
                                                                                          validator: _model.textController2Validator.asValidator(context),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 8.0)),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                        child: Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'p413qawq' /* Phone Number */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: double.infinity,
                                                                                        child: TextFormField(
                                                                                          controller: _model.textController3 ??= TextEditingController(
                                                                                            text: selectedDeliveryAddress?.phoneNo,
                                                                                          ),
                                                                                          focusNode: _model.textFieldFocusNode3,
                                                                                          autofocus: false,
                                                                                          enabled: true,
                                                                                          readOnly: true,
                                                                                          obscureText: false,
                                                                                          decoration: InputDecoration(
                                                                                            isDense: true,
                                                                                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            hintText: FFLocalizations.of(context).getText(
                                                                                              'arz57nh8' /* Enter Phone Number */,
                                                                                            ),
                                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).boderdivder,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            errorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            focusedErrorBorder: OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                                width: 1.0,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            filled: true,
                                                                                            fillColor: Color(0x03000003),
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                          keyboardType: TextInputType.number,
                                                                                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                          enableInteractiveSelection: true,
                                                                                          validator: _model.textController3Validator.asValidator(context),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 8.0)),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        context.pushNamed(DeliveryAddressWidget.routeName);
                                                                                      },
                                                                                      child: Text(
                                                                                        FFLocalizations.of(context).getText(
                                                                                          'oshzyp78' /* change address */,
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                              letterSpacing: 0.0,
                                                                                              decoration: TextDecoration.underline,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  context.pushNamed(DeliveryAddressWidget.routeName);
                                                                                },
                                                                                child: Text(
                                                                                  FFLocalizations.of(context).getText(
                                                                                    'dmgoukdz' /* Add address */,
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Satoshi',
                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        decoration: TextDecoration.underline,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onDoubleTap:
                                                                        () async {},
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        var _shouldSetState =
                                                                            false;
                                                                        if (!deliveryMinimumMet &&
                                                                            _model.farmpickup !=
                                                                                'yes') {
                                                                          if (pageViewFarmsRecord
                                                                              .selfManagedSetup
                                                                              .clickCollect) {
                                                                            _model.farmpickup =
                                                                                'yes';
                                                                            _model.deliveryMethod =
                                                                                'farmpickup';
                                                                            _model.fee =
                                                                                0.0;
                                                                            _model.isAgricodeliver =
                                                                                false;
                                                                            _shouldSetState =
                                                                                true;
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text(
                                                                                  FFLocalizations.of(context).getVariableText(
                                                                                    enText: 'Your order is below the delivery minimum. Add more items to enable delivery.',
                                                                                    frText: 'Votre commande est inférieure au minimum de livraison. Ajoutez des articles pour activer la livraison.',
                                                                                  ),
                                                                                  style: TextStyle(
                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                  ),
                                                                                ),
                                                                                duration: Duration(milliseconds: 4000),
                                                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                              ),
                                                                            );
                                                                            return;
                                                                          }
                                                                        }
                                                                        if (_model.farmpickup !=
                                                                                null &&
                                                                            _model.farmpickup !=
                                                                                '') {
                                                                          if (_model.farmpickup ==
                                                                              'yes') {
                                                                            _model.fee =
                                                                                0.0;
                                                                            safeSetState(() {});
                                                                            _model.deliveryMethod =
                                                                                null;
                                                                            _model.isAgricodeliver =
                                                                                false;
                                                                            safeSetState(() {});
                                                                            await _model.pageViewController?.nextPage(
                                                                              duration: Duration(milliseconds: 300),
                                                                              curve: Curves.ease,
                                                                            );
                                                                            if (_shouldSetState)
                                                                              safeSetState(() {});
                                                                            return;
                                                                          } else {
                                                                            if (columnUsersRecord.deliveryAddresses.isNotEmpty) {
                                                                              _model.postal1 = await actions.checkruleofLocation(
                                                                                pageViewFarmsRecord.farmLocation,
                                                                                valueOrDefault<double>(
                                                                                  pageViewFarmsRecord.selfManagedSetup.deliveryRadiuskm,
                                                                                  0.0,
                                                                                ),
                                                                                selectedDeliveryAddress?.location,
                                                                              );
                                                                              _shouldSetState = true;
                                                                              if (() {
                                                                                if (_model.deliveryMethod == 'uber') {
                                                                                  return false;
                                                                                } else if (pageViewFarmsRecord.selfManagedSetup.ownDelivery) {
                                                                                  return (_model.postal1! ? true : !pageViewFarmsRecord.agricooDelivery);
                                                                                } else {
                                                                                  return false;
                                                                                }
                                                                              }()) {
                                                                                if (_model.postal1!) {
                                                                                  if (functions.meetsFarmMinimumOrder(
                                                                                    functions.totalsales(
                                                                                        containerCartRecordList
                                                                                            .toList()),
                                                                                    pageViewFarmsRecord
                                                                                        .selfManagedSetup
                                                                                        .minimumAmmount,
                                                                                  )) {
                                                                                    _model.fee = functions.selfManagedDeliveryFee(
                                                                                      functions.totalsales(
                                                                                          containerCartRecordList
                                                                                              .toList()),
                                                                                      pageViewFarmsRecord
                                                                                          .selfManagedSetup
                                                                                          .freedelievryAmmount,
                                                                                      pageViewFarmsRecord
                                                                                          .selfManagedSetup
                                                                                          .flatDeliveryFee,
                                                                                    );
                                                                                    _model.isAgricodeliver = false;
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(
                                                                                        content: Text(
                                                                                          FFLocalizations.of(context).getVariableText(
                                                                                            enText: 'Your order is below the minimum order amount for delivery.',
                                                                                            frText: 'Votre commande est inférieure au montant minimum pour la livraison.',
                                                                                          ),
                                                                                          style: TextStyle(
                                                                                            color: FlutterFlowTheme.of(context).textprimary,
                                                                                          ),
                                                                                        ),
                                                                                        duration: Duration(milliseconds: 4000),
                                                                                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                      ),
                                                                                    );
                                                                                    if (_shouldSetState) safeSetState(() {});
                                                                                    return;
                                                                                  }
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(
                                                                                      content: Text(
                                                                                        FFLocalizations.of(context).getVariableText(
                                                                                          enText: 'This product is not available for delivery in your area. Please select a different address.',
                                                                                          frText: 'Ce produit n\'est pas disponible pour la livraison dans votre région. Veuillez sélectionner une autre adresse.',
                                                                                        ),
                                                                                        style: TextStyle(
                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                        ),
                                                                                      ),
                                                                                      duration: Duration(milliseconds: 4000),
                                                                                      backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                    ),
                                                                                  );
                                                                                  if (_shouldSetState) safeSetState(() {});
                                                                                  return;
                                                                                }
                                                                              } else {
                                                                                if (pageViewFarmsRecord.agricooDelivery) {
                                                                                  _model.apiResultzlq = await ValidateAccessCall.call(
                                                                                    address: '${selectedDeliveryAddress?.streetAdress ?? ''}',
                                                                                  );

                                                                                  _shouldSetState = true;
                                                                                  if ((_model.apiResultzlq?.succeeded ?? true)) {
                                                                                    if (!ValidateAccessCall.issupported(
                                                                                      (_model.apiResultzlq?.jsonBody ?? ''),
                                                                                    )!) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                            ValidateAccessCall.message(
                                                                                              (_model.apiResultzlq?.jsonBody ?? ''),
                                                                                            )!,
                                                                                            style: TextStyle(
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                            ),
                                                                                          ),
                                                                                          duration: Duration(milliseconds: 4000),
                                                                                          backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                        ),
                                                                                      );
                                                                                      if (_shouldSetState) safeSetState(() {});
                                                                                      return;
                                                                                    }
                                                                                    _model.farmaddress2 = await actions.getAddressFromLatLng(
                                                                                      pageViewFarmsRecord.farmLocation!,
                                                                                    );
                                                                                    _shouldSetState = true;
                                                                                    _model.apiResultmei = await GetDeliveryQuoteCall.call(
                                                                                      pickupAddress: _model.farmaddress2,
                                                                                      dropoffAddress: '${selectedDeliveryAddress?.streetAdress ?? ''}',
                                                                                    );

                                                                                    _shouldSetState = true;
                                                                                    if ((_model.apiResultmei?.succeeded ?? true)) {
                                                                                      _model.fee = GetDeliveryQuoteCall.fee(
                                                                                            (_model.apiResultmei?.jsonBody ?? ''),
                                                                                          )!
                                                                                              .toDouble() /
                                                                                          100;
                                                                                      _model.isAgricodeliver = true;
                                                                                      safeSetState(() {});
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                            GetDeliveryQuoteCall.error(
                                                                                              (_model.apiResultmei?.jsonBody ?? ''),
                                                                                            )!,
                                                                                            style: TextStyle(
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                            ),
                                                                                          ),
                                                                                          duration: Duration(milliseconds: 4000),
                                                                                          backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                        ),
                                                                                      );
                                                                                      if (_shouldSetState) safeSetState(() {});
                                                                                      return;
                                                                                    }
                                                                                  } else {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(
                                                                                        content: Text(
                                                                                          ValidateAccessCall.message(
                                                                                            (_model.apiResultzlq?.jsonBody ?? ''),
                                                                                          )!,
                                                                                          style: TextStyle(
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                          ),
                                                                                        ),
                                                                                        duration: Duration(milliseconds: 4000),
                                                                                        backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                      ),
                                                                                    );
                                                                                    if (_shouldSetState) safeSetState(() {});
                                                                                    return;
                                                                                  }
                                                                                } else {
                                                                                  if (_shouldSetState) safeSetState(() {});
                                                                                  return;
                                                                                }
                                                                              }

                                                                              await _model.pageViewController?.nextPage(
                                                                                duration: Duration(milliseconds: 300),
                                                                                curve: Curves.ease,
                                                                              );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text(
                                                                                    'Please  Add Address',
                                                                                    style: TextStyle(
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                    ),
                                                                                  ),
                                                                                  duration: Duration(milliseconds: 4000),
                                                                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                ),
                                                                              );
                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }
                                                                          }
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'please select delivery method',
                                                                                style: TextStyle(
                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                ),
                                                                              ),
                                                                              duration: Duration(milliseconds: 4000),
                                                                              backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                            ),
                                                                          );
                                                                          if (_shouldSetState)
                                                                            safeSetState(() {});
                                                                          return;
                                                                        }

                                                                        if (_shouldSetState)
                                                                          safeSetState(
                                                                              () {});
                                                                      },
                                                                      text: FFLocalizations.of(
                                                                              context)
                                                                          .getText(
                                                                        '98lfe7qd' /* Continue */,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            48.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).card,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).boderdivder,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(12.0),
                                                                          child:
                                                                              StreamBuilder<List<ConfigRecord>>(
                                                                            stream:
                                                                                queryConfigRecord(
                                                                              singleRecord: true,
                                                                            ),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              // Customize what your widget looks like when it's loading.
                                                                              if (!snapshot.hasData) {
                                                                                return Center(
                                                                                  child: SizedBox(
                                                                                    width: 50.0,
                                                                                    height: 50.0,
                                                                                    child: CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                                                        FlutterFlowTheme.of(context).primarytheme,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                              List<ConfigRecord> columnConfigRecordList = snapshot.data!;
                                                                              final columnConfigRecord = columnConfigRecordList.isNotEmpty ? columnConfigRecordList.first : null;

                                                                              return Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                                                                    child: Text(
                                                                                      FFLocalizations.of(context).getText(
                                                                                        '8wt9y803' /* Bill Details */,
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Satoshi',
                                                                                            color: FlutterFlowTheme.of(context).textsecondary,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  StreamBuilder<List<CartRecord>>(
                                                                                    stream: queryCartRecord(
                                                                                      parent: currentUserReference,
                                                                                    ),
                                                                                    builder: (context, snapshot) {
                                                                                      // Customize what your widget looks like when it's loading.
                                                                                      if (!snapshot.hasData) {
                                                                                        return Center(
                                                                                          child: SizedBox(
                                                                                            width: 50.0,
                                                                                            height: 50.0,
                                                                                            child: CircularProgressIndicator(
                                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                                FlutterFlowTheme.of(context).primarytheme,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                      List<CartRecord> columnCartRecordList = snapshot.data!;

                                                                                      return Builder(
                                                                                        builder: (context) {
                                                                                          final listItem = columnCartRecordList.toList();

                                                                                          return Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                                                                                            crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
                                                                                            textBaseline: TextBaseline.alphabetic,
                                                                                            children: List.generate(listItem.length, (listItemIndex) {
                                                                                              final listItemItem = listItem[listItemIndex];
                                                                                              return Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                                                                                                crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
                                                                                                textBaseline: TextBaseline.alphabetic,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                                                                                                      crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                                                                                                      textBaseline: TextBaseline.alphabetic,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          FFLocalizations.of(context).getText(
                                                                                                            '51xq2vx4' /* Product */,
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: 'Satoshi',
                                                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                              ),
                                                                                                        ),
                                                                                                        if (listItemItem.isVariableWeight)
                                                                                                          Text(
                                                                                                            'Selected bracket: ${listItemItem.minWeight.toString()} - ${listItemItem.maxWeight.toString()} kg',
                                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                  fontFamily: 'Satoshi',
                                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                ),
                                                                                                          ),
                                                                                                        if (listItemItem.isVariableWeight)
                                                                                                          Text(
                                                                                                            'Deposit due: ${FFLocalizations.of(context).languageCode == 'fr' ? '€' : '\$'}${functions.totalsales([listItemItem]).toStringAsFixed(2)}',
                                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                                  fontFamily: 'Satoshi',
                                                                                                                  color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                ),
                                                                                                          ),
                                                                                                      ].divide(SizedBox(height: 4.0)),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'x${listItemItem.quantity.toString()}',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(width: 10.0)),
                                                                                              );
                                                                                            }).divide(SizedBox(height: 8.0)),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        FFLocalizations.of(context).getText(
                                                                                          '5qs1gck7' /* Items charged now */,
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                              fontSize: 16.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Text(
                                                                                            '${FFLocalizations.of(context).languageCode == 'fr' ? '€' : '\$'}${functions.totalsales(containerCartRecordList.toList()).toStringAsFixed(2)}',
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                          ),
                                                                                        ].divide(SizedBox(width: 12.0)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'bkj5vxmz' /* Platform fee */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            if (FFLocalizations.of(context).languageCode != 'fr')
                                                                                              Text(
                                                                                                FFLocalizations.of(context).getText(
                                                                                                  'ri8vndzg' /* $ */,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                              ),
                                                                                            Text(
                                                                                              valueOrDefault<String>(
                                                                                                functions.platformfees(
                                                                                                    functions.cartTotal(containerCartRecordList.toList()),
                                                                                                    columnConfigRecord?.platformFeeOrNull,
                                                                                                    columnConfigRecord?.platformFeeCapOrNull),
                                                                                                '0',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Satoshi',
                                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                                    fontSize: 16.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                            ),
                                                                                            if (FFLocalizations.of(context).languageCode == 'fr')
                                                                                              Text(
                                                                                                FFLocalizations.of(context).getText(
                                                                                                  'h5e60vik' /* € */,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                              ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'bgdlmlmp' /* Delivery Fees */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            if (FFLocalizations.of(context).languageCode != 'fr')
                                                                                              Text(
                                                                                                FFLocalizations.of(context).getText(
                                                                                                  '91x7pldz' /* $ */,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                              ),
                                                                                            Text(
                                                                                              _model.farmpickup == 'no'
                                                                                                  ? valueOrDefault<String>(
                                                                                                      _model.fee
                                                                                                          ?.toStringAsFixed(2),
                                                                                                      '0',
                                                                                                    )
                                                                                                  : '0',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Satoshi',
                                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                                    fontSize: 16.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                            ),
                                                                                            if (FFLocalizations.of(context).languageCode == 'fr')
                                                                                              Text(
                                                                                                FFLocalizations.of(context).getText(
                                                                                                  'pc28s6lo' /* € */,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                              ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  if (false)
                                                                                    StyledDivider(
                                                                                      height: 0.0,
                                                                                      thickness: 2.0,
                                                                                      color: FlutterFlowTheme.of(context).boderdivder,
                                                                                      lineStyle: DividerLineStyle.dashed,
                                                                                    ),
                                                                                  if (false)
                                                                                    StyledDivider(
                                                                                      height: 0.0,
                                                                                      thickness: 2.0,
                                                                                      color: FlutterFlowTheme.of(context).boderdivder,
                                                                                      lineStyle: DividerLineStyle.dashed,
                                                                                    ),
                                                                                  if (false)
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            FFLocalizations.of(context).getText(
                                                                                              'vep8y23n' /* Delivery Partner Fee */,
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            FFLocalizations.of(context).getText(
                                                                                              'so6mqfbx' /* $2.00 */,
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  if (false)
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            FFLocalizations.of(context).getText(
                                                                                              's3p4ae0h' /* GST and Charges */,
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            FFLocalizations.of(context).getText(
                                                                                              'vzdqkqwk' /* $1.10 */,
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  if (false)
                                                                                    StyledDivider(
                                                                                      height: 0.0,
                                                                                      thickness: 2.0,
                                                                                      color: FlutterFlowTheme.of(context).boderdivder,
                                                                                      lineStyle: DividerLineStyle.dashed,
                                                                                    ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        // Uber's pre-order display quote is an
                                                                                        // estimate; the bound backend quote and
                                                                                        // PaymentSheet amount are authoritative.
                                                                                        FFLocalizations.of(context).getVariableText(
                                                                                          enText: _model.deliveryMethod == 'uber'
                                                                                              ? 'Estimated total'
                                                                                              : 'Total to pay now',
                                                                                          frText: _model.deliveryMethod == 'uber'
                                                                                              ? 'Total estimé'
                                                                                              : 'Total à payer maintenant',
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                              fontSize: 16.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          if (FFLocalizations.of(context).languageCode != 'fr')
                                                                                            Text(
                                                                                              FFLocalizations.of(context).getText(
                                                                                                'h1ary2hl' /* $ */,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Satoshi',
                                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                                    fontSize: 16.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                            ),
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                              (valueOrDefault<double>(
                                                                                                        functions.totalsales(containerCartRecordList.toList()),
                                                                                                        0.0,
                                                                                                      ) +
                                                                                                      (_model.farmpickup == 'no' ? _model.fee! : 0.0) +
                                                                                                      (functions.platformFeeAmount(
                                                                                                          functions.cartTotal(containerCartRecordList.toList()),
                                                                                                          columnConfigRecord?.platformFeeOrNull,
                                                                                                          columnConfigRecord?.platformFeeCapOrNull)))
                                                                                                  .toStringAsFixed(2),
                                                                                              '0',
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Satoshi',
                                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                          ),
                                                                                          if (FFLocalizations.of(context).languageCode == 'fr')
                                                                                            Text(
                                                                                              FFLocalizations.of(context).getText(
                                                                                                'zu5b0qqc' /* € */,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Satoshi',
                                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                                    fontSize: 16.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                            ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        height:
                                                                            24.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        1.0),
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed: () async {
                                                                    // Checkout-v1: the backend owns order creation, inventory
                                                                    // reservations, payment finalization and cart-safe completion.
                                                                    if (_model.isPaymentInProgress) {
                                                                      return;
                                                                    }
                                                                    _model.isPaymentInProgress = true;
                                                                    safeSetState(() {});
                                                                    try {
                                                                      await _startCheckoutV1Payment(
                                                                        farm: pageViewFarmsRecord,
                                                                        selectedCart: containerCartRecordList,
                                                                        selectedAddress: selectedDeliveryAddress,
                                                                      );
                                                                    } catch (_) {
                                                                      _showCheckoutMessage(
                                                                        en: 'We could not complete the checkout. Your order is saved — please retry shortly.',
                                                                        fr: "Nous n'avons pas pu finaliser la commande. Votre commande est enregistrée — veuillez réessayer.",
                                                                      );
                                                                    } finally {
                                                                      _model.isPaymentInProgress = false;
                                                                      safeSetState(() {});
                                                                    }
                                                                  },

                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'dgltazmy' /* Pay */,
                                                                  ),
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        48.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primarytheme,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Satoshi',
                                                                          color:
                                                                              Colors.white,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 16.0),
                                                    child: smooth_page_indicator
                                                        .SmoothPageIndicator(
                                                      controller: _model
                                                              .pageViewController ??=
                                                          PageController(
                                                              initialPage: 0),
                                                      count: 2,
                                                      axisDirection:
                                                          Axis.horizontal,
                                                      onDotClicked: (i) async {
                                                        await _model
                                                            .pageViewController!
                                                            .animateToPage(
                                                          i,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves.ease,
                                                        );
                                                        safeSetState(() {});
                                                      },
                                                      effect:
                                                          smooth_page_indicator
                                                              .SlideEffect(
                                                        spacing: 16.0,
                                                        radius: 8.0,
                                                        dotWidth: 104.0,
                                                        dotHeight: 4.0,
                                                        dotColor:
                                                            Color(0xFFE2E6EA),
                                                        activeDotColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primarytheme,
                                                        paintStyle:
                                                            PaintingStyle.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                if (columnUsersRecord.isSuspend)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 4.0,
                                        sigmaY: 4.0,
                                      ),
                                      child: wrapWithModel(
                                        model: _model.suspendModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: SuspendWidget(
                                          action: () async {
                                            context.pushNamed(
                                                HelpandsupportWidget.routeName);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
