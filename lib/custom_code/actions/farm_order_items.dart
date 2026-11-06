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

Future<List<OrderDataStruct>> farmOrderItems(List<CartRecord> cart) async {
  // Add your function code here!
  // 1. Group items in a Map: { FarmRef: [OrderItemsStruct, ...] }
// 1. Create a Map to group items by Farm Reference
  // Key: Farm DocumentReference, Value: List of OrderItemsStruct
  Map<DocumentReference, List<OrderItemsStruct>> groupedOrders = {};

  for (var item in cart) {
    // skip if farm reference is missing
    if (item.farmRef == null) continue;

    // 2. Create the internal OrderItemsStruct for this specific cart item
    OrderItemsStruct orderItem = OrderItemsStruct(
        productRef: item.productRef,
        totalItems: item.quantity,
        pricePerProduct: item.pricePerProduct,
        isVariableWeight: item.isVariableWeight,
        minWeight: item.minWeight,
        maxWeight: item.maxWeight,
        pricePerKg: item.pricePerKg,
        depositAmount: item.depositAmount);

    // 3. Add to the map
    if (groupedOrders.containsKey(item.farmRef)) {
      groupedOrders[item.farmRef]!.add(orderItem);
    } else {
      groupedOrders[item.farmRef!] = [orderItem];
    }
  }

  // 4. Convert the Map into a List of OrderDataStruct
  List<OrderDataStruct> finalOrders = [];

  groupedOrders.forEach((farmRef, itemsList) {
    finalOrders.add(OrderDataStruct(
      farmRef: farmRef,
      cartItems: itemsList,
    ));
  });

  return finalOrders;
}
