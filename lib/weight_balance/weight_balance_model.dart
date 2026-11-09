import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'weight_balance_widget.dart' show WeightBalanceWidget;
import 'package:flutter/material.dart';

class WeightBalanceModel extends FlutterFlowModel<WeightBalanceWidget> {
  /// Local UI guard only. The authoritative settlement state remains the
  /// Firestore order document updated by the Stripe webhook.
  bool isPaymentProcessing = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
