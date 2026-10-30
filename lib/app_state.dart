import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _xgraphdata = prefs.getStringList('ff_xgraphdata') ?? _xgraphdata;
    });
    _safeInit(() {
      _firsttimeonboarding =
          prefs.getBool('ff_firsttimeonboarding') ?? _firsttimeonboarding;
    });
    _safeInit(() {
      _orderdocument =
          prefs.getString('ff_orderdocument')?.ref ?? _orderdocument;
    });
    _safeInit(() {
      _cartdocument = prefs.getString('ff_cartdocument')?.ref ?? _cartdocument;
    });
    _safeInit(() {
      _cartlist = prefs.getInt('ff_cartlist') ?? _cartlist;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<String> _selectedprice = [];
  List<String> get selectedprice => _selectedprice;
  set selectedprice(List<String> value) {
    _selectedprice = value;
  }

  void addToSelectedprice(String value) {
    selectedprice.add(value);
  }

  void removeFromSelectedprice(String value) {
    selectedprice.remove(value);
  }

  void removeAtIndexFromSelectedprice(int index) {
    selectedprice.removeAt(index);
  }

  void updateSelectedpriceAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedprice[index] = updateFn(_selectedprice[index]);
  }

  void insertAtIndexInSelectedprice(int index, String value) {
    selectedprice.insert(index, value);
  }

  List<String> _selectedAvailability = [];
  List<String> get selectedAvailability => _selectedAvailability;
  set selectedAvailability(List<String> value) {
    _selectedAvailability = value;
  }

  void addToSelectedAvailability(String value) {
    selectedAvailability.add(value);
  }

  void removeFromSelectedAvailability(String value) {
    selectedAvailability.remove(value);
  }

  void removeAtIndexFromSelectedAvailability(int index) {
    selectedAvailability.removeAt(index);
  }

  void updateSelectedAvailabilityAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedAvailability[index] = updateFn(_selectedAvailability[index]);
  }

  void insertAtIndexInSelectedAvailability(int index, String value) {
    selectedAvailability.insert(index, value);
  }

  List<String> _selectedPreparation = [];
  List<String> get selectedPreparation => _selectedPreparation;
  set selectedPreparation(List<String> value) {
    _selectedPreparation = value;
  }

  void addToSelectedPreparation(String value) {
    selectedPreparation.add(value);
  }

  void removeFromSelectedPreparation(String value) {
    selectedPreparation.remove(value);
  }

  void removeAtIndexFromSelectedPreparation(int index) {
    selectedPreparation.removeAt(index);
  }

  void updateSelectedPreparationAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedPreparation[index] = updateFn(_selectedPreparation[index]);
  }

  void insertAtIndexInSelectedPreparation(int index, String value) {
    selectedPreparation.insert(index, value);
  }

  List<String> _selectedOrigin = [];
  List<String> get selectedOrigin => _selectedOrigin;
  set selectedOrigin(List<String> value) {
    _selectedOrigin = value;
  }

  void addToSelectedOrigin(String value) {
    selectedOrigin.add(value);
  }

  void removeFromSelectedOrigin(String value) {
    selectedOrigin.remove(value);
  }

  void removeAtIndexFromSelectedOrigin(int index) {
    selectedOrigin.removeAt(index);
  }

  void updateSelectedOriginAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedOrigin[index] = updateFn(_selectedOrigin[index]);
  }

  void insertAtIndexInSelectedOrigin(int index, String value) {
    selectedOrigin.insert(index, value);
  }

  List<String> _selectedFarmingMethod = [];
  List<String> get selectedFarmingMethod => _selectedFarmingMethod;
  set selectedFarmingMethod(List<String> value) {
    _selectedFarmingMethod = value;
  }

  void addToSelectedFarmingMethod(String value) {
    selectedFarmingMethod.add(value);
  }

  void removeFromSelectedFarmingMethod(String value) {
    selectedFarmingMethod.remove(value);
  }

  void removeAtIndexFromSelectedFarmingMethod(int index) {
    selectedFarmingMethod.removeAt(index);
  }

  void updateSelectedFarmingMethodAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedFarmingMethod[index] = updateFn(_selectedFarmingMethod[index]);
  }

  void insertAtIndexInSelectedFarmingMethod(int index, String value) {
    selectedFarmingMethod.insert(index, value);
  }

  List<String> _selectedcategories = [];
  List<String> get selectedcategories => _selectedcategories;
  set selectedcategories(List<String> value) {
    _selectedcategories = value;
  }

  void addToSelectedcategories(String value) {
    selectedcategories.add(value);
  }

  void removeFromSelectedcategories(String value) {
    selectedcategories.remove(value);
  }

  void removeAtIndexFromSelectedcategories(int index) {
    selectedcategories.removeAt(index);
  }

  void updateSelectedcategoriesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedcategories[index] = updateFn(_selectedcategories[index]);
  }

  void insertAtIndexInSelectedcategories(int index, String value) {
    selectedcategories.insert(index, value);
  }

  List<String> _selectedMethods = [];
  List<String> get selectedMethods => _selectedMethods;
  set selectedMethods(List<String> value) {
    _selectedMethods = value;
  }

  void addToSelectedMethods(String value) {
    selectedMethods.add(value);
  }

  void removeFromSelectedMethods(String value) {
    selectedMethods.remove(value);
  }

  void removeAtIndexFromSelectedMethods(int index) {
    selectedMethods.removeAt(index);
  }

  void updateSelectedMethodsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedMethods[index] = updateFn(_selectedMethods[index]);
  }

  void insertAtIndexInSelectedMethods(int index, String value) {
    selectedMethods.insert(index, value);
  }

  List<String> _selectedLabels = [];
  List<String> get selectedLabels => _selectedLabels;
  set selectedLabels(List<String> value) {
    _selectedLabels = value;
  }

  void addToSelectedLabels(String value) {
    selectedLabels.add(value);
  }

  void removeFromSelectedLabels(String value) {
    selectedLabels.remove(value);
  }

  void removeAtIndexFromSelectedLabels(int index) {
    selectedLabels.removeAt(index);
  }

  void updateSelectedLabelsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedLabels[index] = updateFn(_selectedLabels[index]);
  }

  void insertAtIndexInSelectedLabels(int index, String value) {
    selectedLabels.insert(index, value);
  }

  List<String> _selectedCondition = [];
  List<String> get selectedCondition => _selectedCondition;
  set selectedCondition(List<String> value) {
    _selectedCondition = value;
  }

  void addToSelectedCondition(String value) {
    selectedCondition.add(value);
  }

  void removeFromSelectedCondition(String value) {
    selectedCondition.remove(value);
  }

  void removeAtIndexFromSelectedCondition(int index) {
    selectedCondition.removeAt(index);
  }

  void updateSelectedConditionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedCondition[index] = updateFn(_selectedCondition[index]);
  }

  void insertAtIndexInSelectedCondition(int index, String value) {
    selectedCondition.insert(index, value);
  }

  List<String> _xgraphdata = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> get xgraphdata => _xgraphdata;
  set xgraphdata(List<String> value) {
    _xgraphdata = value;
    prefs.setStringList('ff_xgraphdata', value);
  }

  void addToXgraphdata(String value) {
    xgraphdata.add(value);
    prefs.setStringList('ff_xgraphdata', _xgraphdata);
  }

  void removeFromXgraphdata(String value) {
    xgraphdata.remove(value);
    prefs.setStringList('ff_xgraphdata', _xgraphdata);
  }

  void removeAtIndexFromXgraphdata(int index) {
    xgraphdata.removeAt(index);
    prefs.setStringList('ff_xgraphdata', _xgraphdata);
  }

  void updateXgraphdataAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    xgraphdata[index] = updateFn(_xgraphdata[index]);
    prefs.setStringList('ff_xgraphdata', _xgraphdata);
  }

  void insertAtIndexInXgraphdata(int index, String value) {
    xgraphdata.insert(index, value);
    prefs.setStringList('ff_xgraphdata', _xgraphdata);
  }

  List<String> _FarmSelectedDays = [];
  List<String> get FarmSelectedDays => _FarmSelectedDays;
  set FarmSelectedDays(List<String> value) {
    _FarmSelectedDays = value;
  }

  void addToFarmSelectedDays(String value) {
    FarmSelectedDays.add(value);
  }

  void removeFromFarmSelectedDays(String value) {
    FarmSelectedDays.remove(value);
  }

  void removeAtIndexFromFarmSelectedDays(int index) {
    FarmSelectedDays.removeAt(index);
  }

  void updateFarmSelectedDaysAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    FarmSelectedDays[index] = updateFn(_FarmSelectedDays[index]);
  }

  void insertAtIndexInFarmSelectedDays(int index, String value) {
    FarmSelectedDays.insert(index, value);
  }

  List<String> _delievryarea = [];
  List<String> get delievryarea => _delievryarea;
  set delievryarea(List<String> value) {
    _delievryarea = value;
  }

  void addToDelievryarea(String value) {
    delievryarea.add(value);
  }

  void removeFromDelievryarea(String value) {
    delievryarea.remove(value);
  }

  void removeAtIndexFromDelievryarea(int index) {
    delievryarea.removeAt(index);
  }

  void updateDelievryareaAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    delievryarea[index] = updateFn(_delievryarea[index]);
  }

  void insertAtIndexInDelievryarea(int index, String value) {
    delievryarea.insert(index, value);
  }

  List<String> _farmsavaibleselected = [];
  List<String> get farmsavaibleselected => _farmsavaibleselected;
  set farmsavaibleselected(List<String> value) {
    _farmsavaibleselected = value;
  }

  void addToFarmsavaibleselected(String value) {
    farmsavaibleselected.add(value);
  }

  void removeFromFarmsavaibleselected(String value) {
    farmsavaibleselected.remove(value);
  }

  void removeAtIndexFromFarmsavaibleselected(int index) {
    farmsavaibleselected.removeAt(index);
  }

  void updateFarmsavaibleselectedAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    farmsavaibleselected[index] = updateFn(_farmsavaibleselected[index]);
  }

  void insertAtIndexInFarmsavaibleselected(int index, String value) {
    farmsavaibleselected.insert(index, value);
  }

  bool _gohome = false;
  bool get gohome => _gohome;
  set gohome(bool value) {
    _gohome = value;
  }

  DocumentReference? _farmref;
  DocumentReference? get farmref => _farmref;
  set farmref(DocumentReference? value) {
    _farmref = value;
  }

  LocationFromLatlngStruct _farmlocation = LocationFromLatlngStruct();
  LocationFromLatlngStruct get farmlocation => _farmlocation;
  set farmlocation(LocationFromLatlngStruct value) {
    _farmlocation = value;
  }

  void updateFarmlocationStruct(Function(LocationFromLatlngStruct) updateFn) {
    updateFn(_farmlocation);
  }

  bool _firsttimeonboarding = false;
  bool get firsttimeonboarding => _firsttimeonboarding;
  set firsttimeonboarding(bool value) {
    _firsttimeonboarding = value;
    prefs.setBool('ff_firsttimeonboarding', value);
  }

  DocumentReference? _selectedFarmRef;
  DocumentReference? get selectedFarmRef => _selectedFarmRef;
  set selectedFarmRef(DocumentReference? value) {
    _selectedFarmRef = value;
  }

  List<FarmAvailabilityStruct> _availibility = [
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Monday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Tuesday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Wednesday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Thursday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Friday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Saturday\",\"is_avavible\":\"false\"}')),
    FarmAvailabilityStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Sunday\",\"is_avavible\":\"false\"}'))
  ];
  List<FarmAvailabilityStruct> get availibility => _availibility;
  set availibility(List<FarmAvailabilityStruct> value) {
    _availibility = value;
  }

  void addToAvailibility(FarmAvailabilityStruct value) {
    availibility.add(value);
  }

  void removeFromAvailibility(FarmAvailabilityStruct value) {
    availibility.remove(value);
  }

  void removeAtIndexFromAvailibility(int index) {
    availibility.removeAt(index);
  }

  void updateAvailibilityAtIndex(
    int index,
    FarmAvailabilityStruct Function(FarmAvailabilityStruct) updateFn,
  ) {
    availibility[index] = updateFn(_availibility[index]);
  }

  void insertAtIndexInAvailibility(int index, FarmAvailabilityStruct value) {
    availibility.insert(index, value);
  }

  LatLng? _Selectedlocation;
  LatLng? get Selectedlocation => _Selectedlocation;
  set Selectedlocation(LatLng? value) {
    _Selectedlocation = value;
  }

  String _phonnumber = '';
  String get phonnumber => _phonnumber;
  set phonnumber(String value) {
    _phonnumber = value;
  }

  DocumentReference? _orderdocument;
  DocumentReference? get orderdocument => _orderdocument;
  set orderdocument(DocumentReference? value) {
    _orderdocument = value;
    value != null
        ? prefs.setString('ff_orderdocument', value.path)
        : prefs.remove('ff_orderdocument');
  }

  DocumentReference? _cartdocument;
  DocumentReference? get cartdocument => _cartdocument;
  set cartdocument(DocumentReference? value) {
    _cartdocument = value;
    value != null
        ? prefs.setString('ff_cartdocument', value.path)
        : prefs.remove('ff_cartdocument');
  }

  int _cartlist = 0;
  int get cartlist => _cartlist;
  set cartlist(int value) {
    _cartlist = value;
    prefs.setInt('ff_cartlist', value);
  }

  String _role = '';
  String get role => _role;
  set role(String value) {
    _role = value;
  }

  /// App state selectedWeightBreakdown
  List<String> _selectedWeightBreakdown = [];
  List<String> get selectedWeightBreakdown => _selectedWeightBreakdown;
  set selectedWeightBreakdown(List<String> value) {
    _selectedWeightBreakdown = value;
  }

  void addToSelectedWeightBreakdown(String value) {
    selectedWeightBreakdown.add(value);
  }

  void removeFromSelectedWeightBreakdown(String value) {
    selectedWeightBreakdown.remove(value);
  }

  void removeAtIndexFromSelectedWeightBreakdown(int index) {
    selectedWeightBreakdown.removeAt(index);
  }

  void updateSelectedWeightBreakdownAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedWeightBreakdown[index] = updateFn(_selectedWeightBreakdown[index]);
  }

  void insertAtIndexInSelectedWeightBreakdown(int index, String value) {
    selectedWeightBreakdown.insert(index, value);
  }

  final _productManager = StreamRequestManager<List<ProductRecord>>();
  Stream<List<ProductRecord>> product({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ProductRecord>> Function() requestFn,
  }) =>
      _productManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProductCache() => _productManager.clear();
  void clearProductCacheKey(String? uniqueKey) =>
      _productManager.clearRequest(uniqueKey);

  final _farmuserManager = StreamRequestManager<UsersRecord>();
  Stream<UsersRecord> farmuser({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<UsersRecord> Function() requestFn,
  }) =>
      _farmuserManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearFarmuserCache() => _farmuserManager.clear();
  void clearFarmuserCacheKey(String? uniqueKey) =>
      _farmuserManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
