import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/currency/currency_utils.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/components/add_weight_order_widget.dart';
import '/components/rejectorder_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'orderdatails_model.dart';
export 'orderdatails_model.dart';

class OrderdatailsWidget extends StatefulWidget {
  const OrderdatailsWidget({
    super.key,
    required this.orderRef,
  });

  final DocumentReference? orderRef;

  @override
  State<OrderdatailsWidget> createState() => _OrderdatailsWidgetState();
}

class _OrderdatailsWidgetState extends State<OrderdatailsWidget> {
  late OrderdatailsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderdatailsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
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

          return Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.7,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).offwhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'bi48h8n2' /* Order Details */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textprimary,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 15.0,
                                buttonSize: 30.0,
                                fillColor:
                                    FlutterFlowTheme.of(context).textprimary,
                                icon: Icon(
                                  Icons.close,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 14.0,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'e18f0ft6' /* Order Information */,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'i193f5n2' /* Order ID */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                  '${FFLocalizations.of(context).getVariableText(
                                    enText: 'ORD-',
                                    frText: 'ORD-',
                                  )}${containerOrderRecord.reference.id}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'wbu8xx5u' /* Date */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                  '${dateTimeFormat(
                                    "y MM",
                                    containerOrderRecord.createdAt,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  )}, ${dateTimeFormat(
                                    "jm",
                                    containerOrderRecord.createdAt,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  )}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '6dnyxfen' /* Status */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Container(
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    color: () {
                                      if (containerOrderRecord.orderStatus ==
                                          'Approved') {
                                        return Color(0x1F3FA9F5);
                                      } else if (containerOrderRecord
                                              .orderStatus ==
                                          'Delivered') {
                                        return Color(0x1A3BB273);
                                      } else if (containerOrderRecord
                                              .orderStatus ==
                                          'Preparing') {
                                        return Color(0x1CCB30E0);
                                      } else {
                                        return Color(0x1FF58D2A);
                                      }
                                    }(),
                                    borderRadius: BorderRadius.circular(99.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Text(
                                        containerOrderRecord.orderStatus,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Satoshi',
                                              color: () {
                                                if (containerOrderRecord
                                                        .orderStatus ==
                                                    'Approved') {
                                                  return FlutterFlowTheme.of(
                                                          context)
                                                      .primary;
                                                } else if (containerOrderRecord
                                                        .orderStatus ==
                                                    'Delivered') {
                                                  return FlutterFlowTheme.of(
                                                          context)
                                                      .primarytheme;
                                                } else if (containerOrderRecord
                                                        .orderStatus ==
                                                    'Preparing') {
                                                  return Color(0xFFCB30E0);
                                                } else {
                                                  return FlutterFlowTheme.of(
                                                          context)
                                                      .orange;
                                                }
                                              }(),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).boderdivder,
                            ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                        StreamBuilder<UsersRecord>(
                          stream: UsersRecord.getDocument(
                              containerOrderRecord.userRef!),
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

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'm8rttk2n' /* Customer Information */,
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'iophzt4u' /* Name */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Text(
                                      columnUsersRecord.displayName,
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'b7ug97ir' /* Email */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Text(
                                      columnUsersRecord.email,
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'hhqnypx5' /* Phone */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Text(
                                      columnUsersRecord.phoneNumber,
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
                                Divider(
                                  thickness: 2.0,
                                  color:
                                      FlutterFlowTheme.of(context).boderdivder,
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'eetmkfh9' /* Delivery Information */,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '1ym2xmhw' /* Method */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                  containerOrderRecord.delievryMethod,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'ikya4ttb' /* Address */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                  '${containerOrderRecord.delievryAddress.streetAdress}',
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
                            Divider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).boderdivder,
                            ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'eujldiyd' /* Order Items */,
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
                            Builder(
                              builder: (context) {
                                final orders =
                                    containerOrderRecord.orderItems.toList();

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(orders.length,
                                      (ordersIndex) {
                                    final ordersItem = orders[ordersIndex];
                                    return StreamBuilder<ProductRecord>(
                                      stream: ProductRecord.getDocument(
                                          ordersItem.productRef!),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
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

                                        final rowProductRecord = snapshot.data!;

                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: Duration(
                                                          milliseconds: 500),
                                                      fadeOutDuration: Duration(
                                                          milliseconds: 500),
                                                      imageUrl: rowProductRecord
                                                          .productImage,
                                                      width: 52.0,
                                                      height: 52.0,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Image.asset(
                                                        'assets/images/error_image.png',
                                                        width: 52.0,
                                                        height: 52.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(14.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${rowProductRecord.productName}${ordersItem.isVariableWeight ? (ordersItem.actualWeight > 0.0 ? ' (${formatNumber(
                                                              ordersItem
                                                                  .actualWeight,
                                                              formatType:
                                                                  FormatType
                                                                      .custom,
                                                              format: '#.##',
                                                              locale: '',
                                                            )} kg)' : ' (${formatNumber(
                                                              ordersItem
                                                                  .minWeight,
                                                              formatType:
                                                                  FormatType
                                                                      .custom,
                                                              format: '#.##',
                                                              locale: '',
                                                            )} - ${formatNumber(
                                                              ordersItem
                                                                  .maxWeight,
                                                              formatType:
                                                                  FormatType
                                                                      .custom,
                                                              format: '#.##',
                                                              locale: '',
                                                            )} kg)') : ''}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textprimary,
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          ordersItem
                                                                  .isVariableWeight
                                                              ? '${FFLocalizations.of(context).getVariableText(
                                                                  enText:
                                                                      'Quantity: ',
                                                                  frText:
                                                                      'Quantité : ',
                                                                )}${formatNumber(
                                                                  ordersItem
                                                                      .totalItems,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )}'
                                                              : '1${rowProductRecord.unit} x ${formatNumber(
                                                                  ordersItem
                                                                      .totalItems,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        if (ordersItem
                                                                .isVariableWeight &&
                                                            (ordersItem
                                                                    .actualWeight <=
                                                                0.0) &&
                                                            (containerOrderRecord
                                                                    .orderStatus ==
                                                                'Preparing'))
                                                          Builder(
                                                            builder: (context) =>
                                                                FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (dialogContext) {
                                                                    return Dialog(
                                                                      elevation:
                                                                          0,
                                                                      insetPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0)
                                                                          .resolve(
                                                                              Directionality.of(context)),
                                                                      child:
                                                                          AddWeightOrderWidget(
                                                                        orderRef:
                                                                            widget.orderRef,
                                                                        productRef:
                                                                            ordersItem.productRef,
                                                                        minWeight:
                                                                            ordersItem.minWeight,
                                                                        maxWeight:
                                                                            ordersItem.maxWeight,
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              text: FFLocalizations
                                                                      .of(context)
                                                                  .getVariableText(
                                                                enText:
                                                                    'Add/Update actual weight',
                                                                frText:
                                                                    'Ajouter/Mettre à jour le poids réel',
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 40.0,
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme,
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(6.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                          ordersItem.isVariableWeight
                                                              ? '${formatLanguageCurrency(ordersItem.pricePerKg, FFLocalizations.of(context).languageCode)}/kg'
                                                              : formatLanguageCurrency(rowProductRecord.price, FFLocalizations.of(context).languageCode),
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
                                          ],
                                        );
                                      },
                                    );
                                  }).divide(SizedBox(height: 5.0)),
                                );
                              },
                            ),
                            StyledDivider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).boderdivder,
                              lineStyle: DividerLineStyle.dashed,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'rvmyafq9' /* Deposit paid */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (FFLocalizations.of(context)
                                            .languageCode !=
                                        'fr')
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          'bf2rlx74' /* $ */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Satoshi',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .textprimary,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    Text(
                                      functions
                                          .ordertotal(containerOrderRecord
                                              .orderItems
                                              .toList())
                                          .toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    if (FFLocalizations.of(context)
                                            .languageCode ==
                                        'fr')
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          '8zrk58s6' /* € */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Satoshi',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .textprimary,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                  ],
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
                                    '1r1xugwj' /* Total for order */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                      formatLanguageCurrency(containerOrderRecord.totalAmmount, FFLocalizations.of(context).languageCode),
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
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).card,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (((containerOrderRecord.orderStatus !=
                                        'Delivered') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Rejected') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Canceled')) &&
                                (containerOrderRecord.trackingUrl != '') &&
                                (containerOrderRecord.isAgricoDeliver == true))
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await launchURL(
                                      containerOrderRecord.trackingUrl);
                                },
                                child: Container(
                                  height: 30.0,
                                  decoration: BoxDecoration(),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'ibnt910m' /* Track Delivery */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .orange,
                                            letterSpacing: 0.0,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            if ((containerOrderRecord.orderStatus ==
                                    'Preparing') &&
                                (containerOrderRecord.orderItems
                                        .where((e) =>
                                            e.isVariableWeight &&
                                            (e.actualWeight <= 0.0))
                                        .toList()
                                        .length >
                                    0))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Text(
                                  FFLocalizations.of(context).getVariableText(
                                    enText:
                                        'Add the actual weight for every weight-based product. The customer must complete the remaining payment before you can update the order status.',
                                    frText:
                                        'Ajoutez le poids réel de chaque produit vendu au poids. Le client doit régler le solde restant avant que vous puissiez mettre à jour le statut de la commande.',
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
                              ),
                            if (((containerOrderRecord.orderStatus !=
                                        'Delivered') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Rejected') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Canceled')) &&
                                (containerOrderRecord.delievryMethod ==
                                    'farmpickup'))
                              FFButtonWidget(
                                onPressed: () async {
                                  if ((containerOrderRecord.orderStatus ==
                                          'Preparing') &&
                                      (containerOrderRecord.orderItems
                                              .where((e) =>
                                                  e.isVariableWeight &&
                                                  (e.actualWeight <= 0.0))
                                              .toList()
                                              .length >
                                          0)) {
                                    await actions.toast(
                                      context,
                                      FFLocalizations.of(context)
                                          .getVariableText(
                                        enText:
                                            'Add the actual weight for every weight-based product. The customer must complete the remaining payment before you can update the order status.',
                                        frText:
                                            'Ajoutez le poids réel de chaque produit vendu au poids. Le client doit régler le solde restant avant que vous puissiez mettre à jour le statut de la commande.',
                                      ),
                                    );
                                    return;
                                  }
                                  if (containerOrderRecord.orderStatus ==
                                      'Pending') {
                                    await containerOrderRecord.reference
                                        .update(createOrderRecordData(
                                      orderStatus: 'Approved',
                                      orderConfiramtionTime:
                                          getCurrentTimestamp,
                                    ));
                                    triggerPushNotification(
                                      notificationTitle: 'Order Confirmed!',
                                      notificationText:
                                          'Your order ORD-${containerOrderRecord.reference.id} has been approved and confirmed.',
                                      userRefs: [containerOrderRecord.userRef!],
                                      initialPageName: 'OrderDetails',
                                      parameterData: {
                                        'orderRef':
                                            containerOrderRecord.reference,
                                      },
                                    );

                                    await containerOrderRecord.userRef!.update({
                                      ...mapToFirestore(
                                        {
                                          'notification_count':
                                              FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                  } else {
                                    if (containerOrderRecord.orderStatus ==
                                        'Approved') {
                                      await containerOrderRecord.reference
                                          .update(createOrderRecordData(
                                        orderStatus: 'Preparing',
                                        preparingTime: getCurrentTimestamp,
                                      ));
                                      triggerPushNotification(
                                        notificationTitle:
                                            'Order is Being Prepared',
                                        notificationText:
                                            ' We Are are currently preparing your items for delivery.',
                                        userRefs: [
                                          containerOrderRecord.userRef!
                                        ],
                                        initialPageName: 'OrderDetails',
                                        parameterData: {
                                          'orderRef':
                                              containerOrderRecord.reference,
                                        },
                                      );

                                      await containerOrderRecord.userRef!
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'notification_count':
                                                FieldValue.increment(1),
                                          },
                                        ),
                                      });
                                    } else {
                                      if (containerOrderRecord.orderStatus ==
                                          'Preparing') {
                                        await containerOrderRecord.reference
                                            .update(createOrderRecordData(
                                          orderStatus: 'Picked Up',
                                          pickedUpTime: getCurrentTimestamp,
                                        ));
                                        triggerPushNotification(
                                          notificationTitle: 'Order Picked Up',
                                          notificationText:
                                              'Your order has been  ready for pickup .',
                                          userRefs: [
                                            containerOrderRecord.userRef!
                                          ],
                                          initialPageName: 'OrderDetails',
                                          parameterData: {
                                            'orderRef':
                                                containerOrderRecord.reference,
                                          },
                                        );

                                        await containerOrderRecord.userRef!
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'notification_count':
                                                  FieldValue.increment(1),
                                            },
                                          ),
                                        });
                                      } else {
                                        if (containerOrderRecord.orderStatus ==
                                            'Picked Up') {
                                          await containerOrderRecord.reference
                                              .update(createOrderRecordData(
                                            orderStatus: 'Delivered',
                                            deliveredTime: getCurrentTimestamp,
                                          ));
                                          triggerPushNotification(
                                            notificationTitle:
                                                'Order Delivered',
                                            notificationText:
                                                'Your order has been successfully delivered. Enjoy!',
                                            userRefs: [
                                              containerOrderRecord.userRef!
                                            ],
                                            initialPageName: 'OrderDetails',
                                            parameterData: {
                                              'orderRef': containerOrderRecord
                                                  .reference,
                                            },
                                          );

                                          await containerOrderRecord.userRef!
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'notification_count':
                                                    FieldValue.increment(1),
                                              },
                                            ),
                                          });
                                        }
                                      }
                                    }
                                  }
                                },
                                text:
                                    '${FFLocalizations.of(context).getVariableText(
                                  enText: 'Mark as ',
                                  frText: 'Marquer comme ',
                                )}${() {
                                  if (containerOrderRecord.orderStatus ==
                                      'Pending') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Confirmed',
                                      frText: 'Confirmé',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Approved') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Preparing',
                                      frText: 'Préparation',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Preparing') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Ready for Pickup',
                                      frText: 'Prêt à être récupéré',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Picked Up') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Delivered',
                                      frText: 'Livré',
                                    );
                                  } else {
                                    return ' ';
                                  }
                                }()}',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 45.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color:
                                      FlutterFlowTheme.of(context).primarytheme,
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
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            if (((containerOrderRecord.orderStatus !=
                                        'Delivered') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Rejected') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Canceled')) &&
                                (containerOrderRecord.delievryMethod !=
                                    'farmpickup') &&
                                (containerOrderRecord.isAgricoDeliver
                                    ? ((containerOrderRecord.orderStatus ==
                                            'Pending') ||
                                        (containerOrderRecord.orderStatus ==
                                            'Approved') ||
                                        (containerOrderRecord.orderStatus ==
                                            'Preparing'))
                                    : true))
                              FFButtonWidget(
                                onPressed: () async {
                                  var _shouldSetState = false;
                                  if ((containerOrderRecord.orderStatus ==
                                          'Preparing') &&
                                      (containerOrderRecord.orderItems
                                              .where((e) =>
                                                  e.isVariableWeight &&
                                                  (e.actualWeight <= 0.0))
                                              .toList()
                                              .length >
                                          0)) {
                                    await actions.toast(
                                      context,
                                      FFLocalizations.of(context)
                                          .getVariableText(
                                        enText:
                                            'Add the actual weight for every weight-based product. The customer must complete the remaining payment before you can update the order status.',
                                        frText:
                                            'Ajoutez le poids réel de chaque produit vendu au poids. Le client doit régler le solde restant avant que vous puissiez mettre à jour le statut de la commande.',
                                      ),
                                    );
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }
                                  if (containerOrderRecord.orderStatus ==
                                      'Pending') {
                                    await containerOrderRecord.reference
                                        .update(createOrderRecordData(
                                      orderStatus: 'Approved',
                                      orderConfiramtionTime:
                                          getCurrentTimestamp,
                                    ));
                                    triggerPushNotification(
                                      notificationTitle: 'Order Confirmed!',
                                      notificationText:
                                          'Your order ORD-${containerOrderRecord.reference.id} has been approved and confirmed.',
                                      userRefs: [containerOrderRecord.userRef!],
                                      initialPageName: 'OrderDetails',
                                      parameterData: {
                                        'orderRef':
                                            containerOrderRecord.reference,
                                      },
                                    );

                                    await containerOrderRecord.userRef!.update({
                                      ...mapToFirestore(
                                        {
                                          'notification_count':
                                              FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                  } else {
                                    if (containerOrderRecord.orderStatus ==
                                        'Approved') {
                                      await containerOrderRecord.reference
                                          .update(createOrderRecordData(
                                        orderStatus: 'Preparing',
                                        preparingTime: getCurrentTimestamp,
                                      ));
                                      triggerPushNotification(
                                        notificationTitle:
                                            'Order is Being Prepared',
                                        notificationText:
                                            ' We Are are currently preparing your items for delivery.',
                                        userRefs: [
                                          containerOrderRecord.userRef!
                                        ],
                                        initialPageName: 'OrderDetails',
                                        parameterData: {
                                          'orderRef':
                                              containerOrderRecord.reference,
                                        },
                                      );

                                      await containerOrderRecord.userRef!
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'notification_count':
                                                FieldValue.increment(1),
                                          },
                                        ),
                                      });
                                    } else {
                                      if (containerOrderRecord.orderStatus ==
                                          'Preparing') {
                                        if (containerOrderRecord
                                                .isAgricoDeliver ==
                                            true) {
                                          _model.manifestitem = [];
                                          safeSetState(() {});
                                          for (int loop1Index = 0;
                                              loop1Index <=
                                                  containerOrderRecord
                                                          .orderItems.length -
                                                      1;
                                              loop1Index++) {
                                            final currentLoop1Item =
                                                containerOrderRecord
                                                    .orderItems[loop1Index];
                                            _model.productname =
                                                await ProductRecord
                                                    .getDocumentOnce(
                                                        currentLoop1Item
                                                            .productRef!);
                                            _shouldSetState = true;
                                            _model.addToManifestitem(
                                                ManifestItemsStruct(
                                              name: _model
                                                  .productname?.productName,
                                              quantity:
                                                  currentLoop1Item.totalItems,
                                              size: 'small',
                                            ));
                                            safeSetState(() {});
                                          }
                                        } else {
                                          await containerOrderRecord.reference
                                              .update(createOrderRecordData(
                                            orderStatus: 'Picked Up',
                                            pickedUpTime: getCurrentTimestamp,
                                          ));
                                          triggerPushNotification(
                                            notificationTitle:
                                                'Order Picked Up',
                                            notificationText:
                                                'Your order has been picked up and is ready for transit.',
                                            userRefs: [
                                              containerOrderRecord.userRef!
                                            ],
                                            initialPageName: 'OrderDetails',
                                            parameterData: {
                                              'orderRef': containerOrderRecord
                                                  .reference,
                                            },
                                          );

                                          await containerOrderRecord.userRef!
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'notification_count':
                                                    FieldValue.increment(1),
                                              },
                                            ),
                                          });
                                          Navigator.pop(context);
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }

                                        _model.farm1 =
                                            await FarmsRecord.getDocumentOnce(
                                                containerOrderRecord.farmRef!);
                                        _shouldSetState = true;
                                        _model.farmaddress =
                                            await actions.getAddressFromLatLng(
                                          _model.farm1!.farmLocation!,
                                        );
                                        _shouldSetState = true;
                                        _model.apiResult7q6 =
                                            await CreateDeliveryCopyCall.call(
                                          pickupAddress: _model.farmaddress,
                                          dropoffAddress:
                                              '${containerOrderRecord.delievryAddress.streetAdress}',
                                          pickupName: _model.farm1?.farmName,
                                          pickupPhoneNumber:
                                              _model.farm1?.contactPhoneNo,
                                          dropoffName: containerOrderRecord
                                              .delievryAddress.fullName,
                                          dropoffPhoneNumber:
                                              containerOrderRecord
                                                  .delievryAddress.phoneNo,
                                          manifestItemsJson: _model.manifestitem
                                              .map((e) => e.toMap())
                                              .toList(),
                                          orderId:
                                              containerOrderRecord.reference.id,
                                        );

                                        _shouldSetState = true;
                                        if ((_model.apiResult7q6?.succeeded ??
                                            true)) {
                                          await containerOrderRecord.reference
                                              .update(createOrderRecordData(
                                            uberDeliveryId:
                                                valueOrDefault<String>(
                                              CreateDeliveryCopyCall
                                                  .uberDeliveryId(
                                                (_model.apiResult7q6
                                                        ?.jsonBody ??
                                                    ''),
                                              ),
                                              '-',
                                            ),
                                            deliveryStatus:
                                                valueOrDefault<String>(
                                              CreateDeliveryCopyCall
                                                  .deliveryStatus(
                                                (_model.apiResult7q6
                                                        ?.jsonBody ??
                                                    ''),
                                              ),
                                              '-',
                                            ),
                                            trackingUrl: valueOrDefault<String>(
                                              CreateDeliveryCopyCall
                                                  .trackingUrl(
                                                (_model.apiResult7q6
                                                        ?.jsonBody ??
                                                    ''),
                                              ),
                                              '-',
                                            ),
                                          ));

                                          await containerOrderRecord.reference
                                              .update(createOrderRecordData(
                                            orderStatus: 'Picked Up',
                                            pickedUpTime: getCurrentTimestamp,
                                          ));

                                          await containerOrderRecord.userRef!
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'notification_count':
                                                    FieldValue.increment(1),
                                              },
                                            ),
                                          });
                                          triggerPushNotification(
                                            notificationTitle:
                                                'Order Picked Up',
                                            notificationText:
                                                'Your order has been picked up and is ready for transit.',
                                            userRefs: [
                                              containerOrderRecord.userRef!
                                            ],
                                            initialPageName: 'OrderDetails',
                                            parameterData: {
                                              'orderRef': containerOrderRecord
                                                  .reference,
                                            },
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'agrico is coming to pick up product',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                CreateDeliveryCopyCall.error(
                                                  (_model.apiResult7q6
                                                          ?.jsonBody ??
                                                      ''),
                                                )!,
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primarytheme,
                                            ),
                                          );
                                        }
                                      } else {
                                        if (containerOrderRecord.orderStatus ==
                                            'Picked Up') {
                                          await containerOrderRecord.reference
                                              .update(createOrderRecordData(
                                            orderStatus: 'In Transit',
                                            inTransitTime: getCurrentTimestamp,
                                          ));
                                          triggerPushNotification(
                                            notificationTitle:
                                                'Order on the Way',
                                            notificationText:
                                                'Great news! Your order is in transit and moving toward you.',
                                            userRefs: [
                                              containerOrderRecord.userRef!
                                            ],
                                            initialPageName: 'OrderDetails',
                                            parameterData: {
                                              'orderRef': containerOrderRecord
                                                  .reference,
                                            },
                                          );

                                          await containerOrderRecord.userRef!
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'notification_count':
                                                    FieldValue.increment(1),
                                              },
                                            ),
                                          });
                                        } else {
                                          if (containerOrderRecord
                                                  .orderStatus ==
                                              'In Transit') {
                                            await containerOrderRecord.reference
                                                .update(createOrderRecordData(
                                              orderStatus: 'Delivered',
                                              deliveredTime:
                                                  getCurrentTimestamp,
                                            ));
                                            triggerPushNotification(
                                              notificationTitle:
                                                  'Order Delivered',
                                              notificationText:
                                                  'Your order has been successfully delivered. Enjoy!',
                                              userRefs: [
                                                containerOrderRecord.userRef!
                                              ],
                                              initialPageName: 'OrderDetails',
                                              parameterData: {
                                                'orderRef': containerOrderRecord
                                                    .reference,
                                              },
                                            );

                                            await containerOrderRecord.userRef!
                                                .update({
                                              ...mapToFirestore(
                                                {
                                                  'notification_count':
                                                      FieldValue.increment(1),
                                                },
                                              ),
                                            });
                                          }
                                        }
                                      }
                                    }
                                  }

                                  Navigator.pop(context);
                                  if (_shouldSetState) safeSetState(() {});
                                },
                                text:
                                    '${FFLocalizations.of(context).getVariableText(
                                  enText: 'Mark as ',
                                  frText: 'Marquer comme ',
                                )}${() {
                                  if (containerOrderRecord.orderStatus ==
                                      'Pending') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Confirmed',
                                      frText: 'Confirmé',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Approved') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Preparing',
                                      frText: 'Préparation',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Preparing') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Ready for Delivery',
                                      frText: 'Prêt pour la livraison',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'Picked Up') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'In Transit',
                                      frText: 'En transit',
                                    );
                                  } else if (containerOrderRecord.orderStatus ==
                                      'In Transit') {
                                    return FFLocalizations.of(context)
                                        .getVariableText(
                                      enText: 'Delivered',
                                      frText: 'Livré',
                                    );
                                  } else {
                                    return ' ';
                                  }
                                }()}',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 48.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color:
                                      FlutterFlowTheme.of(context).primarytheme,
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
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primarytheme,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            if ((containerOrderRecord.orderConfiramtionTime == null) &&
                                ((containerOrderRecord.orderStatus !=
                                        'Delivered') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Rejected') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Picked Up') &&
                                    (containerOrderRecord.orderStatus !=
                                        'In Transit') &&
                                    (containerOrderRecord.orderStatus !=
                                        'Canceled')))
                              Builder(
                                builder: (context) => FFButtonWidget(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: AlignmentDirectional(
                                                  0.0, 0.0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: RejectorderWidget(
                                            rejectAction: () async {
                                              await containerOrderRecord
                                                  .reference
                                                  .update(createOrderRecordData(
                                                orderStatus: 'Rejected',
                                              ));
                                              for (int loop1Index = 1;
                                                  loop1Index <=
                                                      containerOrderRecord
                                                              .orderItems
                                                              .length -
                                                          1;
                                                  loop1Index++) {
                                                final currentLoop1Item =
                                                    containerOrderRecord
                                                        .orderItems[loop1Index];

                                                await currentLoop1Item
                                                    .productRef!
                                                    .update({
                                                  ...mapToFirestore(
                                                    {
                                                      'stock_quantity':
                                                          FieldValue.increment(
                                                              currentLoop1Item
                                                                  .totalItems),
                                                    },
                                                  ),
                                                });
                                              }
                                              triggerPushNotification(
                                                notificationTitle:
                                                    'Order Cancelled',
                                                notificationText:
                                                    'Sorry, your order ORD-${containerOrderRecord.reference.id} has been rejected by the producer.',
                                                userRefs: [
                                                  containerOrderRecord.userRef!
                                                ],
                                                initialPageName: 'OrderDetails',
                                                parameterData: {
                                                  'orderRef':
                                                      containerOrderRecord
                                                          .reference,
                                                },
                                              );

                                              await containerOrderRecord
                                                  .userRef!
                                                  .update({
                                                ...mapToFirestore(
                                                  {
                                                    'notification_count':
                                                        FieldValue.increment(1),
                                                  },
                                                ),
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'ahn95aps' /* Reject Order */,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).tometoRed,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color:
                                              FlutterFlowTheme.of(context).card,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .primarytheme,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 40.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  _model.chat = await queryChatRecordOnce(
                                    queryBuilder: (chatRecord) =>
                                        chatRecord.where(
                                      'users',
                                      arrayContains: currentUserReference,
                                    ),
                                  );
                                  if (_model.chat
                                          ?.where((e) => e.users.contains(
                                              containerOrderRecord.userRef))
                                          .toList()
                                          .length !=
                                      0) {
                                    context.pushNamed(
                                      ProducerChatConversationWidget.routeName,
                                      queryParameters: {
                                        'chatRef': serializeParam(
                                          _model.chat
                                              ?.where((e) => e.users.contains(
                                                  containerOrderRecord.userRef))
                                              .toList()
                                              .firstOrNull,
                                          ParamType.Document,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'chatRef': _model.chat
                                            ?.where((e) => e.users.contains(
                                                containerOrderRecord.userRef))
                                            .toList()
                                            .firstOrNull,
                                      },
                                    );
                                  } else {
                                    _model.users = [];
                                    safeSetState(() {});
                                    _model.addToUsers(currentUserReference!);
                                    safeSetState(() {});
                                    _model.addToUsers(
                                        containerOrderRecord.userRef!);
                                    safeSetState(() {});

                                    var chatRecordReference =
                                        ChatRecord.collection.doc();
                                    await chatRecordReference.set({
                                      ...createChatRecordData(
                                        createdAt: getCurrentTimestamp,
                                        farmRef: containerOrderRecord.farmRef,
                                        isSuspend: false,
                                        userb: containerOrderRecord.userRef,
                                        timeb: getCurrentTimestamp,
                                        timea: getCurrentTimestamp,
                                        usera: currentUserReference,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'users': _model.users,
                                        },
                                      ),
                                    });
                                    _model.chatcreate =
                                        ChatRecord.getDocumentFromData({
                                      ...createChatRecordData(
                                        createdAt: getCurrentTimestamp,
                                        farmRef: containerOrderRecord.farmRef,
                                        isSuspend: false,
                                        userb: containerOrderRecord.userRef,
                                        timeb: getCurrentTimestamp,
                                        timea: getCurrentTimestamp,
                                        usera: currentUserReference,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'users': _model.users,
                                        },
                                      ),
                                    }, chatRecordReference);

                                    context.pushNamed(
                                      ProducerChatConversationWidget.routeName,
                                      queryParameters: {
                                        'chatRef': serializeParam(
                                          _model.chatcreate,
                                          ParamType.Document,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'chatRef': _model.chatcreate,
                                      },
                                    );
                                  }

                                  Navigator.pop(context);

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  '8h35v4mt' /* Contact Customer */,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 48.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .textprimary,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
