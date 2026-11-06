import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'product_widget.dart' show ProductWidget;
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel<ProductWidget> {
  ///  Local state fields for this page.

  List<String> pricelist = [
    'Below \$20',
    '\$20 - \$50',
    '\$60 - \$80',
    'Above \$80'
  ];
  void addToPricelist(String item) => pricelist.add(item);
  void removeFromPricelist(String item) => pricelist.remove(item);
  void removeAtIndexFromPricelist(int index) => pricelist.removeAt(index);
  void insertAtIndexInPricelist(int index, String item) =>
      pricelist.insert(index, item);
  void updatePricelistAtIndex(int index, Function(String) updateFn) =>
      pricelist[index] = updateFn(pricelist[index]);

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

  @override
  void initState(BuildContext context) {
    suspendModel = createModel(context, () => SuspendModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    suspendModel.dispose();
  }
}
