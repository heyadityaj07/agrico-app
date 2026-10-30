import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'upload_widget.dart' show UploadWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadModel extends FlutterFlowModel<UploadWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataProductpdf = false;
  FFUploadedFile uploadedLocalFile_uploadDataProductpdf =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataProductpdf = '';

  bool isDataUploading_uploadDataImage = false;
  FFUploadedFile uploadedLocalFile_uploadDataImage =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataImage = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
