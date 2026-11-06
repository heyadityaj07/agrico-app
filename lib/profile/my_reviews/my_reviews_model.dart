import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'my_reviews_widget.dart' show MyReviewsWidget;
import 'package:flutter/material.dart';

class MyReviewsModel extends FlutterFlowModel<MyReviewsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    suspendModel.dispose();
  }
}
