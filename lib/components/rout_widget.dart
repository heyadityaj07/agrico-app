import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/findproductrout/findproductrout_widget.dart';
import 'package:flutter/material.dart';
import 'rout_model.dart';
export 'rout_model.dart';

class RoutWidget extends StatefulWidget {
  const RoutWidget({super.key});

  @override
  State<RoutWidget> createState() => _RoutWidgetState();
}

class _RoutWidgetState extends State<RoutWidget> {
  late RoutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RoutModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: AlignmentDirectional(0.0, -1.0)
                    .resolve(Directionality.of(context)),
                child: FindproductroutWidget(),
              );
            },
          );
        },
        child: Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F3),
            borderRadius: BorderRadius.circular(99.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).card,
            ),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Icon(
              FFIcons.kshareicon,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
