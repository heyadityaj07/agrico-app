import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/caculation_card_widget.dart';
import '/components/data_load_widget.dart';
import '/components/product_detail_shimmer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/producer/edit_product/edit_product_widget.dart';
import '/producer/remove_product/remove_product_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'producerproduct_details_page_widget.dart'
    show ProducerproductDetailsPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProducerproductDetailsPageModel
    extends FlutterFlowModel<ProducerproductDetailsPageWidget> {
  ///  Local state fields for this page.

  ProductWeightStruct? selectedWeightBracket;
  void updateSelectedWeightBracketStruct(
      Function(ProductWeightStruct) updateFn) {
    updateFn(selectedWeightBracket ??= ProductWeightStruct());
  }

  double? weightDepositPercent = 0.0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in producerproductDetailsPage widget.
  ConfigRecord? config;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel1;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel2;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel3;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel4;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    caculationCardModel1 = createModel(context, () => CaculationCardModel());
    caculationCardModel2 = createModel(context, () => CaculationCardModel());
    caculationCardModel3 = createModel(context, () => CaculationCardModel());
    caculationCardModel4 = createModel(context, () => CaculationCardModel());
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    caculationCardModel1.dispose();
    caculationCardModel2.dispose();
    caculationCardModel3.dispose();
    caculationCardModel4.dispose();
    suspendModel.dispose();
  }
}
