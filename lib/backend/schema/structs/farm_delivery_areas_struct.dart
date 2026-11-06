// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class FarmDeliveryAreasStruct extends FFFirebaseStruct {
  FarmDeliveryAreasStruct({
    bool? clickCollect,
    bool? ownDelivery,
    double? deliveryRadiuskm,
    double? flatDeliveryFee,
    double? minimumAmmount,
    double? freedelievryAmmount,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _clickCollect = clickCollect,
        _ownDelivery = ownDelivery,
        _deliveryRadiuskm = deliveryRadiuskm,
        _flatDeliveryFee = flatDeliveryFee,
        _minimumAmmount = minimumAmmount,
        _freedelievryAmmount = freedelievryAmmount,
        super(firestoreUtilData);

  // "ClickCollect" field.
  bool? _clickCollect;
  bool get clickCollect => _clickCollect ?? false;
  set clickCollect(bool? val) => _clickCollect = val;

  bool hasClickCollect() => _clickCollect != null;

  // "OwnDelivery" field.
  bool? _ownDelivery;
  bool get ownDelivery => _ownDelivery ?? false;
  set ownDelivery(bool? val) => _ownDelivery = val;

  bool hasOwnDelivery() => _ownDelivery != null;

  // "DeliveryRadiuskm" field.
  double? _deliveryRadiuskm;
  double get deliveryRadiuskm => _deliveryRadiuskm ?? 0.0;
  set deliveryRadiuskm(double? val) => _deliveryRadiuskm = val;

  void incrementDeliveryRadiuskm(double amount) =>
      deliveryRadiuskm = deliveryRadiuskm + amount;

  bool hasDeliveryRadiuskm() => _deliveryRadiuskm != null;

  // "FlatDeliveryFee" field.
  double? _flatDeliveryFee;
  double get flatDeliveryFee => _flatDeliveryFee ?? 0.0;
  set flatDeliveryFee(double? val) => _flatDeliveryFee = val;

  void incrementFlatDeliveryFee(double amount) =>
      flatDeliveryFee = flatDeliveryFee + amount;

  bool hasFlatDeliveryFee() => _flatDeliveryFee != null;

  // "MinimumAmmount" field.
  double? _minimumAmmount;
  double get minimumAmmount => _minimumAmmount ?? 0.0;
  set minimumAmmount(double? val) => _minimumAmmount = val;

  void incrementMinimumAmmount(double amount) =>
      minimumAmmount = minimumAmmount + amount;

  bool hasMinimumAmmount() => _minimumAmmount != null;

  // "freedelievryAmmount" field.
  double? _freedelievryAmmount;
  double get freedelievryAmmount => _freedelievryAmmount ?? 0.0;
  set freedelievryAmmount(double? val) => _freedelievryAmmount = val;

  void incrementFreedelievryAmmount(double amount) =>
      freedelievryAmmount = freedelievryAmmount + amount;

  bool hasFreedelievryAmmount() => _freedelievryAmmount != null;

  static FarmDeliveryAreasStruct fromMap(Map<String, dynamic> data) =>
      FarmDeliveryAreasStruct(
        clickCollect: data['ClickCollect'] as bool?,
        ownDelivery: data['OwnDelivery'] as bool?,
        deliveryRadiuskm: castToType<double>(data['DeliveryRadiuskm']),
        flatDeliveryFee: castToType<double>(data['FlatDeliveryFee']),
        minimumAmmount: castToType<double>(data['MinimumAmmount']),
        freedelievryAmmount: castToType<double>(data['freedelievryAmmount']),
      );

  static FarmDeliveryAreasStruct? maybeFromMap(dynamic data) => data is Map
      ? FarmDeliveryAreasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ClickCollect': _clickCollect,
        'OwnDelivery': _ownDelivery,
        'DeliveryRadiuskm': _deliveryRadiuskm,
        'FlatDeliveryFee': _flatDeliveryFee,
        'MinimumAmmount': _minimumAmmount,
        'freedelievryAmmount': _freedelievryAmmount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ClickCollect': serializeParam(
          _clickCollect,
          ParamType.bool,
        ),
        'OwnDelivery': serializeParam(
          _ownDelivery,
          ParamType.bool,
        ),
        'DeliveryRadiuskm': serializeParam(
          _deliveryRadiuskm,
          ParamType.double,
        ),
        'FlatDeliveryFee': serializeParam(
          _flatDeliveryFee,
          ParamType.double,
        ),
        'MinimumAmmount': serializeParam(
          _minimumAmmount,
          ParamType.double,
        ),
        'freedelievryAmmount': serializeParam(
          _freedelievryAmmount,
          ParamType.double,
        ),
      }.withoutNulls;

  static FarmDeliveryAreasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      FarmDeliveryAreasStruct(
        clickCollect: deserializeParam(
          data['ClickCollect'],
          ParamType.bool,
          false,
        ),
        ownDelivery: deserializeParam(
          data['OwnDelivery'],
          ParamType.bool,
          false,
        ),
        deliveryRadiuskm: deserializeParam(
          data['DeliveryRadiuskm'],
          ParamType.double,
          false,
        ),
        flatDeliveryFee: deserializeParam(
          data['FlatDeliveryFee'],
          ParamType.double,
          false,
        ),
        minimumAmmount: deserializeParam(
          data['MinimumAmmount'],
          ParamType.double,
          false,
        ),
        freedelievryAmmount: deserializeParam(
          data['freedelievryAmmount'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FarmDeliveryAreasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FarmDeliveryAreasStruct &&
        clickCollect == other.clickCollect &&
        ownDelivery == other.ownDelivery &&
        deliveryRadiuskm == other.deliveryRadiuskm &&
        flatDeliveryFee == other.flatDeliveryFee &&
        minimumAmmount == other.minimumAmmount &&
        freedelievryAmmount == other.freedelievryAmmount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        clickCollect,
        ownDelivery,
        deliveryRadiuskm,
        flatDeliveryFee,
        minimumAmmount,
        freedelievryAmmount
      ]);
}

FarmDeliveryAreasStruct createFarmDeliveryAreasStruct({
  bool? clickCollect,
  bool? ownDelivery,
  double? deliveryRadiuskm,
  double? flatDeliveryFee,
  double? minimumAmmount,
  double? freedelievryAmmount,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FarmDeliveryAreasStruct(
      clickCollect: clickCollect,
      ownDelivery: ownDelivery,
      deliveryRadiuskm: deliveryRadiuskm,
      flatDeliveryFee: flatDeliveryFee,
      minimumAmmount: minimumAmmount,
      freedelievryAmmount: freedelievryAmmount,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FarmDeliveryAreasStruct? updateFarmDeliveryAreasStruct(
  FarmDeliveryAreasStruct? farmDeliveryAreas, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    farmDeliveryAreas
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFarmDeliveryAreasStructData(
  Map<String, dynamic> firestoreData,
  FarmDeliveryAreasStruct? farmDeliveryAreas,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (farmDeliveryAreas == null) {
    return;
  }
  if (farmDeliveryAreas.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && farmDeliveryAreas.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final farmDeliveryAreasData =
      getFarmDeliveryAreasFirestoreData(farmDeliveryAreas, forFieldValue);
  final nestedData =
      farmDeliveryAreasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = farmDeliveryAreas.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFarmDeliveryAreasFirestoreData(
  FarmDeliveryAreasStruct? farmDeliveryAreas, [
  bool forFieldValue = false,
]) {
  if (farmDeliveryAreas == null) {
    return {};
  }
  final firestoreData = mapToFirestore(farmDeliveryAreas.toMap());

  // Add any Firestore field values
  mapToFirestore(farmDeliveryAreas.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFarmDeliveryAreasListFirestoreData(
  List<FarmDeliveryAreasStruct>? farmDeliveryAreass,
) =>
    farmDeliveryAreass
        ?.map((e) => getFarmDeliveryAreasFirestoreData(e, true))
        .toList() ??
    [];
