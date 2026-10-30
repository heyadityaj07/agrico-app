import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/consumer_navbar_widget.dart';
import '/components/filter_widget.dart';
import '/components/rout_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'maps_page_copy_model.dart';
export 'maps_page_copy_model.dart';

class MapsPageCopyWidget extends StatefulWidget {
  const MapsPageCopyWidget({super.key});

  static String routeName = 'mapsPageCopy';
  static String routePath = '/mapsPageCopy';

  @override
  State<MapsPageCopyWidget> createState() => _MapsPageCopyWidgetState();
}

class _MapsPageCopyWidgetState extends State<MapsPageCopyWidget> {
  late MapsPageCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapsPageCopyModel());

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
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 50.0, 12.0, 0.0),
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
                                  '2o2txk02' /* Filter */,
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
                                              'm3urz4y3' /* Category */,
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
                                  '53wksj35' /*  */,
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
                                              'glfw325p' /* Farming Method */,
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
                                  'kgzqeel5' /*  */,
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
                            '4ztl4j6y' /* Update */,
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
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: StreamBuilder<List<FarmsRecord>>(
                      stream: queryFarmsRecord(),
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

                        return Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.95,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: custom_widgets.Mapcomponenet(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.85,
                            defaultRadius: 50.0,
                            farms: containerFarmsRecordList,
                            selectedCategory: _model.selectedavailbility,
                            selectedFarmingMethods:
                                FFAppState().selectedFarmingMethod,
                            markertapaction: () async {
                              safeSetState(() {});

                              context.pushNamed(
                                FarmProfileWidget.routeName,
                                queryParameters: {
                                  'farm': serializeParam(
                                    FFAppState().selectedFarmRef,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            routwidget: () => RoutWidget(),
                            filter: () => FilterWidget(),
                          ),
                        );
                      },
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
              if (valueOrDefault<bool>(currentUserDocument?.isSuspend, false))
                AuthUserStreamWidget(
                  builder: (context) => Container(
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
                              context.pushNamed(HelpandsupportWidget.routeName);
                            },
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
    );
  }
}
