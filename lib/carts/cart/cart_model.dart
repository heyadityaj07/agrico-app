import '/backend/backend.dart';
import '/components/consumer_navbar_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cart_widget.dart' show CartWidget;
import 'package:flutter/material.dart';

class CartModel extends FlutterFlowModel<CartWidget> {
  ///  Local state fields for this page.

  bool tipadd = false;

  ///  State fields for stateful widgets in this page.

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
  // Stores action output result for [Backend Call - Read Document] action in SwipeButtonWidget widget.
  FarmsRecord? farm;
  // Stores action output result for [Firestore Query - Query a collection] action in SwipeButtonWidget widget.
  ConfigRecord? config;
  // Model for noChatProducer component.
  late NoChatProducerModel noChatProducerModel;
  // Model for ConsumerNavbar component.
  late ConsumerNavbarModel consumerNavbarModel;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    noChatProducerModel = createModel(context, () => NoChatProducerModel());
    consumerNavbarModel = createModel(context, () => ConsumerNavbarModel());
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

    noChatProducerModel.dispose();
    consumerNavbarModel.dispose();
    suspendModel.dispose();
  }
}
