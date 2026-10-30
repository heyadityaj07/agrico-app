import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/no_chat_producer_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'help_and_suppeort_conversation_widget.dart'
    show HelpAndSuppeortConversationWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
