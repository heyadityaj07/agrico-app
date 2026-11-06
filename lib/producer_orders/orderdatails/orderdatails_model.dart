import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'orderdatails_widget.dart' show OrderdatailsWidget;
import 'package:flutter/material.dart';

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
