import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_product_shimmer_model.dart';
export 'home_product_shimmer_model.dart';

/// DSL component HomeProductShimmer
class HomeProductShimmerWidget extends StatefulWidget {
  const HomeProductShimmerWidget({super.key});

  @override
  State<HomeProductShimmerWidget> createState() =>
      _HomeProductShimmerWidgetState();
}

class _HomeProductShimmerWidgetState extends State<HomeProductShimmerWidget> {
  late HomeProductShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeProductShimmerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: custom_widgets.DynamicShimmerWidget(
        width: 150.0,
        height: 230.0,
        isRow: false,
        itemCount: 1,
        itemWidth: 150.0,
        itemHeight: 230.0,
        spacing: 12.0,
        borderRadius: 12.0,
        shimmerType: 'productCard',
        scrollable: false,
      ),
    );
  }
}
