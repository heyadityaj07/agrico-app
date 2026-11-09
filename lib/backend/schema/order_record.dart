import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderRecord extends FirestoreRecord {
  OrderRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "total_ammount" field.
  double? _totalAmmount;
  double get totalAmmount => _totalAmmount ?? 0.0;
  bool hasTotalAmmount() => _totalAmmount != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  bool hasNote() => _note != null;

  // "voucher_code" field.
  String? _voucherCode;
  String get voucherCode => _voucherCode ?? '';
  bool hasVoucherCode() => _voucherCode != null;

  // "service_fee" field.
  double? _serviceFee;
  double get serviceFee => _serviceFee ?? 0.0;
  bool hasServiceFee() => _serviceFee != null;

  // "delivery_tip" field.
  double? _deliveryTip;
  double get deliveryTip => _deliveryTip ?? 0.0;
  bool hasDeliveryTip() => _deliveryTip != null;

  // "delivery_fee" field.
  double? _deliveryFee;
  double get deliveryFee => _deliveryFee ?? 0.0;
  bool hasDeliveryFee() => _deliveryFee != null;

  // "tax" field.
  double? _tax;
  double get tax => _tax ?? 0.0;
  bool hasTax() => _tax != null;

  // "delievry_address" field.
  DeliveryAdressStruct? _delievryAddress;
  DeliveryAdressStruct get delievryAddress =>
      _delievryAddress ?? DeliveryAdressStruct();
  bool hasDelievryAddress() => _delievryAddress != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "delievry_method" field.
  String? _delievryMethod;
  String get delievryMethod => _delievryMethod ?? '';
  bool hasDelievryMethod() => _delievryMethod != null;

  // "delievry_time" field.
  String? _delievryTime;
  String get delievryTime => _delievryTime ?? '';
  bool hasDelievryTime() => _delievryTime != null;

  // "order_status" field.
  String? _orderStatus;
  String get orderStatus => _orderStatus ?? '';
  bool hasOrderStatus() => _orderStatus != null;

  // "order_items" field.
  List<OrderItemsStruct>? _orderItems;
  List<OrderItemsStruct> get orderItems => _orderItems ?? const [];
  bool hasOrderItems() => _orderItems != null;

  // "farm_ref" field.
  DocumentReference? _farmRef;
  DocumentReference? get farmRef => _farmRef;
  bool hasFarmRef() => _farmRef != null;

  // "order_confiramtion_time" field.
  DateTime? _orderConfiramtionTime;
  DateTime? get orderConfiramtionTime => _orderConfiramtionTime;
  bool hasOrderConfiramtionTime() => _orderConfiramtionTime != null;

  // "Preparing_time" field.
  DateTime? _preparingTime;
  DateTime? get preparingTime => _preparingTime;
  bool hasPreparingTime() => _preparingTime != null;

  // "PickedUp_time" field.
  DateTime? _pickedUpTime;
  DateTime? get pickedUpTime => _pickedUpTime;
  bool hasPickedUpTime() => _pickedUpTime != null;

  // "InTransit_time" field.
  DateTime? _inTransitTime;
  DateTime? get inTransitTime => _inTransitTime;
  bool hasInTransitTime() => _inTransitTime != null;

  // "Delivered_time" field.
  DateTime? _deliveredTime;
  DateTime? get deliveredTime => _deliveredTime;
  bool hasDeliveredTime() => _deliveredTime != null;

  // "levae_review" field.
  bool? _levaeReview;
  bool get levaeReview => _levaeReview ?? false;
  bool hasLevaeReview() => _levaeReview != null;

  // "review" field.
  ReviewStruct? _review;
  ReviewStruct get review => _review ?? ReviewStruct();
  bool hasReview() => _review != null;

  // "sub_total" field.
  double? _subTotal;
  double get subTotal => _subTotal ?? 0.0;
  bool hasSubTotal() => _subTotal != null;

  // "is_suspend" field.
  bool? _isSuspend;
  bool get isSuspend => _isSuspend ?? false;
  bool hasIsSuspend() => _isSuspend != null;

  // "is_farm_pickup" field.
  bool? _isFarmPickup;
  bool get isFarmPickup => _isFarmPickup ?? false;
  bool hasIsFarmPickup() => _isFarmPickup != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  bool hasUsername() => _username != null;

  // "uberDeliveryId" field.
  String? _uberDeliveryId;
  String get uberDeliveryId => _uberDeliveryId ?? '';
  bool hasUberDeliveryId() => _uberDeliveryId != null;

  // "deliveryStatus" field.
  String? _deliveryStatus;
  String get deliveryStatus => _deliveryStatus ?? '';
  bool hasDeliveryStatus() => _deliveryStatus != null;

  // "trackingUrl" field.
  String? _trackingUrl;
  String get trackingUrl => _trackingUrl ?? '';
  bool hasTrackingUrl() => _trackingUrl != null;

  // "is_agrico_deliver" field.
  bool? _isAgricoDeliver;
  bool get isAgricoDeliver => _isAgricoDeliver ?? false;
  bool hasIsAgricoDeliver() => _isAgricoDeliver != null;

  // "initial_deposit_paid" field.
  double? _initialDepositPaid;
  double get initialDepositPaid => _initialDepositPaid ?? 0.0;
  bool hasInitialDepositPaid() => _initialDepositPaid != null;

  // "final_total_amount" field.
  double? _finalTotalAmount;
  double get finalTotalAmount => _finalTotalAmount ?? 0.0;
  bool hasFinalTotalAmount() => _finalTotalAmount != null;

  // "is_variable_weight_order" field.
  bool? _isVariableWeightOrder;
  bool get isVariableWeightOrder => _isVariableWeightOrder ?? false;
  bool hasIsVariableWeightOrder() => _isVariableWeightOrder != null;

  // "balance_payment_status" field.
  String? _balancePaymentStatus;
  String get balancePaymentStatus => _balancePaymentStatus ?? '';
  bool hasBalancePaymentStatus() => _balancePaymentStatus != null;

  // "final_balance_amount" field.
  double? _finalBalanceAmount;
  double get finalBalanceAmount => _finalBalanceAmount ?? 0.0;
  bool hasFinalBalanceAmount() => _finalBalanceAmount != null;

  // "refund_due_amount" field.
  double? _refundDueAmount;
  double get refundDueAmount => _refundDueAmount ?? 0.0;
  bool hasRefundDueAmount() => _refundDueAmount != null;

  // "refund_status" field.
  String? _refundStatus;
  String get refundStatus => _refundStatus ?? '';
  bool hasRefundStatus() => _refundStatus != null;

  // "refund_amount" field.
  double? _refundAmount;
  double get refundAmount => _refundAmount ?? 0.0;
  bool hasRefundAmount() => _refundAmount != null;

  // "refund_id" field.
  String? _refundId;
  String get refundId => _refundId ?? '';
  bool hasRefundId() => _refundId != null;

  // "refund_attempt" field.
  int? _refundAttempt;
  int get refundAttempt => _refundAttempt ?? 0;
  bool hasRefundAttempt() => _refundAttempt != null;

  // "refund_attempts" field.
  List<dynamic>? _refundAttempts;
  List<dynamic> get refundAttempts => _refundAttempts ?? const [];
  bool hasRefundAttempts() => _refundAttempts != null;

  // "refund_transfer_reversal_status" field.
  String? _refundTransferReversalStatus;
  String get refundTransferReversalStatus =>
      _refundTransferReversalStatus ?? '';
  bool hasRefundTransferReversalStatus() =>
      _refundTransferReversalStatus != null;

  // "refund_transfer_reversal_reason" field.
  String? _refundTransferReversalReason;
  String get refundTransferReversalReason =>
      _refundTransferReversalReason ?? '';
  bool hasRefundTransferReversalReason() =>
      _refundTransferReversalReason != null;

  // "refund_transfer_reversal_amount" field.
  double? _refundTransferReversalAmount;
  double get refundTransferReversalAmount =>
      _refundTransferReversalAmount ?? 0.0;
  bool hasRefundTransferReversalAmount() =>
      _refundTransferReversalAmount != null;

  // "refund_transfer_reversal_shortfall_amount" field.
  double? _refundTransferReversalShortfallAmount;
  double get refundTransferReversalShortfallAmount =>
      _refundTransferReversalShortfallAmount ?? 0.0;
  bool hasRefundTransferReversalShortfallAmount() =>
      _refundTransferReversalShortfallAmount != null;

  // "refund_transfer_reversal_partial" field.
  bool? _refundTransferReversalPartial;
  bool get refundTransferReversalPartial =>
      _refundTransferReversalPartial ?? false;
  bool hasRefundTransferReversalPartial() =>
      _refundTransferReversalPartial != null;

  // "reconciliationRequired" field.
  bool? _reconciliationRequired;
  bool get reconciliationRequired => _reconciliationRequired ?? false;
  bool hasReconciliationRequired() => _reconciliationRequired != null;

  // "reconciliation_issues" field.
  Map<String, dynamic>? _reconciliationIssues;
  Map<String, dynamic> get reconciliationIssues =>
      _reconciliationIssues ?? const {};
  bool hasReconciliationIssues() => _reconciliationIssues != null;

  // "balance_paid_at" field.
  DateTime? _balancePaidAt;
  DateTime? get balancePaidAt => _balancePaidAt;
  bool hasBalancePaidAt() => _balancePaidAt != null;

  // "balance_payment_state" field.
  String? _balancePaymentState;
  String get balancePaymentState => _balancePaymentState ?? '';
  bool hasBalancePaymentState() => _balancePaymentState != null;

  // "balance_payment_intent_id" field.
  String? _balancePaymentIntentId;
  String get balancePaymentIntentId => _balancePaymentIntentId ?? '';
  bool hasBalancePaymentIntentId() => _balancePaymentIntentId != null;

  // "balance_payment_attempt" field.
  int? _balancePaymentAttempt;
  int get balancePaymentAttempt => _balancePaymentAttempt ?? 0;
  bool hasBalancePaymentAttempt() => _balancePaymentAttempt != null;

  void _initializeFields() {
    _totalAmmount = castToType<double>(snapshotData['total_ammount']);
    _note = snapshotData['note'] as String?;
    _voucherCode = snapshotData['voucher_code'] as String?;
    _serviceFee = castToType<double>(snapshotData['service_fee']);
    _deliveryTip = castToType<double>(snapshotData['delivery_tip']);
    _deliveryFee = castToType<double>(snapshotData['delivery_fee']);
    _tax = castToType<double>(snapshotData['tax']);
    _delievryAddress = snapshotData['delievry_address'] is DeliveryAdressStruct
        ? snapshotData['delievry_address']
        : DeliveryAdressStruct.maybeFromMap(snapshotData['delievry_address']);
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _delievryMethod = snapshotData['delievry_method'] as String?;
    _delievryTime = snapshotData['delievry_time'] as String?;
    _orderStatus = snapshotData['order_status'] as String?;
    _orderItems = getStructList(
      snapshotData['order_items'],
      OrderItemsStruct.fromMap,
    );
    _farmRef = snapshotData['farm_ref'] as DocumentReference?;
    _orderConfiramtionTime =
        snapshotData['order_confiramtion_time'] as DateTime?;
    _preparingTime = snapshotData['Preparing_time'] as DateTime?;
    _pickedUpTime = snapshotData['PickedUp_time'] as DateTime?;
    _inTransitTime = snapshotData['InTransit_time'] as DateTime?;
    _deliveredTime = snapshotData['Delivered_time'] as DateTime?;
    _levaeReview = snapshotData['levae_review'] as bool?;
    _review = snapshotData['review'] is ReviewStruct
        ? snapshotData['review']
        : ReviewStruct.maybeFromMap(snapshotData['review']);
    _subTotal = castToType<double>(snapshotData['sub_total']);
    _isSuspend = snapshotData['is_suspend'] as bool?;
    _isFarmPickup = snapshotData['is_farm_pickup'] as bool?;
    _username = snapshotData['username'] as String?;
    _uberDeliveryId = snapshotData['uberDeliveryId'] as String?;
    _deliveryStatus = snapshotData['deliveryStatus'] as String?;
    _trackingUrl = snapshotData['trackingUrl'] as String?;
    _isAgricoDeliver = snapshotData['is_agrico_deliver'] as bool?;
    _initialDepositPaid =
        castToType<double>(snapshotData['initial_deposit_paid']);
    _finalTotalAmount = castToType<double>(snapshotData['final_total_amount']);
    _isVariableWeightOrder = snapshotData['is_variable_weight_order'] as bool?;
    _balancePaymentStatus = snapshotData['balance_payment_status'] as String?;
    _finalBalanceAmount =
        castToType<double>(snapshotData['final_balance_amount']);
    _refundDueAmount = castToType<double>(snapshotData['refund_due_amount']);
    _refundStatus = snapshotData['refund_status'] as String?;
    _refundAmount = castToType<double>(snapshotData['refund_amount']);
    _refundId = snapshotData['refund_id'] as String?;
    _refundAttempt = castToType<int>(snapshotData['refund_attempt']);
    _refundAttempts = getDataList(snapshotData['refund_attempts']);
    _refundTransferReversalStatus =
        snapshotData['refund_transfer_reversal_status'] as String?;
    _refundTransferReversalReason =
        snapshotData['refund_transfer_reversal_reason'] as String?;
    _refundTransferReversalAmount =
        castToType<double>(snapshotData['refund_transfer_reversal_amount']);
    _refundTransferReversalShortfallAmount = castToType<double>(
        snapshotData['refund_transfer_reversal_shortfall_amount']);
    _refundTransferReversalPartial =
        snapshotData['refund_transfer_reversal_partial'] as bool?;
    _reconciliationRequired =
        snapshotData['reconciliationRequired'] as bool?;
    _reconciliationIssues =
        snapshotData['reconciliation_issues'] is Map
            ? Map<String, dynamic>.from(
                snapshotData['reconciliation_issues'] as Map)
            : null;
    _balancePaidAt = snapshotData['balance_paid_at'] as DateTime?;
    _balancePaymentState = snapshotData['balance_payment_state'] as String?;
    _balancePaymentIntentId =
        snapshotData['balance_payment_intent_id'] as String?;
    _balancePaymentAttempt =
        castToType<int>(snapshotData['balance_payment_attempt']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('order');

  static Stream<OrderRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrderRecord.fromSnapshot(s));

  static Future<OrderRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrderRecord.fromSnapshot(s));

  static OrderRecord fromSnapshot(DocumentSnapshot snapshot) => OrderRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrderRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrderRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrderRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrderRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createOrderRecordData({
  double? totalAmmount,
  String? note,
  String? voucherCode,
  double? serviceFee,
  double? deliveryTip,
  double? deliveryFee,
  double? tax,
  DeliveryAdressStruct? delievryAddress,
  DocumentReference? userRef,
  DateTime? createdAt,
  String? delievryMethod,
  String? delievryTime,
  String? orderStatus,
  DocumentReference? farmRef,
  DateTime? orderConfiramtionTime,
  DateTime? preparingTime,
  DateTime? pickedUpTime,
  DateTime? inTransitTime,
  DateTime? deliveredTime,
  bool? levaeReview,
  ReviewStruct? review,
  double? subTotal,
  bool? isSuspend,
  bool? isFarmPickup,
  String? username,
  String? uberDeliveryId,
  String? deliveryStatus,
  String? trackingUrl,
  bool? isAgricoDeliver,
  double? initialDepositPaid,
  double? finalTotalAmount,
  bool? isVariableWeightOrder,
  String? balancePaymentStatus,
  double? finalBalanceAmount,
  double? refundDueAmount,
  String? refundStatus,
  double? refundAmount,
  String? refundId,
  int? refundAttempt,
  List<dynamic>? refundAttempts,
  String? refundTransferReversalStatus,
  String? refundTransferReversalReason,
  double? refundTransferReversalAmount,
  double? refundTransferReversalShortfallAmount,
  bool? refundTransferReversalPartial,
  bool? reconciliationRequired,
  Map<String, dynamic>? reconciliationIssues,
  DateTime? balancePaidAt,
  String? balancePaymentState,
  String? balancePaymentIntentId,
  int? balancePaymentAttempt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'total_ammount': totalAmmount,
      'note': note,
      'voucher_code': voucherCode,
      'service_fee': serviceFee,
      'delivery_tip': deliveryTip,
      'delivery_fee': deliveryFee,
      'tax': tax,
      'delievry_address': DeliveryAdressStruct().toMap(),
      'user_ref': userRef,
      'created_at': createdAt,
      'delievry_method': delievryMethod,
      'delievry_time': delievryTime,
      'order_status': orderStatus,
      'farm_ref': farmRef,
      'order_confiramtion_time': orderConfiramtionTime,
      'Preparing_time': preparingTime,
      'PickedUp_time': pickedUpTime,
      'InTransit_time': inTransitTime,
      'Delivered_time': deliveredTime,
      'levae_review': levaeReview,
      'review': ReviewStruct().toMap(),
      'sub_total': subTotal,
      'is_suspend': isSuspend,
      'is_farm_pickup': isFarmPickup,
      'username': username,
      'uberDeliveryId': uberDeliveryId,
      'deliveryStatus': deliveryStatus,
      'trackingUrl': trackingUrl,
      'is_agrico_deliver': isAgricoDeliver,
      'initial_deposit_paid': initialDepositPaid,
      'final_total_amount': finalTotalAmount,
      'is_variable_weight_order': isVariableWeightOrder,
      'balance_payment_status': balancePaymentStatus,
      'final_balance_amount': finalBalanceAmount,
      'refund_due_amount': refundDueAmount,
      'refund_status': refundStatus,
      'refund_amount': refundAmount,
      'refund_id': refundId,
      'refund_attempt': refundAttempt,
      'refund_attempts': refundAttempts,
      'refund_transfer_reversal_status': refundTransferReversalStatus,
      'refund_transfer_reversal_reason': refundTransferReversalReason,
      'refund_transfer_reversal_amount': refundTransferReversalAmount,
      'refund_transfer_reversal_shortfall_amount':
          refundTransferReversalShortfallAmount,
      'refund_transfer_reversal_partial': refundTransferReversalPartial,
      'reconciliationRequired': reconciliationRequired,
      'reconciliation_issues': reconciliationIssues,
      'balance_paid_at': balancePaidAt,
      'balance_payment_state': balancePaymentState,
      'balance_payment_intent_id': balancePaymentIntentId,
      'balance_payment_attempt': balancePaymentAttempt,
    }.withoutNulls,
  );

  // Handle nested data for "delievry_address" field.
  addDeliveryAdressStructData(
      firestoreData, delievryAddress, 'delievry_address');

  // Handle nested data for "review" field.
  addReviewStructData(firestoreData, review, 'review');

  return firestoreData;
}

class OrderRecordDocumentEquality implements Equality<OrderRecord> {
  const OrderRecordDocumentEquality();

  @override
  bool equals(OrderRecord? e1, OrderRecord? e2) {
    const listEquality = ListEquality();
    const deepEquality = DeepCollectionEquality();
    return e1?.totalAmmount == e2?.totalAmmount &&
        e1?.note == e2?.note &&
        e1?.voucherCode == e2?.voucherCode &&
        e1?.serviceFee == e2?.serviceFee &&
        e1?.deliveryTip == e2?.deliveryTip &&
        e1?.deliveryFee == e2?.deliveryFee &&
        e1?.tax == e2?.tax &&
        e1?.delievryAddress == e2?.delievryAddress &&
        e1?.userRef == e2?.userRef &&
        e1?.createdAt == e2?.createdAt &&
        e1?.delievryMethod == e2?.delievryMethod &&
        e1?.delievryTime == e2?.delievryTime &&
        e1?.orderStatus == e2?.orderStatus &&
        listEquality.equals(e1?.orderItems, e2?.orderItems) &&
        e1?.farmRef == e2?.farmRef &&
        e1?.orderConfiramtionTime == e2?.orderConfiramtionTime &&
        e1?.preparingTime == e2?.preparingTime &&
        e1?.pickedUpTime == e2?.pickedUpTime &&
        e1?.inTransitTime == e2?.inTransitTime &&
        e1?.deliveredTime == e2?.deliveredTime &&
        e1?.levaeReview == e2?.levaeReview &&
        e1?.review == e2?.review &&
        e1?.subTotal == e2?.subTotal &&
        e1?.isSuspend == e2?.isSuspend &&
        e1?.isFarmPickup == e2?.isFarmPickup &&
        e1?.username == e2?.username &&
        e1?.uberDeliveryId == e2?.uberDeliveryId &&
        e1?.deliveryStatus == e2?.deliveryStatus &&
        e1?.trackingUrl == e2?.trackingUrl &&
        e1?.isAgricoDeliver == e2?.isAgricoDeliver &&
        e1?.initialDepositPaid == e2?.initialDepositPaid &&
        e1?.finalTotalAmount == e2?.finalTotalAmount &&
        e1?.isVariableWeightOrder == e2?.isVariableWeightOrder &&
        e1?.balancePaymentStatus == e2?.balancePaymentStatus &&
        e1?.finalBalanceAmount == e2?.finalBalanceAmount &&
        e1?.refundDueAmount == e2?.refundDueAmount &&
        e1?.refundStatus == e2?.refundStatus &&
        e1?.refundAmount == e2?.refundAmount &&
        e1?.refundId == e2?.refundId &&
        e1?.refundAttempt == e2?.refundAttempt &&
        deepEquality.equals(e1?.refundAttempts, e2?.refundAttempts) &&
        e1?.refundTransferReversalStatus ==
            e2?.refundTransferReversalStatus &&
        e1?.refundTransferReversalReason ==
            e2?.refundTransferReversalReason &&
        e1?.refundTransferReversalAmount ==
            e2?.refundTransferReversalAmount &&
        e1?.refundTransferReversalShortfallAmount ==
            e2?.refundTransferReversalShortfallAmount &&
        e1?.refundTransferReversalPartial ==
            e2?.refundTransferReversalPartial &&
        e1?.reconciliationRequired == e2?.reconciliationRequired &&
        deepEquality.equals(
            e1?.reconciliationIssues, e2?.reconciliationIssues) &&
        e1?.balancePaidAt == e2?.balancePaidAt &&
        e1?.balancePaymentState == e2?.balancePaymentState &&
        e1?.balancePaymentIntentId == e2?.balancePaymentIntentId &&
        e1?.balancePaymentAttempt == e2?.balancePaymentAttempt;
  }

  @override
  int hash(OrderRecord? e) => const ListEquality().hash([
        e?.totalAmmount,
        e?.note,
        e?.voucherCode,
        e?.serviceFee,
        e?.deliveryTip,
        e?.deliveryFee,
        e?.tax,
        e?.delievryAddress,
        e?.userRef,
        e?.createdAt,
        e?.delievryMethod,
        e?.delievryTime,
        e?.orderStatus,
        const ListEquality().hash(e?.orderItems),
        e?.farmRef,
        e?.orderConfiramtionTime,
        e?.preparingTime,
        e?.pickedUpTime,
        e?.inTransitTime,
        e?.deliveredTime,
        e?.levaeReview,
        e?.review,
        e?.subTotal,
        e?.isSuspend,
        e?.isFarmPickup,
        e?.username,
        e?.uberDeliveryId,
        e?.deliveryStatus,
        e?.trackingUrl,
        e?.isAgricoDeliver,
        e?.initialDepositPaid,
        e?.finalTotalAmount,
        e?.isVariableWeightOrder,
        e?.balancePaymentStatus,
        e?.finalBalanceAmount,
        e?.refundDueAmount,
        e?.refundStatus,
        e?.refundAmount,
        e?.refundId,
        e?.refundAttempt,
        const DeepCollectionEquality().hash(e?.refundAttempts),
        e?.refundTransferReversalStatus,
        e?.refundTransferReversalReason,
        e?.refundTransferReversalAmount,
        e?.refundTransferReversalShortfallAmount,
        e?.refundTransferReversalPartial,
        e?.reconciliationRequired,
        const DeepCollectionEquality().hash(e?.reconciliationIssues),
        e?.balancePaidAt,
        e?.balancePaymentState,
        e?.balancePaymentIntentId,
        e?.balancePaymentAttempt
      ]);

  @override
  bool isValidKey(Object? o) => o is OrderRecord;
}
