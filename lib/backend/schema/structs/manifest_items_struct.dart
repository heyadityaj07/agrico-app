// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ManifestItemsStruct extends FFFirebaseStruct {
  ManifestItemsStruct({
    String? name,
    int? quantity,
    String? size,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _quantity = quantity,
        _size = size,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "size" field.
  String? _size;
  String get size => _size ?? 'small';
  set size(String? val) => _size = val;

  bool hasSize() => _size != null;

  static ManifestItemsStruct fromMap(Map<String, dynamic> data) =>
      ManifestItemsStruct(
        name: data['name'] as String?,
        quantity: castToType<int>(data['quantity']),
        size: data['size'] as String?,
      );

  static ManifestItemsStruct? maybeFromMap(dynamic data) => data is Map
      ? ManifestItemsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'quantity': _quantity,
        'size': _size,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'size': serializeParam(
          _size,
          ParamType.String,
        ),
      }.withoutNulls;

  static ManifestItemsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ManifestItemsStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        size: deserializeParam(
          data['size'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ManifestItemsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ManifestItemsStruct &&
        name == other.name &&
        quantity == other.quantity &&
        size == other.size;
  }

  @override
  int get hashCode => const ListEquality().hash([name, quantity, size]);
}

ManifestItemsStruct createManifestItemsStruct({
  String? name,
  int? quantity,
  String? size,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ManifestItemsStruct(
      name: name,
      quantity: quantity,
      size: size,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ManifestItemsStruct? updateManifestItemsStruct(
  ManifestItemsStruct? manifestItems, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    manifestItems
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addManifestItemsStructData(
  Map<String, dynamic> firestoreData,
  ManifestItemsStruct? manifestItems,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (manifestItems == null) {
    return;
  }
  if (manifestItems.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && manifestItems.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final manifestItemsData =
      getManifestItemsFirestoreData(manifestItems, forFieldValue);
  final nestedData =
      manifestItemsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = manifestItems.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getManifestItemsFirestoreData(
  ManifestItemsStruct? manifestItems, [
  bool forFieldValue = false,
]) {
  if (manifestItems == null) {
    return {};
  }
  final firestoreData = mapToFirestore(manifestItems.toMap());

  // Add any Firestore field values
  mapToFirestore(manifestItems.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getManifestItemsListFirestoreData(
  List<ManifestItemsStruct>? manifestItemss,
) =>
    manifestItemss
        ?.map((e) => getManifestItemsFirestoreData(e, true))
        .toList() ??
    [];
