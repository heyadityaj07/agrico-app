import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'checkout_copy_model.dart';
export 'checkout_copy_model.dart';

class CheckoutCopyWidget extends StatefulWidget {
  const CheckoutCopyWidget({
    super.key,
    required this.vouchercode,
    required this.note,
    required this.tip,
  });

  final String? vouchercode;
  final String? note;
  final double? tip;

  static String routeName = 'checkoutCopy';
  static String routePath = '/checkoutCopy';

  @override
  State<CheckoutCopyWidget> createState() => _CheckoutCopyWidgetState();
}

class _CheckoutCopyWidgetState extends State<CheckoutCopyWidget> {
  late CheckoutCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CheckoutCopyModel());

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
              'm0ql2ox2' /* Checkout */,
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
                                                                                  'pvk7zkq8' /* Delivery Method */,
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
                                                                                                      'viziwc7w' /* Farm Pickup */,
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
                                                                                                      '4frfnms5' /* Pick up directly */,
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
                                                                                            'hrjsuo8m' /* Free */,
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
                                                                                    (pageViewFarmsRecord.selfManagedSetup.minimumAmmount != null
                                                                                        ? (((valueOrDefault<double>(
                                                                                                  functions.totalsales(containerCartRecordList.toList()),
                                                                                                  0.0,
                                                                                                ) +
                                                                                                math.min(
                                                                                                    (valueOrDefault<double>(
                                                                                                          functions.totalsales(containerCartRecordList.toList()),
                                                                                                          0.0,
                                                                                                        ) *
                                                                                                        valueOrDefault<double>(
                                                                                                          stackConfigRecord?.platformFee,
                                                                                                          0.0,
                                                                                                        ) /
                                                                                                        100),
                                                                                                    3.00))) >=
                                                                                            pageViewFarmsRecord.selfManagedSetup.minimumAmmount)
                                                                                        : true)) {
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
                                                                                                      '6r0240qz' /* Farm Delivery */,
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
                                                                                                      '5e6ttsal' /* Delivered by the Farm directly */,
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
                                                                                              'rere5ey2' /* Charges */,
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
                                                                                visible: () {
                                                                                  if (pageViewFarmsRecord.selfManagedSetup.ownDelivery &&
                                                                                      (pageViewFarmsRecord.selfManagedSetup.minimumAmmount != null
                                                                                          ? (((valueOrDefault<double>(
                                                                                                    functions.totalsales(containerCartRecordList.toList()),
                                                                                                    0.0,
                                                                                                  ) +
                                                                                                  math.min(
                                                                                                      (valueOrDefault<double>(
                                                                                                            functions.totalsales(containerCartRecordList.toList()),
                                                                                                            0.0,
                                                                                                          ) *
                                                                                                          valueOrDefault<double>(
                                                                                                            stackConfigRecord?.platformFee,
                                                                                                            0.0,
                                                                                                          ) /
                                                                                                          100),
                                                                                                      3.00))) >=
                                                                                              pageViewFarmsRecord.selfManagedSetup.minimumAmmount)
                                                                                          : true)) {
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
                                                                                                        '9rbrx4z0' /* Agricoo delivery */,
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
                                                                                                        'q8w6k508' /* Delivered by the Uber directly */,
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
                                                                                                '29uwzn1j' /* Charges */,
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
                                                                          (pageViewFarmsRecord.selfManagedSetup.minimumAmmount != null
                                                                              ? (((valueOrDefault<double>(
                                                                                        functions.totalsales(containerCartRecordList.toList()),
                                                                                        0.0,
                                                                                      ) +
                                                                                      math.min(
                                                                                          (valueOrDefault<double>(
                                                                                                functions.totalsales(containerCartRecordList.toList()),
                                                                                                0.0,
                                                                                              ) *
                                                                                              valueOrDefault<double>(
                                                                                                stackConfigRecord?.platformFee,
                                                                                                0.0,
                                                                                              ) /
                                                                                              100),
                                                                                          3.99))) >=
                                                                                  pageViewFarmsRecord.selfManagedSetup.minimumAmmount)
                                                                              : true)) {
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
                                                                                    'ewnbjzz3' /* Delivery Address */,
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
                                                                                            'zib5jqxy' /* Full Name */,
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
                                                                                              '409xrzih' /* Enter your Name */,
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
                                                                                            'kteipcz5' /* Street Address */,
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
                                                                                              'nmthxfiw' /* Enter Street Address */,
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
                                                                                            '0b29xww9' /* Phone Number */,
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
                                                                                              't1md1wqu' /* Enter Phone Number */,
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
                                                                                          's470a0bq' /* change address */,
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
                                                                                    'ckonw3sq' /* Add address */,
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
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      var _shouldSetState =
                                                                          false;
                                                                      if (_model.farmpickup !=
                                                                              null &&
                                                                          _model.farmpickup !=
                                                                              '') {
                                                                        if ((_model.farmpickup ==
                                                                                'no') &&
                                                                            () {
                                                                              if (pageViewFarmsRecord.selfManagedSetup.ownDelivery &&
                                                                                  (pageViewFarmsRecord.selfManagedSetup.minimumAmmount != null
                                                                                      ? (((valueOrDefault<double>(
                                                                                                functions.totalsales(containerCartRecordList.toList()),
                                                                                                0.0,
                                                                                              ) +
                                                                                              math.min(
                                                                                                  (valueOrDefault<double>(
                                                                                                        functions.totalsales(containerCartRecordList.toList()),
                                                                                                        0.0,
                                                                                                      ) *
                                                                                                      valueOrDefault<double>(
                                                                                                        stackConfigRecord?.platformFee,
                                                                                                        0.0,
                                                                                                      ) /
                                                                                                      100),
                                                                                                  3.99))) >=
                                                                                          pageViewFarmsRecord.selfManagedSetup.minimumAmmount)
                                                                                      : true)) {
                                                                                return true;
                                                                              } else if (pageViewFarmsRecord.agricooDelivery) {
                                                                                return true;
                                                                              } else {
                                                                                return false;
                                                                              }
                                                                            }()) {
                                                                          if (columnUsersRecord
                                                                              .deliveryAddresses
                                                                              .isNotEmpty) {
                                                                            _model.postal1 =
                                                                                await actions.checkruleofLocation(
                                                                              pageViewFarmsRecord.farmLocation,
                                                                              valueOrDefault<double>(
                                                                                pageViewFarmsRecord.selfManagedSetup.deliveryRadiuskm,
                                                                                0.0,
                                                                              ),
                                                                              columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.location,
                                                                            );
                                                                            _shouldSetState =
                                                                                true;
                                                                            if ((pageViewFarmsRecord.doyouofferyourowndeliveryservice == false) &&
                                                                                (_model.selectedeliverymethod != 'uber')) {
                                                                              if (pageViewFarmsRecord.selfManagedSetup.ownDelivery) {
                                                                                if (_model.postal1!) {
                                                                                  if (pageViewFarmsRecord.selfManagedSetup.minimumAmmount != null
                                                                                      ? (((valueOrDefault<double>(
                                                                                                functions.totalsales(containerCartRecordList.toList()),
                                                                                                0.0,
                                                                                              ) +
                                                                                              math.min(
                                                                                                  (valueOrDefault<double>(
                                                                                                        functions.totalsales(containerCartRecordList.toList()),
                                                                                                        0.0,
                                                                                                      ) *
                                                                                                      valueOrDefault<double>(
                                                                                                        stackConfigRecord?.platformFee,
                                                                                                        0.0,
                                                                                                      ) /
                                                                                                      100),
                                                                                                  3.99))) >=
                                                                                          pageViewFarmsRecord.selfManagedSetup.minimumAmmount)
                                                                                      : true) {
                                                                                    _model.fee = (double var1, double var2) {
                                                                                      return var1 >= var2;
                                                                                    }(
                                                                                            valueOrDefault<double>(
                                                                                              functions.totalsales(containerCartRecordList.toList()),
                                                                                              0.0,
                                                                                            ),
                                                                                            valueOrDefault<double>(
                                                                                              pageViewFarmsRecord.selfManagedSetup.freedelievryAmmount,
                                                                                              0.0,
                                                                                            ))
                                                                                        ? 0.0
                                                                                        : valueOrDefault<double>(
                                                                                            pageViewFarmsRecord.selfManagedSetup.flatDeliveryFee,
                                                                                            0.0,
                                                                                          );
                                                                                    _model.isAgricodeliver = false;
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    if (pageViewFarmsRecord.agricooDelivery) {
                                                                                      _model.apiResultyxp = await ValidateAccessCall.call(
                                                                                        address: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                      );

                                                                                      _shouldSetState = true;
                                                                                      if ((_model.apiResultyxp?.succeeded ?? true)) {
                                                                                        if (ValidateAccessCall.issupported(
                                                                                          (_model.apiResultyxp?.jsonBody ?? ''),
                                                                                        )!) {
                                                                                          _model.farmaddress = await actions.getAddressFromLatLng(
                                                                                            pageViewFarmsRecord.farmLocation!,
                                                                                          );
                                                                                          _shouldSetState = true;
                                                                                          _model.apiResultlzc = await GetDeliveryQuoteCall.call(
                                                                                            pickupAddress: _model.farmaddress,
                                                                                            dropoffAddress: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                          );

                                                                                          _shouldSetState = true;
                                                                                          if ((_model.apiResultlzc?.succeeded ?? true)) {
                                                                                            _model.fee = GetDeliveryQuoteCall.fee(
                                                                                                  (_model.apiResultlzc?.jsonBody ?? ''),
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
                                                                                                    (_model.apiResultlzc?.jsonBody ?? ''),
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
                                                                                                  (_model.apiResultyxp?.jsonBody ?? ''),
                                                                                                )!,
                                                                                                style: TextStyle(
                                                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                                (_model.apiResultyxp?.jsonBody ?? ''),
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
                                                                                } else {
                                                                                  if (pageViewFarmsRecord.agricooDelivery) {
                                                                                    _model.validateaddress = await ValidateAccessCall.call(
                                                                                      address: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                    );

                                                                                    _shouldSetState = true;
                                                                                    if ((_model.validateaddress?.succeeded ?? true)) {
                                                                                      if (ValidateAccessCall.issupported(
                                                                                        (_model.validateaddress?.jsonBody ?? ''),
                                                                                      )!) {
                                                                                        _model.farmaddress1 = await actions.getAddressFromLatLng(
                                                                                          pageViewFarmsRecord.farmLocation!,
                                                                                        );
                                                                                        _shouldSetState = true;
                                                                                        _model.quote = await GetDeliveryQuoteCall.call(
                                                                                          pickupAddress: _model.farmaddress1,
                                                                                          dropoffAddress: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                        );

                                                                                        _shouldSetState = true;
                                                                                        if ((_model.quote?.succeeded ?? true)) {
                                                                                          _model.fee = GetDeliveryQuoteCall.fee(
                                                                                                (_model.quote?.jsonBody ?? ''),
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
                                                                                                  (_model.quote?.jsonBody ?? ''),
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
                                                                                                (_model.validateaddress?.jsonBody ?? ''),
                                                                                              )!,
                                                                                              style: TextStyle(
                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                              (_model.validateaddress?.jsonBody ?? ''),
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
                                                                                }
                                                                              } else {
                                                                                if (pageViewFarmsRecord.agricooDelivery) {
                                                                                  _model.validateaddress2 = await ValidateAccessCall.call(
                                                                                    address: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                  );

                                                                                  _shouldSetState = true;
                                                                                  if ((_model.validateaddress2?.succeeded ?? true)) {
                                                                                    if (ValidateAccessCall.issupported(
                                                                                      (_model.validateaddress2?.jsonBody ?? ''),
                                                                                    )!) {
                                                                                      _model.farmaddress12 = await actions.getAddressFromLatLng(
                                                                                        pageViewFarmsRecord.farmLocation!,
                                                                                      );
                                                                                      _shouldSetState = true;
                                                                                      _model.quote1 = await GetDeliveryQuoteCall.call(
                                                                                        pickupAddress: _model.farmaddress12,
                                                                                        dropoffAddress: '${columnUsersRecord.deliveryAddresses.elementAtOrNull(columnUsersRecord.defaultAdress)?.streetAdress}',
                                                                                      );

                                                                                      _shouldSetState = true;
                                                                                      if ((_model.quote1?.succeeded ?? true)) {
                                                                                        _model.fee = GetDeliveryQuoteCall.fee(
                                                                                              (_model.quote1?.jsonBody ?? ''),
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
                                                                                                (_model.quote1?.jsonBody ?? ''),
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
                                                                                              (_model.validateaddress2?.jsonBody ?? ''),
                                                                                            )!,
                                                                                            style: TextStyle(
                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                                                            (_model.validateaddress2?.jsonBody ?? ''),
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
                                                                        } else {
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
                                                                            _model.farmpickup =
                                                                                null;
                                                                            _model.deliveryMethod =
                                                                                null;
                                                                            safeSetState(() {});
                                                                            _model.fee =
                                                                                0.0;
                                                                            safeSetState(() {});
                                                                            ScaffoldMessenger.of(context).showSnackBar(
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
                                                                        }
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(
                                                                              'please select delivery method',
                                                                              style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                              ),
                                                                            ),
                                                                            duration:
                                                                                Duration(milliseconds: 4000),
                                                                            backgroundColor:
                                                                                FlutterFlowTheme.of(context).primarytheme,
                                                                          ),
                                                                        );
                                                                        if (_shouldSetState)
                                                                          safeSetState(
                                                                              () {});
                                                                        return;
                                                                      }

                                                                      if (_shouldSetState)
                                                                        safeSetState(
                                                                            () {});
                                                                    },
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      '337wdjp1' /* Continue */,
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
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                                                                        '19cxvvwp' /* Bill Details */,
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Satoshi',
                                                                                            color: FlutterFlowTheme.of(context).textsecondary,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        FFLocalizations.of(context).getText(
                                                                                          'h3zwc6yl' /* To Pay */,
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
                                                                                            functions.totalsales(containerCartRecordList.toList()).toStringAsFixed(2),
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
                                                                                            'yoo4kn2k' /* To Platform Fees */,
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
                                                                                                  'ds6axn9v' /* $ */,
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
                                                                                                    functions.totalsales(containerCartRecordList.toList()),
                                                                                                    valueOrDefault<double>(
                                                                                                      columnConfigRecord?.platformFee,
                                                                                                      0.0,
                                                                                                    )),
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
                                                                                                  'i75nxd2l' /* € */,
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
                                                                                            'jk7boj0x' /* Delivery Fees */,
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
                                                                                                  'pzbo7knj' /* $ */,
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
                                                                                                  'l589o7ji' /* € */,
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
                                                                                              'ppi6ezyn' /* Delivery Partner Fee */,
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
                                                                                              '5xh2jrku' /* $2.00 */,
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
                                                                                              'jm69g61c' /* GST and Charges */,
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
                                                                                              'kfe50txd' /* $1.10 */,
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
                                                                                          's9k9ai3t' /* Total Pay */,
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
                                                                                                'kc2l9xmg' /* $ */,
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
                                                                                                      (math.min(
                                                                                                          (valueOrDefault<double>(
                                                                                                                functions.totalsales(containerCartRecordList.toList()),
                                                                                                                0.0,
                                                                                                              ) *
                                                                                                              columnConfigRecord!.platformFee),
                                                                                                          3.99)))
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
                                                                                                'l51fwpx1' /* € */,
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
                                                                    }
                                                                    _model.dynamicvendor =
                                                                        await actions
                                                                            .manageproductlist(
                                                                      _model
                                                                          .cart
                                                                          ?.toList(),
                                                                      _model.farmpickup ==
                                                                              'no'
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

                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    '4ip438yj' /* Pay */,
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
