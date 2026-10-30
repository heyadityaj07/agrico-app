import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/producer_orders/orderdatails/orderdatails_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ordermanegement_model.dart';
export 'ordermanegement_model.dart';

class OrdermanegementWidget extends StatefulWidget {
  const OrdermanegementWidget({super.key});

  static String routeName = 'Ordermanegement';
  static String routePath = '/ordermanegement';

  @override
  State<OrdermanegementWidget> createState() => _OrdermanegementWidgetState();
}

class _OrdermanegementWidgetState extends State<OrdermanegementWidget> {
  late OrdermanegementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdermanegementModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primarytheme,
                  ),
                ),
              ),
            ),
          );
        }

        final ordermanegementUsersRecord = snapshot.data!;

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
                    context.safePop();
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).card,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                FFLocalizations.of(context).getText(
                  'hv379lx5' /* Order Management */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Satoshi',
                      color: FlutterFlowTheme.of(context).textprimary,
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
                  StreamBuilder<List<FarmsRecord>>(
                    stream: queryFarmsRecord(
                      queryBuilder: (farmsRecord) => farmsRecord
                          .where(
                            'user_ref',
                            isEqualTo: currentUserReference,
                          )
                          .where(
                            'is_suspend',
                            isEqualTo: false,
                          ),
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
                      List<FarmsRecord> containerFarmsRecordList =
                          snapshot.data!;
                      final containerFarmsRecord =
                          containerFarmsRecordList.isNotEmpty
                              ? containerFarmsRecordList.first
                              : null;

                      return Container(
                        decoration: BoxDecoration(),
                        child: StreamBuilder<List<OrderRecord>>(
                          stream: queryOrderRecord(
                            queryBuilder: (orderRecord) => orderRecord
                                .where(
                                  'farm_ref',
                                  isEqualTo: containerFarmsRecord?.reference,
                                )
                                .where(
                                  'is_suspend',
                                  isEqualTo: false,
                                ),
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
                            List<OrderRecord> containerOrderRecordList =
                                snapshot.data!;

                            return Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 24.0, 16.0, 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFF7F6F4),
                                              Color(0xFFF7F6F4),
                                              FlutterFlowTheme.of(context).info
                                            ],
                                            stops: [0.0, 0.6, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          child: TextFormField(
                                            controller: _model.textController,
                                            focusNode:
                                                _model.textFieldFocusNode,
                                            onChanged: (_) =>
                                                EasyDebounce.debounce(
                                              '_model.textController',
                                              Duration(milliseconds: 0),
                                              () async {
                                                safeSetState(() {});
                                              },
                                            ),
                                            autofocus: false,
                                            enabled: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'r9a3unzf' /* Search by  order id or name */,
                                              ),
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 0.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              prefixIcon: Icon(
                                                const IconData(
                                                    /* search */ 0xf002,
                                                    fontFamily:
                                                        'FontAwesomeSolid',
                                                    fontPackage:
                                                        'font_awesome_flutter'),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textprimary,
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textprimary,
                                                  letterSpacing: 0.0,
                                                ),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .textprimary,
                                            enableInteractiveSelection: true,
                                            validator: _model
                                                .textControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFAF9F6),
                                          borderRadius:
                                              BorderRadius.circular(99.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .boderdivder,
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 0;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  '7ofkziyg' /* All */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 0
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    0
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 0
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 0
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(99.0),
                                                    topRight: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 0
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomLeft:
                                                        Radius.circular(99.0),
                                                    bottomRight:
                                                        Radius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      _model.tabindex == 0
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                  ),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 1;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  '4kg76kib' /* Pending */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 1
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    1
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 1
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 1
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 1
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    topRight: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 1
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 1
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomRight:
                                                        Radius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      _model.tabindex == 1
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                  ),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 2;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'yrd9heqb' /* Confirmed */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 2
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    2
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 2
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 2
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          valueOrDefault<
                                                              double>(
                                                    _model.tabindex == 2
                                                        ? 99.0
                                                        : 0.0,
                                                    0.0,
                                                  )),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 3;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'cxim8jtn' /* Ready */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 3
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    3
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 3
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 3
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          valueOrDefault<
                                                              double>(
                                                    _model.tabindex == 3
                                                        ? 99.0
                                                        : 0.0,
                                                    0.0,
                                                  )),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 4;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'jm74jy1r' /* Picked Up */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 4
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    4
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 4
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 4
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 4
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    topRight:
                                                        Radius.circular(99.0),
                                                    bottomLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 4
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomRight:
                                                        Radius.circular(99.0),
                                                  ),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 5;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'euuatml6' /* In Transit */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 5
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    5
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 5
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 5
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          valueOrDefault<
                                                              double>(
                                                    _model.tabindex == 5
                                                        ? 99.0
                                                        : 0.0,
                                                    0.0,
                                                  )),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 6;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  's8uh2zxl' /* Rejected */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 6
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    6
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 6
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 6
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 6
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    topRight: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 6
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 6
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomRight:
                                                        Radius.circular(
                                                            valueOrDefault<
                                                                double>(
                                                      _model.tabindex == 6
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                  ),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  _model.tabindex = 7;
                                                  safeSetState(() {});
                                                },
                                                text:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  '8c0ksdz1' /* Delivered */,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: _model.tabindex == 7
                                                      ? Color(0xFFF7F6F3)
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .offwhite,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: _model
                                                                        .tabindex ==
                                                                    7
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                  elevation:
                                                      _model.tabindex == 7
                                                          ? 2.0
                                                          : 0.0,
                                                  borderSide: BorderSide(
                                                    color: _model.tabindex == 7
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .boderdivder
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .offwhite,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 7
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    topRight:
                                                        Radius.circular(99.0),
                                                    bottomLeft: Radius.circular(
                                                        valueOrDefault<double>(
                                                      _model.tabindex == 7
                                                          ? 99.0
                                                          : 0.0,
                                                      0.0,
                                                    )),
                                                    bottomRight:
                                                        Radius.circular(99.0),
                                                  ),
                                                ),
                                                showLoadingIndicator: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .offwhite,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 24.0, 0.0, 0.0),
                                            child: Builder(
                                              builder: (context) {
                                                final orders =
                                                    containerOrderRecordList
                                                        .where((e) =>
                                                            ((e.username != null &&
                                                                            e.username !=
                                                                                ''
                                                                        ? e
                                                                            .username
                                                                        : e
                                                                            .reference
                                                                            .id)
                                                                    .toLowerCase()
                                                                    .contains(_model
                                                                        .textController
                                                                        .text
                                                                        .toLowerCase()) ||
                                                                e.reference.id
                                                                    .toLowerCase()
                                                                    .contains(_model
                                                                        .textController
                                                                        .text
                                                                        .toLowerCase())) &&
                                                            () {
                                                              if (_model
                                                                      .tabindex ==
                                                                  1) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Pending');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  2) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Approved');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  3) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Preparing');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  4) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Picked Up');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  5) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'In Transit');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  6) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Rejected');
                                                              } else if (_model
                                                                      .tabindex ==
                                                                  7) {
                                                                return (e
                                                                        .orderStatus ==
                                                                    'Delivered');
                                                              } else {
                                                                return true;
                                                              }
                                                            }())
                                                        .toList()
                                                        .sortedList(
                                                            keyOf: (e) =>
                                                                e.createdAt!,
                                                            desc: true)
                                                        .toList();
                                                if (orders.isEmpty) {
                                                  return NoChatProducerWidget(
                                                    message: FFLocalizations.of(
                                                            context)
                                                        .getText(
                                                      'k2jx6o84' /* No orders yet! */,
                                                    ),
                                                    submsg: FFLocalizations.of(
                                                            context)
                                                        .getText(
                                                      'ajsay6c3' /* You don't have any orders in t... */,
                                                    ),
                                                    index: 0,
                                                  );
                                                }

                                                return SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: List.generate(
                                                        orders.length,
                                                        (ordersIndex) {
                                                      final ordersItem =
                                                          orders[ordersIndex];
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isDismissible:
                                                                false,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  FocusManager
                                                                      .instance
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                },
                                                                child: Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      OrderdatailsWidget(
                                                                    orderRef:
                                                                        ordersItem
                                                                            .reference,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .card,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .boderdivder,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child: StreamBuilder<
                                                                          UsersRecord>(
                                                                        stream:
                                                                            UsersRecord.getDocument(ordersItem.userRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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

                                                                          final columnUsersRecord =
                                                                              snapshot.data!;

                                                                          return Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              Container(
                                                                                decoration: BoxDecoration(),
                                                                                child: Text(
                                                                                  'ORD - ${ordersItem.reference.id}',
                                                                                  maxLines: 1,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Satoshi',
                                                                                        color: FlutterFlowTheme.of(context).textprimary,
                                                                                        fontSize: 12.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                columnUsersRecord.displayName,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      color: FlutterFlowTheme.of(context).textsecondary,
                                                                                      fontSize: 12.0,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ].divide(SizedBox(height: 4.0)),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              () {
                                                                            if (ordersItem.orderStatus ==
                                                                                'Approved') {
                                                                              return Color(0x1F3FA9F5);
                                                                            } else if (ordersItem.orderStatus ==
                                                                                'Delivered') {
                                                                              return Color(0x1A3BB273);
                                                                            } else if (ordersItem.orderStatus ==
                                                                                'Preparing') {
                                                                              return Color(0x1CCB30E0);
                                                                            } else {
                                                                              return Color(0x1FF58D2A);
                                                                            }
                                                                          }(),
                                                                          borderRadius:
                                                                              BorderRadius.circular(99.0),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              4.0,
                                                                              12.0,
                                                                              4.0),
                                                                          child:
                                                                              Text(
                                                                            ordersItem.orderStatus,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Satoshi',
                                                                                  color: () {
                                                                                    if (ordersItem.orderStatus == 'Approved') {
                                                                                      return FlutterFlowTheme.of(context).primary;
                                                                                    } else if (ordersItem.orderStatus == 'Delivered') {
                                                                                      return FlutterFlowTheme.of(context).primarytheme;
                                                                                    } else if (ordersItem.orderStatus == 'Preparing') {
                                                                                      return Color(0xFFCB30E0);
                                                                                    } else {
                                                                                      return FlutterFlowTheme.of(context).orange;
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
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          0.0,
                                                                          12.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '${valueOrDefault<String>(
                                                                          ordersItem
                                                                              .orderItems
                                                                              .length
                                                                              .toString(),
                                                                          '0',
                                                                        )} items',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textsecondary,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        height:
                                                                            6.0)),
                                                                  ),
                                                                ),
                                                                StyledDivider(
                                                                  height: 0.0,
                                                                  thickness:
                                                                      2.0,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .boderdivder,
                                                                  lineStyle:
                                                                      DividerLineStyle
                                                                          .dashed,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        dateTimeFormat(
                                                                          "yMMMd",
                                                                          ordersItem
                                                                              .createdAt!,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textsecondary,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          if (FFLocalizations.of(context).languageCode !=
                                                                              'fr')
                                                                            Text(
                                                                              FFLocalizations.of(context).getText(
                                                                                '8l2hqmbi' /* $ */,
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).primarytheme,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                          Text(
                                                                            valueOrDefault<double>(
                                                                              ordersItem.totalAmmount,
                                                                              0.0,
                                                                            ).toStringAsFixed(2),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Satoshi',
                                                                                  color: FlutterFlowTheme.of(context).primarytheme,
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                          if (FFLocalizations.of(context).languageCode ==
                                                                              'fr')
                                                                            Text(
                                                                              FFLocalizations.of(context).getText(
                                                                                's6tuxxn8' /* € */,
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).primarytheme,
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
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).divide(
                                                        SizedBox(height: 24.0)),
                                                  ),
                                                );
                                              },
                                            ),
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
                    },
                  ),
                  if (ordermanegementUsersRecord.isSuspend)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 4.0,
                          sigmaY: 4.0,
                        ),
                        child: wrapWithModel(
                          model: _model.suspendModel,
                          updateCallback: () => safeSetState(() {}),
                          child: SuspendWidget(
                            action: () async {
                              context.pushNamed(HelpandsupportWidget.routeName);
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
