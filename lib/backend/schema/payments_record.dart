import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentsRecord extends FirestoreRecord {
  PaymentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "buyerId" field.
  String? _buyerId;
  String get buyerId => _buyerId ?? '';
  bool hasBuyerId() => _buyerId != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "orderId" field.
  String? _orderId;
  String get orderId => _orderId ?? '';
  bool hasOrderId() => _orderId != null;

  // "orderType" field.
  List<String>? _orderType;
  List<String> get orderType => _orderType ?? const [];
  bool hasOrderType() => _orderType != null;

  // "platformFee" field.
  double? _platformFee;
  double get platformFee => _platformFee ?? 0.0;
  bool hasPlatformFee() => _platformFee != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "totalPaid" field.
  double? _totalPaid;
  double get totalPaid => _totalPaid ?? 0.0;
  bool hasTotalPaid() => _totalPaid != null;

  // "transferGroup" field.
  String? _transferGroup;
  String get transferGroup => _transferGroup ?? '';
  bool hasTransferGroup() => _transferGroup != null;

  // "vendorDetails" field.
  List<VendorDetailsModelStruct>? _vendorDetails;
  List<VendorDetailsModelStruct> get vendorDetails =>
      _vendorDetails ?? const [];
  bool hasVendorDetails() => _vendorDetails != null;

  void _initializeFields() {
    _buyerId = snapshotData['buyerId'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _orderId = snapshotData['orderId'] as String?;
    _orderType = getDataList(snapshotData['orderType']);
    _platformFee = castToType<double>(snapshotData['platformFee']);
    _status = snapshotData['status'] as String?;
    _totalPaid = castToType<double>(snapshotData['totalPaid']);
    _transferGroup = snapshotData['transferGroup'] as String?;
    _vendorDetails = getStructList(
      snapshotData['vendorDetails'],
      VendorDetailsModelStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('payments');

  static Stream<PaymentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentsRecord.fromSnapshot(s));

  static Future<PaymentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentsRecord.fromSnapshot(s));

  static PaymentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentsRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createPaymentsRecordData({
  String? buyerId,
  DateTime? createdAt,
  String? orderId,
  double? platformFee,
  String? status,
  double? totalPaid,
  String? transferGroup,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'buyerId': buyerId,
      'createdAt': createdAt,
      'orderId': orderId,
      'platformFee': platformFee,
      'status': status,
      'totalPaid': totalPaid,
      'transferGroup': transferGroup,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentsRecordDocumentEquality implements Equality<PaymentsRecord> {
  const PaymentsRecordDocumentEquality();

  @override
  bool equals(PaymentsRecord? e1, PaymentsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.buyerId == e2?.buyerId &&
        e1?.createdAt == e2?.createdAt &&
        e1?.orderId == e2?.orderId &&
        listEquality.equals(e1?.orderType, e2?.orderType) &&
        e1?.platformFee == e2?.platformFee &&
        e1?.status == e2?.status &&
        e1?.totalPaid == e2?.totalPaid &&
        e1?.transferGroup == e2?.transferGroup &&
        listEquality.equals(e1?.vendorDetails, e2?.vendorDetails);
  }

  @override
  int hash(PaymentsRecord? e) => const ListEquality().hash([
        e?.buyerId,
        e?.createdAt,
        e?.orderId,
        const ListEquality().hash(e?.orderType),
        e?.platformFee,
        e?.status,
        e?.totalPaid,
        e?.transferGroup,
        const ListEquality().hash(e?.vendorDetails)
      ]);

  @override
  bool isValidKey(Object? o) => o is PaymentsRecord;
}
