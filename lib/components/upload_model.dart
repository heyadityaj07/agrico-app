import '/flutter_flow/flutter_flow_util.dart';
import 'upload_widget.dart' show UploadWidget;
import 'package:flutter/material.dart';

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
