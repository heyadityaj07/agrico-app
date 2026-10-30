import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'splashpage_model.dart';
export 'splashpage_model.dart';

class SplashpageWidget extends StatefulWidget {
  const SplashpageWidget({super.key});

  static String routeName = 'splashpage';
  static String routePath = '/splashpage';

  @override
  State<SplashpageWidget> createState() => _SplashpageWidgetState();
}

class _SplashpageWidgetState extends State<SplashpageWidget> {
  late SplashpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashpageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 2000,
        ),
      );

      context.goNamed(OnbordingWidget.routeName);
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFFAF9F6),
        body: Stack(
          children: [
            if (false)
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          0.0,
                          valueOrDefault<double>(
                            MediaQuery.sizeOf(context).width * 0.6,
                            0.0,
                          ),
                          0.0),
                      child: Container(
                        width: 240.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          color: Color(0x003BB273),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 190.0,
                              color: FlutterFlowTheme.of(context).primarytheme,
                              offset: Offset(
                                5.0,
                                55.0,
                              ),
                              spreadRadius: 15.0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'xgg3k977' /* Agricoo */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).textprimary,
                          fontSize: 40.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          valueOrDefault<double>(
                            MediaQuery.sizeOf(context).width * 0.6,
                            0.0,
                          ),
                          0.0,
                          0.0,
                          0.0),
                      child: Container(
                        width: 230.0,
                        height: 280.0,
                        decoration: BoxDecoration(
                          color: Color(0x0C1BE278),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 190.0,
                              color: FlutterFlowTheme.of(context).primarytheme,
                              offset: Offset(
                                15.0,
                                15.0,
                              ),
                              spreadRadius: 20.0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(500.0),
                            bottomLeft: Radius.circular(50.0),
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: AlignmentDirectional(0.0, 0.0),
                  image: Image.asset(
                    'assets/images/271AB6CA-9646-4315-9BF1-9E5A6E351536.PNG',
                  ).image,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
