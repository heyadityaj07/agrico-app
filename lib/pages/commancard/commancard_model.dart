import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'commancard_widget.dart' show CommancardWidget;
import 'package:flutter/material.dart';

class CommancardModel extends FlutterFlowModel<CommancardWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  CartRecord? cart;
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  List<CartRecord>? carts;
  // Stores action output result for [Backend Call - Read Document] action in Container widget.
  FarmsRecord? oldfarm;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
