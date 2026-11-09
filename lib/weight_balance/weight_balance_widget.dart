import '/backend/backend.dart';
import '/backend/currency/currency_utils.dart';
import '/components/customer_refund_status_card.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'weight_balance_model.dart';
export 'weight_balance_model.dart';

/// DSL page WeightBalance
class WeightBalanceWidget extends StatefulWidget {
  const WeightBalanceWidget({
    super.key,
    this.orderRef,
  });

  final DocumentReference? orderRef;

  static String routeName = 'WeightBalance';
  static String routePath = '/weight-balance';

  @override
  State<WeightBalanceWidget> createState() => _WeightBalanceWidgetState();
}

class _WeightBalanceWidgetState extends State<WeightBalanceWidget> {
  late WeightBalanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeightBalanceModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: FlutterFlowIconButton(
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'l9wrweck' /* Final weights & balance */,
            ),
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Satoshi',
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<OrderRecord>(
            stream: OrderRecord.getDocument(widget.orderRef!),
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

              final containerOrderRecord = snapshot.data!;

              final balanceStatus =
                  containerOrderRecord.balancePaymentStatus;
              final hasPositiveBalance =
                  containerOrderRecord.finalBalanceAmount > 0;
              final isVariableOrder =
                  containerOrderRecord.isVariableWeightOrder;
              final canPayBalance = isVariableOrder &&
                  hasPositiveBalance &&
                  (balanceStatus == 'payment_requested' ||
                      balanceStatus == 'failed') &&
                  (!_model.isPaymentProcessing || balanceStatus == 'failed');
              final showAwaitingConfirmation = isVariableOrder &&
                  balanceStatus == 'payment_requested' &&
                  _model.isPaymentProcessing;
              final showNoPaymentRequired = isVariableOrder &&
                  !hasPositiveBalance &&
                  (balanceStatus == 'payment_requested' ||
                      balanceStatus == 'failed');
              final showRetryMessage = isVariableOrder &&
                  balanceStatus == 'failed' &&
                  hasPositiveBalance;
              final showPaidMessage = isVariableOrder && balanceStatus == 'paid';

              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                  crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).card,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).boderdivder,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.start).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'arytxpxk' /* Producer-confirmed weights */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textprimary,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '4ese6hbt' /* Review the final weights and r... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textsecondary,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.spaceBetween)
                                        .flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.center).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'nzpxrk75' /* Product total */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    formatLanguageCurrency(containerOrderRecord.finalTotalAmount, FFLocalizations.of(context).languageCode),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.spaceBetween)
                                        .flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.center).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'snmbsx06' /* Platform fee */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    formatLanguageCurrency(containerOrderRecord.serviceFee, FFLocalizations.of(context).languageCode),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.spaceBetween)
                                        .flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.center).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'x9ac6ovy' /* Deposit already paid */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    formatLanguageCurrency(containerOrderRecord.initialDepositPaid, FFLocalizations.of(context).languageCode),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.spaceBetween)
                                        .flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.center).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'ccjwyb9h' /* Total order amount */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    formatLanguageCurrency(containerOrderRecord.totalAmmount, FFLocalizations.of(context).languageCode),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.spaceBetween)
                                        .flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.center).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'pb6invig' /* Balance due */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    formatLanguageCurrency(containerOrderRecord.finalBalanceAmount, FFLocalizations.of(context).languageCode),
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                        ),
                      ),
                    ),
                    CustomerRefundStatusCard(
                      order: containerOrderRecord,
                      margin: EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 12.0),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final item = containerOrderRecord.orderItems.toList();

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemCount: item.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.0),
                            itemBuilder: (context, itemIndex) {
                              final itemItem = item[itemIndex];
                              return Visibility(
                                visible: itemItem.isVariableWeight,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).card,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .boderdivder,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            (FFMainAxisAlignment.start)
                                                .flutterValue,
                                        crossAxisAlignment:
                                            (FFCrossAxisAlignment.start)
                                                .flutterValue,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          StreamBuilder<ProductRecord>(
                                            stream: ProductRecord.getDocument(
                                                itemItem.productRef!),
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
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              final containerProductRecord =
                                                  snapshot.data!;

                                              return Container(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      (FFMainAxisAlignment
                                                              .start)
                                                          .flutterValue,
                                                  crossAxisAlignment:
                                                      (FFCrossAxisAlignment
                                                              .center)
                                                          .flutterValue,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: CachedNetworkImage(
                                                        fadeInDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        fadeOutDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        imageUrl:
                                                            containerProductRecord
                                                                .productImage,
                                                        width: 64.0,
                                                        height: 64.0,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                          'assets/images/error_image.png',
                                                          width: 64.0,
                                                          height: 64.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            (FFMainAxisAlignment
                                                                    .start)
                                                                .flutterValue,
                                                        crossAxisAlignment:
                                                            (FFCrossAxisAlignment
                                                                    .start)
                                                                .flutterValue,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: [
                                                          Text(
                                                            containerProductRecord
                                                                .productName,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textprimary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Selected bracket: ${itemItem.minWeight.toString()} - ${itemItem.maxWeight.toString()} kg',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 4.0)),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 12.0)),
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            crossAxisAlignment:
                                                (FFCrossAxisAlignment.center)
                                                    .flutterValue,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'jjrlvxpd' /* Final weight */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Text(
                                                '${itemItem.actualWeight.toString()} kg x ${formatLanguageCurrency(itemItem.pricePerKg, FFLocalizations.of(context).languageCode)}/kg',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            crossAxisAlignment:
                                                (FFCrossAxisAlignment.center)
                                                    .flutterValue,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'txmmakfp' /* Quantity */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Text(
                                                '${itemItem.totalItems.toString()}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            crossAxisAlignment:
                                                (FFCrossAxisAlignment.center)
                                                    .flutterValue,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'xnqoyz0v' /* Deposit paid for this item */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Text(
                                                formatLanguageCurrency(itemItem.depositAmount, FFLocalizations.of(context).languageCode),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            crossAxisAlignment:
                                                (FFCrossAxisAlignment.center)
                                                    .flutterValue,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7t1wcvtf' /* Balance for this item */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Text(
                                                formatLanguageCurrency(itemItem.remainingBalance, FFLocalizations.of(context).languageCode),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primarytheme,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 10.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                      OrderDetailsWidget.routeName,
                                      queryParameters: {
                                        'orderRef': serializeParam(
                                          widget.orderRef,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'ay5kdcps' /* Contact */,
                                  ),
                                  icon: Icon(
                                    FFIcons.kchat,
                                    size: 24.0,
                                  ),
                                  options: FFButtonOptions(
                                    width: 100.0,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconAlignment: IconAlignment.end,
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconColor:
                                        FlutterFlowTheme.of(context).offwhite,
                                    color: FlutterFlowTheme.of(context)
                                        .primarytheme,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              if (canPayBalance)
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.isPaymentProcessing &&
                                          containerOrderRecord
                                                  .balancePaymentStatus !=
                                              'failed') {
                                        return;
                                      }
                                      _model.isPaymentProcessing = true;
                                      safeSetState(() {});

                                      final result =
                                          await actions.flutterStripeDirect(
                                        context,
                                        null,
                                        containerOrderRecord.reference.id,
                                        null,
                                        FFLocalizations.of(context)
                                            .languageCode,
                                        null,
                                        null,
                                        isBalancePayment: true,
                                      );

                                      if (!mounted) {
                                        return;
                                      }

                                      final localizations =
                                          FFLocalizations.of(context);
                                      String message;
                                      var keepProcessing = false;

                                      switch (result) {
                                        case 'sheetCompleted':
                                        case 'alreadyConfirmed':
                                          keepProcessing = true;
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'Payment submitted — awaiting confirmation. The order will update once the payment is confirmed.',
                                            frText:
                                                'Paiement soumis — en attente de confirmation. La commande sera mise à jour dès que le paiement sera confirmé.',
                                          );
                                          break;
                                        case 'alreadyPaid':
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'The balance is already paid.',
                                            frText:
                                                'Le solde est déjà payé.',
                                          );
                                          break;
                                        case 'noPaymentRequired':
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'No additional payment is required.',
                                            frText:
                                                'Aucun paiement supplémentaire n’est requis.',
                                          );
                                          break;
                                        case 'refundDue':
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'No additional payment is required.',
                                            frText:
                                                'Aucun paiement supplémentaire n’est requis.',
                                          );
                                          break;
                                        case 'cancelled':
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'Payment was cancelled. You can try again.',
                                            frText:
                                                'Le paiement a été annulé. Vous pouvez réessayer.',
                                          );
                                          break;
                                        case 'ambiguous':
                                          keepProcessing = true;
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'We could not confirm the payment yet. Please do not pay again; the order will update once the payment is confirmed.',
                                            frText:
                                                'Nous n’avons pas encore pu confirmer le paiement. Ne payez pas à nouveau ; la commande sera mise à jour dès que le paiement sera confirmé.',
                                          );
                                          break;
                                        default:
                                          message = localizations
                                              .getVariableText(
                                            enText:
                                                'The payment could not be completed. You can try again.',
                                            frText:
                                                'Le paiement n’a pas pu être effectué. Vous pouvez réessayer.',
                                          );
                                      }

                                      _model.isPaymentProcessing = keepProcessing;
                                      safeSetState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            message,
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(
                                                      context)
                                                  .secondaryBackground,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 6000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                        ),
                                      );
                                    },
                                    text: FFLocalizations.of(context).getText(
                                      '7zm7brii' /* Pay balance */,
                                    ),
                                    options: FFButtonOptions(
                                      width: 200.0,
                                      height: 52.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .primarytheme,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            letterSpacing: 0.0,
                                          ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                            ].divide(SizedBox(width: 10.0)),
                          ),
                          if (showAwaitingConfirmation)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getVariableText(
                                  enText:
                                      'Payment submitted — awaiting confirmation.',
                                  frText:
                                      'Paiement soumis — en attente de confirmation.',
                                ),
                                textAlign: TextAlign.center,
                                style:
                                    FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          if (showPaidMessage)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getVariableText(
                                  enText: 'Balance payment completed',
                                  frText: 'Solde payé',
                                ),
                                textAlign: TextAlign.center,
                                style:
                                    FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          if (showNoPaymentRequired)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getVariableText(
                                  enText:
                                      'No additional payment is required.',
                                  frText:
                                      'Aucun paiement supplémentaire n’est requis.',
                                ),
                                textAlign: TextAlign.center,
                                style:
                                    FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                          if (showRetryMessage)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getVariableText(
                                  enText:
                                      'Your previous payment failed. You can try again.',
                                  frText:
                                      'Votre précédent paiement a échoué. Vous pouvez réessayer.',
                                ),
                                textAlign: TextAlign.center,
                                style:
                                    FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                              ),
                            ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
