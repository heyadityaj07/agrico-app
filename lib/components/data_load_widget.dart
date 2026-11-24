import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data_load_model.dart';
export 'data_load_model.dart';

class DataLoadWidget extends StatefulWidget {
  const DataLoadWidget({
    super.key,
    this.height,
    required this.width,
    Color? cmncolor,
    int? length,
  })  : this.cmncolor = cmncolor ?? const Color(0xFFEFEFEF),
        this.length = length ?? 1;

  final double? height;
  final double? width;
  final Color cmncolor;
  final int length;

  @override
  State<DataLoadWidget> createState() => _DataLoadWidgetState();
}

class _DataLoadWidgetState extends State<DataLoadWidget> {
  late DataLoadModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DataLoadModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: custom_widgets.DynamicShimmerWidget(
        width: widget!.width,
        height: widget!.height,
        isRow: false,
        itemCount: valueOrDefault<int>(
          widget!.length,
          1,
        ),
        itemWidth: widget!.width,
        itemHeight: widget!.height,
        spacing: 0.0,
        borderRadius: 12.0,
        shimmerType: 'box',
        scrollable: false,
      ),
    );
  }
}
