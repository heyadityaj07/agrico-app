import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'checkout_copy_widget.dart' show CheckoutCopyWidget;
import 'package:flutter/material.dart';

class CheckoutCopyModel extends FlutterFlowModel<CheckoutCopyWidget> {
  ///  Local state fields for this page.

  String selectedeliverymethod = 'delievry_method';

  String selectedDeliveryTime = 'Tomorrow';

  String? deliveryMethod;

  String? farmpickup;

  double? fee = 0.0;

  bool? isAgricodeliver = false;

  ///  State fields for stateful widgets in this page.

  List<PaymentsRecord>? containerPreviousSnapshot;
  UsersRecord? columnPreviousSnapshot;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Custom Action - checkruleofLocation] action in Button widget.
  bool? postal1;
  // Stores action output result for [Backend Call - API (validateAccess)] action in Button widget.
  ApiCallResponse? apiResultyxp;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress;
  // Stores action output result for [Backend Call - API (getDeliveryQuote)] action in Button widget.
  ApiCallResponse? apiResultlzc;
  // Stores action output result for [Backend Call - API (validateAccess)] action in Button widget.
  ApiCallResponse? validateaddress;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress1;
  // Stores action output result for [Backend Call - API (getDeliveryQuote)] action in Button widget.
  ApiCallResponse? quote;
  // Stores action output result for [Backend Call - API (validateAccess)] action in Button widget.
  ApiCallResponse? validateaddress2;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress12;
  // Stores action output result for [Backend Call - API (getDeliveryQuote)] action in Button widget.
  ApiCallResponse? quote1;
  // Stores action output result for [Backend Call - API (validateAccess)] action in Button widget.
  ApiCallResponse? apiResultzlq;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress2;
  // Stores action output result for [Backend Call - API (getDeliveryQuote)] action in Button widget.
  ApiCallResponse? apiResultmei;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  UsersRecord? farmUser;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<CartRecord>? cart;
  // Stores action output result for [Custom Action - farmOrderItems] action in Button widget.
  List<OrderDataStruct>? cartdata;
  // Stores action output result for [Custom Action - manageproductlist] action in Button widget.
  List<dynamic>? dynamicvendor;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ConfigRecord? config;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    suspendModel.dispose();
  }
}
