import '/backend/api_requests/api_calls.dart';
import '/components/producer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'producer_profile_widget.dart' show ProducerProfileWidget;
import 'package:flutter/material.dart';

class ProducerProfileModel extends FlutterFlowModel<ProducerProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getFirebaseIdToken] action in producerProfile widget.
  String? freshtoken;
  // Stores action output result for [Backend Call - API (createCustomerPortalSessionAPI)] action in Button widget.
  ApiCallResponse? apiResult8e1;
  // Stores action output result for [Backend Call - API (createAccountLinkapi)] action in Button widget.
  ApiCallResponse? apiResultm39;
  // Stores action output result for [Backend Call - API (createConnectAccountAPI)] action in Button widget.
  ApiCallResponse? apiResultxmc;
  // Stores action output result for [Backend Call - API (createAccountLinkapi)] action in Button widget.
  ApiCallResponse? apiResultm399;
  // Stores action output result for [Backend Call - API (createAccountLinkapi)] action in Button widget.
  ApiCallResponse? apiResultm39Copy;
  // Stores action output result for [Backend Call - API (createConnectDashboardLinkAPi)] action in Button widget.
  ApiCallResponse? createconnectdashboardlinkapi;
  // Stores action output result for [Backend Call - API (getConnectAccountStatusAPi)] action in IconButton widget.
  ApiCallResponse? apiResults6v;
  // Model for suspend component.
  late SuspendModel suspendModel;
  // Model for ProducerNavbar component.
  late ProducerNavbarModel producerNavbarModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
    producerNavbarModel = createModel(context, () => ProducerNavbarModel());
  }

  @override
  void dispose() {
    suspendModel.dispose();
    producerNavbarModel.dispose();
  }
}
