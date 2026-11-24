import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/components/empty_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'myfavorites_widget.dart' show MyfavoritesWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyfavoritesModel extends FlutterFlowModel<MyfavoritesWidget> {
  ///  Local state fields for this page.

  int? tabindex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
