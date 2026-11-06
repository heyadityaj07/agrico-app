import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/switchcmn_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'farm_availability_widget.dart' show FarmAvailabilityWidget;
import 'package:flutter/material.dart';

class FarmAvailabilityModel extends FlutterFlowModel<FarmAvailabilityWidget> {
  ///  Local state fields for this page.

  List<FarmAvailabilityStruct> availbiliy = [];
  void addToAvailbiliy(FarmAvailabilityStruct item) => availbiliy.add(item);
  void removeFromAvailbiliy(FarmAvailabilityStruct item) =>
      availbiliy.remove(item);
  void removeAtIndexFromAvailbiliy(int index) => availbiliy.removeAt(index);
  void insertAtIndexInAvailbiliy(int index, FarmAvailabilityStruct item) =>
      availbiliy.insert(index, item);
  void updateAvailbiliyAtIndex(
          int index, Function(FarmAvailabilityStruct) updateFn) =>
      availbiliy[index] = updateFn(availbiliy[index]);

  ///  State fields for stateful widgets in this page.

  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel1;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel2;
  DateTime? datePicked3;
  DateTime? datePicked4;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel3;
  DateTime? datePicked5;
  DateTime? datePicked6;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel4;
  DateTime? datePicked7;
  DateTime? datePicked8;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel5;
  DateTime? datePicked9;
  DateTime? datePicked10;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel6;
  DateTime? datePicked11;
  DateTime? datePicked12;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel7;
  DateTime? datePicked13;
  DateTime? datePicked14;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel8;
  DateTime? datePicked15;
  DateTime? datePicked16;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel9;
  DateTime? datePicked17;
  DateTime? datePicked18;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel10;
  DateTime? datePicked19;
  DateTime? datePicked20;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel11;
  DateTime? datePicked21;
  DateTime? datePicked22;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel12;
  DateTime? datePicked23;
  DateTime? datePicked24;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel13;
  DateTime? datePicked25;
  DateTime? datePicked26;
  // Model for switchcmn component.
  late SwitchcmnModel switchcmnModel14;
  DateTime? datePicked27;
  DateTime? datePicked28;

  @override
  void initState(BuildContext context) {
    switchcmnModel1 = createModel(context, () => SwitchcmnModel());
    switchcmnModel2 = createModel(context, () => SwitchcmnModel());
    switchcmnModel3 = createModel(context, () => SwitchcmnModel());
    switchcmnModel4 = createModel(context, () => SwitchcmnModel());
    switchcmnModel5 = createModel(context, () => SwitchcmnModel());
    switchcmnModel6 = createModel(context, () => SwitchcmnModel());
    switchcmnModel7 = createModel(context, () => SwitchcmnModel());
    switchcmnModel8 = createModel(context, () => SwitchcmnModel());
    switchcmnModel9 = createModel(context, () => SwitchcmnModel());
    switchcmnModel10 = createModel(context, () => SwitchcmnModel());
    switchcmnModel11 = createModel(context, () => SwitchcmnModel());
    switchcmnModel12 = createModel(context, () => SwitchcmnModel());
    switchcmnModel13 = createModel(context, () => SwitchcmnModel());
    switchcmnModel14 = createModel(context, () => SwitchcmnModel());
  }

  @override
  void dispose() {
    switchcmnModel1.dispose();
    switchcmnModel2.dispose();
    switchcmnModel3.dispose();
    switchcmnModel4.dispose();
    switchcmnModel5.dispose();
    switchcmnModel6.dispose();
    switchcmnModel7.dispose();
    switchcmnModel8.dispose();
    switchcmnModel9.dispose();
    switchcmnModel10.dispose();
    switchcmnModel11.dispose();
    switchcmnModel12.dispose();
    switchcmnModel13.dispose();
    switchcmnModel14.dispose();
  }
}
