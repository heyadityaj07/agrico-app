import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'chat_conversation_widget.dart' show ChatConversationWidget;
import 'package:flutter/material.dart';

class ChatConversationModel extends FlutterFlowModel<ChatConversationWidget> {
  ///  Local state fields for this page.

  String? chatmsg;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in ChatConversation widget.
  List<ChatMessagesRecord>? msg;
  bool isDataUploading_uploadDataFvf = false;
  FFUploadedFile uploadedLocalFile_uploadDataFvf =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataFvf = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Read Document] action in IconButton widget.
  FarmsRecord? farmuser;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  ChatMessagesRecord? chatmessage;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    suspendModel.dispose();
  }
}
