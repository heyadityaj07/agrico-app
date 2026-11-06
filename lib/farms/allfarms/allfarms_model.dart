import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'allfarms_widget.dart' show AllfarmsWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class AllfarmsModel extends FlutterFlowModel<AllfarmsWidget> {
  ///  Local state fields for this page.

  List<String> availbledays = [
    'Monday',
    'Tuesday',
    'wednesday',
    'Thursday',
    'Friday',
    'SaturDay',
    'Sunday'
  ];
  void addToAvailbledays(String item) => availbledays.add(item);
  void removeFromAvailbledays(String item) => availbledays.remove(item);
  void removeAtIndexFromAvailbledays(int index) => availbledays.removeAt(index);
  void insertAtIndexInAvailbledays(int index, String item) =>
      availbledays.insert(index, item);
  void updateAvailbledaysAtIndex(int index, Function(String) updateFn) =>
      availbledays[index] = updateFn(availbledays[index]);

  List<String> availabilitylist = ['In stock', 'Pre-order', 'Out of season'];
  void addToAvailabilitylist(String item) => availabilitylist.add(item);
  void removeFromAvailabilitylist(String item) => availabilitylist.remove(item);
  void removeAtIndexFromAvailabilitylist(int index) =>
      availabilitylist.removeAt(index);
  void insertAtIndexInAvailabilitylist(int index, String item) =>
      availabilitylist.insert(index, item);
  void updateAvailabilitylistAtIndex(int index, Function(String) updateFn) =>
      availabilitylist[index] = updateFn(availabilitylist[index]);

  List<String> preparationlist = ['Pre-made basket', 'By weight'];
  void addToPreparationlist(String item) => preparationlist.add(item);
  void removeFromPreparationlist(String item) => preparationlist.remove(item);
  void removeAtIndexFromPreparationlist(int index) =>
      preparationlist.removeAt(index);
  void insertAtIndexInPreparationlist(int index, String item) =>
      preparationlist.insert(index, item);
  void updatePreparationlistAtIndex(int index, Function(String) updateFn) =>
      preparationlist[index] = updateFn(preparationlist[index]);

  List<String> originlist = ['Regional', 'Imported'];
  void addToOriginlist(String item) => originlist.add(item);
  void removeFromOriginlist(String item) => originlist.remove(item);
  void removeAtIndexFromOriginlist(int index) => originlist.removeAt(index);
  void insertAtIndexInOriginlist(int index, String item) =>
      originlist.insert(index, item);
  void updateOriginlistAtIndex(int index, Function(String) updateFn) =>
      originlist[index] = updateFn(originlist[index]);

  List<String> farmingMethodlist = [
    'Organic Certified',
    'Pesticide-Free',
    'Hydroponic',
    'Grass-Fed'
  ];
  void addToFarmingMethodlist(String item) => farmingMethodlist.add(item);
  void removeFromFarmingMethodlist(String item) =>
      farmingMethodlist.remove(item);
  void removeAtIndexFromFarmingMethodlist(int index) =>
      farmingMethodlist.removeAt(index);
  void insertAtIndexInFarmingMethodlist(int index, String item) =>
      farmingMethodlist.insert(index, item);
  void updateFarmingMethodlistAtIndex(int index, Function(String) updateFn) =>
      farmingMethodlist[index] = updateFn(farmingMethodlist[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for suspend component.
  late SuspendModel suspendModel;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController1;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController2;

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    suspendModel.dispose();
    expandableExpandableController1.dispose();
    expandableExpandableController2.dispose();
  }
}
