import '/components/consumer_navbar_widget.dart';
import '/components/filter_widget.dart';
import '/components/rout_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'maps_page_widget.dart' show MapsPageWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class MapsPageModel extends FlutterFlowModel<MapsPageWidget> {
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

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // Model for filter component.
  late FilterModel filterModel;
  // Model for rout component.
  late RoutModel routModel;
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
    filterModel = createModel(context, () => FilterModel());
    routModel = createModel(context, () => RoutModel());
    consumerNavbarModel = createModel(context, () => ConsumerNavbarModel());
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    filterModel.dispose();
    routModel.dispose();
    consumerNavbarModel.dispose();
    suspendModel.dispose();
    expandableExpandableController1.dispose();
    expandableExpandableController2.dispose();
  }
}
