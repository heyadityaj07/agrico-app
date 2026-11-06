import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'data_load_model.dart';
export 'data_load_model.dart';

class DataLoadWidget extends StatefulWidget {
  const DataLoadWidget({
    super.key,
    required this.height,
    required this.width,
    Color? cmncolor,
  }) : this.cmncolor = cmncolor ?? const Color(0xFFEFEFEF);

  final double? height;
  final double? width;
  final Color cmncolor;

  @override
  State<DataLoadWidget> createState() => _DataLoadWidgetState();
}

class _DataLoadWidgetState extends State<DataLoadWidget>
    with TickerProviderStateMixin {
  late DataLoadModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DataLoadModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });
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
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.cmncolor,
          borderRadius: BorderRadius.circular(12.0),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
