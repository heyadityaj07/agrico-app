import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'product_detail_shimmer_model.dart';
export 'product_detail_shimmer_model.dart';

/// DSL component ProductDetailShimmer
class ProductDetailShimmerWidget extends StatefulWidget {
  const ProductDetailShimmerWidget({
    super.key,
    this.height,
    this.width,
    this.shimmerType,
  });

  final double? height;
  final double? width;
  final String? shimmerType;

  @override
  State<ProductDetailShimmerWidget> createState() =>
      _ProductDetailShimmerWidgetState();
}

class _ProductDetailShimmerWidgetState
    extends State<ProductDetailShimmerWidget> {
  late ProductDetailShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailShimmerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return custom_widgets.DynamicShimmerWidget(
      width: widget!.width,
      height: widget!.height,
      isRow: false,
      itemCount: 1,
      itemWidth: widget!.width,
      itemHeight: widget!.height,
      spacing: 0.0,
      borderRadius: 12.0,
      shimmerType: valueOrDefault<String>(
        widget!.shimmerType,
        'productCard',
      ),
      scrollable: false,
    );
  }
}
