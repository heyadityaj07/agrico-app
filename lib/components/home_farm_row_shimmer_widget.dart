import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_farm_row_shimmer_model.dart';
export 'home_farm_row_shimmer_model.dart';

/// DSL component HomeFarmRowShimmer
class HomeFarmRowShimmerWidget extends StatefulWidget {
  const HomeFarmRowShimmerWidget({super.key});

  @override
  State<HomeFarmRowShimmerWidget> createState() =>
      _HomeFarmRowShimmerWidgetState();
}

class _HomeFarmRowShimmerWidgetState extends State<HomeFarmRowShimmerWidget> {
  late HomeFarmRowShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeFarmRowShimmerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return custom_widgets.DynamicShimmerWidget(
      width: 220.0,
      height: 205.0,
      isRow: true,
      itemCount: 3,
      itemWidth: 220.0,
      itemHeight: 190.0,
      spacing: 16.0,
      borderRadius: 12.0,
      shimmerType: 'banner',
      scrollable: true,
    );
  }
}
