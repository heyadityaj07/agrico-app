import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'delivery_address_widget.dart' show DeliveryAddressWidget;
import 'package:flutter/material.dart';

class DeliveryAddressModel extends FlutterFlowModel<DeliveryAddressWidget> {
  ///  State fields for stateful widgets in this page.

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
