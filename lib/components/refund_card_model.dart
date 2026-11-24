import '/backend/backend.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'refund_card_widget.dart' show RefundCardWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RefundCardModel extends FlutterFlowModel<RefundCardWidget> {
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
        'gosulm54' /* Product Weight is required */,
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
