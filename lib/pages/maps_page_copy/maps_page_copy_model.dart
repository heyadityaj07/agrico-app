import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/consumer_navbar_widget.dart';
import '/components/filter_widget.dart';
import '/components/rout_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'maps_page_copy_widget.dart' show MapsPageCopyWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MapsPageCopyModel extends FlutterFlowModel<MapsPageCopyWidget> {
  ///  Local state fields for this page.

  List<String> availabilitylist = ['In stock', 'Pre-order', 'Out of season'];
  void addToAvailabilitylist(String item) => availabilitylist.add(item);
  void removeFromAvailabilitylist(String item) => availabilitylist.remove(item);
  void removeAtIndexFromAvailabilitylist(int index) =>
      availabilitylist.removeAt(index);
  void insertAtIndexInAvailabilitylist(int index, String item) =>
      availabilitylist.insert(index, item);
  void updateAvailabilitylistAtIndex(int index, Function(String) updateFn) =>
      availabilitylist[index] = updateFn(availabilitylist[index]);

  String? selectedavailbility;

  ///  State fields for stateful widgets in this page.

  // Model for ConsumerNavbar component.
  late ConsumerNavbarModel consumerNavbarModel;
  // Model for suspend component.
  late SuspendModel suspendModel;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController1;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController2;

  @override
  void initState(BuildContext context) {
    consumerNavbarModel = createModel(context, () => ConsumerNavbarModel());
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    consumerNavbarModel.dispose();
    suspendModel.dispose();
    expandableExpandableController1.dispose();
    expandableExpandableController2.dispose();
  }
}
