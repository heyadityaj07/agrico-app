import '/backend/backend.dart';
import '/components/feature_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'rootdeliverysetting_widget.dart' show RootdeliverysettingWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RootdeliverysettingModel
    extends FlutterFlowModel<RootdeliverysettingWidget> {
  ///  Local state fields for this page.

  String? deliveryservice;

  ///  State fields for stateful widgets in this page.

  // Model for FeatureItem component.
  late FeatureItemModel featureItemModel1;
  // Model for FeatureItem component.
  late FeatureItemModel featureItemModel2;
  // Model for FeatureItem component.
  late FeatureItemModel featureItemModel3;
  // Model for FeatureItem component.
  late FeatureItemModel featureItemModel4;

  @override
  void initState(BuildContext context) {
    featureItemModel1 = createModel(context, () => FeatureItemModel());
    featureItemModel2 = createModel(context, () => FeatureItemModel());
    featureItemModel3 = createModel(context, () => FeatureItemModel());
    featureItemModel4 = createModel(context, () => FeatureItemModel());
  }

  @override
  void dispose() {
    featureItemModel1.dispose();
    featureItemModel2.dispose();
    featureItemModel3.dispose();
    featureItemModel4.dispose();
  }
}
