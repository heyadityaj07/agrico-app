import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/place.dart';
import 'dart:io';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'findproductrout_model.dart';
export 'findproductrout_model.dart';

class FindproductroutWidget extends StatefulWidget {
  const FindproductroutWidget({super.key});

  @override
  State<FindproductroutWidget> createState() => _FindproductroutWidgetState();
}

class _FindproductroutWidgetState extends State<FindproductroutWidget> {
  late FindproductroutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FindproductroutModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 80.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).card,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context).getText(
                  '7dadt07o' /* Find producers along your rout... */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Satoshi',
                      color: FlutterFlowTheme.of(context).textprimary,
                      letterSpacing: 0.0,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Container(
                            width: 11.0,
                            height: 11.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primarytheme,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3.0,
                                  color:
                                      FlutterFlowTheme.of(context).primarytheme,
                                  spreadRadius: 2.0,
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        StyledDivider(
                          height: 20.0,
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).textprimary,
                          lineStyle: DividerLineStyle.dashed,
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          color: FlutterFlowTheme.of(context).orange,
                          size: 24.0,
                        ),
                      ].divide(SizedBox(height: 5.0)),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FlutterFlowPlacePicker(
                            iOSGoogleMapsApiKey:
                                'AIzaSyDs54T-XQN008UL5eqPn7WzlZJsQk4kjlA',
                            androidGoogleMapsApiKey:
                                'AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc',
                            webGoogleMapsApiKey:
                                'AIzaSyCCI5dSMJfpbH-xb2ZMWrShpLyq_RPbM_Q',
                            onSelect: (place) async {
                              safeSetState(
                                  () => _model.startPlacePickerValue = place);
                            },
                            defaultText: FFLocalizations.of(context).getText(
                              'mun0e2if' /* Your Location */,
                            ),
                            buttonOptions: FFButtonOptions(
                              width: 200.0,
                              height: 40.0,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Satoshi',
                                    color: FlutterFlowTheme.of(context)
                                        .textsecondary,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).boderdivder,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          FlutterFlowPlacePicker(
                            iOSGoogleMapsApiKey:
                                'AIzaSyDs54T-XQN008UL5eqPn7WzlZJsQk4kjlA',
                            androidGoogleMapsApiKey:
                                'AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc',
                            webGoogleMapsApiKey:
                                'AIzaSyCCI5dSMJfpbH-xb2ZMWrShpLyq_RPbM_Q',
                            onSelect: (place) async {
                              safeSetState(() =>
                                  _model.destinationPlacePickerValue = place);
                            },
                            defaultText: FFLocalizations.of(context).getText(
                              'oqefslrl' /* Destination Location */,
                            ),
                            buttonOptions: FFButtonOptions(
                              width: 200.0,
                              height: 40.0,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Satoshi',
                                    color: FlutterFlowTheme.of(context)
                                        .textsecondary,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).boderdivder,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 4.0),
                child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      child: Slider(
                        activeColor: FlutterFlowTheme.of(context).primarytheme,
                        inactiveColor: FlutterFlowTheme.of(context).boderdivder,
                        min: 0.0,
                        max: 100.0,
                        value: _model.sliderValue ??= 8.0,
                        onChanged: (newValue) {
                          newValue = double.parse(newValue.toStringAsFixed(2));
                          safeSetState(() => _model.sliderValue = newValue);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                child: Text(
                  '${FFLocalizations.of(context).getVariableText(
                    enText: 'Detect radius: ',
                    frText: 'Détecter le rayon :',
                  )}${_model.sliderValue?.toString()} km',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Satoshi',
                        color: FlutterFlowTheme.of(context).textsecondary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      _model.location = await actions.islocateionselect(
                        _model.startPlacePickerValue.latLng,
                        _model.destinationPlacePickerValue.latLng,
                      );
                      if (_model.location == true) {
                        Navigator.pop(context);

                        context.pushNamed(
                          MapsroutpageWidget.routeName,
                          queryParameters: {
                            'destination': serializeParam(
                              _model.destinationPlacePickerValue.latLng,
                              ParamType.LatLng,
                            ),
                            'startlocation': serializeParam(
                              _model.startPlacePickerValue.latLng,
                              ParamType.LatLng,
                            ),
                            'radius': serializeParam(
                              _model.sliderValue,
                              ParamType.double,
                            ),
                          }.withoutNulls,
                        );
                      } else {
                        await actions.toast(
                          context,
                          FFLocalizations.of(context).getVariableText(
                            enText:
                                'Please select destination location and  your location',
                            frText:
                                'Veuillez sélectionner votre lieu de destination et votre emplacement.',
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    text: FFLocalizations.of(context).getText(
                      '9xpe2fgw' /* Update */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 48.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primarytheme,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Satoshi',
                                color: FlutterFlowTheme.of(context).alternate,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
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
