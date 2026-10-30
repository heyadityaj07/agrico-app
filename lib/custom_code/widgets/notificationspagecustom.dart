// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/push_notifications/push_notifications_handler.dart';
import '/components/no_chat_producer_widget.dart';
import 'package:translator/translator.dart';

// ─────────────────────────────────────────────
// Single shared translator instance + cache
// ─────────────────────────────────────────────
final _translator = GoogleTranslator();
final Map<String, String> _translationCache = {};

Future<String> _translateText(String text, String targetLang) async {
  // Skip translation for English or empty text
  if (targetLang == 'en' || text.trim().isEmpty || text == 'null') return text;

  final cacheKey = '${targetLang}__$text';

  // Return from cache if already translated
  if (_translationCache.containsKey(cacheKey)) {
    return _translationCache[cacheKey]!;
  }

  try {
    final result = await _translator
        .translate(text, from: 'en', to: targetLang)
        .timeout(const Duration(seconds: 8));
    _translationCache[cacheKey] = result.text;
    return result.text;
  } catch (_) {
    // Silently fall back to original text
    return text;
  }
}

/// ───────────────────────────────────────────── Main Widget
/// ─────────────────────────────────────────────
class Notificationspagecustom extends StatefulWidget {
  const Notificationspagecustom({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Notificationspagecustom> createState() =>
      _NotificationspagecustomState();
}

class _NotificationspagecustomState extends State<Notificationspagecustom> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    _clearNotificationCount();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    final userRef = currentUserReference;
    if (userRef == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final notifications = await getAllUserPushNotifications(userRef);
    if (!mounted) return;

    setState(() {
      _notifications = notifications.toList().cast<dynamic>();
      _isLoading = false;
    });
  }

  Future<void> _clearNotificationCount() async {
    final userRef = currentUserReference;
    if (userRef == null) return;
    await userRef.update(createUsersRecordData(notificationCount: 0));
  }

  String _getNotificationString(
    dynamic notification,
    String snakeCaseKey,
    String camelCaseKey,
  ) {
    final value = notification is Map
        ? notification[snakeCaseKey] ?? notification[camelCaseKey]
        : null;
    return value?.toString() ?? '';
  }

  Future<void> _openNotification(dynamic notification) async {
    final initialPageName = _getNotificationString(
      notification,
      'initial_page_name',
      'initialPageName',
    );
    final parameterData = _getNotificationString(
      notification,
      'parameter_data',
      'parameterData',
    );

    if (initialPageName.isEmpty) {
      showSnackbar(context, 'This notification cannot be opened.');
      return;
    }

    final parametersBuilder = parametersBuilderMap[initialPageName];
    if (parametersBuilder == null) {
      showSnackbar(context, 'This notification cannot be opened.');
      return;
    }

    final initialParameterData =
        getInitialParameterData({'parameterData': parameterData});
    final routeParameterData = await parametersBuilder(initialParameterData);

    if (!mounted) return;

    context.pushNamed(
      initialPageName,
      pathParameters: routeParameterData.pathParameters,
      extra: routeParameterData.extra,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = FFLocalizations.of(context).languageCode;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: _buildBody(context, currentLang),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String currentLang) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return NoChatProducerWidget(
        message: FFLocalizations.of(context).getText(
          '67vgeyih' /* No Notification Found */,
        ),
        submsg: ' ',
        index: 0,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _NotificationTile(
          notification: notification,
          currentLang: currentLang,
          onTap: () async => _openNotification(notification),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Notification Tile — translates dynamically
// ─────────────────────────────────────────────
class _NotificationTile extends StatefulWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.currentLang,
  });

  final dynamic notification;
  final Future<void> Function() onTap;
  final String currentLang;

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  late Future<_TranslatedNotif> _translationFuture;

  @override
  void initState() {
    super.initState();
    _translationFuture = _buildTranslation();
  }

  Future<_TranslatedNotif> _buildTranslation() async {
    final rawTitle =
        getJsonField(widget.notification, r'''$.notification_title''')
                ?.toString() ??
            '';
    final rawText =
        getJsonField(widget.notification, r'''$.notification_text''')
                ?.toString() ??
            '';

    // English — return immediately, no API call
    if (widget.currentLang == 'en') {
      return _TranslatedNotif(title: rawTitle, text: rawText);
    }

    // Translate title and body in parallel for speed
    final results = await Future.wait([
      _translateText(rawTitle, widget.currentLang),
      _translateText(rawText, widget.currentLang),
    ]);

    return _TranslatedNotif(title: results[0], text: results[1]);
  }

  @override
  Widget build(BuildContext context) {
    final rawTitle =
        getJsonField(widget.notification, r'''$.notification_title''')
            .toString();
    final rawText =
        getJsonField(widget.notification, r'''$.notification_text''')
            .toString();
    final timestamp =
        getJsonField(widget.notification, r'''$.timestamp''').toString();

    return FutureBuilder<_TranslatedNotif>(
      future: _translationFuture,
      builder: (context, snap) {
        final isTranslating = snap.connectionState != ConnectionState.done &&
            widget.currentLang != 'en';

        // Show original while translating — no blank flicker
        final title = snap.data?.title ?? rawTitle;
        final text = snap.data?.text ?? rawText;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: icon ──
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12, top: 2),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20,
                    ),
                  ),

                  // ── Middle: title + body ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        isTranslating
                            ? _ShimmerBox(
                                width: 160,
                                height: 14,
                                radius: 4,
                              )
                            : Text(
                                title,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textprimary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                        const SizedBox(height: 4),

                        // Body text
                        isTranslating
                            ? _ShimmerBox(
                                width: 220,
                                height: 12,
                                radius: 4,
                              )
                            : Text(
                                text,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Satoshi',
                                      color: FlutterFlowTheme.of(context)
                                          .textsecondary,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                        const SizedBox(height: 6),

                        // Timestamp
                        Text(
                          formatDateTimeString(timestamp),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Satoshi',
                                color:
                                    FlutterFlowTheme.of(context).textsecondary,
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Shimmer placeholder shown while translating
// ─────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 4,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.25, end: 0.6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data class for translated result
// ─────────────────────────────────────────────
class _TranslatedNotif {
  const _TranslatedNotif({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;
}
