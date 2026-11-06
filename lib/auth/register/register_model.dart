import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'register_widget.dart' show RegisterWidget;
import 'package:flutter/material.dart';

class RegisterModel extends FlutterFlowModel<RegisterWidget> {
  ///  Local state fields for this page.

  bool isloading = false;

  bool isappleLoading = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'c3zzori7' /* Enter your name is required */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '4ztqsju2' /* Enter your email is required */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  late FocusNode textFieldPasswordVisibilityFocusNode3;
  FocusNode? textFieldFocusNode3;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  String? _passwordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'qm7707nt' /* Create a password is required */,
      );
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  FarmsRecord? fams;
  // Stores action output result for [Backend Call - Create Document] action in Container widget.
  FarmsRecord? farms;
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  FarmsRecord? farmcopy;
  // Stores action output result for [Backend Call - Create Document] action in Container widget.
  FarmsRecord? farmsCopy;
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  FarmsRecord? farmcopyCopy;

  @override
  void initState(BuildContext context) {
    textControllerValidator = _textControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    textFieldPasswordVisibilityFocusNode3 = FocusNode();
    passwordVisibility = false;
    passwordTextControllerValidator = _passwordTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController?.dispose();

    textFieldFocusNode2?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode3?.dispose();
    passwordTextController?.dispose();
    textFieldPasswordVisibilityFocusNode3.dispose();
  }
}
