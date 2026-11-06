import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'producer_chat_conversation_widget.dart'
    show ProducerChatConversationWidget;
import 'package:flutter/material.dart';

class ProducerChatConversationModel
    extends FlutterFlowModel<ProducerChatConversationWidget> {
  ///  Local state fields for this page.

  String? producerChat;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in ProducerChatConversation widget.
  List<ChatMessagesRecord>? chatmsg;
  bool isDataUploading_uploadDataA8u = false;
  FFUploadedFile uploadedLocalFile_uploadDataA8u =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataA8u = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Read Document] action in IconButton widget.
  UsersRecord? farmuser;
  // Stores action output result for [Backend Call - Create Document] action in IconButton widget.
  ChatMessagesRecord? chatmessage;
  // Stores action output result for [Backend Call - Read Document] action in IconButton widget.
  FarmsRecord? farmName;
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
