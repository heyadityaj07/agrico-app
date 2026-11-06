import '/components/consumer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'checkoutfinal_widget.dart' show CheckoutfinalWidget;
import 'package:flutter/material.dart';

class CheckoutfinalModel extends FlutterFlowModel<CheckoutfinalWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ConsumerNavbar component.
  late ConsumerNavbarModel consumerNavbarModel;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    consumerNavbarModel = createModel(context, () => ConsumerNavbarModel());
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    consumerNavbarModel.dispose();
    suspendModel.dispose();
  }
}
