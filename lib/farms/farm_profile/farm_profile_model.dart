import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/data_load_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/reviewcard/reviewcard_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'farm_profile_widget.dart' show FarmProfileWidget;
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:styled_divider/styled_divider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

class FarmProfileModel extends FlutterFlowModel<FarmProfileWidget> {
  ///  Local state fields for this page.

  int? index = 0;

  List<DocumentReference> usersRef = [];
  void addToUsersRef(DocumentReference item) => usersRef.add(item);
  void removeFromUsersRef(DocumentReference item) => usersRef.remove(item);
  void removeAtIndexFromUsersRef(int index) => usersRef.removeAt(index);
  void insertAtIndexInUsersRef(int index, DocumentReference item) =>
      usersRef.insert(index, item);
  void updateUsersRefAtIndex(int index, Function(DocumentReference) updateFn) =>
      usersRef[index] = updateFn(usersRef[index]);

  List<String> delivery = [];
  void addToDelivery(String item) => delivery.add(item);
  void removeFromDelivery(String item) => delivery.remove(item);
  void removeAtIndexFromDelivery(int index) => delivery.removeAt(index);
  void insertAtIndexInDelivery(int index, String item) =>
      delivery.insert(index, item);
  void updateDeliveryAtIndex(int index, Function(String) updateFn) =>
      delivery[index] = updateFn(delivery[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<ChatRecord>? chatfind;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ChatRecord? chatcreate;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  List<CartRecord>? carts;
  // Stores action output result for [Backend Call - Read Document] action in Container widget.
  FarmsRecord? oldfarm;
  // Model for noChatProducer component.
  late NoChatProducerModel noChatProducerModel;
  // Model for suspend component.
  late SuspendModel suspendModel;

  @override
  void initState(BuildContext context) {
    noChatProducerModel = createModel(context, () => NoChatProducerModel());
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    noChatProducerModel.dispose();
    suspendModel.dispose();
  }
}
