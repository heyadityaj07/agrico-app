import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'farm_location_widget.dart' show FarmLocationWidget;
import 'package:flutter/material.dart';

class FarmLocationModel extends FlutterFlowModel<FarmLocationWidget> {
  ///  State fields for stateful widgets in this page.

  List<FarmsRecord>? containerPreviousSnapshot;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    suspendModel.dispose();
  }
}
