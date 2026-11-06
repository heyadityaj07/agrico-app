import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckoutModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.farmpickup = null;
      _model.deliveryMethod = null;
      safeSetState(() {});
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
                      safeSetState(() {
                        _model.textController1?.text = columnUsersRecord
                            .deliveryAddresses
                            .elementAtOrNull(columnUsersRecord.defaultAdress)!
                            .fullName;
                      });
                      safeSetState(() {
                        _model.textController2?.text = columnUsersRecord
                            .deliveryAddresses
                            .elementAtOrNull(columnUsersRecord.defaultAdress)!
                            .streetAdress;
                      });
                      safeSetState(() {
                        _model.textController3?.text = columnUsersRecord
                            .deliveryAddresses
                            .elementAtOrNull(columnUsersRecord.defaultAdress)!
                            .phoneNo;
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
                                                                              visible: () {
                                                                                if (pageViewFarmsRecord.selfManagedSetup.ownDelivery &&
                                                                                    functions.meetsFarmMinimumOrder(
                                                                                      functions.totalsales(
                                                                                          containerCartRecordList
                                                                                              .toList()),
                                                                                      pageViewFarmsRecord
                                                                                          .selfManagedSetup
                                                                                          .minimumAmmount,
                                                                                    )) {
                                                                                  return true;
                                                                                } else if (pageViewFarmsRecord.agricooDelivery) {
                                                                                  return true;
                                                                                } else {
                                                                                  return false;
                                                                                }
                                                                              }(),
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
                                                                                visible: pageViewFarmsRecord.agricooDelivery,
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
                                                                    () {
                                                                      if (pageViewFarmsRecord
                                                                              .selfManagedSetup
                                                                              .ownDelivery &&
                                                                          functions.meetsFarmMinimumOrder(
                                                                            functions.totalsales(
                                                                                containerCartRecordList
                                                                                    .toList()),
                                                                            pageViewFarmsRecord
                                                                                .selfManagedSetup
                                                                                .minimumAmmount,
                                                                          )) {
                                                                        return true;
                                                                      } else if (pageViewFarmsRecord.agricooDelivery) {
                                                                        return true;
                                                                      } else {
                                                                        return false;
                                                                      }
                                                                    }())
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
                                                                                            text: columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.fullName,
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
                                                                                            text: columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress,
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
                                                                                            text: columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.phoneNo,
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
                                                                                columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.location,
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
                                                                                            enText: 'Your order subtotal is below the minimum order amount for farm delivery.',
                                                                                            frText: 'Le sous-total de votre commande est inférieur au montant minimum pour la livraison par la ferme.',
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
                                                                                    address: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
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
                                                                                      dropoffAddress: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
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
                                                                                                            'Deposit due: ${FFLocalizations.of(context).languageCode == 'fr' ? '€' : '\$'}${listItemItem.depositAmount.toString()}',
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
                                                                                                      _model.fee?.toString(),
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
                                                                                        FFLocalizations.of(context).getText(
                                                                                          'ld0mqmw0' /* Total to pay now */,
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
                                                                  onPressed:
                                                                      () async {
                                                                    if (_model.farmpickup !=
                                                                            'yes' &&
                                                                        _model.deliveryMethod !=
                                                                            'uber' &&
                                                                        pageViewFarmsRecord
                                                                            .selfManagedSetup
                                                                            .ownDelivery &&
                                                                        !functions.meetsFarmMinimumOrder(
                                                                          functions.totalsales(
                                                                              containerCartRecordList
                                                                                  .toList()),
                                                                          pageViewFarmsRecord
                                                                              .selfManagedSetup
                                                                              .minimumAmmount,
                                                                        )) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                          content: Text(
                                                                            FFLocalizations.of(context).getVariableText(
                                                                              enText: 'Your order subtotal is below the minimum order amount for farm delivery.',
                                                                              frText: 'Le sous-total de votre commande est inférieur au montant minimum pour la livraison par la ferme.',
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
                                                                    _model.farmUser =
                                                                        await UsersRecord.getDocumentOnce(
                                                                            pageViewFarmsRecord.userRef!);
                                                                    _model.cart =
                                                                        await queryCartRecordOnce(
                                                                      parent:
                                                                          currentUserReference,
                                                                    );
                                                                    _model.cartdata =
                                                                        await actions
                                                                            .farmOrderItems(
                                                                      _model
                                                                          .cart!
                                                                          .toList(),
                                                                    );
                                                                    for (int loop1Index =
                                                                            0;
                                                                        loop1Index <=
                                                                            _model.cartdata!.length -
                                                                                1;
                                                                        loop1Index++) {
                                                                      final currentLoop1Item =
                                                                          _model
                                                                              .cartdata![loop1Index];
                                                                      _model.farmn =
                                                                          await FarmsRecord.getDocumentOnce(
                                                                              currentLoop1Item.farmRef!);

                                                                      var orderRecordReference = OrderRecord
                                                                          .collection
                                                                          .doc();
                                                                      await orderRecordReference
                                                                          .set({
                                                                        ...createOrderRecordData(
                                                                          userRef:
                                                                              currentUserReference,
                                                                          note:
                                                                              widget.note,
                                                                          voucherCode:
                                                                              widget.vouchercode,
                                                                          serviceFee:
                                                                              functions.platformFeeAmount(
                                                                            functions.cartTotal(containerCartRecordList.toList()),
                                                                            stackConfigRecord?.platformFeeOrNull,
                                                                            stackConfigRecord?.platformFeeCapOrNull,
                                                                          ),
                                                                          deliveryTip:
                                                                              widget.tip,
                                                                          deliveryFee:
                                                                              0.0,
                                                                          tax:
                                                                              0.0,
                                                                          createdAt:
                                                                              getCurrentTimestamp,
                                                                          delievryMethod:
                                                                              _model.deliveryMethod,
                                                                          delievryTime:
                                                                              _model.selectedDeliveryTime,
                                                                          orderStatus:
                                                                              'Pending',
                                                                          farmRef:
                                                                              currentLoop1Item.farmRef,
                                                                          subTotal: functions.ordertotal(currentLoop1Item
                                                                              .cartItems
                                                                              .toList()),
                                                                          isSuspend:
                                                                              false,
                                                                          isFarmPickup:
                                                                              _model.farmpickup == 'yes',
                                                                          username:
                                                                              currentUserDisplayName,
                                                                          balancePaymentStatus:
                                                                              'pending',
                                                                          isVariableWeightOrder: currentLoop1Item
                                                                              .cartItems
                                                                              .where((e) => e.isVariableWeight == true)
                                                                              .toList()
                                                                              .isNotEmpty,
                                                                        ),
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'order_items':
                                                                                getOrderItemsListFirestoreData(
                                                                              currentLoop1Item.cartItems,
                                                                            ),
                                                                          },
                                                                        ),
                                                                      });
                                                                      _model.order =
                                                                          OrderRecord
                                                                              .getDocumentFromData({
                                                                        ...createOrderRecordData(
                                                                          userRef:
                                                                              currentUserReference,
                                                                          note:
                                                                              widget.note,
                                                                          voucherCode:
                                                                              widget.vouchercode,
                                                                          serviceFee:
                                                                              functions.platformFeeAmount(
                                                                            functions.cartTotal(containerCartRecordList.toList()),
                                                                            stackConfigRecord?.platformFeeOrNull,
                                                                            stackConfigRecord?.platformFeeCapOrNull,
                                                                          ),
                                                                          deliveryTip:
                                                                              widget.tip,
                                                                          deliveryFee:
                                                                              0.0,
                                                                          tax:
                                                                              0.0,
                                                                          createdAt:
                                                                              getCurrentTimestamp,
                                                                          delievryMethod:
                                                                              _model.deliveryMethod,
                                                                          delievryTime:
                                                                              _model.selectedDeliveryTime,
                                                                          orderStatus:
                                                                              'Pending',
                                                                          farmRef:
                                                                              currentLoop1Item.farmRef,
                                                                          subTotal: functions.ordertotal(currentLoop1Item
                                                                              .cartItems
                                                                              .toList()),
                                                                          isSuspend:
                                                                              false,
                                                                          isFarmPickup:
                                                                              _model.farmpickup == 'yes',
                                                                          username:
                                                                              currentUserDisplayName,
                                                                          balancePaymentStatus:
                                                                              'pending',
                                                                          isVariableWeightOrder: currentLoop1Item
                                                                              .cartItems
                                                                              .where((e) => e.isVariableWeight == true)
                                                                              .toList()
                                                                              .isNotEmpty,
                                                                        ),
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'order_items':
                                                                                getOrderItemsListFirestoreData(
                                                                              currentLoop1Item.cartItems,
                                                                            ),
                                                                          },
                                                                        ),
                                                                      }, orderRecordReference);
                                                                    }
                                                                    _model.dynamicvendor =
                                                                        await actions
                                                                            .manageproductlist(
                                                                      _model
                                                                          .cart
                                                                          ?.toList(),
                                                                      _model.farmpickup ==
                                                                                  'no' &&
                                                                              _model
                                                                                      .isAgricodeliver !=
                                                                                  true
                                                                          ? _model
                                                                              .fee
                                                                              ?.toString()
                                                                          : '0',
                                                                    );
                                                                    _model.config =
                                                                        await queryConfigRecordOnce(
                                                                      singleRecord:
                                                                          true,
                                                                    ).then((s) =>
                                                                            s.firstOrNull);
                                                                    _model.stripedocument =
                                                                        await actions
                                                                            .flutterStripeDirect(
                                                                      context,
                                                                      (valueOrDefault<
                                                                              double>(
                                                                            functions.totalsales(containerCartRecordList.toList()),
                                                                            0.0,
                                                                          ) +
                                                                          (_model.farmpickup ==
                                                                                  'no'
                                                                              ? valueOrDefault<
                                                                                  double>(
                                                                                  _model.fee,
                                                                                  0.0,
                                                                                )
                                                                              : 0.0) +
                                                                          (functions.platformFeeAmount(
                                                                              functions.cartTotal(containerCartRecordList.toList()),
                                                                              stackConfigRecord?.platformFeeOrNull,
                                                                              stackConfigRecord?.platformFeeCapOrNull))),
                                                                      _model
                                                                          .order
                                                                          ?.reference
                                                                          .id,
                                                                      currentUserReference
                                                                          ?.id,
                                                                      FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                      _model
                                                                          .dynamicvendor
                                                                          ?.toList(),
                                                                      containerCartRecordList
                                                                          .firstOrNull
                                                                          ?.farmRef
                                                                          ?.id,
                                                                    );
                                                                    if (_model
                                                                        .stripedocument!) {
                                                                      for (int loop2Index =
                                                                              0;
                                                                          loop2Index <=
                                                                              _model.cart!.length - 1;
                                                                          loop2Index++) {
                                                                        final currentLoop2Item =
                                                                            _model.cart![loop2Index];
                                                                        if (_model.farmpickup ==
                                                                            'yes') {
                                                                          await _model
                                                                              .order!
                                                                              .reference
                                                                              .update(createOrderRecordData(
                                                                            deliveryFee:
                                                                                0.0,
                                                                            totalAmmount: (valueOrDefault<double>(
                                                                                  functions.totalsales(containerCartRecordList.toList()),
                                                                                  0.0,
                                                                                ) +
                                                                                (_model.farmpickup == 'no'
                                                                                    ? valueOrDefault<double>(
                                                                                        _model.fee,
                                                                                        0.0,
                                                                                      )
                                                                                    : 0.0) +
                                                                                (functions.platformFeeAmount(
                                                                                  functions.cartTotal(containerCartRecordList.toList()),
                                                                                  stackConfigRecord?.platformFeeOrNull,
                                                                                  stackConfigRecord?.platformFeeCapOrNull,
                                                                                ))),
                                                                            isAgricoDeliver:
                                                                                false,
                                                                          ));
                                                                          for (int loop3Index = 0;
                                                                              loop3Index <= _model.order!.orderItems.length - 1;
                                                                              loop3Index++) {
                                                                            final currentLoop3Item =
                                                                                _model.order!.orderItems[loop3Index];

                                                                            await currentLoop3Item.productRef!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'stock_quantity': FieldValue.increment(-(currentLoop3Item.totalItems)),
                                                                                  'sold': FieldValue.increment(currentLoop3Item.totalItems),
                                                                                },
                                                                              ),
                                                                            });
                                                                          }
                                                                        } else {
                                                                          await _model
                                                                              .order!
                                                                              .reference
                                                                              .update(createOrderRecordData(
                                                                            delievryAddress:
                                                                                updateDeliveryAdressStruct(
                                                                              (currentUserDocument?.deliveryAddresses.toList() ?? []).elementAtOrNull(valueOrDefault(currentUserDocument?.defaultAdress, 0)),
                                                                              clearUnsetFields: false,
                                                                            ),
                                                                            deliveryFee:
                                                                                _model.fee,
                                                                            totalAmmount: (valueOrDefault<double>(
                                                                                  functions.totalsales(containerCartRecordList.toList()),
                                                                                  0.0,
                                                                                ) +
                                                                                (_model.farmpickup == 'no'
                                                                                    ? valueOrDefault<double>(
                                                                                        _model.fee,
                                                                                        0.0,
                                                                                      )
                                                                                    : 0.0) +
                                                                                (functions.platformFeeAmount(
                                                                                  functions.cartTotal(containerCartRecordList.toList()),
                                                                                  stackConfigRecord?.platformFeeOrNull,
                                                                                  stackConfigRecord?.platformFeeCapOrNull,
                                                                                ))),
                                                                            isAgricoDeliver:
                                                                                _model.isAgricodeliver,
                                                                          ));
                                                                          for (int loop4Index = 0;
                                                                              loop4Index <= _model.order!.orderItems.length - 1;
                                                                              loop4Index++) {
                                                                            final currentLoop4Item =
                                                                                _model.order!.orderItems[loop4Index];

                                                                            await currentLoop4Item.productRef!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'stock_quantity': FieldValue.increment(-(currentLoop4Item.totalItems)),
                                                                                  'sold': FieldValue.increment(currentLoop4Item.totalItems),
                                                                                },
                                                                              ),
                                                                            });
                                                                          }
                                                                        }

                                                                        triggerPushNotification(
                                                                          notificationTitle:
                                                                              '🔔 New Order Received!',
                                                                          notificationText:
                                                                              'You have a new order (ORD-${_model.order?.reference.id} from ${currentUserDisplayName}. Open the app to approve and start preparing.',
                                                                          userRefs: [
                                                                            _model.farmn!.userRef!
                                                                          ],
                                                                          initialPageName:
                                                                              'Ordermanegement',
                                                                          parameterData: {},
                                                                        );

                                                                        await _model
                                                                            .farmn!
                                                                            .userRef!
                                                                            .update({
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'notification_count': FieldValue.increment(1),
                                                                            },
                                                                          ),
                                                                        });
                                                                        FFAppState().orderdocument = _model
                                                                            .order
                                                                            ?.reference;
                                                                        FFAppState().cartdocument =
                                                                            currentLoop2Item.reference;
                                                                        safeSetState(
                                                                            () {});
                                                                      }

                                                                      context
                                                                          .goNamed(
                                                                        CheckoutfinalWidget
                                                                            .routeName,
                                                                        queryParameters:
                                                                            {
                                                                          'orderRef':
                                                                              serializeParam(
                                                                            FFAppState().orderdocument,
                                                                            ParamType.DocumentReference,
                                                                          ),
                                                                        }.withoutNulls,
                                                                      );

                                                                      if (FFAppState()
                                                                              .cartdocument !=
                                                                          null) {
                                                                        await FFAppState()
                                                                            .cartdocument!
                                                                            .delete();
                                                                      }
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            FFLocalizations.of(context).getVariableText(
                                                                              enText: 'payment failed ',
                                                                              frText: 'échec du paiement',
                                                                            ),
                                                                            style:
                                                                                TextStyle(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                        ),
                                                                      );
                                                                      await _model
                                                                          .order!
                                                                          .reference
                                                                          .delete();
                                                                    }

                                                                    safeSetState(
                                                                        () {});
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
