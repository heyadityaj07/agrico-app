import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selectlocationcomponentedit_model.dart';
export 'selectlocationcomponentedit_model.dart';

class SelectlocationcomponenteditWidget extends StatefulWidget {
  const SelectlocationcomponenteditWidget({
    super.key,
    required this.farmRef,
  });

  final DocumentReference? farmRef;

  @override
  State<SelectlocationcomponenteditWidget> createState() =>
      _SelectlocationcomponenteditWidgetState();
}

class _SelectlocationcomponenteditWidgetState
    extends State<SelectlocationcomponenteditWidget> {
  late SelectlocationcomponenteditModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectlocationcomponenteditModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.farm = await FarmsRecord.getDocumentOnce(widget!.farmRef!);
      FFAppState().Selectedlocation = _model.farm?.farmLocation;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 0.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.LocationPickerMap(
              width: double.infinity,
              height: double.infinity,
              onConfirm: (address) async {
                await widget!.farmRef!.update(createFarmsRecordData(
                  farmLocation: FFAppState().Selectedlocation,
                  farmAddress: address,
                ));
                _model.farmcheck =
                    await FarmsRecord.getDocumentOnce(widget!.farmRef!);
                if (_model.farmcheck?.agricooDelivery == true) {
                  _model.farmaddress = await actions.getAddressFromLatLng(
                    FFAppState().Selectedlocation!,
                  );
                  _model.success = await ValidateAccessCall.call(
                    address: _model.farmaddress,
                  );

                  if ((_model.success?.succeeded ?? true)) {
                    if (ValidateAccessCall.issupported(
                      (_model.success?.jsonBody ?? ''),
                    )!) {
                      await widget!.farmRef!.update(createFarmsRecordData(
                        agricooDelivery: true,
                      ));
                    } else {
                      await widget!.farmRef!.update(createFarmsRecordData(
                        agricooDelivery: false,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ValidateAccessCall.message(
                              (_model.success?.jsonBody ?? ''),
                            )!,
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).primarytheme,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ValidateAccessCall.message(
                            (_model.success?.jsonBody ?? ''),
                          )!,
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                        backgroundColor:
                            FlutterFlowTheme.of(context).primarytheme,
                      ),
                    );
                  }
                }
                Navigator.pop(context);
                _model.updatePage(() {});

                safeSetState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
