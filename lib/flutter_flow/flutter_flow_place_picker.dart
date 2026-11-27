// http and google_maps_webservice come with flutter_google_places.
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart' as legacy_places;
import 'package:http/http.dart' as http;

import 'flutter_flow_widgets.dart';
import 'lat_lng.dart';
import 'place.dart';

class FlutterFlowPlacePicker extends StatefulWidget {
  const FlutterFlowPlacePicker({
    super.key,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
    required this.defaultText,
    this.icon,
    required this.buttonOptions,
    required this.onSelect,
    this.proxyBaseUrl,
  });

  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;
  final String? defaultText;
  final Widget? icon;
  final FFButtonOptions buttonOptions;
  final Function(FFPlace place) onSelect;

  /// Where legacy Places API requests go on the web. Places API (New)
  /// requests never use it.
  final String? proxyBaseUrl;

  @override
  State<FlutterFlowPlacePicker> createState() => _FFPlacePickerState();
}

class _FFPlacePickerState extends State<FlutterFlowPlacePicker> {
  String? _selectedPlace;

  String get googleMapsApiKey {
    if (kIsWeb) {
      return widget.webGoogleMapsApiKey;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
      case TargetPlatform.iOS:
        return widget.iOSGoogleMapsApiKey;
      case TargetPlatform.android:
        return widget.androidGoogleMapsApiKey;
      default:
        return widget.webGoogleMapsApiKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return FFButtonWidget(
      text: _selectedPlace ?? widget.defaultText ?? 'Search places',
      icon: widget.icon,
      onPressed: () => _searchPlaces(languageCode),
      options: widget.buttonOptions,
    );
  }

  Future<void> _searchPlaces(String languageCode) async {
    // One search, from opening the overlay to the details of the picked
    // place, is one Google session.
    final session = _PlacesSession(
      apiKey: googleMapsApiKey,
      languageCode: languageCode,
      proxyBaseUrl: widget.proxyBaseUrl,
    );
    try {
      final suggestion = await showDialog<_PlaceSuggestion>(
        context: context,
        builder: (_) => _PlaceSearchOverlay(session: session),
      );
      if (suggestion == null) {
        return;
      }
      final FFPlace place;
      try {
        place = await session.details(suggestion.placeId);
      } catch (e) {
        debugPrint('Error occurred when getting place details:\n$e');
        return;
      }
      if (mounted) {
        setState(() => _selectedPlace = place.name);
      }
      widget.onSelect(place);
    } finally {
      session.close();
    }
  }
}

class _PlaceSuggestion {
  const _PlaceSuggestion(this.placeId, this.description);

  final String placeId;
  final String description;
}

class _PlacesException implements Exception {
  const _PlacesException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The requests of one search. They share one session token and one HTTP
/// client, and go to Places API (New) unless Google said that API is off
/// for this key.
class _PlacesSession {
  _PlacesSession({
    required this.apiKey,
    required this.languageCode,
    this.proxyBaseUrl,
  });

  static const _placesHost = 'places.googleapis.com';
  static const _detailsFieldMask =
      'id,displayName,formattedAddress,location,addressComponents';

  /// The keys whose Google Cloud project has Places API (New) off, or whose
  /// API restrictions leave it out. Their searches use the legacy Places API
  /// for as long as the app runs.
  static final _legacyKeys = <String>{};

  final String apiKey;
  final String languageCode;
  final String? proxyBaseUrl;
  final String sessionToken = _newSessionToken();
  final http.Client _client = http.Client();
  Map<String, String>? _platformHeaders;
  legacy_places.GoogleMapsPlaces? _legacyPlaces;

  bool get _useLegacy => _legacyKeys.contains(apiKey);

  /// The app's package or bundle id, which keys restricted to an Android or
  /// iOS app check.
  Future<Map<String, String>> _appHeaders() async =>
      _platformHeaders ??= await const GoogleApiHeaders().getHeaders();

  Future<Map<String, String>> _headers() async => {
        ...await _appHeaders(),
        'X-Goog-Api-Key': apiKey,
      };

  Future<List<_PlaceSuggestion>> autocomplete(String input) async {
    if (!_useLegacy) {
      final response = await _client.post(
        Uri.https(_placesHost, '/v1/places:autocomplete'),
        headers: {...await _headers(), 'Content-Type': 'application/json'},
        body: jsonEncode({
          'input': input,
          'languageCode': languageCode,
          'sessionToken': sessionToken,
        }),
      );
      if (!_newApiIsOff(response)) {
        final suggestions = _decode(response)['suggestions'];
        return [
          if (suggestions is List)
            for (final suggestion in suggestions.whereType<Map>())
              if (suggestion['placePrediction']
                  case {
                    'placeId': final String placeId,
                    'text': {'text': final String description},
                  })
                _PlaceSuggestion(placeId, description),
        ];
      }
    }
    final response = await (await _legacy()).autocomplete(
      input,
      language: languageCode,
      sessionToken: sessionToken,
      types: [],
      components: [],
      strictbounds: false,
    );
    if (response.errorMessage?.isNotEmpty == true ||
        response.status == 'REQUEST_DENIED') {
      throw _legacyError(response.status, response.errorMessage);
    }
    return [
      for (final prediction in response.predictions)
        if (prediction.placeId != null)
          _PlaceSuggestion(
            prediction.placeId!,
            prediction.description ?? '',
          ),
    ];
  }

  Future<FFPlace> details(String placeId) async {
    if (!_useLegacy) {
      final response = await _client.get(
        Uri.https(_placesHost, '/v1/places/$placeId', {
          'languageCode': languageCode,
          'sessionToken': sessionToken,
        }),
        headers: {
          ...await _headers(),
          'X-Goog-FieldMask': _detailsFieldMask,
        },
      );
      if (!_newApiIsOff(response)) {
        return _placeFromNewApi(_decode(response));
      }
    }
    final response = await (await _legacy()).getDetailsByPlaceId(
      placeId,
      language: languageCode,
      sessionToken: sessionToken,
    );
    if (response.errorMessage?.isNotEmpty == true ||
        response.status == 'REQUEST_DENIED') {
      throw _legacyError(response.status, response.errorMessage);
    }
    return _placeFromLegacyApi(response.result);
  }

  void close() => _client.close();

  /// The legacy API only runs after Google said Places API (New) is off for
  /// this key, so a legacy failure means neither API works. Turning on
  /// Places API (New) is the fix, since Google no longer lets new projects
  /// turn on the legacy API.
  static _PlacesException _legacyError(String status, String? message) =>
      _PlacesException(
        'Places API (New) is not enabled for this API key. Enable '
        '"Places API (New)" in Google Cloud, and allow it in the key\'s API '
        'restrictions. The legacy Places API answered $status: '
        '${message ?? ''}',
      );

  Future<legacy_places.GoogleMapsPlaces> _legacy() async =>
      _legacyPlaces ??= legacy_places.GoogleMapsPlaces(
        apiKey: apiKey,
        baseUrl: proxyBaseUrl,
        httpClient: _client,
        apiHeaders: await _appHeaders(),
      );

  /// Whether [response] is Google saying Places API (New) is off for this
  /// key: the API is not enabled in the key's project (`SERVICE_DISABLED`),
  /// or the key's API restrictions leave it out (`API_KEY_SERVICE_BLOCKED`).
  /// Then this key switches to the legacy API.
  bool _newApiIsOff(http.Response response) {
    if (response.statusCode < 400) {
      return false;
    }
    final Object? body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      return false;
    }
    final details =
        body is Map && body['error'] is Map ? body['error']['details'] : null;
    final isOff = details is List &&
        details.any(
          (detail) =>
              detail is Map &&
              detail['domain'] == 'googleapis.com' &&
              (detail['reason'] == 'SERVICE_DISABLED' ||
                  detail['reason'] == 'API_KEY_SERVICE_BLOCKED'),
        );
    if (isOff) {
      _legacyKeys.add(apiKey);
    }
    return isOff;
  }

  static Map<String, dynamic> _decode(http.Response response) {
    final Object? body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw _PlacesException('Places API (New) ${response.statusCode}');
    }
    if (response.statusCode != 200 || body is! Map<String, dynamic>) {
      final error = body is Map ? body['error'] : null;
      throw _PlacesException(
        'Places API (New) ${response.statusCode}: '
        '${error is Map ? error['message'] : body}',
      );
    }
    return body;
  }

  static FFPlace _placeFromNewApi(Map<String, dynamic> json) {
    final components = [
      if (json['addressComponents'] case final List components)
        ...components.whereType<Map>(),
    ];
    String? shortText(String type) {
      final component = components.firstWhereOrNull(
        (c) => c['types'] is List && (c['types'] as List).contains(type),
      );
      if (component == null) {
        return null;
      }
      return (component['shortText'] ?? component['longText'] ?? '') as String;
    }

    final location = json['location'];
    final displayName = json['displayName'];
    return FFPlace(
      latLng: LatLng(
        location is Map ? (location['latitude'] as num?)?.toDouble() ?? 0 : 0,
        location is Map ? (location['longitude'] as num?)?.toDouble() ?? 0 : 0,
      ),
      name: displayName is Map ? displayName['text'] as String? ?? '' : '',
      address: json['formattedAddress'] as String? ?? '',
      city: shortText('locality') ?? shortText('sublocality') ?? '',
      state: shortText('administrative_area_level_1') ?? '',
      country: shortText('country') ?? '',
      zipCode: shortText('postal_code') ?? '',
    );
  }

  static FFPlace _placeFromLegacyApi(legacy_places.PlaceDetails result) {
    String? shortName(String type) => result.addressComponents
        .firstWhereOrNull((e) => e.types.contains(type))
        ?.shortName;
    return FFPlace(
      latLng: LatLng(
        result.geometry?.location.lat ?? 0,
        result.geometry?.location.lng ?? 0,
      ),
      name: result.name,
      address: result.formattedAddress ?? '',
      city: shortName('locality') ?? shortName('sublocality') ?? '',
      state: shortName('administrative_area_level_1') ?? '',
      country: shortName('country') ?? '',
      zipCode: shortName('postal_code') ?? '',
    );
  }

  /// A version 4 UUID, the session token format Google recommends.
  static String _newSessionToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return [
      hex.substring(0, 8),
      hex.substring(8, 12),
      hex.substring(12, 16),
      hex.substring(16, 20),
      hex.substring(20),
    ].join('-');
  }
}

/// The search overlay: a search bar on top, the suggestions below it, and
/// the Google Maps attribution.
class _PlaceSearchOverlay extends StatefulWidget {
  const _PlaceSearchOverlay({required this.session});

  final _PlacesSession session;

  @override
  State<_PlaceSearchOverlay> createState() => _PlaceSearchOverlayState();
}

class _PlaceSearchOverlayState extends State<_PlaceSearchOverlay> {
  static const _debounce = Duration(milliseconds: 300);

  final _query = TextEditingController();
  Timer? _debounceTimer;
  String _searchedText = '';
  int _searchCount = 0;
  bool _searching = false;
  List<_PlaceSuggestion> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _query.removeListener(_onQueryChanged);
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => _search(_query.text));
  }

  Future<void> _search(String input) async {
    if (!mounted || input == _searchedText) {
      return;
    }
    _searchedText = input;
    final search = ++_searchCount;
    if (input.isEmpty) {
      setState(() {
        _searching = false;
        _suggestions = const [];
      });
      return;
    }
    setState(() => _searching = true);
    List<_PlaceSuggestion> suggestions;
    try {
      suggestions = await widget.session.autocomplete(input);
    } catch (e) {
      debugPrint('Error occurred when getting places response:\n$e');
      suggestions = const [];
    }
    // A later search's results replace this one's.
    if (!mounted || search != _searchCount) {
      return;
    }
    setState(() {
      _searching = false;
      _suggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final background = _dialogBackgroundColor(theme);
    const corner = Radius.circular(2);
    final header = Column(
      children: [
        Material(
          color: background,
          borderRadius: const BorderRadius.only(
            topLeft: corner,
            topRight: corner,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                color: isLight ? Colors.black45 : null,
                icon: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? Icons.arrow_back_ios
                      : Icons.arrow_back,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextField(
                    controller: _query,
                    autofocus: true,
                    style: TextStyle(
                      color: isLight ? Colors.black87 : null,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: isLight ? Colors.black45 : null,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );

    const bodyCorners = BorderRadius.only(
      bottomLeft: corner,
      bottomRight: corner,
    );
    final Widget body;
    if (_searching) {
      body = Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 2),
            child: const LinearProgressIndicator(),
          ),
        ],
      );
    } else if (_query.text.isEmpty || _suggestions.isEmpty) {
      body = Material(
        color: background,
        borderRadius: bodyCorners,
        child: const _GoogleMapsAttribution(),
      );
    } else {
      body = SingleChildScrollView(
        child: Material(
          color: background,
          borderRadius: bodyCorners,
          child: ListBody(
            children: [
              for (final suggestion in _suggestions)
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    suggestion.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  onTap: () => Navigator.pop(context, suggestion),
                ),
              const _GoogleMapsAttribution(),
            ],
          ),
        ),
      );
    }

    final overlay = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Stack(
        children: [
          header,
          Padding(padding: const EdgeInsets.only(top: 48), child: body),
        ],
      ),
    );
    if (theme.platform == TargetPlatform.iOS) {
      return Padding(padding: const EdgeInsets.only(top: 8), child: overlay);
    }
    return overlay;
  }

  /// The theme's dialog background color, as the deprecated
  /// `ThemeData.dialogBackgroundColor` defaults it.
  static Color _dialogBackgroundColor(ThemeData theme) =>
      theme.dialogTheme.backgroundColor ??
      (theme.useMaterial3
          ? theme.colorScheme.surface
          : theme.brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.white);
}

/// Google's required attribution for Places results shown without a map.
/// Google's policy asks for the Google Maps logo wherever it fits, unmodified
/// and 16 to 19dp tall: the plain (not outlined) logo on a plain background,
/// gray on a light one and white on a dark one.
class _GoogleMapsAttribution extends StatelessWidget {
  const _GoogleMapsAttribution();

  static final _grayLogo = base64Decode(_kGoogleMapsLogoGray4x);
  static final _whiteLogo = base64Decode(_kGoogleMapsLogoWhite4x);

  @override
  Widget build(BuildContext context) {
    final background =
        _PlaceSearchOverlayState._dialogBackgroundColor(Theme.of(context));
    final onDark =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          // More than Google's minimum clear space: 10dp on the left, right
          // and top, 5dp below.
          padding: const EdgeInsets.all(16),
          child: Image.memory(
            onDark ? _whiteLogo : _grayLogo,
            scale: 4,
            height: 18,
            filterQuality: FilterQuality.medium,
            semanticLabel: 'Google Maps',
          ),
        ),
      ],
    );
  }
}

// GoogleMaps_Logo_Gray_4x.png and GoogleMaps_Logo_White_4x.png, unmodified,
// from Google's Maps attribution assets
// (developers.google.com/maps/documentation/places/web-service/policies).
const _kGoogleMapsLogoGray4x =
    'iVBORw0KGgoAAAANSUhEUgAAAYgAAABICAYAAADs3GImAAAAGXRFWHRTb2Z0d2FyZQBBZG9i'
    'ZSBJbWFnZVJlYWR5ccllPAAAE7NJREFUeNrsXf1Z4zgTF3n4/3IVnKmAUAFOBRsaOJwKIBWE'
    'VECoALMNECrAWwHZCvBVcLkK9vWE0b5ebyyNpPFHzPyex89xC3Gk0Wi+NJo5Ucz4+++/o+I/'
    'cfGcF88En7HhI9vi2RXPt+LJvn79mimBQCAQdI4TRqWQFM8XVAih2BTPU6EsNrJEAgPfjS38'
    'tit4aCuUEgj8cBq4QcFTuEblwIkZPMX7c1AUxbMuNvpOlktQASiHV8PvwRudCpkEAj+MfD2G'
    '4nnEzZk0OD7wTJbF81Z8XyLLJRAIBD1WEIWgvgWB3bBiOKQoHovvfsVwlkAgEAj6oiAg3gsC'
    'uvjxXpkPnZtEjN7ETJZOIBAImgXpDKIQyBDrfUZLvmuAcnouxjT/+vVrKkso+Mwo9sGPml/B'
    'md1Z12d3aFTGh35XjO1EVvDIPQhUDq8MygGySbLSkwe+7xHDXQKB4LAh1en+wHPDWJZioB5E'
    'STm4hpTAaoEU1RdQDIWlkFu+A5joUn1kL7koHPEgBIJ6LIv9lZr2X4PKAWTGUpZgoArCUzmA'
    'Z/DkEvrBPHV41shUYPXcKPvluqmkvgoEVsCZ4VUH33ur+hGSFgRgZND+LsoBBPVVIbCnIecC'
    'IPCL56748ax4VqIcBIJgzPC+UpveQ4RGnmCICkJ9HEhTlQOEks44bz2XFMWF+vWsQpSDQODn'
    'RbSJpeou01HQpIIotD8IZqrFsSqE9VVTAhvDTxeoGEQ5CAR+mLR10RS9lURIPkAFgecO1IOl'
    'OVr5jQIVwlSUg0AQ5kVg6LgN70EwEJx6uqKLNu8giGIQCIKhE0AaM+okrXXAHgS6hpTFhbS5'
    'tZBOIDg6LJsqVSNprQNXEMTFzcF7ELIJBEeLpg6sJa11qAqidFnNhrmEewSCowZ72quktQ7f'
    'g7gm/K10exMIjgebFr0IU1prKktxvNCH1JQSF6vPSKCarmV5F+ULasb3W0vXPijyvtONgc59'
    '71b3XX1cYE0O/G6f9sqRaGJJawX6PClJez1eBYGMH1n+bvtZvAd0l0Fh6vap45q/0xsA6PLS'
    'Fn2w1DmMLa5bNxxbjuODelibNkKDmMWix1ZHN12n66nPPIWCT89lYqBzVqJx35TfAnn50FpA'
    '2isHXywt39/0Pj03yK9veo+2GRpH40iPrco7O1TejUVkSrT5q4Z3t6UxGHn2BCui2lzOxdAz'
    'l1Ag3Ci3goG/WMfq4+Jg2hDDUWpUmZDi+PIGxnfnObYMeWuL9De1D11V790QPgMbYOo4lwSF'
    'XtQnGhvG+8NEL1ybJZWmHrR6rPk1KJ8r0xr5lPvG77xR5l7kdWvjbJTg913XGM2LQBkCyuJB'
    'MbRULiklV97NlKF+HpxBXBJeslEDBTZC0u1TQxoRwaJACfJ3zkNAVODvKrx8ATD6OwoMtrAL'
    'zDdgbECntz6Ubce5vKHAi/pC41CgAqhTWN5pr4S01kWD6zPxXBvoSPnoeGEwQj6tPpOKDHn2'
    'kCGahu8hN90xquDLuzHKrTeMJv2mIGzEOtq4MYXpUPgmjK+NkBHvAsemmY67g98SmSEKHF+C'
    'TBkxjOledZhDj3N59RQ8dTR+benmMgUrC+19YEprLXtRY4b1mTGuj1biE2YZEmJcjlFIuyov'
    'hcYtRzO3CRprSVVB2KzdoSoHLeCa2sRLXDxf6yzUo6Eww8RzfI+G0IIv4g754LEBPqgNrXTg'
    'RaQYSjgE57RXS1orhErWFV4LXZ9n5vUZoxEXOjbffjk2L2fssA8TZnZ5LCsJSsvRLfOGvGe0'
    '1ExY1GWZWGKnnEjgILMYx9xDOTRNI71Jpi7ZOLh+iRoAWuADCIs8uqw/Iy4PeBGxwYu4cDF+'
    'DEJxwXUgjAL4sU/8X/k8t+LSCvXVth4YoWhqH4KSgDOW7Yjwx/81QIC4hWdsYLo2yx8nKFSp'
    'eG5Jgf5kcgeLJVEdt7FkVA5t8UHShzMWPJxNDYosIdItNgimLVeSBvLkM9GABeU3rTwrgnE7'
    'DlBApuxP+N4FjuMMD+Ph57mi3QuZmKIPSBvbxcQMv+8Cvl8/OI4FITJ0T/UgjhVx1a0uMR1V'
    '6wMRH3DB92cxuEGAMb44hIBui899s/XMcCy1Xm7rmmMmUFQZW0R4T4Sb5IoQVnARqOWxZZ5j'
    'axIuYaV9Wq4qpUvifGJFyxrRKaV5x3NeqfC017YOpm2lO4CWc0NWEvz7He5X0+Et250Q05hK'
    '/5YW37fAvZRYDIuXGpmRGHh3h2PYGAwFeNaWDNYYaDdkBeHDdFYiVxZaC02KooANWJuPje+i'
    'HtRCjHdVfRcKoBwZYIEMQMkwgjj0zKLAqAI1Q9rllrHdqY4OppEuFC9tiyGTQxs+R2swJc7l'
    'Ea23Lr0IMHAeasZqrfZqqda6afFey0YRy/6gcXKhzGHbGxV+4xvmfkUc016+gNFo8WDqZIYp'
    '83RBbd4GVxfwXtKhMQA98pH6JHAQwFtF7JAHGw5yvYmWU2QJz1BcXd3adUFkxDUKJYrlem+g'
    '3UzRK/1OKZZyqWNgF7W9bohCaEoRejgXGw/Ebbf+NBgXdetTm/badlprpfXw7oCVvnN4l+4p'
    'szV4ESEe7Rb5fuc4xxTDQK4yo9Z7cPWE8O/TEm1hHf+EczPYxxQF8cdAdARFKHh1rUNBPPcd'
    'QylcYcPUtbUrHsBNCYI4MsShKbRLXQ9jcWxXLRsKCcGLzDw6JW4INO68oB3OySftlZrWyurx'
    'gKIonj9xf2mPbuc5b5MSC7kgOw2YY2oZ17XD63yNrRUanmAY/3Jpj6IgJmoYSAjE9e5ahwtt'
    'E97jGiFMERwL39o/uHkpgvj6gEClVPrd+mbqoIXeZp2vLxQvzUHhQHgOwhfvihbKi7reCK5p'
    'r45prY2NuXguXA2kA7xWt4fOPV8bnLWFBubWYLhRlVfk46WiIj5I15GBUQajIJBots27YkjP'
    'mxO0+BcP6yUPLXViyWIph0HGHpZVaHhhrdoLNc1CNzxeYrzDW+TPyu0OR9KTbeHiRZjOsVZH'
    '1gIgM4RznL2HEIVVwYODzDB5a89clwABp8oen4bNMOGqXOlaG8ewSe+VOaZfnpdtA+84ak3B'
    'RinGlVrGdcg6iwI2sysT2gRUXPGEbKVYgouOEenGZSjYsLF8/loN4B4IHt6mylLt1ZLWmndR'
    'ow0t6ks0XicG5ZWjZQ6HwTqLjDNt/4HTQ0KZNrbJDPWRHVi3JvD5N1zbl1AFBgriO9Hq6ltp'
    'Y5uWzB2EHGetqReLoAOFG5VithTLZcPEhJAKu7XQblL5PptQfWKi25Nq/o6Fjda/ZYyUiqD5'
    'FIgr8yLMb90za9ua9qrMB9OtXQAsFay8drD2tfE1w/lkzJ5qxjzNTY3gjyr7eINziS2ealKp'
    'Ov1NOVa2PcVB2fLbYVHueqYgYsKmLGtVE74xW2YUxs2J8+AuVZxZBJ1rLJbLs9wS6Na0gthW'
    'PLulQYBSaf3AGIbg9iJsaa+m1NCs5RL3HOVQYmb6cRvN/5i81wq9F4pe5kN7Wrf4rrykMIx3'
    'X0al/HTjxupJih45VFDJqnDxNjjAyTjcFqfNxR470plzrlnHrPUfhFZKh86Jh1DSh7ZnmPrY'
    '90rIprTXSdfeA4ZdmihpEYq8gXeS+b+Unegzjgh5G5Tuv1AUtG6vjxzCBMseLc51zwUNp1D/'
    'fgSMPRQscdP4GEOwYSF3/E+8p3IUdCakvR5UKm3MD8tN9LW0S96DtQOeu1DhWWT7arlYgTg6'
    'pCBSinsWUrOckWl0TNiEF5F1dg9BwALYOxeYgpke4wQsaa+HjJ9VC/s8UbRkAF1yZoWPvriq'
    '/z8bMvOBgsfGRVMVflYJhtEvVZ5P8UtyPJCyCV599btL7XlLEHJdM0XE+K5L5rG5KIidEtRZ'
    'jxC7T48sxdOEFdFzajytFY3Ae8IakDs4BnYKbHqPcygKkHlZpWVy7CkfwJO4qN6kfiB++Lkr'
    'Ilgu7Px09Q/ExW0KI2Zmbhfm2bXMiOeEjVd2YW3zjRnHFqt+Q5ff+O3G6QAs0YwQSWgrrTWx'
    'GDLaa0sd5gfK/EzxZSw2oSBihnXMkTenpeqtK0W76V+W8/vSPyNHBgFMfBvhMIByWPXgIYTP'
    'W17kbc3PBxmR+fatbXz/ONKOszNX0/DxLHVI5QzLbww5ZLGyrHdbaa1fLAbgPEA5s53pNcCz'
    'fxFlhpPix3IlV1iyBM4sKOW+97XDRo4M8lPDt60k8PsmhM18yEKwpbFylkCweTh5hbkpC58w'
    '0ZCSspk5CtWblujGgdzhb2He+tD5bqhtd6vWpyGSkLWoHE1GTGjtrsuWxsn5vh2XtwpRAfQw'
    'zlBRmN57MzrAINSyCYlPD1WfkA32ZqYIybr4KIWxlwxjjQlMk1VoviMoiRsmOi8JDFSlle3A'
    'PwpNXiAmHnAJQIqgv0AXPQ2YU6SOE3VlT+Y9GNs2RFEjn3EKdTajBo23iNHzpeyHtUXh/uZB'
    'VMu/Uizb16bCA6WerzMi86zrtCZBMCQh8XTiwVqdwLWlGYd0vtLjuyN4YIfWnRKzvQ9UYE30'
    'hK4DZT4zBlq/43+PzYvQxQpXpWfeEw8q9M4Nd8os5/2wG0eZsZePaKT/8B2HpYDhuK6a68Jh'
    'MUDovGHxMpZNrouhwXsVPcZts3Aoh/Ahha4ovbbrintRFPLMN6xXyuCw4alGYNjGpzMfxp5j'
    'm7UoZCh8sPTdcBVaw3veWjpf4VQSOm6tn7QnQxsHyJSJauYuV3AUBRtYxVSjBi9zvqF8TBgi'
    'ILVRgpHBinC9pbfUVpOvew2fw5uT744TnhMyblJlP1/Rgi52GPMYb95SwiwrA70p2SHOZz/I'
    'fJTPmGLMlLz3CdIuamBsnMIvJyrkZ4cyy6b5/DSglCAUvkpbRyKaQBTCw4Te6L+kUqNiOHQe'
    'Gwf0Pj93UhAVV9PlcGRcUhTaq4gNXaomWE//Hif+rmj3HMpYUywchxujWkk82oQdWovvRMa1'
    'NXR3SRB4sykxpPuroveRXlmEKkWBaWF4a7Kq0BBwGRs3KLQeo5Kg8AGF1kfpTfQslDRGA9JH'
    'OTQZwpz5nMfiHn513JcmD/je9TwQ6VNnCOWnFqG6xX6uz8o9nVEXiFriQJpYmBRvEVKtR+jB'
    'Sr1AkqAwBqv6GwqUHVoM5/gOKkPse9DaFFjxXXNFu2eirXUQ3DC+f3BTwb//gWNzWa81IUNF'
    'V/60eQj6LGaJtPuOnqj+3BfVcY8RvBi6IioozQcbnMsW1xPm8JcjrSMloCAz0PQWZYnxwl6p'
    '+mtbJYKAT8DgXdj2ksPYVgd6u0NZcFNl4UesFm31WNHwMXk/2SlxM02VubJjF1i7KIcSwCt6'
    'c9issQrPfCB1g8MyvmtFP0yLVHgKbEahIyqwKwdrTGcmzfoogdBYOHegH8dcFg1UAB0iHix7'
    '4BaVNnjkL1ogo+CdoBGSqPbLymjDDcbzpEqXdj3GtjUI+TnKMJO3eo103FSVDHoN14RxPI2I'
    'mwnycDmKQnFgb417Kgff0FkI5o43PmFeaUtjc+oJ7dDf+ljgkozRKh98ZhDPibQV/opZPD+K'
    'n/9FA8YUpt4y7p2dwagEy/zNcWxlGTe17ENbUk6EHvI7jgHG8o5jeSOMAxRLNnJcOF0UKu+I'
    'd/YCKnSjBZbKbVwoYH/ntCVa7jxptxuAINIbcdNHPvjkaEJ57z0OpndFKvzSXq1ysO1Lx+sI'
    '2ruJHGTDXgGNPDYVuE/gTaxaFBL7A2asmMnWoAbnkTU03qsQoYBKYtEQPddIy10A7aaMG3jX'
    '4Fwp3vFVQ97xjsOg+aRexI6Zx1LcU1wYoyyk9KF3MdrIMq4hGfGL4TgK2FR3xY9nDSuKch2c'
    'u4aEw1TZr5y7WilnHI1i8OIfpxLLcfEXDGPTSmLFMSbVcUvbBrzjDfJBpgRde3hrZuVQteQ5'
    '+HeNezP3kBFcfLupei+nDAsIgvsO06t0hlDI4ZCup/TSVjcuPLCEhXbteVtVDCvuG6daEGNK'
    'HGQv+ByUwjseuC1Zvf5IO9f2nPDZB9y8uz50LERhfoa8fK38khM2SGtRDHw8doV3Uu4d92aG'
    'ezJreIx7y9+zpPgGx7gN4VvMNvWVX7V0OmmCYLjZIeZ1joPVJ/iHBqYFGKRqZn3I8ijlBuvx'
    'Tw4Ity0+zo3AA8cWoeC6LI1tfICuO/X/nrN5i7Sb4dgmlXXP8dnTrKr8CTnhqya8SAKtq3ww'
    'rng/ek7flaW/r4B1b2r+jyqGEND/hYvv8YLjskYwn3iOMW9yb5Zqwl3WyF6yfDgRlhP0ZOOD'
    '9WXKyb46gv7OguHxpbOCGBJGwgKCnsDWk0Msc4GgZZwKCQSelpW+CLdjsuxjy+/lgplAIApC'
    '0HPFEKmPw/JEfcQ3c+xTvgt8p+mWfi6xfYFAFISgv4oBvIVr9XsWFQh3iNGGpM7aaiJlsgIC'
    'QfuQMwgBRTnA4fGzqk+xvfXtKkfsB/EiqyAQiIIQ9BNPhL959Cg1DH9vq6W/k+wlgUAUhKCn'
    'wAs0GVFJPBP6J+i6/pRGKw+yAgJBN5AzCAEVcMbwRvi7fVls7J8AF3HK2Uex+khnpd4Gp3ba'
    'EwgEoiAEHXoRW2xoRG2vyNE/YS7ZSwJBd5AQk8BFSaSqvV4VqZw9CASiIATHpSTa6FWRNlV9'
    'UyAQiIIQNK8kmurfsBLlIBD0A3IGIfBVElAiHQ6g4UwiYnhlrj7OHDKhrqBH+NT8KNVcBcHA'
    'ipe+fTRy9BpSoaRAIApCMFxFUe4FEdf8me6loWvRSxE+gaCn+J8AAwDDQNl4BLfyWgAAAABJ'
    'RU5ErkJggg==';

const _kGoogleMapsLogoWhite4x =
    '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'
    'AG1TBdr/gacdAAAAAElFTkSuQmCC';
