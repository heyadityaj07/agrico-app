/// Transactional cleanup of the cart lines purchased by a finalized
/// checkout-v1 order.
///
/// The cleanup is intentionally idempotent and conservative:
///   * only the exact captured cart document IDs are considered;
///   * a line whose product/bracket changed is left alone;
///   * units added during checkout are preserved;
///   * other farms' cart lines are never touched;
///   * a missing document means the line was already cleared.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/cart_record.dart';

import 'checkout_v1_client.dart';

class CartClearReport {
  const CartClearReport({
    required this.deleted,
    required this.decremented,
    required this.skipped,
  });

  final int deleted;
  final int decremented;
  final int skipped;
}

Future<CartClearReport> clearPurchasedCartLines({
  required DocumentReference userRef,
  required Iterable<CapturedCartLine> purchasedLines,
  FirebaseFirestore? firestore,
}) async {
  final lines = normalizeCapturedCartLines(purchasedLines);
  if (lines.isEmpty) {
    return const CartClearReport(deleted: 0, decremented: 0, skipped: 0);
  }

  final db = firestore ?? FirebaseFirestore.instance;
  final cart = userRef.collection('cart');
  final references = <String, DocumentReference>{
    for (final line in lines)
      line.cartDocumentId: cart.doc(line.cartDocumentId),
  };

  return db.runTransaction<CartClearReport>((transaction) async {
    final snapshots = <String, DocumentSnapshot>{};
    for (final entry in references.entries) {
      snapshots[entry.key] = await transaction.get(entry.value);
    }

    final currentByDocumentId = <String, CartLineCurrentState?>{};
    for (final line in lines) {
      final snapshot = snapshots[line.cartDocumentId];
      if (snapshot == null || !snapshot.exists) {
        currentByDocumentId[line.cartDocumentId] = null;
        continue;
      }
      final cartRecord = CartRecord.fromSnapshot(snapshot);
      CheckoutWeightBracket? bracket;
      if (cartRecord.isVariableWeight == true) {
        try {
          bracket = CheckoutWeightBracket(
            minWeight: cartRecord.minWeight,
            maxWeight: cartRecord.maxWeight,
          );
        } on ArgumentError {
          // A corrupt/changed bracket no longer represents the purchased line.
          currentByDocumentId[line.cartDocumentId] = null;
          continue;
        }
      }
      currentByDocumentId[line.cartDocumentId] = CartLineCurrentState(
        cartDocumentId: line.cartDocumentId,
        productId: cartRecord.productRef?.id ?? '',
        farmId: cartRecord.farmRef?.id ?? '',
        quantity: cartRecord.quantity,
        weightBracket: bracket,
      );
    }

    final decisions = planCartClear(
      purchasedLines: lines,
      currentByDocumentId: currentByDocumentId,
    );
    final writes = buildCartClearWrites(
      decisions: decisions,
      currentByDocumentId: currentByDocumentId,
    );

    var deleted = 0;
    var decremented = 0;
    var skipped = 0;

    for (final write in writes) {
      final reference = references[write.cartDocumentId]!;
      switch (write.action) {
        case CartClearWriteAction.skip:
          skipped += 1;
          break;
        case CartClearWriteAction.delete:
          transaction.delete(reference);
          deleted += 1;
          break;
        case CartClearWriteAction.setQuantity:
          transaction.update(reference, <String, dynamic>{
            'quantity': write.quantity,
          });
          decremented += 1;
          break;
      }
    }

    return CartClearReport(
      deleted: deleted,
      decremented: decremented,
      skipped: skipped,
    );
  });
}
