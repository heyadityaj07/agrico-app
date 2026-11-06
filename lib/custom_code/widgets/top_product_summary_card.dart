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

import 'index.dart'; // Imports other custom widgets
import 'package:cloud_firestore/cloud_firestore.dart';

// class TopProductSummaryCard extends StatefulWidget {
//   const TopProductSummaryCard({
//     super.key,
//     this.width,
//     this.height,
//     this.orders,
//     this.currentlanguge,
//   });

//   final double? width;
//   final double? height;
//   final List<OrderRecord>? orders;
//   final String? currentlanguge;

//   @override
//   State<TopProductSummaryCard> createState() => _TopProductSummaryCardState();
// }

// class _TopProductSummaryCardState extends State<TopProductSummaryCard> {
//   final Map<String, String> _nameCache = {};
//   final Map<String, double> _ratingCache = {};

//   Future<String?> _getProductName(DocumentReference ref) async {
//     final key = ref.path;
//     if (_nameCache.containsKey(key)) return _nameCache[key];

//     try {
//       final snap = await ref.get();
//       if (!snap.exists) return null;

//       final data = snap.data() as Map<String, dynamic>?;

//       final name = (data?['name'] ??
//               data?['product_name'] ??
//               data?['title'] ??
//               data?['productName'])
//           ?.toString()
//           .trim();

//       if (name != null && name.isNotEmpty) {
//         _nameCache[key] = name;
//         return name;
//       }
//     } catch (_) {}

//     return null;
//   }

//   Future<double> _getProductRating(DocumentReference ref) async {
//     final key = ref.path;
//     if (_ratingCache.containsKey(key)) return _ratingCache[key]!;

//     try {
//       final snap = await ref.get();
//       if (!snap.exists) return 0.0;

//       final data = snap.data() as Map<String, dynamic>?;

//       final raw = data?['rating'] ??
//           data?['avgRating'] ??
//           data?['ratingAvg'] ??
//           data?['average_rating'];

//       final rating = (raw is num)
//           ? raw.toDouble()
//           : (double.tryParse(raw?.toString() ?? '') ?? 0.0);

//       _ratingCache[key] = rating;
//       return rating;
//     } catch (_) {
//       return 0.0;
//     }
//   }

//   String _text(String key) {
//     final lang = widget.currentlanguge?.toLowerCase();

//     if (lang == 'fr') {
//       switch (key) {
//         case 'bestSellingProduct':
//           return 'Produit le plus vendu';
//         case 'unitsSold':
//           return 'Unités vendues';
//         case 'revenue':
//           return 'Revenu';
//         case 'rating':
//           return 'Note';
//         case 'topProduct':
//           return 'Meilleur produit';
//       }
//     }

//     switch (key) {
//       case 'bestSellingProduct':
//         return 'Best Selling Product';
//       case 'unitsSold':
//         return 'Units Sold';
//       case 'revenue':
//         return 'Revenue';
//       case 'rating':
//         return 'Rating';
//       case 'topProduct':
//         return 'Top Product';
//       default:
//         return key;
//     }
//   }

//   // Modified to return structured details instead of a single string
//   _MoneyDisplay _formatMoney(double v, String? lang) {
//     String symbol = '\$';
//     double rate = 1.0;
//     final normalizedLang = lang?.toLowerCase();

//     if (normalizedLang == 'fr') {
//       symbol = '€';
//       rate = 0.92;
//     } else if (normalizedLang == 'hi') {
//       symbol = '₹';
//       rate = 83.0;
//     } else if (normalizedLang == 'en') {
//       symbol = '\$';
//       rate = 1.0;
//     }

//     final convertedValue = v * rate;
//     String formattedValue;

//     if (convertedValue >= 1000000) {
//       formattedValue = '${(convertedValue / 1000000).toStringAsFixed(1)}M';
//     } else if (convertedValue >= 1000) {
//       formattedValue = '${(convertedValue / 1000).toStringAsFixed(1)}K';
//     } else {
//       formattedValue = convertedValue.toStringAsFixed(2);
//     }

//     return _MoneyDisplay(
//       value: formattedValue,
//       symbol: symbol,
//       isTrailingSymbol:
//           normalizedLang == 'fr', // target rule for French notation
//     );
//   }

//   String _formatUnits(double v) => v.toStringAsFixed(0);

//   Future<_TopProductResult?> _computeTopProduct() async {
//     final orders = widget.orders ?? const <OrderRecord>[];
//     if (orders.isEmpty) return null;

//     final Map<String, _Agg> agg = {};

//     for (final o in orders) {
//       final items = o.orderItems ?? const <OrderItemsStruct>[];

//       for (final it in items) {
//         final ref = it.productRef;
//         final qty = (it.totalItems ?? 0).toDouble();
//         final price = (it.pricePerProduct ?? 0).toDouble();

//         if (ref == null) continue;

//         final key = ref.path;
//         final revenue = qty * price;

//         final a = agg[key] ?? _Agg(ref: ref);
//         a.units += qty;
//         a.revenue += revenue;
//         agg[key] = a;
//       }
//     }

//     if (agg.isEmpty) return null;

//     _Agg best = agg.values.first;
//     for (final a in agg.values) {
//       if (a.revenue > best.revenue ||
//           (a.revenue == best.revenue && a.units > best.units)) {
//         best = a;
//       }
//     }

//     final name = await _getProductName(best.ref) ?? 'Top Product';
//     final rating = await _getProductRating(best.ref);

//     return _TopProductResult(
//       name: name,
//       units: best.units,
//       revenue: best.revenue,
//       rating: rating,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<_TopProductResult?>(
//       future: _computeTopProduct(),
//       builder: (context, snap) {
//         final res = snap.data;
//         final loading = snap.connectionState != ConnectionState.done;

//         // Calculate the currency details explicitly for rendering
//         final moneyDisplay =
//             _formatMoney(res?.revenue ?? 0, widget.currentlanguge);

//         return Container(
//           width: widget.width ?? double.infinity,
//           height: widget.height ?? 120,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF194C31), Color(0xFF3BB273)],
//               stops: [0.0, 1.0],
//               begin: AlignmentDirectional(1.0, 0.0),
//               end: AlignmentDirectional(-1.0, 0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.10),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             child: loading
//                 ? const Center(
//                     child: SizedBox(
//                       height: 18,
//                       width: 18,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 28,
//                             height: 28,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFFC542),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(Icons.star,
//                                 color: Colors.white, size: 18),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   res?.name ?? '—',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14.5,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   _text('bestSellingProduct'),
//                                   style: const TextStyle(
//                                     color: Color(0xFFE7F6EF),
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                           height: 1, color: Colors.white.withOpacity(0.22)),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _Metric(
//                             title: _text('unitsSold'),
//                             valueWidget: Text(
//                               _formatUnits(res?.units ?? 0),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15.5,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                           // Currency section engineered with conditional suffix/prefix rules:
//                           _Metric(
//                             title: _text('revenue'),
//                             valueWidget: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 if (!moneyDisplay.isTrailingSymbol)
//                                   Text(
//                                     moneyDisplay.symbol,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15.5,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                                 Text(
//                                   moneyDisplay.value,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15.5,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                                 if (moneyDisplay.isTrailingSymbol)
//                                   Text(
//                                     ' ${moneyDisplay.symbol}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15.5,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           _Metric(
//                             title: _text('rating'),
//                             valueWidget: Text(
//                               (res?.rating ?? 0).toStringAsFixed(1),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15.5,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _Metric extends StatelessWidget {
//   const _Metric({required this.title, required this.valueWidget});

//   final String title;
//   final Widget valueWidget;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.85),
//             fontSize: 11.5,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 2),
//         valueWidget,
//       ],
//     );
//   }
// }

// class _Agg {
//   _Agg({required this.ref});
//   final DocumentReference ref;
//   double units = 0.0;
//   double revenue = 0.0;
// }

// class _TopProductResult {
//   _TopProductResult({
//     required this.name,
//     required this.units,
//     required this.revenue,
//     required this.rating,
//   });

//   final String name;
//   final double units;
//   final double revenue;
//   final double rating;
// }

// // Data holder class for currency layout tracking
// class _MoneyDisplay {
//   _MoneyDisplay({
//     required this.value,
//     required this.symbol,
//     required this.isTrailingSymbol,
//   });
//   final String value;
//   final String symbol;
//   final bool isTrailingSymbol;
// }

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets
import 'package:cloud_firestore/cloud_firestore.dart';

class TopProductSummaryCard extends StatefulWidget {
  const TopProductSummaryCard({
    super.key,
    this.width,
    this.height,
    this.orders,
    this.currentlanguge,
  });

  final double? width;
  final double? height;
  final List<OrderRecord>? orders;
  final String? currentlanguge;

  @override
  State<TopProductSummaryCard> createState() => _TopProductSummaryCardState();
}

class _TopProductSummaryCardState extends State<TopProductSummaryCard> {
  final Map<String, String> _nameCache = {};
  final Map<String, double> _ratingCache = {};

  Future<String?> _getProductName(DocumentReference ref) async {
    final key = ref.path;
    if (_nameCache.containsKey(key)) return _nameCache[key];

    try {
      final product = await ProductRecord.getDocumentOnce(ref);
      final name = product.productName.trim();

      if (name.isNotEmpty) {
        _nameCache[key] = name;
        return name;
      }
    } catch (_) {}

    // Fallback if ProductRecord fails or productName is empty
    try {
      final snap = await ref.get();
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>?;
        final name = (data?['name'] ??
                data?['product_name'] ??
                data?['title'] ??
                data?['productName'])
            ?.toString()
            .trim();
        if (name != null && name.isNotEmpty) {
          _nameCache[key] = name;
          return name;
        }
      }
    } catch (e) {}

    return null;
  }

  Future<double> _getProductRating(DocumentReference ref) async {
    final key = ref.path;
    if (_ratingCache.containsKey(key)) return _ratingCache[key]!;

    try {
      final snap = await ref.get();
      if (!snap.exists) return 0.0;

      final data = snap.data() as Map<String, dynamic>?;

      final raw = data?['rating'] ??
          data?['avgRating'] ??
          data?['ratingAvg'] ??
          data?['average_rating'];

      final rating = (raw is num)
          ? raw.toDouble()
          : (double.tryParse(raw?.toString() ?? '') ?? 0.0);

      _ratingCache[key] = rating;
      return rating;
    } catch (_) {
      return 0.0;
    }
  }

  String _text(String key) {
    final lang = widget.currentlanguge?.toLowerCase();

    if (lang == 'fr') {
      switch (key) {
        case 'bestSellingProduct':
          return 'Produit le plus vendu';
        case 'unitsSold':
          return 'Unités vendues';
        case 'revenue':
          return 'Revenu';
        case 'rating':
          return 'Note';
        case 'topProduct':
          return 'Meilleur produit';
      }
    }

    switch (key) {
      case 'bestSellingProduct':
        return 'Best Selling Product';
      case 'unitsSold':
        return 'Units Sold';
      case 'revenue':
        return 'Revenue';
      case 'rating':
        return 'Rating';
      case 'topProduct':
        return 'Top Product';
      default:
        return key;
    }
  }

  // Modified to return structured details instead of a single string
  _MoneyDisplay _formatMoney(double v, String? lang) {
    String symbol = '\$';
    double rate = 1.0;
    final normalizedLang = lang?.toLowerCase();

    if (normalizedLang == 'fr') {
      symbol = '€';
      rate = 0.92;
    } else if (normalizedLang == 'hi') {
      symbol = '₹';
      rate = 83.0;
    } else if (normalizedLang == 'en') {
      symbol = '\$';
      rate = 1.0;
    }

    final convertedValue = v * rate;
    String formattedValue;

    if (convertedValue >= 1000000) {
      formattedValue = '${(convertedValue / 1000000).toStringAsFixed(1)}M';
    } else if (convertedValue >= 1000) {
      formattedValue = '${(convertedValue / 1000).toStringAsFixed(1)}K';
    } else {
      formattedValue = convertedValue.toStringAsFixed(2);
    }

    return _MoneyDisplay(
      value: formattedValue,
      symbol: symbol,
      isTrailingSymbol:
          normalizedLang == 'fr', // target rule for French notation
    );
  }

  String _formatUnits(double v) => v.toStringAsFixed(0);

  Future<_TopProductResult?> _computeTopProduct() async {
    final orders = widget.orders ?? const <OrderRecord>[];
    if (orders.isEmpty) return null;

    final Map<String, _Agg> agg = {};

    for (final o in orders) {
      final items = o.orderItems ?? const <OrderItemsStruct>[];

      for (final it in items) {
        final ref = it.productRef;
        final qty = (it.totalItems ?? 0).toDouble();
        final price = (it.pricePerProduct ?? 0).toDouble();

        if (ref == null) continue;

        final key = ref.path;
        final revenue = qty * price;

        final a = agg[key] ?? _Agg(ref: ref);
        a.units += qty;
        a.revenue += revenue;
        agg[key] = a;
      }
    }

    if (agg.isEmpty) return null;

    final sortedAggs = agg.values.toList()
      ..sort((a, b) {
        final revCmp = b.revenue.compareTo(a.revenue);
        if (revCmp != 0) return revCmp;
        return b.units.compareTo(a.units);
      });

    for (final best in sortedAggs) {
      final name = await _getProductName(best.ref);
      if (name != null && name.isNotEmpty) {
        final rating = await _getProductRating(best.ref);
        return _TopProductResult(
          name: name,
          units: best.units,
          revenue: best.revenue,
          rating: rating,
        );
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TopProductResult?>(
      future: _computeTopProduct(),
      builder: (context, snap) {
        final res = snap.data;
        final loading = snap.connectionState != ConnectionState.done;

        // Calculate the currency details explicitly for rendering
        final moneyDisplay =
            _formatMoney(res?.revenue ?? 0, widget.currentlanguge);

        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF194C31), Color(0xFF3BB273)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(1.0, 0.0),
              end: AlignmentDirectional(-1.0, 0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: loading
                ? const Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC542),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.star,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  res?.name ?? '—',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _text('bestSellingProduct'),
                                  style: const TextStyle(
                                    color: Color(0xFFE7F6EF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          height: 1, color: Colors.white.withOpacity(0.22)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Metric(
                            title: _text('unitsSold'),
                            valueWidget: Text(
                              _formatUnits(res?.units ?? 0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          // Currency section engineered with conditional suffix/prefix rules:
                          _Metric(
                            title: _text('revenue'),
                            valueWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!moneyDisplay.isTrailingSymbol)
                                  Text(
                                    moneyDisplay.symbol,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                Text(
                                  moneyDisplay.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (moneyDisplay.isTrailingSymbol)
                                  Text(
                                    ' ${moneyDisplay.symbol}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          _Metric(
                            title: _text('rating'),
                            valueWidget: Text(
                              (res?.rating ?? 0).toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.valueWidget});

  final String title;
  final Widget valueWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        valueWidget,
      ],
    );
  }
}

class _Agg {
  _Agg({required this.ref});
  final DocumentReference ref;
  double units = 0.0;
  double revenue = 0.0;
}

class _TopProductResult {
  _TopProductResult({
    required this.name,
    required this.units,
    required this.revenue,
    required this.rating,
  });

  final String name;
  final double units;
  final double revenue;
  final double rating;
}

// Data holder class for currency layout tracking
class _MoneyDisplay {
  _MoneyDisplay({
    required this.value,
    required this.symbol,
    required this.isTrailingSymbol,
  });
  final String value;
  final String symbol;
  final bool isTrailingSymbol;
}
