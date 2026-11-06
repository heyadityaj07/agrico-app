import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nochatusertlist_widget.dart' show NochatusertlistWidget;
import 'package:flutter/material.dart';

class NochatusertlistModel extends FlutterFlowModel<NochatusertlistWidget> {
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
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  FarmsRecord? farmData;
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
