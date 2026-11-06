import '/flutter_flow/flutter_flow_util.dart';
import 'add_delivery_widget.dart' show AddDeliveryWidget;
import 'package:flutter/material.dart';

class AddDeliveryModel extends FlutterFlowModel<AddDeliveryWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
