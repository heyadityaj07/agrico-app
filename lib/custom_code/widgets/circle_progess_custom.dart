// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CircleProgessCustom extends StatefulWidget {
  const CircleProgessCustom({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CircleProgessCustom> createState() => _CircleProgessCustomState();
}

class _CircleProgessCustomState extends State<CircleProgessCustom> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        color: FlutterFlowTheme.of(context).primarytheme,
        strokeWidth: 4,
      ),
    ));
  }
}
