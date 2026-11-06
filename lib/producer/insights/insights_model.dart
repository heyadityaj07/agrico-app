import '/components/producer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'insights_widget.dart' show InsightsWidget;
import 'package:flutter/material.dart';

class InsightsModel extends FlutterFlowModel<InsightsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for suspend component.
  late SuspendModel suspendModel;
  // Model for ProducerNavbar component.
  late ProducerNavbarModel producerNavbarModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
    producerNavbarModel = createModel(context, () => ProducerNavbarModel());
  }

  @override
  void dispose() {
    suspendModel.dispose();
    producerNavbarModel.dispose();
  }
}
