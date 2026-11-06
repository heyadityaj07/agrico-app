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

Future<List<dynamic>> manageproductlist(
    List<CartRecord>? cart, String? deliveryfees) async {
  // Add your function code here!
  Map<DocumentReference, double> farmAmountMap = {};

  // 1️⃣ Group amount by farmRef
  for (var item in cart ?? []) {
    if (item.farmRef == null) continue;

    final double itemAmount = item.isVariableWeight == true
        ? (item.depositAmount ?? 0)
        : (item.pricePerProduct ?? 0);
    final double itemTotal = (item.quantity ?? 0) * itemAmount;

    farmAmountMap[item.farmRef!] =
        (farmAmountMap[item.farmRef] ?? 0) + itemTotal;
  }

  // 2️⃣ Fetch farm documents and build result
  List<dynamic> result = [];

  for (final entry in farmAmountMap.entries) {
    final DocumentReference farmRef = entry.key;
    final double amount = entry.value;

    final farmSnapshot = await farmRef.get();

    if (!farmSnapshot.exists) continue;

    final farmData = farmSnapshot.data() as Map<String, dynamic>;

    // result.add({
    //   "farm_ref": farmRef,
    //   "farm_user_ref": farmData['user_ref'], // farmer owner
    //   "farm_name": farmData['farm_name'], // if exists
    //   "amount": double.parse(amount.toStringAsFixed(2)),
    // });

    result.add({
      "id": farmData['user_ref'].id,
      "amount": double.parse(amount.toStringAsFixed(2)) +
          double.parse(deliveryfees ?? '0'),
    });
  }

  return result;
}
