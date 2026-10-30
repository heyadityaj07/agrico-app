import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'selectlocationcomponentedit_widget.dart'
    show SelectlocationcomponenteditWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectlocationcomponenteditModel
    extends FlutterFlowModel<SelectlocationcomponenteditWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in selectlocationcomponentedit widget.
  FarmsRecord? farm;
  // Stores action output result for [Backend Call - Read Document] action in LocationPickerMap widget.
  FarmsRecord? farmcheck;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in LocationPickerMap widget.
  String? farmaddress;
  // Stores action output result for [Backend Call - API (validateAccess)] action in LocationPickerMap widget.
  ApiCallResponse? success;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
