import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'new_planingscadule_widget.dart' show NewPlaningscaduleWidget;
import 'package:flutter/material.dart';

class NewPlaningscaduleModel extends FlutterFlowModel<NewPlaningscaduleWidget> {
  ///  Local state fields for this component.

  DateTime? plantedDate;

  DateTime? expectedDate;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'sxj89m3f' /* Enter Name is required */,
      );
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'p0rh9x13' /* Enter Street Address is requir... */,
      );
    }

    return null;
  }

  // State field(s) for prodcut_categoryDropDown widget.
  String? prodcutCategoryDropDownValue;
  FormFieldController<String>? prodcutCategoryDropDownValueController;
  // State field(s) for prodcut_statusDropDown widget.
  String? prodcutStatusDropDownValue;
  FormFieldController<String>? prodcutStatusDropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'eopyhr77' /* Enter Quatity is required */,
      );
    }

    return null;
  }

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool isDataUploading_uploadDataGnu = false;
  FFUploadedFile uploadedLocalFile_uploadDataGnu =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataGnu = '';

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  FarmsRecord? farm;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
