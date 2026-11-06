// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CartTotalStruct extends FFFirebaseStruct {
  CartTotalStruct({
    double? price,
    int? questity,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _price = price,
        _questity = questity,
        super(firestoreUtilData);

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "questity" field.
  int? _questity;
  int get questity => _questity ?? 0;
  set questity(int? val) => _questity = val;

  void incrementQuestity(int amount) => questity = questity + amount;

  bool hasQuestity() => _questity != null;

  static CartTotalStruct fromMap(Map<String, dynamic> data) => CartTotalStruct(
        price: castToType<double>(data['price']),
        questity: castToType<int>(data['questity']),
      );

  static CartTotalStruct? maybeFromMap(dynamic data) => data is Map
      ? CartTotalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'price': _price,
        'questity': _questity,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'questity': serializeParam(
          _questity,
          ParamType.int,
        ),
      }.withoutNulls;

  static CartTotalStruct fromSerializableMap(Map<String, dynamic> data) =>
      CartTotalStruct(
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        questity: deserializeParam(
          data['questity'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CartTotalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CartTotalStruct &&
        price == other.price &&
        questity == other.questity;
  }

  @override
  int get hashCode => const ListEquality().hash([price, questity]);
}

CartTotalStruct createCartTotalStruct({
  double? price,
  int? questity,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CartTotalStruct(
      price: price,
      questity: questity,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CartTotalStruct? updateCartTotalStruct(
  CartTotalStruct? cartTotal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cartTotal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCartTotalStructData(
  Map<String, dynamic> firestoreData,
  CartTotalStruct? cartTotal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cartTotal == null) {
    return;
  }
  if (cartTotal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && cartTotal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cartTotalData = getCartTotalFirestoreData(cartTotal, forFieldValue);
  final nestedData = cartTotalData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cartTotal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCartTotalFirestoreData(
  CartTotalStruct? cartTotal, [
  bool forFieldValue = false,
]) {
  if (cartTotal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cartTotal.toMap());

  // Add any Firestore field values
  mapToFirestore(cartTotal.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCartTotalListFirestoreData(
  List<CartTotalStruct>? cartTotals,
) =>
    cartTotals?.map((e) => getCartTotalFirestoreData(e, true)).toList() ?? [];
