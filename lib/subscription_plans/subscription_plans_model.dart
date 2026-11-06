import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'subscription_plans_widget.dart' show SubscriptionPlansWidget;
import 'package:flutter/material.dart';

class SubscriptionPlansModel extends FlutterFlowModel<SubscriptionPlansWidget> {
  ///  Local state fields for this page.

  int tabindex = 0;

  bool isactive = false;

  dynamic rootsdata;

  dynamic harvestplanprice;

  dynamic flovorsplan;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic rootplan;
  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic harvestplan;
  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic favorablplanemenu;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Backend Call - API (cloud function call)] action in Button widget.
  ApiCallResponse? apiResulthgy;
  // Stores action output result for [Backend Call - API (update Subscription)] action in Button widget.
  ApiCallResponse? apiResultrs2;
  // Stores action output result for [Backend Call - API (cloud function call)] action in Button widget.
  ApiCallResponse? harvest;
  // Stores action output result for [Backend Call - API (update Subscription)] action in Button widget.
  ApiCallResponse? apiResultvyz;
  // Stores action output result for [Backend Call - API (cloud function call)] action in Button widget.
  ApiCallResponse? falouver;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
