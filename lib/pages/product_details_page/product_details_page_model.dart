import '/backend/backend.dart';
import '/components/caculation_card_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'product_details_page_widget.dart' show ProductDetailsPageWidget;
import 'package:flutter/material.dart';

class ProductDetailsPageModel
    extends FlutterFlowModel<ProductDetailsPageWidget> {
  ///  Local state fields for this page.

  List<DocumentReference> usersref = [];
  void addToUsersref(DocumentReference item) => usersref.add(item);
  void removeFromUsersref(DocumentReference item) => usersref.remove(item);
  void removeAtIndexFromUsersref(int index) => usersref.removeAt(index);
  void insertAtIndexInUsersref(int index, DocumentReference item) =>
      usersref.insert(index, item);
  void updateUsersrefAtIndex(int index, Function(DocumentReference) updateFn) =>
      usersref[index] = updateFn(usersref[index]);

  String? address;

  ProductWeightStruct? selectedWeightBracket;
  void updateSelectedWeightBracketStruct(
      Function(ProductWeightStruct) updateFn) {
    updateFn(selectedWeightBracket ??= ProductWeightStruct());
  }

  double? weightDepositPercent = 0.0;

  double? standardProductPrice = 0.0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in productDetailsPage widget.
  ConfigRecord? config;
  // Stores action output result for [Backend Call - Read Document] action in productDetailsPage widget.
  ProductRecord? product;
  // Stores action output result for [Backend Call - Read Document] action in productDetailsPage widget.
  FarmsRecord? farm;
  // Stores action output result for [Custom Action - getAddressFromLatLng] action in productDetailsPage widget.
  String? farmlocation;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel1;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel2;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel3;
  // Model for caculationCard.
  late CaculationCardModel caculationCardModel4;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<ChatRecord>? chatfind;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ChatRecord? chatcreate;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<CartRecord>? carts;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  FarmsRecord? farm1;
  // Stores action output result for [Backend Call - Read Document] action in Button widget.
  FarmsRecord? oldfarm;
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
