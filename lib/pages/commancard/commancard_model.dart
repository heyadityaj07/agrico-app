import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'commancard_widget.dart' show CommancardWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommancardModel extends FlutterFlowModel<CommancardWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  CartRecord? cart;
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  List<CartRecord>? carts;
  // Stores action output result for [Backend Call - Read Document] action in Container widget.
  FarmsRecord? oldfarm;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
