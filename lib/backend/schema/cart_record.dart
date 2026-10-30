import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartRecord extends FirestoreRecord {
  CartRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "productRef" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  // "price_per_product" field.
  double? _pricePerProduct;
  double get pricePerProduct => _pricePerProduct ?? 0.0;
  bool hasPricePerProduct() => _pricePerProduct != null;

  // "farm_ref" field.
  DocumentReference? _farmRef;
  DocumentReference? get farmRef => _farmRef;
  bool hasFarmRef() => _farmRef != null;

  // "is_variable_weight" field.
  bool? _isVariableWeight;
  bool get isVariableWeight => _isVariableWeight ?? false;
  bool hasIsVariableWeight() => _isVariableWeight != null;

  // "min_weight" field.
  double? _minWeight;
  double get minWeight => _minWeight ?? 0.0;
  bool hasMinWeight() => _minWeight != null;

  // "max_weight" field.
  double? _maxWeight;
  double get maxWeight => _maxWeight ?? 0.0;
  bool hasMaxWeight() => _maxWeight != null;

  // "price_per_kg" field.
  double? _pricePerKg;
  double get pricePerKg => _pricePerKg ?? 0.0;
  bool hasPricePerKg() => _pricePerKg != null;

  // "deposit_amount" field.
  double? _depositAmount;
  double get depositAmount => _depositAmount ?? 0.0;
  bool hasDepositAmount() => _depositAmount != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _productRef = snapshotData['productRef'] as DocumentReference?;
    _quantity = castToType<int>(snapshotData['quantity']);
    _pricePerProduct = castToType<double>(snapshotData['price_per_product']);
    _farmRef = snapshotData['farm_ref'] as DocumentReference?;
    _isVariableWeight = snapshotData['is_variable_weight'] as bool?;
    _minWeight = castToType<double>(snapshotData['min_weight']);
    _maxWeight = castToType<double>(snapshotData['max_weight']);
    _pricePerKg = castToType<double>(snapshotData['price_per_kg']);
    _depositAmount = castToType<double>(snapshotData['deposit_amount']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('cart')
          : FirebaseFirestore.instance.collectionGroup('cart');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('cart').doc(id);

  static Stream<CartRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CartRecord.fromSnapshot(s));

  static Future<CartRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CartRecord.fromSnapshot(s));

  static CartRecord fromSnapshot(DocumentSnapshot snapshot) => CartRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CartRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CartRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CartRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CartRecord && reference.path == other.reference.path;
}

Map<String, dynamic> createCartRecordData({
  DocumentReference? productRef,
  int? quantity,
  double? pricePerProduct,
  DocumentReference? farmRef,
  bool? isVariableWeight,
  double? minWeight,
  double? maxWeight,
  double? pricePerKg,
  double? depositAmount,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'productRef': productRef,
      'quantity': quantity,
      'price_per_product': pricePerProduct,
      'farm_ref': farmRef,
      'is_variable_weight': isVariableWeight,
      'min_weight': minWeight,
      'max_weight': maxWeight,
      'price_per_kg': pricePerKg,
      'deposit_amount': depositAmount,
    }.withoutNulls,
  );

  return firestoreData;
}

class CartRecordDocumentEquality implements Equality<CartRecord> {
  const CartRecordDocumentEquality();

  @override
  bool equals(CartRecord? e1, CartRecord? e2) {
    return e1?.productRef == e2?.productRef &&
        e1?.quantity == e2?.quantity &&
        e1?.pricePerProduct == e2?.pricePerProduct &&
        e1?.farmRef == e2?.farmRef &&
        e1?.isVariableWeight == e2?.isVariableWeight &&
        e1?.minWeight == e2?.minWeight &&
        e1?.maxWeight == e2?.maxWeight &&
        e1?.pricePerKg == e2?.pricePerKg &&
        e1?.depositAmount == e2?.depositAmount;
  }

  @override
  int hash(CartRecord? e) => const ListEquality().hash([
        e?.productRef,
        e?.quantity,
        e?.pricePerProduct,
        e?.farmRef,
        e?.isVariableWeight,
        e?.minWeight,
        e?.maxWeight,
        e?.pricePerKg,
        e?.depositAmount
      ]);

  @override
  bool isValidKey(Object? o) => o is CartRecord;
}
