import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AuditLogRecord extends FirestoreRecord {
  AuditLogRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('audit_log');

  static Stream<AuditLogRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AuditLogRecord.fromSnapshot(s));

  static Future<AuditLogRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AuditLogRecord.fromSnapshot(s));

  static AuditLogRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AuditLogRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AuditLogRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AuditLogRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AuditLogRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AuditLogRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createAuditLogRecordData({
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class AuditLogRecordDocumentEquality implements Equality<AuditLogRecord> {
  const AuditLogRecordDocumentEquality();

  @override
  bool equals(AuditLogRecord? e1, AuditLogRecord? e2) {
    return e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(AuditLogRecord? e) => const ListEquality().hash([e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is AuditLogRecord;
}
