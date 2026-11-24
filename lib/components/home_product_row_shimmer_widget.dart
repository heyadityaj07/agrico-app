import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_product_row_shimmer_model.dart';
export 'home_product_row_shimmer_model.dart';

/// DSL component HomeProductRowShimmer
class HomeProductRowShimmerWidget extends StatefulWidget {
  const HomeProductRowShimmerWidget({super.key});

  @override
  State<HomeProductRowShimmerWidget> createState() =>
      _HomeProductRowShimmerWidgetState();
}

class _HomeProductRowShimmerWidgetState
    extends State<HomeProductRowShimmerWidget> {
  late HomeProductRowShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeProductRowShimmerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return custom_widgets.DynamicShimmerWidget(
      width: 150.0,
      height: 230.0,
      isRow: true,
      itemCount: 3,
      itemWidth: 150.0,
      itemHeight: 230.0,
      spacing: 16.0,
      borderRadius: 12.0,
      shimmerType: 'productCard',
      scrollable: true,
    );
  }
}
