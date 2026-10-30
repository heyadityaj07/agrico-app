import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgricooRecord extends FirestoreRecord {
  AgricooRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "farmId" field.
  DocumentReference? _farmId;
  DocumentReference? get farmId => _farmId;
  bool hasFarmId() => _farmId != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "created_At" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as DocumentReference?;
    _farmId = snapshotData['farmId'] as DocumentReference?;
    _location = snapshotData['location'] as LatLng?;
    _createdAt = snapshotData['created_At'] as DateTime?;
    _status = snapshotData['status'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('agricoo');

  static Stream<AgricooRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AgricooRecord.fromSnapshot(s));

  static Future<AgricooRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AgricooRecord.fromSnapshot(s));

  static AgricooRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AgricooRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AgricooRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AgricooRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AgricooRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AgricooRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createAgricooRecordData({
  DocumentReference? userId,
  DocumentReference? farmId,
  LatLng? location,
  DateTime? createdAt,
  String? status,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userId': userId,
      'farmId': farmId,
      'location': location,
      'created_At': createdAt,
      'status': status,
    }.withoutNulls,
  );

  return firestoreData;
}

class AgricooRecordDocumentEquality implements Equality<AgricooRecord> {
  const AgricooRecordDocumentEquality();

  @override
  bool equals(AgricooRecord? e1, AgricooRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.farmId == e2?.farmId &&
        e1?.location == e2?.location &&
        e1?.createdAt == e2?.createdAt &&
        e1?.status == e2?.status;
  }

  @override
  int hash(AgricooRecord? e) => const ListEquality()
      .hash([e?.userId, e?.farmId, e?.location, e?.createdAt, e?.status]);

  @override
  bool isValidKey(Object? o) => o is AgricooRecord;
}
