import '/backend/backend.dart';
import '/components/caculation_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_product_widget.dart' show AddProductWidget;
import 'package:flutter/material.dart';

class AddProductModel extends FlutterFlowModel<AddProductWidget> {
  ///  Local state fields for this component.

  List<String> sessons = ['Monsoon', 'Winter', 'Summer'];
  void addToSessons(String item) => sessons.add(item);
  void removeFromSessons(String item) => sessons.remove(item);
  void removeAtIndexFromSessons(int index) => sessons.removeAt(index);
  void insertAtIndexInSessons(int index, String item) =>
      sessons.insert(index, item);
  void updateSessonsAtIndex(int index, Function(String) updateFn) =>
      sessons[index] = updateFn(sessons[index]);

  List<String> selectedsesson = [];
  void addToSelectedsesson(String item) => selectedsesson.add(item);
  void removeFromSelectedsesson(String item) => selectedsesson.remove(item);
  void removeAtIndexFromSelectedsesson(int index) =>
      selectedsesson.removeAt(index);
  void insertAtIndexInSelectedsesson(int index, String item) =>
      selectedsesson.insert(index, item);
  void updateSelectedsessonAtIndex(int index, Function(String) updateFn) =>
      selectedsesson[index] = updateFn(selectedsesson[index]);

  List<String> selectedbedge = [];
  void addToSelectedbedge(String item) => selectedbedge.add(item);
  void removeFromSelectedbedge(String item) => selectedbedge.remove(item);
  void removeAtIndexFromSelectedbedge(int index) =>
      selectedbedge.removeAt(index);
  void insertAtIndexInSelectedbedge(int index, String item) =>
      selectedbedge.insert(index, item);
  void updateSelectedbedgeAtIndex(int index, Function(String) updateFn) =>
      selectedbedge[index] = updateFn(selectedbedge[index]);

  List<ProductWeightStruct> selectedWeightBrackets = [];
  void addToSelectedWeightBrackets(ProductWeightStruct item) =>
      selectedWeightBrackets.add(item);
  void removeFromSelectedWeightBrackets(ProductWeightStruct item) =>
      selectedWeightBrackets.remove(item);
  void removeAtIndexFromSelectedWeightBrackets(int index) =>
      selectedWeightBrackets.removeAt(index);
  void insertAtIndexInSelectedWeightBrackets(
          int index, ProductWeightStruct item) =>
      selectedWeightBrackets.insert(index, item);
  void updateSelectedWeightBracketsAtIndex(
          int index, Function(ProductWeightStruct) updateFn) =>
      selectedWeightBrackets[index] = updateFn(selectedWeightBrackets[index]);

  bool weightProduct = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Firestore Query - Query a collection] action in AddProduct widget.
  ConfigRecord? config;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'cehjqqq5' /* Enter Label is required */,
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
        '661q93op' /* Enter Full Name is required */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '58l206o6' /* Enter Street Address is requir... */,
      );
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '58307nhj' /* eg., Batch #2025-10-A is requi... */,
      );
    }

    return null;
  }

  // State field(s) for price widget.
  FocusNode? priceFocusNode1;
  TextEditingController? priceTextController1;
  String? Function(BuildContext, String?)? priceTextController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for prodcut_categoryDropDown widget.
  String? prodcutCategoryDropDownValue;
  FormFieldController<String>? prodcutCategoryDropDownValueController;
  // State field(s) for SwitchListTile widget.
  bool? switchListTileValue;
  // State field(s) for min widget.
  FocusNode? minFocusNode;
  TextEditingController? minTextController;
  String? Function(BuildContext, String?)? minTextControllerValidator;
  // State field(s) for max widget.
  FocusNode? maxFocusNode;
  TextEditingController? maxTextController;
  String? Function(BuildContext, String?)? maxTextControllerValidator;
  // State field(s) for price widget.
  FocusNode? priceFocusNode2;
  TextEditingController? priceTextController2;
  String? Function(BuildContext, String?)? priceTextController2Validator;
  // Model for caculationCard component.
  late CaculationCardModel caculationCardModel1;
  // Model for caculationCard component.
  late CaculationCardModel caculationCardModel2;
  // Model for caculationCard component.
  late CaculationCardModel caculationCardModel3;
  // Model for caculationCard component.
  late CaculationCardModel caculationCardModel4;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  bool isDataUploading_uploadDataHarvest = false;
  FFUploadedFile uploadedLocalFile_uploadDataHarvest =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataHarvest = '';

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  FarmsRecord? farm;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
    textController4Validator = _textController4Validator;
    caculationCardModel1 = createModel(context, () => CaculationCardModel());
    caculationCardModel2 = createModel(context, () => CaculationCardModel());
    caculationCardModel3 = createModel(context, () => CaculationCardModel());
    caculationCardModel4 = createModel(context, () => CaculationCardModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    priceFocusNode1?.dispose();
    priceTextController1?.dispose();

    minFocusNode?.dispose();
    minTextController?.dispose();

    maxFocusNode?.dispose();
    maxTextController?.dispose();

    priceFocusNode2?.dispose();
    priceTextController2?.dispose();

    caculationCardModel1.dispose();
    caculationCardModel2.dispose();
    caculationCardModel3.dispose();
    caculationCardModel4.dispose();
  }
}
