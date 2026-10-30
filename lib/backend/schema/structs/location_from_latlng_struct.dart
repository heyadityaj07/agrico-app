// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart' hide Type;

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocationFromLatlngStruct extends FFFirebaseStruct {
  LocationFromLatlngStruct({
    String? street,
    String? city,
    String? state,
    String? country,
    LatLng? latlng,
    String? zipcode,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _street = street,
        _city = city,
        _state = state,
        _country = country,
        _latlng = latlng,
        _zipcode = zipcode,
        super(firestoreUtilData);

  // "street" field.
  String? _street;
  String get street => _street ?? '';
  set street(String? val) => _street = val;

  bool hasStreet() => _street != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "latlng" field.
  LatLng? _latlng;
  LatLng? get latlng => _latlng;
  set latlng(LatLng? val) => _latlng = val;

  bool hasLatlng() => _latlng != null;

  // "zipcode" field.
  String? _zipcode;
  String get zipcode => _zipcode ?? '';
  set zipcode(String? val) => _zipcode = val;

  bool hasZipcode() => _zipcode != null;

  static LocationFromLatlngStruct fromMap(Map<String, dynamic> data) =>
      LocationFromLatlngStruct(
        street: data['street'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        country: data['country'] as String?,
        latlng: data['latlng'] as LatLng?,
        zipcode: data['zipcode'] as String?,
      );

  static LocationFromLatlngStruct? maybeFromMap(dynamic data) => data is Map
      ? LocationFromLatlngStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'street': _street,
        'city': _city,
        'state': _state,
        'country': _country,
        'latlng': _latlng,
        'zipcode': _zipcode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'street': serializeParam(
          _street,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'latlng': serializeParam(
          _latlng,
          ParamType.LatLng,
        ),
        'zipcode': serializeParam(
          _zipcode,
          ParamType.String,
        ),
      }.withoutNulls;

  static LocationFromLatlngStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      LocationFromLatlngStruct(
        street: deserializeParam(
          data['street'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        latlng: deserializeParam(
          data['latlng'],
          ParamType.LatLng,
          false,
        ),
        zipcode: deserializeParam(
          data['zipcode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LocationFromLatlngStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocationFromLatlngStruct &&
        street == other.street &&
        city == other.city &&
        state == other.state &&
        country == other.country &&
        latlng == other.latlng &&
        zipcode == other.zipcode;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([street, city, state, country, latlng, zipcode]);
}

LocationFromLatlngStruct createLocationFromLatlngStruct({
  String? street,
  String? city,
  String? state,
  String? country,
  LatLng? latlng,
  String? zipcode,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LocationFromLatlngStruct(
      street: street,
      city: city,
      state: state,
      country: country,
      latlng: latlng,
      zipcode: zipcode,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LocationFromLatlngStruct? updateLocationFromLatlngStruct(
  LocationFromLatlngStruct? locationFromLatlng, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    locationFromLatlng
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLocationFromLatlngStructData(
  Map<String, dynamic> firestoreData,
  LocationFromLatlngStruct? locationFromLatlng,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (locationFromLatlng == null) {
    return;
  }
  if (locationFromLatlng.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && locationFromLatlng.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final locationFromLatlngData =
      getLocationFromLatlngFirestoreData(locationFromLatlng, forFieldValue);
  final nestedData =
      locationFromLatlngData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      locationFromLatlng.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLocationFromLatlngFirestoreData(
  LocationFromLatlngStruct? locationFromLatlng, [
  bool forFieldValue = false,
]) {
  if (locationFromLatlng == null) {
    return {};
  }
  final firestoreData = mapToFirestore(locationFromLatlng.toMap());

  // Add any Firestore field values
  mapToFirestore(locationFromLatlng.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLocationFromLatlngListFirestoreData(
  List<LocationFromLatlngStruct>? locationFromLatlngs,
) =>
    locationFromLatlngs
        ?.map((e) => getLocationFromLatlngFirestoreData(e, true))
        .toList() ??
    [];
