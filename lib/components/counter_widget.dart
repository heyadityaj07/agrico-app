import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'counter_model.dart';
export 'counter_model.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({
    super.key,
    required this.action,
  });

  final Future Function()? action;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late CounterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CounterModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 26.0,
      decoration: BoxDecoration(
        color: Color(0x193BB273),
        borderRadius: BorderRadius.circular(8.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: FlutterFlowTheme.of(context).primarytheme,
        ),
      ),
      child: FlutterFlowCountController(
        decrementIconBuilder: (enabled) => Icon(
          Icons.remove_rounded,
          color: enabled
              ? FlutterFlowTheme.of(context).primarytheme
              : FlutterFlowTheme.of(context).alternate,
          size: 18.0,
        ),
        incrementIconBuilder: (enabled) => Icon(
          Icons.add_rounded,
          color: enabled
              ? FlutterFlowTheme.of(context).primarytheme
              : FlutterFlowTheme.of(context).alternate,
          size: 18.0,
        ),
        countBuilder: (count) => Text(
          count.toString(),
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Satoshi',
                color: FlutterFlowTheme.of(context).primarytheme,
                fontSize: 14.0,
                letterSpacing: 0.0,
              ),
        ),
        count: _model.countControllerValue ??= 1,
        updateCount: (count) async {
          safeSetState(() => _model.countControllerValue = count);
          await widget.action?.call();
        },
        stepSize: 1,
        minimum: 1,
        contentPadding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
      ),
    );
  }
}
