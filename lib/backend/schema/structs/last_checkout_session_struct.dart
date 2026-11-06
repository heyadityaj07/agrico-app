// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LastCheckoutSessionStruct extends FFFirebaseStruct {
  LastCheckoutSessionStruct({
    String? sessionId,
    String? subscriptionId,
    DateTime? timestamp,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _sessionId = sessionId,
        _subscriptionId = subscriptionId,
        _timestamp = timestamp,
        super(firestoreUtilData);

  // "sessionId" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  set sessionId(String? val) => _sessionId = val;

  bool hasSessionId() => _sessionId != null;

  // "subscriptionId" field.
  String? _subscriptionId;
  String get subscriptionId => _subscriptionId ?? '';
  set subscriptionId(String? val) => _subscriptionId = val;

  bool hasSubscriptionId() => _subscriptionId != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  static LastCheckoutSessionStruct fromMap(Map<String, dynamic> data) =>
      LastCheckoutSessionStruct(
        sessionId: data['sessionId'] as String?,
        subscriptionId: data['subscriptionId'] as String?,
        timestamp: data['timestamp'] as DateTime?,
      );

  static LastCheckoutSessionStruct? maybeFromMap(dynamic data) => data is Map
      ? LastCheckoutSessionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'sessionId': _sessionId,
        'subscriptionId': _subscriptionId,
        'timestamp': _timestamp,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'sessionId': serializeParam(
          _sessionId,
          ParamType.String,
        ),
        'subscriptionId': serializeParam(
          _subscriptionId,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static LastCheckoutSessionStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      LastCheckoutSessionStruct(
        sessionId: deserializeParam(
          data['sessionId'],
          ParamType.String,
          false,
        ),
        subscriptionId: deserializeParam(
          data['subscriptionId'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'LastCheckoutSessionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LastCheckoutSessionStruct &&
        sessionId == other.sessionId &&
        subscriptionId == other.subscriptionId &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([sessionId, subscriptionId, timestamp]);
}

LastCheckoutSessionStruct createLastCheckoutSessionStruct({
  String? sessionId,
  String? subscriptionId,
  DateTime? timestamp,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LastCheckoutSessionStruct(
      sessionId: sessionId,
      subscriptionId: subscriptionId,
      timestamp: timestamp,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LastCheckoutSessionStruct? updateLastCheckoutSessionStruct(
  LastCheckoutSessionStruct? lastCheckoutSession, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    lastCheckoutSession
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLastCheckoutSessionStructData(
  Map<String, dynamic> firestoreData,
  LastCheckoutSessionStruct? lastCheckoutSession,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (lastCheckoutSession == null) {
    return;
  }
  if (lastCheckoutSession.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && lastCheckoutSession.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final lastCheckoutSessionData =
      getLastCheckoutSessionFirestoreData(lastCheckoutSession, forFieldValue);
  final nestedData =
      lastCheckoutSessionData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      lastCheckoutSession.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLastCheckoutSessionFirestoreData(
  LastCheckoutSessionStruct? lastCheckoutSession, [
  bool forFieldValue = false,
]) {
  if (lastCheckoutSession == null) {
    return {};
  }
  final firestoreData = mapToFirestore(lastCheckoutSession.toMap());

  // Add any Firestore field values
  mapToFirestore(lastCheckoutSession.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLastCheckoutSessionListFirestoreData(
  List<LastCheckoutSessionStruct>? lastCheckoutSessions,
) =>
    lastCheckoutSessions
        ?.map((e) => getLastCheckoutSessionFirestoreData(e, true))
        .toList() ??
    [];
