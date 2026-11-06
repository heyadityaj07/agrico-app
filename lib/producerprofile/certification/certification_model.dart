import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'certification_widget.dart' show CertificationWidget;
import 'package:flutter/material.dart';

class CertificationModel extends FlutterFlowModel<CertificationWidget> {
  ///  Local state fields for this page.

  DateTime? issueDate;

  DateTime? expireDate;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '6gfqulpo' /* eg., Rainfall Affricate is req... */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'nkql40fq' /* eg., #GAP-2023-45678 is requir... */,
      );
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  bool isDataUploading_uploadDataA7d = false;
  FFUploadedFile uploadedLocalFile_uploadDataA7d =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataA7d = '';

  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    suspendModel.dispose();
  }
}
