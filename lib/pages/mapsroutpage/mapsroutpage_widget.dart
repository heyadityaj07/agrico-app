import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mapsroutpage_model.dart';
export 'mapsroutpage_model.dart';

class MapsroutpageWidget extends StatefulWidget {
  const MapsroutpageWidget({
    super.key,
    required this.destination,
    required this.startlocation,
    required this.radius,
  });

  final LatLng? destination;
  final LatLng? startlocation;
  final double? radius;

  static String routeName = 'mapsroutpage';
  static String routePath = '/mapsroutpage';

  @override
  State<MapsroutpageWidget> createState() => _MapsroutpageWidgetState();
}

class _MapsroutpageWidgetState extends State<MapsroutpageWidget> {
  late MapsroutpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapsroutpageModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
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

        final mapsroutpageUsersRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            body: Stack(
              children: [
                StreamBuilder<List<FarmsRecord>>(
                  stream: queryFarmsRecord(
                    queryBuilder: (farmsRecord) => farmsRecord.where(
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
                    List<FarmsRecord> containerFarmsRecordList = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          custom_widgets.MapPage(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: MediaQuery.sizeOf(context).height * 1.0,
                            farms: containerFarmsRecordList,
                            destinationLocation: widget.destination!,
                            startLocation: widget.startlocation!,
                            currentlocation: widget.startlocation!,
                            radius: widget.radius,
                            action: () async {
                              context.pushNamed(
                                FarmProfileWidget.routeName,
                                queryParameters: {
                                  'farm': serializeParam(
                                    FFAppState().farmref,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (mapsroutpageUsersRecord.isSuspend)
                  Container(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
