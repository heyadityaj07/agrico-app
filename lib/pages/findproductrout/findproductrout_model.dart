import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/place.dart';
import 'dart:io';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'findproductrout_widget.dart' show FindproductroutWidget;
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FindproductroutModel extends FlutterFlowModel<FindproductroutWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for startPlacePicker widget.
  FFPlace startPlacePickerValue = FFPlace();
  // State field(s) for destinationPlacePicker widget.
  FFPlace destinationPlacePickerValue = FFPlace();
  // State field(s) for Slider widget.
  double? sliderValue;
  // Stores action output result for [Custom Action - islocateionselect] action in Button widget.
  bool? location;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
