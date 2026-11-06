import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'myfavorites_widget.dart' show MyfavoritesWidget;
import 'package:flutter/material.dart';

class MyfavoritesModel extends FlutterFlowModel<MyfavoritesWidget> {
  ///  Local state fields for this page.

  int? tabindex = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  List<CartRecord>? carts;
  // Stores action output result for [Backend Call - Read Document] action in Container widget.
  FarmsRecord? oldfarm;
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
