import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'productswitch_model.dart';
export 'productswitch_model.dart';

class ProductswitchWidget extends StatefulWidget {
  const ProductswitchWidget({
    super.key,
    this.parameter1,
    this.parameter3,
  });

  final String? parameter1;
  final DocumentReference? parameter3;

  @override
  State<ProductswitchWidget> createState() => _ProductswitchWidgetState();
}

class _ProductswitchWidgetState extends State<ProductswitchWidget> {
  late ProductswitchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductswitchModel());

    _model.switchValue = widget.parameter1 == 'Active';
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (widget.parameter1 == 'Approved') ||
          (widget.parameter1 == 'Active') ||
          (widget.parameter1 == 'Inactive'),
      child: Switch.adaptive(
        value: _model.switchValue!,
        onChanged: (newValue) async {
          safeSetState(() => _model.switchValue = newValue);
          if (newValue) {
            await widget.parameter3!.update(createProductRecordData(
              activeStatus: _model.switchValue,
              productStatus: 'Active',
            ));
          } else {
            await widget.parameter3!.update(createProductRecordData(
              activeStatus: false,
              productStatus: 'Inactive',
            ));
          }
        },
        activeColor: FlutterFlowTheme.of(context).card,
        activeTrackColor: FlutterFlowTheme.of(context).primarytheme,
        inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
        inactiveThumbColor: FlutterFlowTheme.of(context).textsecondary,
      ),
    );
  }
}
