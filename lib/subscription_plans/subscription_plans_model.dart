import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'subscription_plans_widget.dart' show SubscriptionPlansWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscriptionPlansModel extends FlutterFlowModel<SubscriptionPlansWidget> {
  ///  Local state fields for this page.

  int tabindex = 0;

  bool isactive = false;

  dynamic rootsdata;

  dynamic harvestplanprice;

  dynamic flovorsplan;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic? rootplan;
  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic? harvestplan;
  // Stores action output result for [Custom Action - getStripePrice] action in SubscriptionPlans widget.
  dynamic? favorablplanemenu;
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
