import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'caculation_card_model.dart';
export 'caculation_card_model.dart';

class CaculationCardWidget extends StatefulWidget {
  const CaculationCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String? label;
  final String? value;
  final Color? color;

  @override
  State<CaculationCardWidget> createState() => _CaculationCardWidgetState();
}

class _CaculationCardWidgetState extends State<CaculationCardWidget> {
  late CaculationCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CaculationCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            valueOrDefault<String>(
              widget!.label,
              'Est. Weight Range:',
            ),
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Satoshi',
                  color: widget!.color,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        Text(
          valueOrDefault<String>(
            widget!.value,
            '0',
          ),
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Satoshi',
                color: widget!.color,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
      ].divide(SizedBox(width: 6.0)),
    );
  }
}
