import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/empty_widget.dart';
import '/components/order_rejection_status_card_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:styled_divider/styled_divider.dart';
import 'refund_status_widget.dart' show RefundStatusWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RefundStatusModel extends FlutterFlowModel<RefundStatusWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for OrderRejectionStatusCard.
  late FlutterFlowDynamicModels<OrderRejectionStatusCardModel>
      orderRejectionStatusCardModels;

  @override
  void initState(BuildContext context) {
    orderRejectionStatusCardModels =
        FlutterFlowDynamicModels(() => OrderRejectionStatusCardModel());
  }

  @override
  void dispose() {
    orderRejectionStatusCardModels.dispose();
  }
}
