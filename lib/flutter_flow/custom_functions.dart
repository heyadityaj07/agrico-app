import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/auth/firebase_auth/auth_util.dart';

List<String> productunit(String category) {
  Map<String, List<String>> categoryUnits = {
    'Fruits': [
      'kg',
      'g',
      'lbs',
      'oz',
      'Each',
      'Bunch',
      'Liters(L)',
      'mL',
    ],
    'Vegetables': [
      'kg',
      'g',
      'lbs',
      'oz',
      'Each',
      'Bunch',
      'Bag',
      'Meters(m)',
    ],
    'Meat': [
      'kg',
      'Grams (g)',
      'Pounds (lbs)',
      'Ounces (oz)',
      'Each',
      'Pack',
    ],
    'Milk': [
      'Liters(L)',
      'mL',
      'kg', // for powdered milk
      'Carton',
      'Bottle',
    ],
    'Grains': [
      'kg',
      'Grams(g)',
      'Pounds(lbs)',
      'Cups',
      'Bag',
      'Box',
    ],
  };

  // Return the corresponding unit list based on the category
  return categoryUnits[category] ?? [];
}

List<String> productbadges(String category) {
  final Map<String, List<String>> categoryBadges = {
    'Fruits': [
      'Organic',
      'Pesticide-Free',
      'Local Harvest',
      'Naturally Ripened',
      'Seasonal',
      'Farm Fresh',
    ],
    'Vegetables': [
      'Organic',
      'Pesticide-Free',
      'Local Harvest',
      'Seasonal',
      'Farm Fresh',
    ],
    'Meat': [
      'Organic',
      'Antibiotic-Free',
      'Hormone-Free',
      'Free-Range',
      'Grass-Fed',
      'Local Harvest',
      'Farm Fresh',
    ],
    'Milk': [
      'Organic',
      'Hormone-Free',
      'Grass-Fed',
      'Local Harvest',
      'Farm Fresh',
    ],
    'Grains': [
      'Organic',
      'Pesticide-Free',
      'Non-GMO',
      'Local Harvest',
      'Seasonal',
    ],
  };

  return categoryBadges[category] ??
      [
        'Organic',
        'Pesticide-Free',
        'Local Harvest',
        'Seasonal',
        'Farm Fresh',
      ];
}

List<String> storageTypeByProductType(String productType) {
  Map<String, List<String>> storageMap = {
    'Fruits': [
      'Fresh',
      'Chilled',
      'Ripened',
      'Stored',
    ],
    'Vegetables': [
      'Fresh',
      'Chilled',
      'Dry Stored',
    ],
    'Meat': [
      'Fresh',
      'Frozen',
    ],
    'Milk': [
      'Fresh',
      'Chilled',
    ],
    'Grains': [
      'Fresh'
          'Dry',
      'Stored',
    ],
  };

  return storageMap[productType] ?? ['Fresh'];
}

String dayrenge(List<String>? days) {
  if (days == null || days.isEmpty) return "";

  const order = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  String fmt(String d) => d[0] + d.substring(1).toLowerCase();

  final set = days.map((e) => e.trim().toUpperCase()).toSet();

  final pickedIdx = <int>[];
  for (int i = 0; i < order.length; i++) {
    if (set.contains(order[i])) pickedIdx.add(i);
  }
  if (pickedIdx.isEmpty) return "";

  final ranges = <String>[];
  final notAvailable = <String>[];

  int start = pickedIdx[0];
  int prev = pickedIdx[0];

  void closeRange(int s, int e) {
    ranges.add(s == e ? fmt(order[s]) : "${fmt(order[s])}-${fmt(order[e])}");
  }

  for (int k = 1; k < pickedIdx.length; k++) {
    final cur = pickedIdx[k];

    if (cur == prev + 1) {
      prev = cur;
      continue;
    }

    // gap => missing days
    for (int miss = prev + 1; miss < cur; miss++) {
      notAvailable.add(fmt(order[miss]));
    }

    closeRange(start, prev);
    start = cur;
    prev = cur;
  }
  closeRange(start, prev);

  final rangeText = ranges.join(", ");
  if (notAvailable.isEmpty) return rangeText;

  return "$rangeText (Not Available: ${notAvailable.join(", ")})";
}

List<DeliveryAdressStruct> deliveryaddresssorting(
  List<DeliveryAdressStruct>? delievryaddress,
  int? defultindex,
) {
  if (delievryaddress == null || delievryaddress.isEmpty) return [];

  final list = List<DeliveryAdressStruct>.from(delievryaddress);

  final idx = defultindex;
  if (idx == null || idx < 0 || idx >= list.length) return list;

  final defaultItem = list.removeAt(idx);
  list.insert(0, defaultItem);

  print("defaultIndex = $idx");
  print("sorted labels = ${list.map((e) => e.label).toList()}");

  return list;
}

List<String> farminglist(List<FarmsRecord>? farmsmethods) {
  if (farmsmethods == null || farmsmethods.isEmpty) return [];

  final seen = <String>{};
  final result = <String>[];

  for (final doc in farmsmethods) {
    final methods = doc.farmingMethod ?? []; // List<String>

    for (final m in methods) {
      final v = m.trim();
      if (v.isEmpty) continue;
      if (seen.add(v)) result.add(v); // unique + keeps order
    }
  }

  return result;
}

List<String> tagslist(List<ProductRecord>? products) {
  if (products == null || products.isEmpty) return [];

  final seen = <String>{};
  final result = <String>[];

  for (final doc in products) {
    final methods = doc.badges ?? []; // List<String>

    for (final m in methods) {
      final v = m.trim();
      if (v.isEmpty) continue;
      if (seen.add(v)) result.add(v); // unique + keeps order
    }
  }

  return result;
}

String currentSeason() {
  final month = DateTime.now().month;

  if (month == 12 || month <= 2) return 'Winter';
  if (month >= 3 && month <= 5) return 'Summer';
  if (month >= 6 && month <= 9) return 'Monsoon';
  return 'Autumn';
}

double cartTotal(List<CartRecord> cart) {
  double total = 0.0;
  for (final item in cart) {
    total += (item.quantity) * (item.pricePerProduct);
  }
  return total;
}

double ordertotal(List<OrderItemsStruct> orderitems) {
  double total = 0.0;
  for (final item in orderitems) {
    final itemAmount =
        item.isVariableWeight ? item.depositAmount : item.pricePerProduct;
    total += itemAmount * item.totalItems;
  }
  return total;
}

List<ProductRecord>? nearProductsfunction(
  List<ProductRecord>? products,
  LatLng? currentlocation,
) {
  if (products == null || products.isEmpty) return [];
  if (currentlocation == null) return [];

  double deg2rad(double deg) => deg * (math.pi / 180.0);

  double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = deg2rad(lat2 - lat1);
    final dLng = deg2rad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  final out = <ProductRecord>[];

  for (final p in products) {
    final farmLoc = p.farmLocation;
    if (farmLoc == null) continue;

    final km = distanceKm(
      currentlocation.latitude,
      currentlocation.longitude,
      farmLoc.latitude,
      farmLoc.longitude,
    );

    if (km <= 2.0) out.add(p);
  }

  return out;
}

bool locationcheck(LatLng? location) {
  if (location != null &&
      location.latitude == 0.0 &&
      location.longitude == 0.0) {
    return true; // [0° N, 0° E] location
  }
  return false;
}

double totalRevnue(List<double>? totalammount) {
  final sum = (totalammount ?? [])
      .where((e) => e.isFinite)
      .fold<double>(0.0, (acc, e) => acc + e);

  return double.parse(sum.toStringAsFixed(2));
}

double avargeRating(List<double>? ratings) {
  final list = (ratings ?? []).where((e) => e.isFinite).toList();
  if (list.isEmpty) return 0.0;

  final avg = list.fold(0.0, (s, e) => s + e) / list.length;
  return double.parse(avg.toStringAsFixed(2)); // 2 decimals
}

double repeatCustomerPercent(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  // ✅ change this getter according to your OrderRecord field
  DocumentReference? getUserRef(OrderRecord o) => o.userRef; // or o.buyerRef

  final Map<String, int> counts = {};

  for (final o in list) {
    final ref = getUserRef(o);
    if (ref == null) continue;
    counts[ref.path] = (counts[ref.path] ?? 0) + 1;
  }

  if (counts.isEmpty) return 0.0;

  final totalUniqueCustomers = counts.length;
  final repeatCustomers = counts.values.where((c) => c >= 2).length;

  final pct = (repeatCustomers / totalUniqueCustomers) * 100;
  return double.parse(pct.toStringAsFixed(0));
}

double onTimeDeliveryRatePercent(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  int deliveredCount = 0;
  int onTimeCount = 0;

  int promisedDays(String? deliveryTime) {
    final v = (deliveryTime ?? '').trim().toLowerCase();
    if (v == 'tomorrow') return 1;
    if (v == 'day after tomorrow' || v == 'day after tommorow') return 2;
    return 0;
  }

  DateTime endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  for (final o in list) {
    final DateTime? createdAt = o.createdAt;
    final String? deliveryTime = o.delievryTime;

    final DateTime? deliveredAt = o.deliveredTime;

    if (createdAt == null || deliveredAt == null) continue;

    deliveredCount++;

    final days = promisedDays(deliveryTime);

    final createdDateOnly =
        DateTime(createdAt.year, createdAt.month, createdAt.day);
    final promisedDate = createdDateOnly.add(Duration(days: days));
    final deadline = endOfDay(promisedDate);

    if (!deliveredAt.isAfter(deadline)) {
      onTimeCount++;
    }
  }

  if (deliveredCount == 0) return 0.0;

  final pct = (onTimeCount / deliveredCount) * 100;
  return double.parse(pct.toStringAsFixed(0));
}

double avgOrderValue(List<OrderRecord>? orders) {
  final list = orders ?? const <OrderRecord>[];
  if (list.isEmpty) return 0.0;

  double totalRevenue = 0.0;
  int count = 0;

  for (final o in list) {
    // ✅ replace with your order total field
    final amt = (o.totalAmmount ?? 0).toDouble();

    // if you want to ignore 0 amount orders, keep this check
    if (amt <= 0) continue;

    totalRevenue += amt;
    count++;
  }

  if (count == 0) return 0.0;

  final aov = totalRevenue / count;
  return double.parse(aov.toStringAsFixed(2)); // 2 decimals
}

double totalsales(List<CartRecord>? cart) {
  // if (totalammount == null) return 0.0; // Return 0 if the list is null
  // return totalammount
  //     .where((amount) => amount != null)
  //     .fold(0.0, (sum, amount) => sum + amount);
  if (cart == null || cart.isEmpty) return 0.0;

  return cart.fold(0.0, (sum, item) {
    final quantity = item.quantity ?? 0;
    final itemAmount = item.isVariableWeight
        ? (item.depositAmount ?? 0) * quantity
        : (item.pricePerProduct ?? 0) * quantity;
    return sum + itemAmount;
  });
}

List<dynamic> convertCartItemsToOrderItems(List<CartRecord> cart) {
  Map<DocumentReference, double> farmAmountMap = {};

  for (var item in cart) {
    if (item.farmRef == null) continue;

    final double itemTotal = (item.quantity ?? 0) * (item.pricePerProduct ?? 0);

    if (farmAmountMap.containsKey(item.farmRef)) {
      farmAmountMap[item.farmRef!] = farmAmountMap[item.farmRef!]! + itemTotal;
    } else {
      farmAmountMap[item.farmRef!] = itemTotal;
    }
  }

  /// Convert to JSON list
  List<dynamic> result = [];

  farmAmountMap.forEach((farmRef, amount) {
    result.add({
      "id": farmRef.id,
      "amount": double.parse(amount.toStringAsFixed(2)),
    });
  });

  return result;
}

double newCustomFunction(List<dynamic>? value) {
  double totalAmount = value?.fold<double>(
        0.0,
        (sum, item) => sum + ((item['amount'] as num?)?.toDouble() ?? 0.0),
      ) ??
      0.0;

  return totalAmount;
}

String greeting(String languageCode) {
  final hour = DateTime.now().hour;
  String timeOfDay;

  if (hour < 12) {
    timeOfDay = 'Good morning';
  } else if (hour < 18) {
    timeOfDay = 'Good afternoon';
  } else {
    timeOfDay = 'Good evening';
  }

  // Map translations based on language code
  switch (languageCode) {
    case 'es': // Spanish
      if (timeOfDay == 'Good morning') return '¡Buen día!';
      if (timeOfDay == 'Good afternoon') return '¡Buenas tardes!';
      return '¡Buenas noches!';
    case 'fr': // French
      if (timeOfDay == 'Good morning') return 'Bonjour';
      if (timeOfDay == 'Good afternoon') return 'Bon après-midi';
      return 'Bonne soirée';
    default: // Default to English
      if (timeOfDay == 'Good morning') return 'Good Morning';
      if (timeOfDay == 'Good afternoon') return 'Good Afternoon';
      return 'Good Evening';
  }
}

bool checkavaliblity(List<FarmAvailabilityStruct> avaiblity) {
  if (avaiblity.isEmpty) {
    return false;
  }
  int timeInMinutes(DateTime time) {
    return (time.hour * 60) + time.minute;
  }

  bool hasAtLeastOneAvailable = false;

  for (var dayEntry in avaiblity) {
    if (dayEntry.isAvavible == true) {
      if (dayEntry.startTime == null || dayEntry.endtime == null) {
        return false;
      }

      if (dayEntry.isBreak == true) {
        final DateTime? breakStart = dayEntry.breakStart;
        final DateTime? breakEnd = dayEntry.breakEnd;

        if (breakStart == null || breakEnd == null) {
          return false;
        }

        final int breakStartMinutes = timeInMinutes(breakStart);
        final int breakEndMinutes = timeInMinutes(breakEnd);
        final int startMinutes = timeInMinutes(dayEntry.startTime!);
        final int endMinutes = timeInMinutes(dayEntry.endtime!);

        if (breakEndMinutes <= breakStartMinutes) {
          return false;
        }

        if (breakStartMinutes < startMinutes) {
          return false;
        }

        if (breakEndMinutes > endMinutes) {
          return false;
        }
      }

      hasAtLeastOneAvailable = true;
    }
  }

  return hasAtLeastOneAvailable;
}

String checkavaliblitymsg(List<FarmAvailabilityStruct> avaiblity) {
  // 1. Check if the list itself is empty
  if (avaiblity.isEmpty) {
    return "Please select at least one day of availability.";
  }
  int timeInMinutes(DateTime time) {
    return (time.hour * 60) + time.minute;
  }

  bool hasAtLeastOneAvailable = false;

  for (var dayEntry in avaiblity) {
    // Check the toggle status
    if (dayEntry.isAvavible == true) {
      // 2. If toggled ON, check if either time is missing
      if (dayEntry.startTime == null || dayEntry.endtime == null) {
        // Returns a specific error mentioning the day (e.g., "Set time for Monday")
        return "Please set start and end times for ${dayEntry.day}.";
      }
      if (dayEntry.isBreak == true) {
        final DateTime? breakStart = dayEntry.breakStart;
        final DateTime? breakEnd = dayEntry.breakEnd;

        if (breakStart == null || breakEnd == null) {
          return "Please set break start and end times for  ${dayEntry.day}.";
        }

        final int breakStartMinutes = timeInMinutes(breakStart);
        final int breakEndMinutes = timeInMinutes(breakEnd);
        final int startMinutes = timeInMinutes(dayEntry.startTime!);
        final int endMinutes = timeInMinutes(dayEntry.endtime!);

        if (breakEndMinutes <= breakStartMinutes) {
          return "Break end time must be after break start time for ${dayEntry.day}.";
        }

        if (breakStartMinutes < startMinutes) {
          return "Break start time must be within working hours for ${dayEntry.day}.";
        }

        if (breakEndMinutes > endMinutes) {
          return "Break end time must be within working hours for ${dayEntry.day}.";
        }
      }
      hasAtLeastOneAvailable = true;
    }
  }

  // 3. Final check: If no days were toggled ON at all
  if (!hasAtLeastOneAvailable) {
    return "Please select at least one day to be available.";
  }

  // 4. Everything is correct, return an empty string
  return "";
}

const double defaultPlatformFeeRate = 0.0099;
const double defaultPlatformFeeCap = 3.0;

double resolvePlatformFeeRate(double? configuredRate) {
  if (configuredRate == null ||
      !configuredRate.isFinite ||
      configuredRate < 0 ||
      configuredRate > 1) {
    return defaultPlatformFeeRate;
  }
  return configuredRate;
}

double resolvePlatformFeeCap(double? configuredCap) {
  if (configuredCap == null || !configuredCap.isFinite || configuredCap < 0) {
    return defaultPlatformFeeCap;
  }
  return configuredCap;
}

double platformFeeAmount(
  double productOrderValue,
  double? configuredRate,
  double? configuredCap,
) {
  if (!productOrderValue.isFinite || productOrderValue < 0) return 0.0;
  final rate = resolvePlatformFeeRate(configuredRate);
  final cap = resolvePlatformFeeCap(configuredCap);
  final rawFee = productOrderValue * rate;
  final cappedFee = rawFee > cap ? cap : rawFee;
  return (cappedFee * 100).round() / 100;
}

String? platformfees(
  double? totalamount,
  double? platformfee, [
  double? platformfeeCap,
]) {
  if (totalamount == null) return null;
  final fee = platformFeeAmount(totalamount, platformfee, platformfeeCap);
  return fee.toStringAsFixed(2);
}

double? newCustomFunction2(
  double? totalamount,
  double? platformfee, [
  double? platformfeeCap,
]) {
  if (totalamount == null) return null;
  final fee = platformFeeAmount(totalamount, platformfee, platformfeeCap);
  return totalamount + fee;
}

String formatDateTimeString(String input) {
  try {
    final secondsMatch = RegExp(r'seconds=(\d+)').firstMatch(input);
    final nanosecondsMatch = RegExp(r'nanoseconds=(\d+)').firstMatch(input);

    if (secondsMatch == null || nanosecondsMatch == null) {
      return 'Invalid timestamp format';
    }

    final seconds = int.parse(secondsMatch.group(1)!);
    final nanoseconds = int.parse(nanosecondsMatch.group(1)!);

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + (nanoseconds ~/ 1000000),
    );

    // Format: "10 May 2025, 17:41"
    return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
  } catch (e) {
    return 'Error formatting timestamp';
  }
}

bool isbeforeTime(
  DateTime? userTime,
  DateTime messageTime,
) {
  if (userTime == null) {
    return false;
  }
  return userTime.isBefore(messageTime);
}

bool isbesinnesTime(
  DateTime? startTime,
  DateTime? endTime,
) {
  if (startTime == null || endTime == null) {
    return false;
  }
  return startTime.isBefore(endTime);
}

String rootPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Root Plan';
  // }

  // if (plan == 'root_plan' || plan == 'root_plan_yearly') {
  //   return 'Current Plan';
  // }

  // if (plan == 'harvest_plan' ||
  //     plan == 'harvest_plan_yearly' ||
  //     plan == 'flavour_plan' ||
  //     plan == 'flavour_plan_yearly') {
  //   return 'Downgrade to Root';
  // }

  // return 'Upgrade to Root';
  //
  String t(String en, String fr) {
    switch (lancode) {
      case 'fr':
        return fr;
      case 'en':
      default:
        return en;
    }
  }

  if (isActive != true) {
    return t('Upgrade to Root', 'Passer au forfait Racine');
  }

  if ((isYearly && plan == 'root_plan_yearly') ||
      (!isYearly && plan == 'root_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  if (plan == 'harvest_plan' ||
      plan == 'harvest_plan_yearly' ||
      plan == 'flavour_plan' ||
      plan == 'flavour_plan_yearly') {
    return t('Downgrade to Root', 'Passer au forfait Racine');
  }

  return t('Upgrade to Root', 'Passer au forfait Racine');
}

String harvestPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Harvest Plan';
  // }

  // if (plan == 'harvest_plan' || plan == 'harvest_plan_yearly') {
  //   return 'Current Plan';
  // }

  // if (plan == 'root_plan' || plan == 'root_plan_yearly') {
  //   return 'Upgrade to Harvest';
  // }

  // if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
  //   return 'Downgrade to Harvest';
  // }

  // return 'Upgrade to Harvest';
  String t(String en, String fr) {
    switch (lancode) {
      case 'fr':
        return fr;
      case 'en':
      default:
        return en;
    }
  }

  if (isActive != true) {
    return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
  }

  if ((isYearly && plan == 'harvest_plan_yearly') ||
      (!isYearly && plan == 'harvest_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  if (plan == 'root_plan' || plan == 'root_plan_yearly') {
    return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
  }

  if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
    return t('Downgrade to Harvest', 'Passer au forfait Harvest');
  }

  return t('Upgrade to Harvest', 'Passer au forfait Harvest supérieur');
}

String flavourPlanButton(
  String? plan,
  bool isActive,
  String lancode,
  bool isYearly,
) {
  // if (isActive != true) {
  //   return 'Flavour Plan';
  // }

  // if (plan == 'flavour_plan' || plan == 'flavour_plan_yearly') {
  //   return 'Current Plan';
  // }

  // return 'Upgrade to Flavour';
  String t(String en, String fr) {
    switch (lancode) {
      case 'fr':
        return fr;
      case 'en':
      default:
        return en;
    }
  }

  if (isActive != true) {
    return t('Upgrade to Flavour', 'Passer au forfait Flavour supérieur');
  }

  if ((isYearly && plan == 'flavour_plan_yearly') ||
      (!isYearly && plan == 'flavour_plan')) {
    return t('Current Plan', 'Forfait actuel');
  }

  return t('Upgrade to Flavour', 'Passer au forfait Flavour supérieur');
}

double topProductScore(
  int sold,
  int maxSold,
  int stockQuantity,
  int maxStockQuantity,
  int discount,
  DateTime? createdAt,
) {
  final soldScore = maxSold > 0 ? sold / maxSold : 0.0;
  final stockScore =
      maxStockQuantity > 0 ? stockQuantity / maxStockQuantity : 0.0;
  final discountScore = discount.clamp(0, 100) / 100.0;

  double freshnessScore = 0.0;
  if (createdAt != null) {
    final ageDays = DateTime.now().difference(createdAt).inDays;
    freshnessScore = ((30 - ageDays).clamp(0, 30)) / 30.0;
  }

  final score = (soldScore * 0.45) +
      (stockScore * 0.15) +
      (discountScore * 0.10) +
      (freshnessScore * 0.10);

  return double.parse((score * 100).toStringAsFixed(2));
}

bool hasAnySelectedTag(
  List<String>? productTags,
  List<String>? selectedTags,
) {
  if (selectedTags == null || selectedTags.isEmpty) {
    return true;
  }

  final productSet =
      (productTags ?? []).map((tag) => tag.trim().toLowerCase()).toSet();

  return selectedTags.any(
    (tag) => productSet.contains(tag.trim().toLowerCase()),
  );
}

bool showInvoiceLink(DateTime? periodStart) {
  if (periodStart == null) {
    return false;
  }
  return DateTime.now().difference(periodStart).inDays <= 10;
}

double cartPlatformFee(
  double fullPrice,
  double? platformfee, [
  double? platformfeeCap,
]) {
  return platformFeeAmount(fullPrice, platformfee, platformfeeCap);
}

double checkoutPaymentTotal(
  double depositTotal,
  double deliveryFee,
  double serviceFee,
) {
  return depositTotal + deliveryFee + serviceFee;
}

double cartWeightDepositTotal(
  double depositAmount,
  int quantity,
) {
  return depositAmount * quantity;
}

bool isWeightOutsideRange(
  String weightText,
  double minWeight,
  double maxWeight,
) {
  final weight = double.tryParse(weightText.trim());
  return weight == null || weight < minWeight || weight > maxWeight;
}

double totalOrderBalance(List<OrderItemsStruct> orderitems) {
  return orderitems.fold<double>(
    0,
    (total, item) =>
        total + (item.isVariableWeight ? item.remainingBalance : 0),
  );
}

double orderTotalWithBalance(
  List<OrderItemsStruct> orderitems,
  double currentTotal,
) {
  return currentTotal + totalOrderBalance(orderitems);
}
