// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopProductsChart extends StatefulWidget {
  const TopProductsChart({
    super.key,
    this.width,
    this.height,
    required this.products,
    this.orders,
    required this.currentlanguge,
  });

  final double? width;
  final double? height;
  final List<String> products;
  final List<OrderRecord>? orders;
  final String currentlanguge;

  @override
  State<TopProductsChart> createState() => _TopProductsChartState();
}

class _TopProductsChartState extends State<TopProductsChart> {
  late Future<List<ProductData>> _futureProductsData;
  final Map<String, String> _nameCache = {};

  String _norm(String s) => s.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _futureProductsData = _buildProductDataFromOrders();
  }

  String _t(String key) {
    final lang = widget.currentlanguge?.toLowerCase();

    if (lang == 'fr') {
      switch (key) {
        case 'topProductsPerformance':
          return 'Performance des meilleurs produits';
        case 'bestSellersThisMonth':
          return 'Meilleures ventes ce mois-ci';
      }
    }

    switch (key) {
      case 'topProductsPerformance':
        return 'Top Products Performance';
      case 'bestSellersThisMonth':
        return 'Best sellers this month';
      default:
        return key;
    }
  }

  Future<String?> _getProductNameFromRef(DocumentReference ref) async {
    final key = ref.path;

    if (_nameCache.containsKey(key)) {
      debugPrint('✅ (cache hit) productRef=$key name=${_nameCache[key]}');
      return _nameCache[key];
    }

    try {
      final snap = await ref.get();
      if (!snap.exists) {
        debugPrint('❌ productRef=$key doc NOT exists');
        return null;
      }

      final data = snap.data() as Map<String, dynamic>?;
      final rawName = data?['name'] ??
          data?['product_name'] ??
          data?['title'] ??
          data?['productName'];
      final name = rawName?.toString().trim();

      debugPrint('ℹ️ productRef=$key rawName=$rawName resolvedName=$name');

      if (name != null && name.isNotEmpty) {
        _nameCache[key] = name;
        return name;
      }
    } catch (e) {
      debugPrint('🔥 Error fetching product name for ref=$key => $e');
    }

    return null;
  }

  Future<List<ProductData>> _buildProductDataFromOrders() async {
    final orders = widget.orders ?? const <OrderRecord>[];

    debugPrint('==============================');
    debugPrint('📦 TopProductsChart Debug Start');
    debugPrint('Orders count: ${orders.length}');
    debugPrint('Incoming products list: ${widget.products}');
    debugPrint('==============================');

    final allowedMap = {
      for (final p in widget.products.where((e) => e.trim().isNotEmpty))
        _norm(p): p.trim(),
    };

    debugPrint('✅ Allowed normalized keys: ${allowedMap.keys.toList()}');

    final totalsByNormName = {
      for (final k in allowedMap.keys) k: 0.0,
    };

    for (int oi = 0; oi < orders.length; oi++) {
      final o = orders[oi];

      // ✅ your field: orderItems
      final items = o.orderItems ?? const <OrderItemsStruct>[];

      debugPrint('------------------------------');
      debugPrint('🧾 Order[$oi] itemsCount=${items.length}');
      debugPrint('Order id: ${o.reference.id}');
      debugPrint('------------------------------');

      for (int ii = 0; ii < items.length; ii++) {
        final it = items[ii];

        // ✅ your struct fields
        final ref = it.productRef;
        final qty = (it.totalItems ?? 0).toDouble();
        final price = (it.pricePerProduct ?? 0).toDouble();
        final lineTotal = qty * price;

        debugPrint(
          'Item[$ii] ref=${ref?.path} qty=$qty price=$price lineTotal=$lineTotal',
        );

        if (ref == null) continue;

        final fetchedName = await _getProductNameFromRef(ref);
        if (fetchedName == null) continue;

        final key = _norm(fetchedName);

        debugPrint(
          '🔎 Match check: fetchedName="$fetchedName" norm="$key" allowed=${totalsByNormName.containsKey(key)}',
        );

        if (totalsByNormName.containsKey(key)) {
          totalsByNormName[key] = (totalsByNormName[key] ?? 0.0) + lineTotal;
          debugPrint(
            '✅ Added: $lineTotal to "$fetchedName" => newTotal=${totalsByNormName[key]}',
          );
        }
      }
    }

    debugPrint('==============================');
    debugPrint('📊 Final totalsByNormName: $totalsByNormName');
    debugPrint('==============================');

    final result = widget.products.map((p) {
      final k = _norm(p);
      return ProductData(name: p.trim(), value: totalsByNormName[k] ?? 0.0);
    }).toList();

    debugPrint(
        '📈 Result list for chart: ${result.map((e) => "${e.name}:${e.value}").toList()}');
    debugPrint('✅ TopProductsChart Debug End');
    debugPrint('==============================');

    return result;
  }

  // ✅ Pick a clean Y-axis interval so labels look like 0,100,200,300...
  double _niceInterval(double maxY) {
    if (maxY <= 100) return 20;
    if (maxY <= 250) return 50;
    if (maxY <= 600) return 100;
    if (maxY <= 1200) return 200;
    if (maxY <= 3000) return 500;
    if (maxY <= 7000) return 1000;
    return 2000;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductData>>(
      future: _futureProductsData,
      builder: (context, snap) {
        final data = snap.data ??
            widget.products
                .map((e) => ProductData(name: e.trim(), value: 0.0))
                .toList();

        final maxVal = data.isEmpty
            ? 0.0
            : data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

        // keep headroom
        final maxY = (maxVal <= 0) ? 100.0 : (maxVal * 1.2);

        final interval = _niceInterval(maxY);

        debugPrint('📌 Chart maxVal=$maxVal maxY=$maxY interval=$interval');

        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E6EA), width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _t('topProductsPerformance'),
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _t('bestSellersThisMonth'),
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: BarChart(
                    _mainBarData(data, maxY, interval),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    const double barWidth = 22;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Color(0xFF3BB273), Color(0x003BB273)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  BarChartData _mainBarData(
      List<ProductData> productsData, double maxY, double interval) {
    return BarChartData(
      maxY: maxY,
      minY: 0,
      barGroups: productsData
          .asMap()
          .entries
          .map((entry) => _makeGroupData(entry.key, entry.value.value))
          .toList(),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, titleMeta) {
              const style = TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w400,
                fontSize: 10,
              );

              final i = value.toInt();
              String text = (i >= 0 && i < productsData.length)
                  ? productsData[i].name
                  : '';

              if (text.length > 5) {
                text = '${text.substring(0, 5)}..';
              }

              return SideTitleWidget(
                axisSide: titleMeta.axisSide, // ✅ REQUIRED
                space: 8,
                child: SizedBox(
                  width: 45,
                  child: Text(
                    text,
                    style: style,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ),

        // ✅ FIXED LEFT TITLES (shows 0,100,200,300...)
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            interval: interval, // ⭐️ THIS is the key fix
            getTitlesWidget: (value, meta) {
              // show only clean ticks (avoid decimals)
              final v = value.round();
              return Text(
                v.toString(),
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProductData {
  final String name;
  final double value;
  ProductData({required this.name, required this.value});
}
