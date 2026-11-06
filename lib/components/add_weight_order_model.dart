import '/flutter_flow/flutter_flow_util.dart';
import 'add_weight_order_widget.dart' show AddWeightOrderWidget;
import 'package:flutter/material.dart';

class AddWeightOrderModel extends FlutterFlowModel<AddWeightOrderWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for actualWeightInput widget.
  FocusNode? actualWeightInputFocusNode;
  TextEditingController? actualWeightInputTextController;
  String? Function(BuildContext, String?)?
      actualWeightInputTextControllerValidator;
  String? _actualWeightInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'w8w9m18u' /* Product Weight is required */,
      );
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    actualWeightInputTextControllerValidator =
        _actualWeightInputTextControllerValidator;
  }

  @override
  void dispose() {
    actualWeightInputFocusNode?.dispose();
    actualWeightInputTextController?.dispose();
  }
}
