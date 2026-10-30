import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StripeConnectAccountsRecord extends FirestoreRecord {
  StripeConnectAccountsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "accountId" field.
  String? _accountId;
  String get accountId => _accountId ?? '';
  bool hasAccountId() => _accountId != null;

  // "businessType" field.
  String? _businessType;
  String get businessType => _businessType ?? '';
  bool hasBusinessType() => _businessType != null;

  // "chargesEnabled" field.
  bool? _chargesEnabled;
  bool get chargesEnabled => _chargesEnabled ?? false;
  bool hasChargesEnabled() => _chargesEnabled != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "detailsSubmitted" field.
  bool? _detailsSubmitted;
  bool get detailsSubmitted => _detailsSubmitted ?? false;
  bool hasDetailsSubmitted() => _detailsSubmitted != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "payoutsEnabled" field.
  bool? _payoutsEnabled;
  bool get payoutsEnabled => _payoutsEnabled ?? false;
  bool hasPayoutsEnabled() => _payoutsEnabled != null;

  void _initializeFields() {
    _accountId = snapshotData['accountId'] as String?;
    _businessType = snapshotData['businessType'] as String?;
    _chargesEnabled = snapshotData['chargesEnabled'] as bool?;
    _country = snapshotData['country'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _detailsSubmitted = snapshotData['detailsSubmitted'] as bool?;
    _email = snapshotData['email'] as String?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _userId = snapshotData['userId'] as String?;
    _payoutsEnabled = snapshotData['payoutsEnabled'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('stripeConnectAccounts');

  static Stream<StripeConnectAccountsRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => StripeConnectAccountsRecord.fromSnapshot(s));

  static Future<StripeConnectAccountsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => StripeConnectAccountsRecord.fromSnapshot(s));

  static StripeConnectAccountsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      StripeConnectAccountsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static StripeConnectAccountsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      StripeConnectAccountsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'StripeConnectAccountsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is StripeConnectAccountsRecord &&
      reference.path == other.reference.path;
}

Map<String, dynamic> createStripeConnectAccountsRecordData({
  String? accountId,
  String? businessType,
  bool? chargesEnabled,
  String? country,
  DateTime? createdAt,
  bool? detailsSubmitted,
  String? email,
  DateTime? updatedAt,
  String? userId,
  bool? payoutsEnabled,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'accountId': accountId,
      'businessType': businessType,
      'chargesEnabled': chargesEnabled,
      'country': country,
      'createdAt': createdAt,
      'detailsSubmitted': detailsSubmitted,
      'email': email,
      'updatedAt': updatedAt,
      'userId': userId,
      'payoutsEnabled': payoutsEnabled,
    }.withoutNulls,
  );

  return firestoreData;
}

class StripeConnectAccountsRecordDocumentEquality
    implements Equality<StripeConnectAccountsRecord> {
  const StripeConnectAccountsRecordDocumentEquality();

  @override
  bool equals(
      StripeConnectAccountsRecord? e1, StripeConnectAccountsRecord? e2) {
    return e1?.accountId == e2?.accountId &&
        e1?.businessType == e2?.businessType &&
        e1?.chargesEnabled == e2?.chargesEnabled &&
        e1?.country == e2?.country &&
        e1?.createdAt == e2?.createdAt &&
        e1?.detailsSubmitted == e2?.detailsSubmitted &&
        e1?.email == e2?.email &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.userId == e2?.userId &&
        e1?.payoutsEnabled == e2?.payoutsEnabled;
  }

  @override
  int hash(StripeConnectAccountsRecord? e) => const ListEquality().hash([
        e?.accountId,
        e?.businessType,
        e?.chargesEnabled,
        e?.country,
        e?.createdAt,
        e?.detailsSubmitted,
        e?.email,
        e?.updatedAt,
        e?.userId,
        e?.payoutsEnabled
      ]);

  @override
  bool isValidKey(Object? o) => o is StripeConnectAccountsRecord;
}
