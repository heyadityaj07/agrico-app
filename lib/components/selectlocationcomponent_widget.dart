import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'selectlocationcomponent_model.dart';
export 'selectlocationcomponent_model.dart';

class SelectlocationcomponentWidget extends StatefulWidget {
  const SelectlocationcomponentWidget({
    super.key,
    required this.farmRef,
  });

  final DocumentReference? farmRef;

  @override
  State<SelectlocationcomponentWidget> createState() =>
      _SelectlocationcomponentWidgetState();
}

class _SelectlocationcomponentWidgetState
    extends State<SelectlocationcomponentWidget> {
  late SelectlocationcomponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectlocationcomponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
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
            await widget.farmRef!.update(createFarmsRecordData(
              farmLocation: FFAppState().Selectedlocation,
              farmAddress: address,
            ));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
