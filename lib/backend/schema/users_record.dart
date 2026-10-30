import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "my_favourite_product" field.
  List<DocumentReference>? _myFavouriteProduct;
  List<DocumentReference> get myFavouriteProduct =>
      _myFavouriteProduct ?? const [];
  bool hasMyFavouriteProduct() => _myFavouriteProduct != null;

  // "my_favourite_farm" field.
  List<DocumentReference>? _myFavouriteFarm;
  List<DocumentReference> get myFavouriteFarm => _myFavouriteFarm ?? const [];
  bool hasMyFavouriteFarm() => _myFavouriteFarm != null;

  // "delivery_Addresses" field.
  List<DeliveryAdressStruct>? _deliveryAddresses;
  List<DeliveryAdressStruct> get deliveryAddresses =>
      _deliveryAddresses ?? const [];
  bool hasDeliveryAddresses() => _deliveryAddresses != null;

  // "default_adress" field.
  int? _defaultAdress;
  int get defaultAdress => _defaultAdress ?? 0;
  bool hasDefaultAdress() => _defaultAdress != null;

  // "is_suspend" field.
  bool? _isSuspend;
  bool get isSuspend => _isSuspend ?? false;
  bool hasIsSuspend() => _isSuspend != null;

  // "stripeCustomerId" field.
  String? _stripeCustomerId;
  String get stripeCustomerId => _stripeCustomerId ?? '';
  bool hasStripeCustomerId() => _stripeCustomerId != null;

  // "subscriptionId" field.
  String? _subscriptionId;
  String get subscriptionId => _subscriptionId ?? '';
  bool hasSubscriptionId() => _subscriptionId != null;

  // "subscriptionActive" field.
  bool? _subscriptionActive;
  bool get subscriptionActive => _subscriptionActive ?? false;
  bool hasSubscriptionActive() => _subscriptionActive != null;

  // "stripeConnectAccountId" field.
  String? _stripeConnectAccountId;
  String get stripeConnectAccountId => _stripeConnectAccountId ?? '';
  bool hasStripeConnectAccountId() => _stripeConnectAccountId != null;

  // "stripeConnectStatus" field.
  String? _stripeConnectStatus;
  String get stripeConnectStatus => _stripeConnectStatus ?? '';
  bool hasStripeConnectStatus() => _stripeConnectStatus != null;

  // "stripeId" field.
  String? _stripeId;
  String get stripeId => _stripeId ?? '';
  bool hasStripeId() => _stripeId != null;

  // "stripeLink" field.
  String? _stripeLink;
  String get stripeLink => _stripeLink ?? '';
  bool hasStripeLink() => _stripeLink != null;

  // "subscriptionStatus" field.
  String? _subscriptionStatus;
  String get subscriptionStatus => _subscriptionStatus ?? '';
  bool hasSubscriptionStatus() => _subscriptionStatus != null;

  // "lastCheckoutSession" field.
  LastCheckoutSessionStruct? _lastCheckoutSession;
  LastCheckoutSessionStruct get lastCheckoutSession =>
      _lastCheckoutSession ?? LastCheckoutSessionStruct();
  bool hasLastCheckoutSession() => _lastCheckoutSession != null;

  // "currentPeriodEnd" field.
  DateTime? _currentPeriodEnd;
  DateTime? get currentPeriodEnd => _currentPeriodEnd;
  bool hasCurrentPeriodEnd() => _currentPeriodEnd != null;

  // "subscriptionPlanName" field.
  String? _subscriptionPlanName;
  String get subscriptionPlanName => _subscriptionPlanName ?? '';
  bool hasSubscriptionPlanName() => _subscriptionPlanName != null;

  // "notification_count" field.
  int? _notificationCount;
  int get notificationCount => _notificationCount ?? 0;
  bool hasNotificationCount() => _notificationCount != null;

  // "termsAcceptedAt" field.
  DateTime? _termsAcceptedAt;
  DateTime? get termsAcceptedAt => _termsAcceptedAt;
  bool hasTermsAcceptedAt() => _termsAcceptedAt != null;

  // "termsVersion" field.
  String? _termsVersion;
  String get termsVersion => _termsVersion ?? '';
  bool hasTermsVersion() => _termsVersion != null;

  // "producerTermsAcceptedAt" field.
  DateTime? _producerTermsAcceptedAt;
  DateTime? get producerTermsAcceptedAt => _producerTermsAcceptedAt;
  bool hasProducerTermsAcceptedAt() => _producerTermsAcceptedAt != null;

  // "producerTermsVersion" field.
  String? _producerTermsVersion;
  String get producerTermsVersion => _producerTermsVersion ?? '';
  bool hasProducerTermsVersion() => _producerTermsVersion != null;

  // "privacyAcknowledgedAt" field.
  DateTime? _privacyAcknowledgedAt;
  DateTime? get privacyAcknowledgedAt => _privacyAcknowledgedAt;
  bool hasPrivacyAcknowledgedAt() => _privacyAcknowledgedAt != null;

  // "privacyVersion" field.
  String? _privacyVersion;
  String get privacyVersion => _privacyVersion ?? '';
  bool hasPrivacyVersion() => _privacyVersion != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _role = snapshotData['role'] as String?;
    _myFavouriteProduct = getDataList(snapshotData['my_favourite_product']);
    _myFavouriteFarm = getDataList(snapshotData['my_favourite_farm']);
    _deliveryAddresses = getStructList(
      snapshotData['delivery_Addresses'],
      DeliveryAdressStruct.fromMap,
    );
    _defaultAdress = castToType<int>(snapshotData['default_adress']);
    _isSuspend = snapshotData['is_suspend'] as bool?;
    _stripeCustomerId = snapshotData['stripeCustomerId'] as String?;
    _subscriptionId = snapshotData['subscriptionId'] as String?;
    _subscriptionActive = snapshotData['subscriptionActive'] as bool?;
    _stripeConnectAccountId = snapshotData['stripeConnectAccountId'] as String?;
    _stripeConnectStatus = snapshotData['stripeConnectStatus'] as String?;
    _stripeId = snapshotData['stripeId'] as String?;
    _stripeLink = snapshotData['stripeLink'] as String?;
    _subscriptionStatus = snapshotData['subscriptionStatus'] as String?;
    _lastCheckoutSession =
        snapshotData['lastCheckoutSession'] is LastCheckoutSessionStruct
            ? snapshotData['lastCheckoutSession']
            : LastCheckoutSessionStruct.maybeFromMap(
                snapshotData['lastCheckoutSession']);
    _currentPeriodEnd = snapshotData['currentPeriodEnd'] as DateTime?;
    _subscriptionPlanName = snapshotData['subscriptionPlanName'] as String?;
    _notificationCount = castToType<int>(snapshotData['notification_count']);
    _termsAcceptedAt = snapshotData['termsAcceptedAt'] as DateTime?;
    _termsVersion = snapshotData['termsVersion'] as String?;
    _producerTermsAcceptedAt =
        snapshotData['producerTermsAcceptedAt'] as DateTime?;
    _producerTermsVersion = snapshotData['producerTermsVersion'] as String?;
    _privacyAcknowledgedAt = snapshotData['privacyAcknowledgedAt'] as DateTime?;
    _privacyVersion = snapshotData['privacyVersion'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? role,
  int? defaultAdress,
  bool? isSuspend,
  String? stripeCustomerId,
  String? subscriptionId,
  bool? subscriptionActive,
  String? stripeConnectAccountId,
  String? stripeConnectStatus,
  String? stripeId,
  String? stripeLink,
  String? subscriptionStatus,
  LastCheckoutSessionStruct? lastCheckoutSession,
  DateTime? currentPeriodEnd,
  String? subscriptionPlanName,
  int? notificationCount,
  DateTime? termsAcceptedAt,
  String? termsVersion,
  DateTime? producerTermsAcceptedAt,
  String? producerTermsVersion,
  DateTime? privacyAcknowledgedAt,
  String? privacyVersion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'role': role,
      'default_adress': defaultAdress,
      'is_suspend': isSuspend,
      'stripeCustomerId': stripeCustomerId,
      'subscriptionId': subscriptionId,
      'subscriptionActive': subscriptionActive,
      'stripeConnectAccountId': stripeConnectAccountId,
      'stripeConnectStatus': stripeConnectStatus,
      'stripeId': stripeId,
      'stripeLink': stripeLink,
      'subscriptionStatus': subscriptionStatus,
      'lastCheckoutSession': LastCheckoutSessionStruct().toMap(),
      'currentPeriodEnd': currentPeriodEnd,
      'subscriptionPlanName': subscriptionPlanName,
      'notification_count': notificationCount,
      'termsAcceptedAt': termsAcceptedAt,
      'termsVersion': termsVersion,
      'producerTermsAcceptedAt': producerTermsAcceptedAt,
      'producerTermsVersion': producerTermsVersion,
      'privacyAcknowledgedAt': privacyAcknowledgedAt,
      'privacyVersion': privacyVersion,
    }.withoutNulls,
  );

  // Handle nested data for "lastCheckoutSession" field.
  addLastCheckoutSessionStructData(
      firestoreData, lastCheckoutSession, 'lastCheckoutSession');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.role == e2?.role &&
        listEquality.equals(e1?.myFavouriteProduct, e2?.myFavouriteProduct) &&
        listEquality.equals(e1?.myFavouriteFarm, e2?.myFavouriteFarm) &&
        listEquality.equals(e1?.deliveryAddresses, e2?.deliveryAddresses) &&
        e1?.defaultAdress == e2?.defaultAdress &&
        e1?.isSuspend == e2?.isSuspend &&
        e1?.stripeCustomerId == e2?.stripeCustomerId &&
        e1?.subscriptionId == e2?.subscriptionId &&
        e1?.subscriptionActive == e2?.subscriptionActive &&
        e1?.stripeConnectAccountId == e2?.stripeConnectAccountId &&
        e1?.stripeConnectStatus == e2?.stripeConnectStatus &&
        e1?.stripeId == e2?.stripeId &&
        e1?.stripeLink == e2?.stripeLink &&
        e1?.subscriptionStatus == e2?.subscriptionStatus &&
        e1?.lastCheckoutSession == e2?.lastCheckoutSession &&
        e1?.currentPeriodEnd == e2?.currentPeriodEnd &&
        e1?.subscriptionPlanName == e2?.subscriptionPlanName &&
        e1?.notificationCount == e2?.notificationCount &&
        e1?.termsAcceptedAt == e2?.termsAcceptedAt &&
        e1?.termsVersion == e2?.termsVersion &&
        e1?.producerTermsAcceptedAt == e2?.producerTermsAcceptedAt &&
        e1?.producerTermsVersion == e2?.producerTermsVersion &&
        e1?.privacyAcknowledgedAt == e2?.privacyAcknowledgedAt &&
        e1?.privacyVersion == e2?.privacyVersion;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.role,
        const ListEquality().hash(e?.myFavouriteProduct),
        const ListEquality().hash(e?.myFavouriteFarm),
        const ListEquality().hash(e?.deliveryAddresses),
        e?.defaultAdress,
        e?.isSuspend,
        e?.stripeCustomerId,
        e?.subscriptionId,
        e?.subscriptionActive,
        e?.stripeConnectAccountId,
        e?.stripeConnectStatus,
        e?.stripeId,
        e?.stripeLink,
        e?.subscriptionStatus,
        e?.lastCheckoutSession,
        e?.currentPeriodEnd,
        e?.subscriptionPlanName,
        e?.notificationCount,
        e?.termsAcceptedAt,
        e?.termsVersion,
        e?.producerTermsAcceptedAt,
        e?.producerTermsVersion,
        e?.privacyAcknowledgedAt,
        e?.privacyVersion
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
