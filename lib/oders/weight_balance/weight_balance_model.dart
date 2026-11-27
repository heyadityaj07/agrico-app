import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/data_load_widget.dart';
import '/components/order_rejection_status_card_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'weight_balance_widget.dart' show WeightBalanceWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeightBalanceModel extends FlutterFlowModel<WeightBalanceWidget> {
  ///  Local state fields for this page.

  bool isPaymentProcessing = false;

  bool keepProcessing = false;

  ///  State fields for stateful widgets in this page.

  // Model for OrderRejectionStatusCard.
  late OrderRejectionStatusCardModel orderRejectionStatusCardModel;
  // Stores action output result for [Custom Action - flutterStripeDirect] action in Button widget.
  String? result;

  @override
  void initState(BuildContext context) {
    orderRejectionStatusCardModel =
        createModel(context, () => OrderRejectionStatusCardModel());
  }

  @override
  void dispose() {
    orderRejectionStatusCardModel.dispose();
  }
}
