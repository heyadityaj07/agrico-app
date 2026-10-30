import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'demo11_model.dart';
export 'demo11_model.dart';

class Demo11Widget extends StatefulWidget {
  const Demo11Widget({super.key});

  @override
  State<Demo11Widget> createState() => _Demo11WidgetState();
}

class _Demo11WidgetState extends State<Demo11Widget> {
  late Demo11Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Demo11Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      constraints: BoxConstraints(
        maxWidth: 200.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Text(
        FFLocalizations.of(context).getText(
          'x5h6gyfi' /* Hello World hnkjgnkfjgnjkhnfjl... */,
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Satoshi',
              letterSpacing: 0.0,
            ),
      ),
    );
  }
}
