import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/carts/view_cart/view_cart_widget.dart';
import '/components/data_load_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'Search';
  static String routePath = '/search';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().selectedprice = [];
      FFAppState().selectedAvailability = [];
      FFAppState().selectedPreparation = [];
      FFAppState().selectedFarmingMethod = [];
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    _model.expandableExpandableController2 =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    _model.expandableExpandableController3 =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    _model.expandableExpandableController4 =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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

        final searchUsersRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            endDrawer: Drawer(
              elevation: 16.0,
              child: Align(
                alignment: AlignmentDirectional(1.0, -1.0),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).offwhite,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      '8bztsxby' /* Filter */,
                                    ),
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
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 24.0, 0.0),
                                  child: Icon(
                                    FFIcons.kfilter,
                                    color: FlutterFlowTheme.of(context)
                                        .primarytheme,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: Color(0x00000000),
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController1,
                                child: ExpandablePanel(
                                  header: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x66FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .boderdivder,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'm7s1itx8' /* Price */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (_model
                                                          .expandableExpandableController1
                                                          .expanded ??
                                                      false) {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* angleUp */ 0xf106,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  } else {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* chevronDown */ 0xf078,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  collapsed: Text(
                                    FFLocalizations.of(context).getText(
                                      'h40w3yzl' /*  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: Colors.transparent,
                                          fontSize: 2.0,
                                          letterSpacing: 0.0,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 12.0, 8.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final price = _model.pricelist.toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(price.length,
                                              (priceIndex) {
                                            final priceItem = price[priceIndex];
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (_model.selectedPrice ==
                                                        priceItem) {
                                                      _model.selectedPrice =
                                                          null;
                                                      safeSetState(() {});
                                                    } else {
                                                      _model.selectedPrice =
                                                          priceItem;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                      ),
                                                    ),
                                                    child: Visibility(
                                                      visible: _model
                                                              .selectedPrice ==
                                                          priceItem,
                                                      child: Icon(
                                                        Icons.check,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  priceItem,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            );
                                          }).divide(SizedBox(height: 8.0)),
                                        );
                                      },
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: Color(0x00000000),
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController2,
                                child: ExpandablePanel(
                                  header: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x66FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Color(0xFFE2E6EA),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '02q8t09p' /* Availability */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (_model
                                                          .expandableExpandableController2
                                                          .expanded ??
                                                      false) {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* angleUp */ 0xf106,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  } else {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* chevronDown */ 0xf078,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  collapsed: Text(
                                    FFLocalizations.of(context).getText(
                                      'zolwh4zo' /*  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: Colors.transparent,
                                          fontSize: 2.0,
                                          letterSpacing: 0.0,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 12.0, 8.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final availability =
                                            _model.availabilitylist.toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                              List.generate(availability.length,
                                                  (availabilityIndex) {
                                            final availabilityItem =
                                                availability[availabilityIndex];
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (_model
                                                            .selectedavailbility ==
                                                        availabilityItem) {
                                                      _model.selectedavailbility =
                                                          null;
                                                      safeSetState(() {});
                                                    } else {
                                                      _model.selectedavailbility =
                                                          availabilityItem;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                      ),
                                                    ),
                                                    child: Visibility(
                                                      visible: _model
                                                              .selectedavailbility ==
                                                          availabilityItem,
                                                      child: Icon(
                                                        Icons.check,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  availabilityItem,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textprimary,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 4.0)),
                                            );
                                          }).divide(SizedBox(height: 8.0)),
                                        );
                                      },
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              color: Color(0x00000000),
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController3,
                                child: ExpandablePanel(
                                  header: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x66FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Color(0xFFE2E6EA),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'a6eocfcr' /* tags */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (_model
                                                          .expandableExpandableController3
                                                          .expanded ??
                                                      false) {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* angleUp */ 0xf106,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  } else {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* chevronDown */ 0xf078,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 16.0,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  collapsed: Text(
                                    FFLocalizations.of(context).getText(
                                      'ffd86frp' /*  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: Colors.transparent,
                                          fontSize: 2.0,
                                          letterSpacing: 0.0,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: StreamBuilder<List<ProductRecord>>(
                                    stream: queryProductRecord(
                                      queryBuilder: (productRecord) =>
                                          productRecord.where(
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primarytheme,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<ProductRecord>
                                          containerProductRecordList =
                                          snapshot.data!;

                                      return Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 12.0, 8.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final preparation = functions
                                                  .tagslist(
                                                      containerProductRecordList
                                                          .toList())
                                                  .toList();

                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    preparation.length,
                                                    (preparationIndex) {
                                                  final preparationItem =
                                                      preparation[
                                                          preparationIndex];
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          if (FFAppState()
                                                              .selectedPreparation
                                                              .contains(
                                                                  preparationItem)) {
                                                            FFAppState()
                                                                .removeFromSelectedPreparation(
                                                                    preparationItem);
                                                            safeSetState(() {});
                                                          } else {
                                                            FFAppState()
                                                                .addToSelectedPreparation(
                                                                    preparationItem);
                                                            safeSetState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                            ),
                                                          ),
                                                          child: Visibility(
                                                            visible: FFAppState()
                                                                .selectedPreparation
                                                                .contains(
                                                                    preparationItem),
                                                            child: Icon(
                                                              Icons.check,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                              size: 12.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        preparationItem,
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
                                                    ].divide(
                                                        SizedBox(width: 4.0)),
                                                  );
                                                }).divide(
                                                    SizedBox(height: 8.0)),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 20.0),
                            child: Container(
                              width: double.infinity,
                              color: Color(0x00000000),
                              child: ExpandableNotifier(
                                controller:
                                    _model.expandableExpandableController4,
                                child: ExpandablePanel(
                                  header: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x66FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Color(0xFFE2E6EA),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'hlgdox8f' /* Farming Method */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  if (_model
                                                          .expandableExpandableController4
                                                          .expanded ??
                                                      false) {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* angleUp */ 0xf106,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  } else {
                                                    return FaIcon(
                                                      FaIconData(const IconData(
                                                          /* chevronDown */ 0xf078,
                                                          fontFamily:
                                                              'FontAwesomeSolid',
                                                          fontPackage:
                                                              'font_awesome_flutter')),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .textprimary,
                                                      size: 16.0,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  collapsed: Text(
                                    FFLocalizations.of(context).getText(
                                      '02iosxhh' /*  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: Colors.transparent,
                                          fontSize: 2.0,
                                          letterSpacing: 0.0,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: StreamBuilder<List<FarmsRecord>>(
                                    stream: queryFarmsRecord(
                                      queryBuilder: (farmsRecord) =>
                                          farmsRecord.where(
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primarytheme,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<FarmsRecord>
                                          containerFarmsRecordList =
                                          snapshot.data!;

                                      return Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 12.0, 8.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final farmingMethod = functions
                                                  .farminglist(
                                                      containerFarmsRecordList
                                                          .toList())
                                                  .toList();

                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    farmingMethod.length,
                                                    (farmingMethodIndex) {
                                                  final farmingMethodItem =
                                                      farmingMethod[
                                                          farmingMethodIndex];
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          if (FFAppState()
                                                              .selectedFarmingMethod
                                                              .contains(
                                                                  farmingMethodItem)) {
                                                            FFAppState()
                                                                .removeFromSelectedFarmingMethod(
                                                                    farmingMethodItem);
                                                            safeSetState(() {});
                                                          } else {
                                                            FFAppState()
                                                                .addToSelectedFarmingMethod(
                                                                    farmingMethodItem);
                                                            safeSetState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                            ),
                                                          ),
                                                          child: Visibility(
                                                            visible: FFAppState()
                                                                .selectedFarmingMethod
                                                                .contains(
                                                                    farmingMethodItem),
                                                            child: Icon(
                                                              Icons.check,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                              size: 12.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        farmingMethodItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 4.0)),
                                                  );
                                                }).divide(
                                                    SizedBox(height: 8.0)),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.top,
                                    hasIcon: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 40.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                safeSetState(() {});
                                if (scaffoldKey.currentState!.isDrawerOpen ||
                                    scaffoldKey.currentState!.isEndDrawerOpen) {
                                  Navigator.pop(context);
                                }
                              },
                              text: FFLocalizations.of(context).getText(
                                'mhg6tb4c' /* Update */,
                              ),
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
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ].addToEnd(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.arrow_back,
                                color: FlutterFlowTheme.of(context).textprimary,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Container(
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFF7F6F4),
                                          Color(0xFFF7F6F4),
                                          FlutterFlowTheme.of(context).info
                                        ],
                                        stops: [0.0, 0.6, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
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
                                          hintText: FFLocalizations.of(context)
                                              .getText(
                                            'bfjdr7fv' /* Organic */,
                                          ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textsecondary,
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
                                            const IconData(/* search */ 0xf002,
                                                fontFamily: 'FontAwesomeSolid',
                                                fontPackage:
                                                    'font_awesome_flutter'),
                                            color: FlutterFlowTheme.of(context)
                                                .textsecondary,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Satoshi',
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
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                scaffoldKey.currentState!.openEndDrawer();
                              },
                              child: Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: Color(0x0DFFFFFF),
                                  borderRadius: BorderRadius.circular(99.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).card,
                                  ),
                                ),
                                child: Icon(
                                  FFIcons.kfilter,
                                  color:
                                      FlutterFlowTheme.of(context).textprimary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<List<ProductRecord>>(
                          stream: queryProductRecord(
                            queryBuilder: (productRecord) => productRecord
                                .where(
                                  'approval_status',
                                  isEqualTo: true,
                                )
                                .where(
                                  'product_status',
                                  isEqualTo: 'Active',
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
                            List<ProductRecord> containerProductRecordList =
                                snapshot.data!;

                            return Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 24.0, 16.0, 0.0),
                                child: Builder(
                                  builder: (context) {
                                    final viewall = containerProductRecordList
                                        .where((e) =>
                                            (e.productName.toLowerCase().contains(
                                                _model.textController.text
                                                    .toLowerCase())) &&
                                            (_model.selectedPrice != null &&
                                                    _model.selectedPrice != ''
                                                ? () {
                                                    if (_model.selectedPrice ==
                                                        'Below \$20') {
                                                      return (e.price < 20.0);
                                                    } else if (_model
                                                            .selectedPrice ==
                                                        '\$20 - \$50') {
                                                      return ((e.price >=
                                                              20.0) &&
                                                          (e.price <= 50.0));
                                                    } else if (_model
                                                            .selectedPrice ==
                                                        '\$60 - \$80') {
                                                      return ((e.price >=
                                                              60.0) &&
                                                          (e.price <= 80.0));
                                                    } else {
                                                      return (e.price >= 80.0);
                                                    }
                                                  }()
                                                : true) &&
                                            (_model.selectedavailbility != null &&
                                                    _model.selectedavailbility !=
                                                        ''
                                                ? (_model.selectedavailbility ==
                                                        'In stock'
                                                    ? (e.stockQuantity > 1)
                                                    : !e.sesson.contains(
                                                        functions
                                                            .currentSeason()))
                                                : true) &&
                                            (FFAppState().selectedPreparation.isNotEmpty
                                                ? functions.hasAnySelectedTag(
                                                    e.badges.toList(),
                                                    FFAppState()
                                                        .selectedPreparation
                                                        .toList())
                                                : true))
                                        .toList();
                                    if (viewall.isEmpty) {
                                      return Center(
                                        child: NoChatProducerWidget(
                                          message: FFLocalizations.of(context)
                                              .getText(
                                            'lm0l39pj' /* No results found */,
                                          ),
                                          submsg: FFLocalizations.of(context)
                                              .getText(
                                            '2um6qye6' /* We couldn’t find any products ... */,
                                          ),
                                          index: 0,
                                        ),
                                      );
                                    }

                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: List.generate(viewall.length,
                                            (viewallIndex) {
                                          final viewallItem =
                                              viewall[viewallIndex];
                                          return StreamBuilder<UsersRecord>(
                                            stream: UsersRecord.getDocument(
                                                viewallItem.userRef!),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return DataLoadWidget(
                                                  height: 115.0,
                                                  width: 300.0,
                                                  cmncolor: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                );
                                              }

                                              final containerfmuserUsersRecord =
                                                  snapshot.data!;

                                              return Container(
                                                decoration: BoxDecoration(),
                                                child: Visibility(
                                                  visible:
                                                      containerfmuserUsersRecord
                                                              .stripeConnectStatus ==
                                                          'active',
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 16.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context.pushNamed(
                                                          ProductDetailsPageWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'product':
                                                                serializeParam(
                                                              viewallItem
                                                                  .reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
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
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      11.0,
                                                                      8.0,
                                                                      8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        1.0,
                                                                        -1.0),
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fadeInDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      fadeOutDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      imageUrl:
                                                                          viewallItem
                                                                              .productImage,
                                                                      width:
                                                                          120.0,
                                                                      height:
                                                                          120.0,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      errorWidget: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/error_image.png',
                                                                        width:
                                                                            120.0,
                                                                        height:
                                                                            120.0,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            25.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0x34000000),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 10.0,
                                                                              color: Color(0x34000000),
                                                                              offset: Offset(
                                                                                0.0,
                                                                                0.0,
                                                                              ),
                                                                              spreadRadius: 0.0,
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(9999.0),
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                14.0,
                                                                                0.0,
                                                                                14.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                viewallItem.badges.firstOrNull,
                                                                                'Organic',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).offwhite,
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: StreamBuilder<
                                                                      FarmsRecord>(
                                                                    stream: FarmsRecord.getDocument(
                                                                        viewallItem
                                                                            .farmRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return DataLoadWidget(
                                                                          height:
                                                                              120.0,
                                                                          width:
                                                                              150.0,
                                                                          cmncolor:
                                                                              FlutterFlowTheme.of(context).card,
                                                                        );
                                                                      }

                                                                      final columnFarmsRecord =
                                                                          snapshot
                                                                              .data!;

                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 3,
                                                                                child: Text(
                                                                                  viewallItem.productName,
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Satoshi',
                                                                                        color: FlutterFlowTheme.of(context).textprimary,
                                                                                        fontSize: 16.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(1.0, -1.0),
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      if (searchUsersRecord.myFavouriteProduct.contains(viewallItem.reference)) {
                                                                                        await searchUsersRecord.reference.update({
                                                                                          ...mapToFirestore(
                                                                                            {
                                                                                              'my_favourite_product': FieldValue.arrayRemove([
                                                                                                viewallItem.reference
                                                                                              ]),
                                                                                            },
                                                                                          ),
                                                                                        });
                                                                                      } else {
                                                                                        await searchUsersRecord.reference.update({
                                                                                          ...mapToFirestore(
                                                                                            {
                                                                                              'my_favourite_product': FieldValue.arrayUnion([
                                                                                                viewallItem.reference
                                                                                              ]),
                                                                                            },
                                                                                          ),
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Builder(
                                                                                      builder: (context) {
                                                                                        if (searchUsersRecord.myFavouriteProduct.contains(viewallItem.reference)) {
                                                                                          return Icon(
                                                                                            Icons.favorite_sharp,
                                                                                            color: FlutterFlowTheme.of(context).tometoRed,
                                                                                            size: 24.0,
                                                                                          );
                                                                                        } else {
                                                                                          return Icon(
                                                                                            Icons.favorite_border,
                                                                                            color: FlutterFlowTheme.of(context).tometoRed,
                                                                                            size: 24.0,
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                4.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              columnFarmsRecord.farmName,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).textsecondary,
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          if (responsiveVisibility(
                                                                            context:
                                                                                context,
                                                                            phone:
                                                                                false,
                                                                            tablet:
                                                                                false,
                                                                            tabletLandscape:
                                                                                false,
                                                                          ))
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'xgvykmi1' /* 4.5 km • 0.2 lbs CO₂ saved */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      color: FlutterFlowTheme.of(context).textsecondary,
                                                                                      fontSize: 10.0,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    if (FFLocalizations.of(context).languageCode != 'fr')
                                                                                      Text(
                                                                                        FFLocalizations.of(context).getText(
                                                                                          '6tap2z6j' /* $ */,
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        viewallItem.price.toString(),
                                                                                        '0',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Satoshi',
                                                                                            color: FlutterFlowTheme.of(context).primarytheme,
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                    ),
                                                                                    if (FFLocalizations.of(context).languageCode != 'en')
                                                                                      Text(
                                                                                        FFLocalizations.of(context).getText(
                                                                                          's8ddl1xo' /* € */,
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                    Text(
                                                                                      ' / ${viewallItem.unit}',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Satoshi',
                                                                                            color: FlutterFlowTheme.of(context).primarytheme,
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              if (containerfmuserUsersRecord.subscriptionActive && ((containerfmuserUsersRecord.subscriptionPlanName != 'root_plan') && (containerfmuserUsersRecord.subscriptionPlanName != 'root_plan_yearly')) && (viewallItem.stockQuantity > 0))
                                                                                StreamBuilder<List<CartRecord>>(
                                                                                  stream: queryCartRecord(
                                                                                    parent: searchUsersRecord.reference,
                                                                                    queryBuilder: (cartRecord) => cartRecord.where(
                                                                                      'productRef',
                                                                                      isEqualTo: viewallItem.reference,
                                                                                    ),
                                                                                    singleRecord: true,
                                                                                  ),
                                                                                  builder: (context, snapshot) {
                                                                                    // Customize what your widget looks like when it's loading.
                                                                                    if (!snapshot.hasData) {
                                                                                      return Center(
                                                                                        child: SizedBox(
                                                                                          width: 40.0,
                                                                                          height: 40.0,
                                                                                          child: CircularProgressIndicator(
                                                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                                                              Colors.transparent,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    List<CartRecord> containerCartRecordList = snapshot.data!;
                                                                                    final containerCartRecord = containerCartRecordList.isNotEmpty ? containerCartRecordList.first : null;

                                                                                    return InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (containerCartRecord?.reference != null) {
                                                                                          await containerCartRecord!.reference.delete();
                                                                                          FFAppState().cartlist = FFAppState().cartlist + (FFAppState().cartlist >= 1 ? -1 : 0);
                                                                                          safeSetState(() {});
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: Text(
                                                                                                '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                  enText: ' has been removed from cart',
                                                                                                  frText: ' a été retiré du panier',
                                                                                                )}',
                                                                                                style: TextStyle(
                                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                                ),
                                                                                              ),
                                                                                              duration: Duration(milliseconds: 4000),
                                                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                            ),
                                                                                          );
                                                                                        } else {
                                                                                          _model.carts = await queryCartRecordOnce(
                                                                                            parent: currentUserReference,
                                                                                          );
                                                                                          if (_model.carts?.length != 0) {
                                                                                            if (_model.carts?.firstOrNull?.farmRef == columnFarmsRecord.reference) {
                                                                                              await CartRecord.createDoc(searchUsersRecord.reference).set(createCartRecordData(
                                                                                                productRef: viewallItem.reference,
                                                                                                quantity: 1,
                                                                                                pricePerProduct: viewallItem.price,
                                                                                                farmRef: viewallItem.farmRef,
                                                                                              ));
                                                                                              FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                              safeSetState(() {});
                                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                                SnackBar(
                                                                                                  content: Text(
                                                                                                    '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                      enText: ' has been added in cart',
                                                                                                      frText: ' a été ajouté au panier',
                                                                                                    )}',
                                                                                                    style: TextStyle(
                                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                                    ),
                                                                                                  ),
                                                                                                  duration: Duration(milliseconds: 4000),
                                                                                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                ),
                                                                                              );
                                                                                            } else {
                                                                                              _model.oldfarm = await FarmsRecord.getDocumentOnce(_model.carts!.firstOrNull!.farmRef!);
                                                                                              ScaffoldMessenger.of(context).clearSnackBars();
                                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                                SnackBar(
                                                                                                  content: Text(
                                                                                                    '${FFLocalizations.of(context).getVariableText(
                                                                                                      enText: 'Oops! You already have delicious items from ',
                                                                                                      frText: 'Oups ! Vous avez déjà de délicieux articles de ',
                                                                                                    )}${_model.oldfarm?.farmName}${FFLocalizations.of(context).getVariableText(
                                                                                                      enText: ' in your cart. To add items from ',
                                                                                                      frText: 'dans votre panier. Pour ajouter des articles depuis ',
                                                                                                    )}${columnFarmsRecord.farmName}${FFLocalizations.of(context).getVariableText(
                                                                                                      enText: ', you\'ll need to start a new order.',
                                                                                                      frText: ', Vous devrez passer une nouvelle commande.',
                                                                                                    )}',
                                                                                                    style: TextStyle(
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                    ),
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                  duration: Duration(milliseconds: 4850),
                                                                                                  backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                                ),
                                                                                              );
                                                                                            }
                                                                                          } else {
                                                                                            await CartRecord.createDoc(searchUsersRecord.reference).set(createCartRecordData(
                                                                                              productRef: viewallItem.reference,
                                                                                              quantity: 1,
                                                                                              pricePerProduct: viewallItem.price,
                                                                                              farmRef: viewallItem.farmRef,
                                                                                            ));
                                                                                            FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                            safeSetState(() {});
                                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                              SnackBar(
                                                                                                content: Text(
                                                                                                  '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                    enText: ' has been added in cart',
                                                                                                    frText: ' a été ajouté au panier',
                                                                                                  )}',
                                                                                                  style: TextStyle(
                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                  ),
                                                                                                ),
                                                                                                duration: Duration(milliseconds: 4000),
                                                                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                              ),
                                                                                            );
                                                                                          }
                                                                                        }

                                                                                        safeSetState(() {});
                                                                                      },
                                                                                      child: Container(
                                                                                        width: 26.0,
                                                                                        height: 26.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: containerCartRecord?.reference == null ? Color(0x1A3BB273) : Color(0x39E63946),
                                                                                          borderRadius: BorderRadius.circular(4.0),
                                                                                          border: Border.all(
                                                                                            color: containerCartRecord?.reference == null ? FlutterFlowTheme.of(context).primarytheme : FlutterFlowTheme.of(context).tometoRed,
                                                                                          ),
                                                                                        ),
                                                                                        child: Builder(
                                                                                          builder: (context) {
                                                                                            if (containerCartRecord?.reference == null) {
                                                                                              return Icon(
                                                                                                Icons.add,
                                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                size: 24.0,
                                                                                              );
                                                                                            } else {
                                                                                              return Icon(
                                                                                                Icons.remove,
                                                                                                color: FlutterFlowTheme.of(context).tometoRed,
                                                                                                size: 24.0,
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
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
                                              );
                                            },
                                          );
                                        }).addToEnd(SizedBox(height: 15.0)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: StreamBuilder<List<CartRecord>>(
                          stream: queryCartRecord(
                            parent: searchUsersRecord.reference,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return DataLoadWidget(
                                height: 80.0,
                                width: MediaQuery.sizeOf(context).width,
                                cmncolor: FlutterFlowTheme.of(context).card,
                              );
                            }
                            List<CartRecord> containerCartRecordList =
                                snapshot.data!;

                            return Container(
                              decoration: BoxDecoration(),
                              child: Visibility(
                                visible: containerCartRecordList.isNotEmpty,
                                child: Container(
                                  width: double.infinity,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).card,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        18.0, 16.0, 18.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: Builder(
                                                builder: (context) {
                                                  if (containerCartRecordList
                                                          .length >
                                                      1) {
                                                    return Container(
                                                      width: 90.0,
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Transform
                                                                .rotate(
                                                              angle: 197.0 *
                                                                  (math.pi /
                                                                      180),
                                                              child: StreamBuilder<
                                                                  ProductRecord>(
                                                                stream: ProductRecord.getDocument(
                                                                    containerCartRecordList
                                                                        .firstOrNull!
                                                                        .productRef!),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primarytheme,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }

                                                                  final imageProductRecord =
                                                                      snapshot
                                                                          .data!;

                                                                  return ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fadeInDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      fadeOutDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      imageUrl:
                                                                          imageProductRecord
                                                                              .productImage,
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          FutureBuilder<
                                                              ProductRecord>(
                                                            future: ProductRecord
                                                                .getDocumentOnce(
                                                                    containerCartRecordList
                                                                        .lastOrNull!
                                                                        .productRef!),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
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

                                                              final transformProductRecord =
                                                                  snapshot
                                                                      .data!;

                                                              return Transform
                                                                  .rotate(
                                                                angle: 62.0 *
                                                                    (math.pi /
                                                                        180),
                                                                child:
                                                                    Visibility(
                                                                  visible:
                                                                      transformProductRecord
                                                                              .reference !=
                                                                          null,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fadeInDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      fadeOutDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      imageUrl:
                                                                          transformProductRecord
                                                                              .productImage,
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return StreamBuilder<
                                                        ProductRecord>(
                                                      stream: ProductRecord
                                                          .getDocument(
                                                              containerCartRecordList
                                                                  .firstOrNull!
                                                                  .productRef!),
                                                      builder:
                                                          (context, snapshot) {
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

                                                        final imageProductRecord =
                                                            snapshot.data!;

                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            imageUrl:
                                                                imageProductRecord
                                                                    .productImage,
                                                            width: 45.0,
                                                            height: 45.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        '${containerCartRecordList.length.toString()} Item',
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
                                                                          .bold,
                                                                ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
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
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        ViewCartWidget(),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                          child: FaIcon(
                                                            FaIconData(const IconData(
                                                                /* angleUp */ 0xf106,
                                                                fontFamily:
                                                                    'FontAwesomeSolid',
                                                                fontPackage:
                                                                    'font_awesome_flutter')),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tometoRed,
                                                            size: 15.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Total ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primarytheme,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      if (FFLocalizations.of(
                                                                  context)
                                                              .languageCode !=
                                                          'fr')
                                                        Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'ibnhfn3k' /* $ */,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          functions
                                                              .cartTotal(
                                                                  containerCartRecordList
                                                                      .toList())
                                                              .toStringAsFixed(
                                                                  2),
                                                          '0',
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
                                                                      .primarytheme,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                      ),
                                                      if (FFLocalizations.of(
                                                                  context)
                                                              .languageCode !=
                                                          'en')
                                                        Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'lewy73tn' /* € */,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                  CartWidget.routeName);
                                            },
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              'vl18nyun' /* View Cart */,
                                            ),
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primarytheme,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (searchUsersRecord.isSuspend)
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
