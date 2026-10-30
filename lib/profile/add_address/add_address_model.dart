import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'add_address_widget.dart' show AddAddressWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAddressModel extends FlutterFlowModel<AddAddressWidget> {
  ///  Local state fields for this component.

  FFPlace? locationvalue;

  String? address;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'e5ag9ycj' /* Enter Full Name is required */,
      );
    }

    return null;
  }

  // State field(s) for apartment widget.
  FocusNode? apartmentFocusNode;
  TextEditingController? apartmentTextController;
  String? Function(BuildContext, String?)? apartmentTextControllerValidator;
  String? _apartmentTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'gokrv6hr' /* Enter Street Address is requir... */,
      );
    }

    return null;
  }

  // State field(s) for zipcodetextfield widget.
  FocusNode? zipcodetextfieldFocusNode;
  TextEditingController? zipcodetextfieldTextController;
  String? Function(BuildContext, String?)?
      zipcodetextfieldTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;

  @override
  void initState(BuildContext context) {
    textController2Validator = _textController2Validator;
    apartmentTextControllerValidator = _apartmentTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    apartmentFocusNode?.dispose();
    apartmentTextController?.dispose();

    zipcodetextfieldFocusNode?.dispose();
    zipcodetextfieldTextController?.dispose();

    textFieldFocusNode3?.dispose();
    textController5?.dispose();
  }
}
