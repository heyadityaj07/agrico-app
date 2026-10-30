// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FarmAvailabilityStruct extends FFFirebaseStruct {
  FarmAvailabilityStruct({
    String? day,
    DateTime? startTime,
    DateTime? endtime,
    bool? isAvavible,
    bool? isBreak,
    DateTime? breakStart,
    DateTime? breakEnd,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _day = day,
        _startTime = startTime,
        _endtime = endtime,
        _isAvavible = isAvavible,
        _isBreak = isBreak,
        _breakStart = breakStart,
        _breakEnd = breakEnd,
        super(firestoreUtilData);

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  set day(String? val) => _day = val;

  bool hasDay() => _day != null;

  // "startTime" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  set startTime(DateTime? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "endtime" field.
  DateTime? _endtime;
  DateTime? get endtime => _endtime;
  set endtime(DateTime? val) => _endtime = val;

  bool hasEndtime() => _endtime != null;

  // "is_avavible" field.
  bool? _isAvavible;
  bool get isAvavible => _isAvavible ?? false;
  set isAvavible(bool? val) => _isAvavible = val;

  bool hasIsAvavible() => _isAvavible != null;

  // "is_break" field.
  bool? _isBreak;
  bool get isBreak => _isBreak ?? false;
  set isBreak(bool? val) => _isBreak = val;

  bool hasIsBreak() => _isBreak != null;

  // "breakStart" field.
  DateTime? _breakStart;
  DateTime? get breakStart => _breakStart;
  set breakStart(DateTime? val) => _breakStart = val;

  bool hasBreakStart() => _breakStart != null;

  // "breakEnd" field.
  DateTime? _breakEnd;
  DateTime? get breakEnd => _breakEnd;
  set breakEnd(DateTime? val) => _breakEnd = val;

  bool hasBreakEnd() => _breakEnd != null;

  static FarmAvailabilityStruct fromMap(Map<String, dynamic> data) =>
      FarmAvailabilityStruct(
        day: data['day'] as String?,
        startTime: data['startTime'] as DateTime?,
        endtime: data['endtime'] as DateTime?,
        isAvavible: data['is_avavible'] as bool?,
        isBreak: data['is_break'] as bool?,
        breakStart: data['breakStart'] as DateTime?,
        breakEnd: data['breakEnd'] as DateTime?,
      );

  static FarmAvailabilityStruct? maybeFromMap(dynamic data) => data is Map
      ? FarmAvailabilityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'day': _day,
        'startTime': _startTime,
        'endtime': _endtime,
        'is_avavible': _isAvavible,
        'is_break': _isBreak,
        'breakStart': _breakStart,
        'breakEnd': _breakEnd,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'day': serializeParam(
          _day,
          ParamType.String,
        ),
        'startTime': serializeParam(
          _startTime,
          ParamType.DateTime,
        ),
        'endtime': serializeParam(
          _endtime,
          ParamType.DateTime,
        ),
        'is_avavible': serializeParam(
          _isAvavible,
          ParamType.bool,
        ),
        'is_break': serializeParam(
          _isBreak,
          ParamType.bool,
        ),
        'breakStart': serializeParam(
          _breakStart,
          ParamType.DateTime,
        ),
        'breakEnd': serializeParam(
          _breakEnd,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static FarmAvailabilityStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      FarmAvailabilityStruct(
        day: deserializeParam(
          data['day'],
          ParamType.String,
          false,
        ),
        startTime: deserializeParam(
          data['startTime'],
          ParamType.DateTime,
          false,
        ),
        endtime: deserializeParam(
          data['endtime'],
          ParamType.DateTime,
          false,
        ),
        isAvavible: deserializeParam(
          data['is_avavible'],
          ParamType.bool,
          false,
        ),
        isBreak: deserializeParam(
          data['is_break'],
          ParamType.bool,
          false,
        ),
        breakStart: deserializeParam(
          data['breakStart'],
          ParamType.DateTime,
          false,
        ),
        breakEnd: deserializeParam(
          data['breakEnd'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'FarmAvailabilityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FarmAvailabilityStruct &&
        day == other.day &&
        startTime == other.startTime &&
        endtime == other.endtime &&
        isAvavible == other.isAvavible &&
        isBreak == other.isBreak &&
        breakStart == other.breakStart &&
        breakEnd == other.breakEnd;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [day, startTime, endtime, isAvavible, isBreak, breakStart, breakEnd]);
}

FarmAvailabilityStruct createFarmAvailabilityStruct({
  String? day,
  DateTime? startTime,
  DateTime? endtime,
  bool? isAvavible,
  bool? isBreak,
  DateTime? breakStart,
  DateTime? breakEnd,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FarmAvailabilityStruct(
      day: day,
      startTime: startTime,
      endtime: endtime,
      isAvavible: isAvavible,
      isBreak: isBreak,
      breakStart: breakStart,
      breakEnd: breakEnd,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FarmAvailabilityStruct? updateFarmAvailabilityStruct(
  FarmAvailabilityStruct? farmAvailability, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    farmAvailability
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFarmAvailabilityStructData(
  Map<String, dynamic> firestoreData,
  FarmAvailabilityStruct? farmAvailability,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (farmAvailability == null) {
    return;
  }
  if (farmAvailability.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && farmAvailability.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final farmAvailabilityData =
      getFarmAvailabilityFirestoreData(farmAvailability, forFieldValue);
  final nestedData =
      farmAvailabilityData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = farmAvailability.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFarmAvailabilityFirestoreData(
  FarmAvailabilityStruct? farmAvailability, [
  bool forFieldValue = false,
]) {
  if (farmAvailability == null) {
    return {};
  }
  final firestoreData = mapToFirestore(farmAvailability.toMap());

  // Add any Firestore field values
  mapToFirestore(farmAvailability.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFarmAvailabilityListFirestoreData(
  List<FarmAvailabilityStruct>? farmAvailabilitys,
) =>
    farmAvailabilitys
        ?.map((e) => getFarmAvailabilityFirestoreData(e, true))
        .toList() ??
    [];
