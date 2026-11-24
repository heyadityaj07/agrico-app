import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/components/product_detail_shimmer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'checkout_widget.dart' show CheckoutWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckoutModel extends FlutterFlowModel<CheckoutWidget> {
  ///  Local state fields for this page.

  String selectedeliverymethod = 'delievry_method';

  String selectedDeliveryTime = 'Tomorrow';

  String? deliveryMethod;

  String? farmpickup;

  double? fee = 0.0;

  bool? isAgricodeliver = false;

  bool isPaymentInProgress = false;

  ///  State fields for stateful widgets in this page.

  List<PaymentsRecord>? containerPreviousSnapshot;
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
  ApiCallResponse? apiResultzlq;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress2;
  // Stores action output result for [Backend Call - API (getDeliveryQuote)] action in Button widget.
  ApiCallResponse? apiResultmei;
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
