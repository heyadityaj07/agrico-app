import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/consumer_navbar_widget.dart';
import '/components/filter_widget.dart';
import '/components/rout_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'maps_page_model.dart';
export 'maps_page_model.dart';

class MapsPageWidget extends StatefulWidget {
  const MapsPageWidget({super.key});

  static String routeName = 'mapsPage';
  static String routePath = '/mapsPage';

  @override
  State<MapsPageWidget> createState() => _MapsPageWidgetState();
}

class _MapsPageWidgetState extends State<MapsPageWidget> {
  late MapsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapsPageModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    _model.expandableExpandableController1 =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    _model.expandableExpandableController2 =
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
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
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
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'bfxwlnqy' /* Filter */,
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
                                color:
                                    FlutterFlowTheme.of(context).primarytheme,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          color: Color(0x00000000),
                          child: ExpandableNotifier(
                            controller: _model.expandableExpandableController1,
                            child: ExpandablePanel(
                              header: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x66FFFFFF),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Color(0xFFE2E6EA),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'ewx8lnpj' /* Category */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                  color: FlutterFlowTheme.of(
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
                                                  color: FlutterFlowTheme.of(
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
                                  'ljz9duiw' /*  */,
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
                                  queryBuilder: (farmsRecord) => farmsRecord
                                      .where(
                                        'is_suspend',
                                        isEqualTo: false,
                                      )
                                      .where(
                                        'approval_status',
                                        isEqualTo: true,
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
                                  List<FarmsRecord> containerFarmsRecordList =
                                      snapshot.data!;

                                  return Container(
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 12.0, 8.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final availability =
                                              containerFarmsRecordList
                                                  .unique((e) => e.farmType)
                                                  .toList();

                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                availability.length,
                                                (availabilityIndex) {
                                              final availabilityItem =
                                                  availability[
                                                      availabilityIndex];
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
                                                          availabilityItem
                                                              .farmType) {
                                                        _model.selectedavailbility =
                                                            null;
                                                        safeSetState(() {});
                                                      } else {
                                                        _model.selectedavailbility =
                                                            availabilityItem
                                                                .farmType;
                                                        safeSetState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                        ),
                                                      ),
                                                      child: Visibility(
                                                        visible: _model
                                                                .selectedavailbility ==
                                                            availabilityItem
                                                                .farmType,
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
                                                    availabilityItem.farmType,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                            controller: _model.expandableExpandableController2,
                            child: ExpandablePanel(
                              header: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x66FFFFFF),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Color(0xFFE2E6EA),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'd80mlaf0' /* Farming Method */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                  color: FlutterFlowTheme.of(
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
                                                  color: FlutterFlowTheme.of(
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
                                  'equqxv1v' /*  */,
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
                                  queryBuilder: (farmsRecord) => farmsRecord
                                      .where(
                                        'is_suspend',
                                        isEqualTo: false,
                                      )
                                      .where(
                                        'approval_status',
                                        isEqualTo: true,
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
                                  List<FarmsRecord> containerFarmsRecordList =
                                      snapshot.data!;

                                  return Container(
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                                      decoration: BoxDecoration(
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
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
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
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            safeSetState(() {});
                            if (scaffoldKey.currentState!.isDrawerOpen ||
                                scaffoldKey.currentState!.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          },
                          text: FFLocalizations.of(context).getText(
                            'wgfanzui' /* Update */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 48.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primarytheme,
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
          child: StreamBuilder<UsersRecord>(
            stream: UsersRecord.getDocument(currentUserReference!),
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

              final stackUsersRecord = snapshot.data!;

              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Stack(
                                  children: [
                                    StreamBuilder<List<FarmsRecord>>(
                                      stream: queryFarmsRecord(),
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
                                        List<FarmsRecord>
                                            containerFarmsRecordList =
                                            snapshot.data!;

                                        return Container(
                                          width: double.infinity,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.4,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: FlutterFlowGoogleMap(
                                            controller:
                                                _model.googleMapsController,
                                            onCameraIdle: (latLng) =>
                                                safeSetState(() => _model
                                                    .googleMapsCenter = latLng),
                                            initialLocation:
                                                _model.googleMapsCenter ??=
                                                    currentUserLocationValue!,
                                            markerColor:
                                                GoogleMarkerColor.violet,
                                            mapType: MapType.normal,
                                            style: GoogleMapStyle.standard,
                                            initialZoom: 14.0,
                                            allowInteraction: true,
                                            allowZoom: true,
                                            showZoomControls: true,
                                            showLocation: true,
                                            showCompass: true,
                                            showMapToolbar: false,
                                            showTraffic: false,
                                            centerMapOnMarkerTap: true,
                                            mapTakesGesturePreference: false,
                                          ),
                                        );
                                      },
                                    ),
                                    PointerInterceptor(
                                      intercepting: isWeb,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 24.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            wrapWithModel(
                                              model: _model.filterModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: FilterWidget(),
                                            ),
                                            wrapWithModel(
                                              model: _model.routModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: RoutWidget(),
                                            ),
                                          ].divide(SizedBox(width: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: StreamBuilder<List<FarmsRecord>>(
                                    stream: queryFarmsRecord(
                                      queryBuilder: (farmsRecord) => farmsRecord
                                          .where(
                                            'approval_status',
                                            isEqualTo: true,
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
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final containerVar =
                                                  containerFarmsRecordList
                                                      .where((e) =>
                                                          (_model.selectedavailbility !=
                                                                      null &&
                                                                  _model.selectedavailbility !=
                                                                      ''
                                                              ? (e.farmType ==
                                                                  _model
                                                                      .selectedavailbility)
                                                              : true) &&
                                                          (FFAppState()
                                                                  .selectedFarmingMethod
                                                                  .isNotEmpty
                                                              ? ((List<String>
                                                                          all,
                                                                      List<String>
                                                                          selected) {
                                                                  return ((selected ??
                                                                              [])
                                                                          .map((e) => e
                                                                              .trim()
                                                                              .toLowerCase())
                                                                          .toSet())
                                                                      .intersection((all ??
                                                                              [])
                                                                          .map((e) => e
                                                                              .trim()
                                                                              .toLowerCase())
                                                                          .toSet())
                                                                      .isNotEmpty;
                                                                }(
                                                                  e.farmingMethod
                                                                      .toList(),
                                                                  FFAppState()
                                                                      .selectedFarmingMethod
                                                                      .toList()))
                                                              : true))
                                                      .toList();

                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                          containerVar.length,
                                                          (containerVarIndex) {
                                                    final containerVarItem =
                                                        containerVar[
                                                            containerVarIndex];
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
                                                        context.pushNamed(
                                                          FarmProfileWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'farm':
                                                                serializeParam(
                                                              containerVarItem
                                                                  .reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 220.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .card,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            12.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    containerVarItem
                                                                        .farmProfilePhoto,
                                                                    width:
                                                                        220.0,
                                                                    height:
                                                                        105.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          1.0,
                                                                          -1.0),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            5.0,
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
                                                                      onTap:
                                                                          () async {
                                                                        if (stackUsersRecord
                                                                            .myFavouriteFarm
                                                                            .contains(containerVarItem.reference)) {
                                                                          await stackUsersRecord
                                                                              .reference
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'my_favourite_farm': FieldValue.arrayRemove([
                                                                                  containerVarItem.reference
                                                                                ]),
                                                                              },
                                                                            ),
                                                                          });
                                                                        } else {
                                                                          await stackUsersRecord
                                                                              .reference
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'my_favourite_farm': FieldValue.arrayUnion([
                                                                                  containerVarItem.reference
                                                                                ]),
                                                                              },
                                                                            ),
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          if (stackUsersRecord
                                                                              .myFavouriteFarm
                                                                              .contains(containerVarItem.reference)) {
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
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    containerVarItem
                                                                        .farmName,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Satoshi',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      containerVarItem
                                                                          .aboutFarm,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).textsecondary,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .harvestYellow,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      Text(
                                                                        FFLocalizations.of(context)
                                                                            .getText(
                                                                          'rr00dlwj' /* 4.9 (420 reviews) */,
                                                                        ),
                                                                        maxLines:
                                                                            11,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textsecondary,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        4.0)),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0,
                                                                      -1.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            8.0,
                                                                            0.0,
                                                                            8.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'zrhss0np' /* View Farm */,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  maxLines: 1,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Satoshi',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        lineHeight:
                                                                            1.5,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                      .divide(
                                                          SizedBox(width: 16.0))
                                                      .addToStart(
                                                          SizedBox(width: 16.0))
                                                      .addToEnd(SizedBox(
                                                          width: 16.0)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.consumerNavbarModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ConsumerNavbarWidget(
                          index: 1,
                        ),
                      ),
                    ],
                  ),
                  if (stackUsersRecord.isSuspend)
                    PointerInterceptor(
                      intercepting: isWeb,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: MediaQuery.sizeOf(context).height * 1.0,
                        decoration: BoxDecoration(),
                        child: ClipRRect(
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
                                  context.pushNamed(
                                      HelpandsupportWidget.routeName);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
