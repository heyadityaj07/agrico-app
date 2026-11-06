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

import 'package:slide_to_act/slide_to_act.dart';

class SwipeButtonWidget extends StatefulWidget {
  const SwipeButtonWidget({
    super.key,
    this.width,
    this.height,
    required this.returnvalue,
  });

  final double? width;
  final double? height;
  final Future Function() returnvalue;

  @override
  State<SwipeButtonWidget> createState() => _SwipeButtonWidgetState();
}

class _SwipeButtonWidgetState extends State<SwipeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? 60,
      child: SlideAction(
        height: widget.height ?? 60,
        borderRadius: 30,
        elevation: 0,
        // text: "Swipe to Confirm",
        text: "Swipe to Checkout",
        textStyle: FlutterFlowTheme.of(context)
            .titleMedium
            .copyWith(color: Colors.white),
        outerColor: FlutterFlowTheme.of(context).primarytheme,
        innerColor: Colors.white,
        sliderButtonIcon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
        onSubmit: () async {
          await widget.returnvalue();
        },
      ),
    );
  }
}
