import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'producer_navbar_model.dart';
export 'producer_navbar_model.dart';

class ProducerNavbarWidget extends StatefulWidget {
  const ProducerNavbarWidget({
    super.key,
    int? index,
  }) : this.index = index ?? 0;

  final int index;

  @override
  State<ProducerNavbarWidget> createState() => _ProducerNavbarWidgetState();
}

class _ProducerNavbarWidgetState extends State<ProducerNavbarWidget> {
  late ProducerNavbarModel _model;

  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProducerNavbarModel());

    if (!isWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        safeSetState(() {
          _isKeyboardVisible = visible;
        });
      });
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    if (!isWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (isWeb
              ? MediaQuery.viewInsetsOf(context).bottom > 0
              : _isKeyboardVisible) ==
          false,
      child: Container(
        width: double.infinity,
        height: 80.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (widget!.index != 0) {
                    context.pushNamed(
                      ProducerHomeWidget.routeName,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FaIconData(const IconData(/* home */ 0xf015,
                          fontFamily: 'FontAwesomeRegular',
                          fontPackage: 'font_awesome_flutter')),
                      color: widget!.index == 0
                          ? FlutterFlowTheme.of(context).primarytheme
                          : FlutterFlowTheme.of(context).textsecondary,
                      size: 24.0,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'd9myslwe' /* Home */,
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            color: widget!.index == 0
                                ? FlutterFlowTheme.of(context).primarytheme
                                : FlutterFlowTheme.of(context).textsecondary,
                            fontSize: widget!.index == 0 ? 18.0 : 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (widget!.index != 1) {
                    context.pushNamed(
                      InsightsWidget.routeName,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FFIcons.kinsights,
                      color: widget!.index == 1
                          ? FlutterFlowTheme.of(context).primarytheme
                          : FlutterFlowTheme.of(context).textsecondary,
                      size: 24.0,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        '3o3olmjy' /* Insights */,
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            color: widget!.index == 1
                                ? FlutterFlowTheme.of(context).primarytheme
                                : FlutterFlowTheme.of(context).textsecondary,
                            fontSize: widget!.index == 1 ? 18.0 : 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (widget!.index != 2) {
                    context.pushNamed(
                      ProducerchatWidget.routeName,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FFIcons.kchat,
                      color: widget!.index == 2
                          ? FlutterFlowTheme.of(context).primarytheme
                          : FlutterFlowTheme.of(context).textsecondary,
                      size: 24.0,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'pdli8qaq' /* Chat */,
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            color: widget!.index == 2
                                ? FlutterFlowTheme.of(context).primarytheme
                                : FlutterFlowTheme.of(context).textsecondary,
                            fontSize: widget!.index == 2 ? 18.0 : 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (widget!.index != 3) {
                    context.pushNamed(
                      ProducerProfileWidget.routeName,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: widget!.index == 3
                          ? FlutterFlowTheme.of(context).primarytheme
                          : FlutterFlowTheme.of(context).textsecondary,
                      size: 24.0,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        '2fojvjug' /* Profile */,
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Satoshi',
                            color: widget!.index == 3
                                ? FlutterFlowTheme.of(context).primarytheme
                                : FlutterFlowTheme.of(context).textsecondary,
                            fontSize: widget!.index == 3 ? 18.0 : 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
