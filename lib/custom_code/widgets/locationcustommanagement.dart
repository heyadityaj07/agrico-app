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

import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';

class Locationcustommanagement extends StatefulWidget {
  const Locationcustommanagement({
    super.key,
    this.width,
    this.height,
    this.onreturnvalue,
  });

  final double? width;
  final double? height;
  final Future Function(FFPlace? value)? onreturnvalue;

  @override
  State<Locationcustommanagement> createState() =>
      _LocationcustommanagementState();
}

class _LocationcustommanagementState extends State<Locationcustommanagement> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlutterFlowPlacePicker(
      iOSGoogleMapsApiKey: 'AIzaSyDs54T-XQN008UL5eqPn7WzlZJsQk4kjlA',
      androidGoogleMapsApiKey: 'AIzaSyBybzs-CZ7ZqYJZdxN4Gjr1wnUh_yhwjIc',
      webGoogleMapsApiKey: 'AIzaSyCCI5dSMJfpbH-xb2ZMWrShpLyq_RPbM_Q',
      onSelect: (place) async {
        await widget.onreturnvalue?.call(place);
      },
      defaultText: FFLocalizations.of(context).getText(
        'gk0sd0iq' /* Search address */,
      ),
      icon: Icon(
        Icons.place,
        color: FlutterFlowTheme.of(context).info,
        size: 16,
      ),
      buttonOptions: FFButtonOptions(
        width: double.infinity,
        height: 40,
        color: FlutterFlowTheme.of(context).primarytheme,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Satoshi',
              color: FlutterFlowTheme.of(context).info,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
        elevation: 0,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ));
  }
}
