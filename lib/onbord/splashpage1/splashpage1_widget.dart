import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'splashpage1_model.dart';
export 'splashpage1_model.dart';

class Splashpage1Widget extends StatefulWidget {
  const Splashpage1Widget({super.key});

  static String routeName = 'splashpage1';
  static String routePath = '/splashpage1';

  @override
  State<Splashpage1Widget> createState() => _Splashpage1WidgetState();
}

class _Splashpage1WidgetState extends State<Splashpage1Widget> {
  late Splashpage1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Splashpage1Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await authManager.refreshUser();
      await Future.delayed(
        Duration(
          milliseconds: 2000,
        ),
      );
      if (!currentUserEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getVariableText(
                enText:
                    'Email verification required. Please check your inbox (and spam folder) for the activation link.',
                frText:
                    'Vérification par courriel requise. Veuillez consulter votre boîte de réception (et votre dossier de courriers indésirables) pour le lien d\'activation.',
              ),
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).primarytheme,
          ),
        );
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();

        context.goNamedAuth(LoginpageWidget.routeName, context.mounted);

        return;
      }
      if (valueOrDefault(currentUserDocument?.role, '') == 'consumer') {
        context.goNamedAuth(HomePageWidget.routeName, context.mounted);
      } else {
        if (valueOrDefault(currentUserDocument?.role, '') == 'producer') {
          _model.farm = await queryFarmsRecordOnce(
            queryBuilder: (farmsRecord) => farmsRecord.where(
              'user_ref',
              isEqualTo: currentUserReference,
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
          if (_model.farm!.approvalStatus) {
            context.goNamedAuth(ProducerHomeWidget.routeName, context.mounted);
          } else {
            context.goNamedAuth(
                FarmerdetailsEntryWidget.routeName, context.mounted);
          }
        } else {
          context.goNamedAuth(SelectOptionWidget.routeName, context.mounted);
        }
      }
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                      'cxe9pb96' /* Agricoo */,
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
                  fit: BoxFit.contain,
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
