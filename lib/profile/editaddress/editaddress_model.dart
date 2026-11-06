import '/flutter_flow/flutter_flow_util.dart';
import 'editaddress_widget.dart' show EditaddressWidget;
import 'package:flutter/material.dart';

class EditaddressModel extends FlutterFlowModel<EditaddressWidget> {
  ///  Local state fields for this component.

  FFPlace? valuelocation;

  String? address;

  String? city;

  String? state;

  LatLng? location;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'ief5wv7z' /* Enter Label is required */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'n38rk816' /* Enter Full Name is required */,
      );
    }

    return null;
  }

  // State field(s) for apartmenttextfield widget.
  FocusNode? apartmenttextfieldFocusNode;
  TextEditingController? apartmenttextfieldTextController;
  String? Function(BuildContext, String?)?
      apartmenttextfieldTextControllerValidator;
  String? _apartmenttextfieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'qhanp203' /* street_adress is required */,
      );
    }

    return null;
  }

  // State field(s) for postalcode widget.
  FocusNode? postalcodeFocusNode;
  TextEditingController? postalcodeTextController;
  String? Function(BuildContext, String?)? postalcodeTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    apartmenttextfieldTextControllerValidator =
        _apartmenttextfieldTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    apartmenttextfieldFocusNode?.dispose();
    apartmenttextfieldTextController?.dispose();

    postalcodeFocusNode?.dispose();
    postalcodeTextController?.dispose();

    textFieldFocusNode3?.dispose();
    textController5?.dispose();
  }
}
