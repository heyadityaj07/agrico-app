// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> updateOrderActualWeight(
  BuildContext context,
  String orderPath,
  String productPath,
  String weightText,
) async {
  final actualWeight = double.tryParse(weightText.trim());
  if (actualWeight == null || actualWeight <= 0) return false;

  final orderRef = FirebaseFirestore.instance.doc(orderPath);
  var updated = false;
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(orderRef);
    final data = snapshot.data() as Map<String, dynamic>?;
    final rawItems = data?['order_items'];
    if (rawItems is! List) return;

    final items = rawItems
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();
    final itemIndex = items.indexWhere((item) {
      final ref = item['product_ref'];
      return ref is DocumentReference && ref.path == productPath;
    });
    if (itemIndex < 0) return;

    items[itemIndex]['actual_weight'] = actualWeight;
    items[itemIndex]['weight_locked'] = true;
    final quantity = (items[itemIndex]['total_items'] as num?)?.toInt() ?? 1;
    final pricePerKg =
        (items[itemIndex]['price_per_kg'] as num?)?.toDouble() ?? 0;
    final deposit =
        (items[itemIndex]['deposit_amount'] as num?)?.toDouble() ?? 0;
    final finalPrice = actualWeight * pricePerKg * quantity;
    items[itemIndex]['final_item_price'] = finalPrice;
    items[itemIndex]['remaining_balance'] =
        (finalPrice - deposit * quantity).clamp(0, double.infinity);
    transaction.update(orderRef, {'order_items': items});
    updated = true;
  });

  return updated;
}
