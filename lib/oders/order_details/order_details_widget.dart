import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/currency/currency_utils.dart';
import '/components/consumer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'order_details_model.dart';
export 'order_details_model.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({
    super.key,
    required this.orderRef,
  });

  final DocumentReference? orderRef;

  static String routeName = 'OrderDetails';
  static String routePath = '/orderDetails';

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  late OrderDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderRecord>(
      stream: OrderRecord.getDocument(widget.orderRef!),
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

        final orderDetailsOrderRecord = snapshot.data!;

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
                    context.pushNamed(MyOrdersWidget.routeName);
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${widget.orderRef?.id}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).textsecondary,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    dateTimeFormat(
                      "y-M-d",
                      orderDetailsOrderRecord.createdAt!,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).textsecondary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
              actions: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 10.0, 10.0),
                  child: Container(
                    height: 25.0,
                    decoration: BoxDecoration(
                      color: () {
                        if (orderDetailsOrderRecord.orderStatus == 'Approved') {
                          return Color(0x1F3FA9F5);
                        } else if (orderDetailsOrderRecord.orderStatus ==
                            'Delivered') {
                          return Color(0x1A3BB273);
                        } else if (orderDetailsOrderRecord.orderStatus ==
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
                          orderDetailsOrderRecord.orderStatus,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Satoshi',
                                color: () {
                                  if (orderDetailsOrderRecord.orderStatus ==
                                      'Approved') {
                                    return FlutterFlowTheme.of(context).skyblue;
                                  } else if (orderDetailsOrderRecord
                                          .orderStatus ==
                                      'Delivered') {
                                    return FlutterFlowTheme.of(context)
                                        .primarytheme;
                                  } else if (orderDetailsOrderRecord
                                          .orderStatus ==
                                      'Preparing') {
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
                ),
              ],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: StreamBuilder<FarmsRecord>(
                            stream: FarmsRecord.getDocument(
                                orderDetailsOrderRecord.farmRef!),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context)
                                            .primarytheme,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final columnFarmsRecord = snapshot.data!;

                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (orderDetailsOrderRecord
                                                .delievryMethod !=
                                            'farmpickup') {
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Approved') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Preparing') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      Icons
                                                          .check_circle_outline_sharp,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'dlr4llma' /* Confirmed */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasOrderConfiramtionTime()
                                                            ? '${dateTimeFormat(
                                                                "y-M-d",
                                                                orderDetailsOrderRecord
                                                                    .orderConfiramtionTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )},${dateTimeFormat(
                                                                "jm",
                                                                orderDetailsOrderRecord
                                                                    .orderConfiramtionTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: (orderDetailsOrderRecord.orderStatus == 'Preparing') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Picked Up') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'In Transit') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Delivered')
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord.orderStatus == 'Preparing') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kframe,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'n8qavman' /* Preparing */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasPreparingTime()
                                                            ? '${dateTimeFormat(
                                                                "y-M-d",
                                                                orderDetailsOrderRecord
                                                                    .preparingTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )},${dateTimeFormat(
                                                                "jm",
                                                                orderDetailsOrderRecord
                                                                    .preparingTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: (orderDetailsOrderRecord.orderStatus == 'Picked Up') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'In Transit') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Delivered')
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kcubecustom,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'hdg7fu2w' /* Picked Up */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasPickedUpTime()
                                                            ? '${dateTimeFormat(
                                                                "y-M-d",
                                                                orderDetailsOrderRecord
                                                                    .pickedUpTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )},${dateTimeFormat(
                                                                "jm",
                                                                orderDetailsOrderRecord
                                                                    .pickedUpTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'In Transit') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Delivered')
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kframe2,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'bo1qevvv' /* In Transit */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasInTransitTime()
                                                            ? '${dateTimeFormat(
                                                                "y-M-d",
                                                                orderDetailsOrderRecord
                                                                    .inTransitTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )},${dateTimeFormat(
                                                                "jm",
                                                                orderDetailsOrderRecord
                                                                    .inTransitTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: orderDetailsOrderRecord
                                                                      .orderStatus ==
                                                                  'Delivered'
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor:
                                                        orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kframe1,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'ubgps83r' /* Delivered */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasDeliveredTime()
                                                            ? '${dateTimeFormat(
                                                                "y-M-d",
                                                                orderDetailsOrderRecord
                                                                    .deliveredTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )},${dateTimeFormat(
                                                                "jm",
                                                                orderDetailsOrderRecord
                                                                    .deliveredTime,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Approved') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Preparing') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      Icons
                                                          .check_circle_outline_sharp,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'fa2yv1t4' /* Confirmed */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasOrderConfiramtionTime()
                                                            ? '${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "y-M-d",
                                                                  orderDetailsOrderRecord
                                                                      .orderConfiramtionTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )},${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "jm",
                                                                  orderDetailsOrderRecord
                                                                      .orderConfiramtionTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )}'
                                                            : ' -',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: (orderDetailsOrderRecord.orderStatus == 'Preparing') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Picked Up') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'In Transit') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Delivered')
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord.orderStatus == 'Preparing') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kframe,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          '1cxhh5t8' /* Preparing */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasPreparingTime()
                                                            ? '${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "y-M-d",
                                                                  orderDetailsOrderRecord
                                                                      .preparingTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )},${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "jm",
                                                                  orderDetailsOrderRecord
                                                                      .preparingTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )}'
                                                            : ' -',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: (orderDetailsOrderRecord.orderStatus == 'Picked Up') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'In Transit') ||
                                                                  (orderDetailsOrderRecord
                                                                          .orderStatus ==
                                                                      'Delivered')
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor: (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Picked Up') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'In Transit') ||
                                                            (orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered')
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kcubecustom,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'f8rnp406' /* Picked Up */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasPickedUpTime()
                                                            ? '${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "y-M-d",
                                                                  orderDetailsOrderRecord
                                                                      .pickedUpTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )},${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "jm",
                                                                  orderDetailsOrderRecord
                                                                      .pickedUpTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          18.0, 0.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 40.0,
                                                        child:
                                                            StyledVerticalDivider(
                                                          width: 0.0,
                                                          thickness: 2.0,
                                                          color: orderDetailsOrderRecord
                                                                      .orderStatus ==
                                                                  'Delivered'
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .primarytheme
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .textsecondary,
                                                          lineStyle:
                                                              DividerLineStyle
                                                                  .dashed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 50.0,
                                                    buttonSize: 36.0,
                                                    fillColor:
                                                        orderDetailsOrderRecord
                                                                    .orderStatus ==
                                                                'Delivered'
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .textsecondary,
                                                    icon: Icon(
                                                      FFIcons.kframe1,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      print(
                                                          'IconButton pressed ...');
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'my73fao6' /* Delivered */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Satoshi',
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                                .hasDeliveredTime()
                                                            ? '${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "y-M-d",
                                                                  orderDetailsOrderRecord
                                                                      .deliveredTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )},${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "jm",
                                                                  orderDetailsOrderRecord
                                                                      .deliveredTime,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                '-',
                                                              )}'
                                                            : ' ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 10.0)),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    if ((orderDetailsOrderRecord
                                                    .trackingUrl !=
                                                '') &&
                                        (orderDetailsOrderRecord
                                                .isAgricoDeliver ==
                                            true))
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await launchURL(
                                              orderDetailsOrderRecord
                                                  .trackingUrl);
                                        },
                                        child: Container(
                                          height: 30.0,
                                          decoration: BoxDecoration(),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                '7kzhwbai' /* Tracking Delivery */,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .orange,
                                                        letterSpacing: 0.0,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              FlutterFlowTheme.of(context).card,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .boderdivder,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 12.0, 12.0, 12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'cq2lwmp3' /* Order Items */,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    FFIcons.khome,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primarytheme,
                                                    size: 24.0,
                                                  ),
                                                  Text(
                                                    columnFarmsRecord.farmName,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  final orders =
                                                      orderDetailsOrderRecord
                                                          .orderItems
                                                          .toList();

                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: List.generate(
                                                        orders.length,
                                                        (ordersIndex) {
                                                      final ordersItem =
                                                          orders[ordersIndex];
                                                      return StreamBuilder<
                                                          ProductRecord>(
                                                        stream: ProductRecord
                                                            .getDocument(
                                                                ordersItem
                                                                    .productRef!),
                                                        builder: (context,
                                                            snapshot) {
                                                          // Customize what your widget looks like when it's loading.
                                                          if (!snapshot
                                                              .hasData) {
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

                                                          final rowProductRecord =
                                                              snapshot.data!;

                                                          return Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration(milliseconds: 500),
                                                                        fadeOutDuration:
                                                                            Duration(milliseconds: 500),
                                                                        imageUrl:
                                                                            rowProductRecord.productImage,
                                                                        width:
                                                                            52.0,
                                                                        height:
                                                                            52.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorWidget: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Image.asset(
                                                                          'assets/images/error_image.png',
                                                                          width:
                                                                              52.0,
                                                                          height:
                                                                              52.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            14.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                                                                              crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
                                                                              textBaseline: TextBaseline.alphabetic,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    rowProductRecord.productName,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Satoshi',
                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                if (ordersItem.isVariableWeight && (ordersItem.actualWeight > 0.0))
                                                                                  Text(
                                                                                    ordersItem.actualWeight > 0.0 ? '(${ordersItem.actualWeight.toString()} kg)' : '',
                                                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                          fontFamily: 'Satoshi',
                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                              ].divide(SizedBox(width: 4.0)),
                                                                            ),
                                                                            Text(
                                                                              ordersItem.isVariableWeight ? 'Quantity: ${ordersItem.totalItems.toString()}' : '1${rowProductRecord.unit} x ${ordersItem.totalItems.toString()}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).primarytheme,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                            if (ordersItem.isVariableWeight)
                                                                              Text(
                                                                                'Selected bracket: ${ordersItem.minWeight.toString()} - ${ordersItem.maxWeight.toString()} kg',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      color: FlutterFlowTheme.of(context).textsecondary,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            if (ordersItem.isVariableWeight)
                                                                              Text(
                                                                                'Deposit paid: ${formatOrderCurrency(ordersItem.depositAmount * ordersItem.totalItems.toDouble(), orderDetailsOrderRecord.currency)}',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      color: FlutterFlowTheme.of(context).textsecondary,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            6.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        if (!rowProductRecord
                                                                            .isVariableWeight)
                                                                          Text(
                                                                              formatOrderCurrency(
                                                                                rowProductRecord.price,
                                                                                orderDetailsOrderRecord.currency,
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }).divide(
                                                        SizedBox(height: 5.0)),
                                                  );
                                                },
                                              ),
                                            ].divide(SizedBox(height: 12.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (orderDetailsOrderRecord
                                        .hasDelievryAddress())
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .card,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .boderdivder,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'qahwkvyu' /* Delivery Information */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'dh2j8ubj' /* Name */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                            .delievryAddress
                                                            .fullName,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textprimary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          '1z7225d6' /* Address */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          '${orderDetailsOrderRecord.delievryAddress.streetAdress}',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textprimary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'wjm1onhk' /* Phone Number */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          orderDetailsOrderRecord
                                                              .delievryAddress
                                                              .phoneNo,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textprimary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'u70c3r2r' /* Delivery Method */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textsecondary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                      ),
                                                      Text(
                                                        orderDetailsOrderRecord
                                                            .delievryMethod,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textprimary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (orderDetailsOrderRecord
                                            .hasDelievryAddress() ==
                                        false)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                '4sbhs3bg' /* Delivery Method */,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                            Text(
                                              orderDetailsOrderRecord
                                                  .delievryMethod,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Satoshi',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .textprimary,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            FlutterFlowTheme.of(context).card,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .boderdivder,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'id4kjjz0' /* Bill Details */,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ),
                                            if (false)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 12.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '7qtwacfa' /* Item Total */,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          formatOrderCurrency(orderDetailsOrderRecord.subTotal, orderDetailsOrderRecord.currency),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textprimary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          width: 12.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (false)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'efa1pknq' /* Handling Fee */,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '53hdh1pq' /* $1.20 */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .textprimary,
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            StyledDivider(
                                              height: 0.0,
                                              thickness: 2.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .boderdivder,
                                              lineStyle:
                                                  DividerLineStyle.dashed,
                                            ),
                                            if (false)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '7ouyyzp8' /* Delivery Partner Fee */,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'cwvkervx' /* $2.00 */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .textprimary,
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (false)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'ofh9l50a' /* GST and Charges */,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'lhu32r6z' /* $1.10 */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .textprimary,
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (false)
                                              StyledDivider(
                                                height: 0.0,
                                                thickness: 2.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boderdivder,
                                                lineStyle:
                                                    DividerLineStyle.dashed,
                                              ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '7e9ntp0a' /* To Pay */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        formatOrderCurrency(
                                                          orderDetailsOrderRecord.totalAmmount,
                                                          orderDetailsOrderRecord.currency,
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
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (false)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 12.0, 0.0, 0.0),
                                                child: Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    '7lz37nwy' /* Stripe Payment */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            Color(0xFF88009B),
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            if (orderDetailsOrderRecord
                                                    .isVariableWeightOrder &&
                                                ((orderDetailsOrderRecord
                                                            .balancePaymentStatus ==
                                                        'payment_requested') ||
                                                    (orderDetailsOrderRecord
                                                            .balancePaymentStatus ==
                                                        'paid')))
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    (FFMainAxisAlignment
                                                            .spaceBetween)
                                                        .flutterValue,
                                                crossAxisAlignment:
                                                    (FFCrossAxisAlignment
                                                            .center)
                                                        .flutterValue,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getVariableText(
                                                        enText:
                                                            'Remaining balance',
                                                        frText: 'Solde restant',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
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
                                                  ),
                                                  if ((orderDetailsOrderRecord
                                                              .balancePaymentStatus ==
                                                          'payment_requested') ||
                                                      (orderDetailsOrderRecord
                                                              .balancePaymentStatus ==
                                                          'paid'))
                                                    Text(
                                                      formatOrderCurrency(orderDetailsOrderRecord.finalBalanceAmount, orderDetailsOrderRecord.currency),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                ],
                                              ),
                                            if (orderDetailsOrderRecord
                                                    .balancePaymentStatus ==
                                                'payment_requested')
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getVariableText(
                                                  enText:
                                                      'Your producer has confirmed the final product weights. Contact the producer to arrange this balance payment.',
                                                  frText:
                                                      'Votre producteur a confirmé les poids finaux. Contactez-le pour régler ce solde.',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            if (orderDetailsOrderRecord
                                                    .balancePaymentStatus ==
                                                'paid')
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getVariableText(
                                                  enText:
                                                      'Balance payment completed',
                                                  frText: 'Solde payé',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
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
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 24.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          _model.chatfind =
                                              await queryChatRecordOnce(
                                            queryBuilder: (chatRecord) =>
                                                chatRecord.where(
                                              'users',
                                              arrayContains:
                                                  currentUserReference,
                                            ),
                                          );
                                          if (_model.chatfind
                                                  ?.where((e) => e.users
                                                      .contains(
                                                          columnFarmsRecord
                                                              .userRef))
                                                  .toList()
                                                  .length !=
                                              0) {
                                            context.pushNamed(
                                              ChatConversationWidget.routeName,
                                              queryParameters: {
                                                'chatRef': serializeParam(
                                                  _model.chatfind
                                                      ?.where((e) => e.users
                                                          .contains(
                                                              columnFarmsRecord
                                                                  .userRef))
                                                      .toList()
                                                      .firstOrNull,
                                                  ParamType.Document,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                'chatRef': _model.chatfind
                                                    ?.where((e) => e.users
                                                        .contains(
                                                            columnFarmsRecord
                                                                .userRef))
                                                    .toList()
                                                    .firstOrNull,
                                              },
                                            );
                                          } else {
                                            _model.users = [];
                                            safeSetState(() {});
                                            _model.addToUsers(
                                                currentUserReference!);
                                            safeSetState(() {});
                                            _model.addToUsers(
                                                columnFarmsRecord.userRef!);
                                            safeSetState(() {});

                                            var chatRecordReference =
                                                ChatRecord.collection.doc();
                                            await chatRecordReference.set({
                                              ...createChatRecordData(
                                                createdAt: getCurrentTimestamp,
                                                farmRef:
                                                    columnFarmsRecord.reference,
                                                isSuspend: false,
                                                userb:
                                                    columnFarmsRecord.userRef,
                                                timeb: getCurrentTimestamp,
                                                usera: currentUserReference,
                                                timea: getCurrentTimestamp,
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
                                                farmRef:
                                                    columnFarmsRecord.reference,
                                                isSuspend: false,
                                                userb:
                                                    columnFarmsRecord.userRef,
                                                timeb: getCurrentTimestamp,
                                                usera: currentUserReference,
                                                timea: getCurrentTimestamp,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'users': _model.users,
                                                },
                                              ),
                                            }, chatRecordReference);

                                            context.pushNamed(
                                              ChatConversationWidget.routeName,
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

                                          safeSetState(() {});
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'vvpsn1l2' /* Contact */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kchat,
                                          size: 24.0,
                                        ),
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 48.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconAlignment: IconAlignment.end,
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconColor:
                                              FlutterFlowTheme.of(context)
                                                  .offwhite,
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.consumerNavbarModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ConsumerNavbarWidget(
                          index: 5,
                        ),
                      ),
                    ],
                  ),
                  if (orderDetailsOrderRecord.isSuspend)
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
