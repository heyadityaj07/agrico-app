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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'index.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.day, this.sales);
  final String day;
  final double sales;
}

class SalesEvolutionChartWidget extends StatefulWidget {
  const SalesEvolutionChartWidget({
    super.key,
    this.width,
    this.height,
    required this.order,
    required this.currentlanguge,
  });

  final double? width;
  final double? height;
  final List<OrderRecord> order;
  final String currentlanguge;

  @override
  State<SalesEvolutionChartWidget> createState() =>
      _SalesEvolutionChartWidgetState();
}

class _SalesEvolutionChartWidgetState extends State<SalesEvolutionChartWidget> {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  DateTime _startOfWeek(DateTime d) {
    final local = DateTime(d.year, d.month, d.day);
    return local.subtract(Duration(days: local.weekday - DateTime.monday));
  }

  DateTime _endOfWeek(DateTime d) =>
      _startOfWeek(d).add(const Duration(days: 7));
  String _t(String key) {
    final lang = widget.currentlanguge?.toLowerCase();

    if (lang == 'fr') {
      switch (key) {
        case 'salesEvolution':
          return 'Évolution des ventes';
        case 'currentWeek':
          return 'Semaine en cours (lun.–dim.)';
      }
    }

    switch (key) {
      case 'salesEvolution':
        return 'Sales Evolution';
      case 'currentWeek':
        return 'Current week (Mon–Sun)';
      default:
        return key;
    }
  }

  List<SalesData> _buildWeeklySalesData(List<OrderRecord> orders) {
    final now = DateTime.now();
    final start = _startOfWeek(now);
    final end = _endOfWeek(now);

    // Mon..Sun totals
    final totals = List<double>.filled(7, 0.0);

    for (final o in orders) {
      // ✅ Replace these 2 lines with your exact field names:
      final DateTime? created = o.createdAt; // e.g. o.createdAt / o.createdTime
      final double amount =
          (o.totalAmmount ?? 0).toDouble(); // e.g. o.totalAmmount

      if (created == null) continue;

      final cd = DateTime(created.year, created.month, created.day);
      if (cd.isBefore(start) || !cd.isBefore(end)) continue;

      final idx = cd.weekday - DateTime.monday; // Mon=0..Sun=6
      if (idx >= 0 && idx < 7) totals[idx] += amount;
    }

    return List.generate(7, (i) => SalesData(_days[i], totals[i]));
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _buildWeeklySalesData(widget.order);

    // --- SAME UI COLORS ---
    const Color lineColor = Color(0xFF3BB273);
    const Color peakLabelBg = Color(0xFF3BB273);

    final List<Color> gradientColors = <Color>[
      lineColor.withOpacity(0.4),
      lineColor.withOpacity(0.0),
    ];
    final List<double> stops = <double>[0.0, 1.0];

    // Peak (max) index
    double maxVal = -1;
    int peakIndex = -1;
    for (int i = 0; i < chartData.length; i++) {
      if (chartData[i].sales > maxVal) {
        maxVal = chartData[i].sales;
        peakIndex = i;
      }
    }

    // Dynamic max Y (nice chart scaling)
    final double yMax = (maxVal <= 0) ? 100 : (maxVal * 1.2);
    final double interval = (yMax / 5).ceilToDouble(); // approx 5 steps

    return Container(
      width: widget.width ?? 350,
      height: widget.height ?? 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E6EA)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(
              _t('salesEvolution'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              _t('currentWeek'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelPlacement: LabelPlacement.onTicks,
                  isVisible: true,
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 12),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: yMax,
                  interval: interval <= 0 ? 20 : interval,
                  majorTickLines: const MajorTickLines(size: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 12),
                  majorGridLines:
                      const MajorGridLines(color: Colors.transparent),
                ),
                series: <CartesianSeries<SalesData, String>>[
                  SplineAreaSeries<SalesData, String>(
                    dataSource: chartData,
                    xValueMapper: (SalesData s, _) => s.day,
                    yValueMapper: (SalesData s, _) => s.sales,
                    borderColor: lineColor,
                    borderWidth: 2,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: 0.5,
                    gradient: LinearGradient(
                      colors: gradientColors,
                      stops: stops,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    markerSettings: const MarkerSettings(isVisible: false),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      builder: (data, point, series, pointIndex, seriesIndex) {
                        if (pointIndex == peakIndex && data.sales > 0) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: peakLabelBg,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Text(
                              data.sales.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
