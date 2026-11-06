import '/components/consumer_navbar_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'maps_page_copy_widget.dart' show MapsPageCopyWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

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
