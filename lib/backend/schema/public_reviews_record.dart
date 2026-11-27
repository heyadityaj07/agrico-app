import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Collection public_reviews
class PublicReviewsRecord extends FirestoreRecord {
  PublicReviewsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "author_display_name" field.
  String? _authorDisplayName;
  String get authorDisplayName => _authorDisplayName ?? '';
  bool hasAuthorDisplayName() => _authorDisplayName != null;

  // "author_photo_url" field.
  String? _authorPhotoUrl;
  String get authorPhotoUrl => _authorPhotoUrl ?? '';
  bool hasAuthorPhotoUrl() => _authorPhotoUrl != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _rating = castToType<double>(snapshotData['rating']);
    _comment = snapshotData['comment'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _authorDisplayName = snapshotData['author_display_name'] as String?;
    _authorPhotoUrl = snapshotData['author_photo_url'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('public_reviews')
          : FirebaseFirestore.instance.collectionGroup('public_reviews');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('public_reviews').doc(id);

  static Stream<PublicReviewsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PublicReviewsRecord.fromSnapshot(s));

  static Future<PublicReviewsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PublicReviewsRecord.fromSnapshot(s));

  static PublicReviewsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PublicReviewsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PublicReviewsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PublicReviewsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PublicReviewsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PublicReviewsRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createPublicReviewsRecordData({
  double? rating,
  String? comment,
  DateTime? createdAt,
  String? authorDisplayName,
  String? authorPhotoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'author_display_name': authorDisplayName,
      'author_photo_url': authorPhotoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class PublicReviewsRecordDocumentEquality
    implements Equality<PublicReviewsRecord> {
  const PublicReviewsRecordDocumentEquality();

  @override
  bool equals(PublicReviewsRecord? e1, PublicReviewsRecord? e2) {
    return e1?.rating == e2?.rating &&
        e1?.comment == e2?.comment &&
        e1?.createdAt == e2?.createdAt &&
        e1?.authorDisplayName == e2?.authorDisplayName &&
        e1?.authorPhotoUrl == e2?.authorPhotoUrl;
  }

  @override
  int hash(PublicReviewsRecord? e) => const ListEquality().hash([
        e?.rating,
        e?.comment,
        e?.createdAt,
        e?.authorDisplayName,
        e?.authorPhotoUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is PublicReviewsRecord;
}
