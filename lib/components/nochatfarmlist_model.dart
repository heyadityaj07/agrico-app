import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'nochatfarmlist_widget.dart' show NochatfarmlistWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NochatfarmlistModel extends FlutterFlowModel<NochatfarmlistWidget> {
  ///  Local state fields for this component.

  List<DocumentReference> userRef = [];
  void addToUserRef(DocumentReference item) => userRef.add(item);
  void removeFromUserRef(DocumentReference item) => userRef.remove(item);
  void removeAtIndexFromUserRef(int index) => userRef.removeAt(index);
  void insertAtIndexInUserRef(int index, DocumentReference item) =>
      userRef.insert(index, item);
  void updateUserRefAtIndex(int index, Function(DocumentReference) updateFn) =>
      userRef[index] = updateFn(userRef[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Container widget.
  ChatRecord? chatcreate;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
