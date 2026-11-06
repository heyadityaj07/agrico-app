// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VendorDetailsModelStruct extends FFFirebaseStruct {
  VendorDetailsModelStruct({
    double? amount,
    String? reason,
    String? status,
    String? vendorId,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _amount = amount,
        _reason = reason,
        _status = status,
        _vendorId = vendorId,
        super(firestoreUtilData);

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  set reason(String? val) => _reason = val;

  bool hasReason() => _reason != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "vendorId" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  set vendorId(String? val) => _vendorId = val;

  bool hasVendorId() => _vendorId != null;

  static VendorDetailsModelStruct fromMap(Map<String, dynamic> data) =>
      VendorDetailsModelStruct(
        amount: castToType<double>(data['amount']),
        reason: data['reason'] as String?,
        status: data['status'] as String?,
        vendorId: data['vendorId'] as String?,
      );

  static VendorDetailsModelStruct? maybeFromMap(dynamic data) => data is Map
      ? VendorDetailsModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'amount': _amount,
        'reason': _reason,
        'status': _status,
        'vendorId': _vendorId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'reason': serializeParam(
          _reason,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'vendorId': serializeParam(
          _vendorId,
          ParamType.String,
        ),
      }.withoutNulls;

  static VendorDetailsModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      VendorDetailsModelStruct(
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        reason: deserializeParam(
          data['reason'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        vendorId: deserializeParam(
          data['vendorId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VendorDetailsModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VendorDetailsModelStruct &&
        amount == other.amount &&
        reason == other.reason &&
        status == other.status &&
        vendorId == other.vendorId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([amount, reason, status, vendorId]);
}

VendorDetailsModelStruct createVendorDetailsModelStruct({
  double? amount,
  String? reason,
  String? status,
  String? vendorId,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VendorDetailsModelStruct(
      amount: amount,
      reason: reason,
      status: status,
      vendorId: vendorId,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VendorDetailsModelStruct? updateVendorDetailsModelStruct(
  VendorDetailsModelStruct? vendorDetailsModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    vendorDetailsModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVendorDetailsModelStructData(
  Map<String, dynamic> firestoreData,
  VendorDetailsModelStruct? vendorDetailsModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (vendorDetailsModel == null) {
    return;
  }
  if (vendorDetailsModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && vendorDetailsModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final vendorDetailsModelData =
      getVendorDetailsModelFirestoreData(vendorDetailsModel, forFieldValue);
  final nestedData =
      vendorDetailsModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      vendorDetailsModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVendorDetailsModelFirestoreData(
  VendorDetailsModelStruct? vendorDetailsModel, [
  bool forFieldValue = false,
]) {
  if (vendorDetailsModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(vendorDetailsModel.toMap());

  // Add any Firestore field values
  mapToFirestore(vendorDetailsModel.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVendorDetailsModelListFirestoreData(
  List<VendorDetailsModelStruct>? vendorDetailsModels,
) =>
    vendorDetailsModels
        ?.map((e) => getVendorDetailsModelFirestoreData(e, true))
        .toList() ??
    [];
