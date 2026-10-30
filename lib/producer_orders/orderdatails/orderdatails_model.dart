import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/backend/schema/structs/index.dart';
import '/components/add_weight_order_widget.dart';
import '/components/rejectorder_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'orderdatails_widget.dart' show OrderdatailsWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:styled_divider/styled_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderdatailsModel extends FlutterFlowModel<OrderdatailsWidget> {
  ///  Local state fields for this component.

  List<DocumentReference> users = [];
  void addToUsers(DocumentReference item) => users.add(item);
  void removeFromUsers(DocumentReference item) => users.remove(item);
  void removeAtIndexFromUsers(int index) => users.removeAt(index);
  void insertAtIndexInUsers(int index, DocumentReference item) =>
      users.insert(index, item);
  void updateUsersAtIndex(int index, Function(DocumentReference) updateFn) =>
      users[index] = updateFn(users[index]);

  List<ManifestItemsStruct> manifestitem = [];
  void addToManifestitem(ManifestItemsStruct item) => manifestitem.add(item);
  void removeFromManifestitem(ManifestItemsStruct item) =>
      manifestitem.remove(item);
  void removeAtIndexFromManifestitem(int index) => manifestitem.removeAt(index);
  void insertAtIndexInManifestitem(int index, ManifestItemsStruct item) =>
      manifestitem.insert(index, item);
  void updateManifestitemAtIndex(
          int index, Function(ManifestItemsStruct) updateFn) =>
      manifestitem[index] = updateFn(manifestitem[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  ProductRecord? productname;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  FarmsRecord? farm1;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in Button widget.
  String? farmaddress;
  // Stores action output result for [Backend Call - API (createDelivery Copy)] action in Button widget.
  ApiCallResponse? apiResult7q6;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<ChatRecord>? chat;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ChatRecord? chatcreate;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
