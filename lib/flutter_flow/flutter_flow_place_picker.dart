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
class _GoogleMapsAttribution extends StatelessWidget {
  const _GoogleMapsAttribution();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Google Maps',
            maxLines: 1,
            softWrap: false,
            semanticsLabel: 'Google Maps',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isLight ? const Color(0xFF5E5E5E) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
