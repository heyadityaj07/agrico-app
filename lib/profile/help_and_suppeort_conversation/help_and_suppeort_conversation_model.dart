import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'help_and_suppeort_conversation_widget.dart'
    show HelpAndSuppeortConversationWidget;
import 'package:flutter/material.dart';

class HelpAndSuppeortConversationModel
    extends FlutterFlowModel<HelpAndSuppeortConversationWidget> {
  ///  Local state fields for this page.

  String? msg;

  String? image;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in HelpAndSuppeortConversation widget.
  int? conversation11;
  bool isDataUploading_helpimge = false;
  FFUploadedFile uploadedLocalFile_helpimge =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_helpimge = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  ConversationRecord? conversation;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  ConversationRecord? conversation1;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  ConversationRecord? conversation2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
