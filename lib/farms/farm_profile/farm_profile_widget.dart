import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/data_load_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/reviewcard/reviewcard_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:styled_divider/styled_divider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'farm_profile_model.dart';
export 'farm_profile_model.dart';

class FarmProfileWidget extends StatefulWidget {
  const FarmProfileWidget({
    super.key,
    required this.farm,
  });

  final DocumentReference? farm;

  static String routeName = 'farmProfile';
  static String routePath = '/farmProfile';

  @override
  State<FarmProfileWidget> createState() => _FarmProfileWidgetState();
}

class _FarmProfileWidgetState extends State<FarmProfileWidget> {
  late FarmProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FarmProfileModel());
    _model.setOnUpdate(onUpdate: () => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).offwhite,
        body: StreamBuilder<UsersRecord>(
          stream: UsersRecord.getDocument(currentUserReference!),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primarytheme,
                    ),
                  ),
                ),
              );
            }

            final containerUsersRecord = snapshot.data!;

            return Container(
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  StreamBuilder<FarmsRecord>(
                    stream: FarmsRecord.getDocument(widget!.farm!),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primarytheme,
                              ),
                            ),
                          ),
                        );
                      }

                      final columnFarmsRecord = snapshot.data!;

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl:
                                        columnFarmsRecord.farmProfilePhoto,
                                    width: double.infinity,
                                    height: 244.0,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) =>
                                        Image.asset(
                                      'assets/images/error_image.png',
                                      width: double.infinity,
                                      height: 244.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      19.0, 55.0, 21.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.safePop();
                                        },
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x67FFFFFF),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .card,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (containerUsersRecord
                                              .myFavouriteFarm
                                              .contains(columnFarmsRecord
                                                  .reference)) {
                                            await containerUsersRecord.reference
                                                .update({
                                              ...mapToFirestore(
                                                {
                                                  'my_favourite_farm':
                                                      FieldValue.arrayRemove([
                                                    columnFarmsRecord.reference
                                                  ]),
                                                },
                                              ),
                                            });
                                          } else {
                                            await containerUsersRecord.reference
                                                .update({
                                              ...mapToFirestore(
                                                {
                                                  'my_favourite_farm':
                                                      FieldValue.arrayUnion([
                                                    columnFarmsRecord.reference
                                                  ]),
                                                },
                                              ),
                                            });
                                          }
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            if (containerUsersRecord
                                                .myFavouriteFarm
                                                .contains(columnFarmsRecord
                                                    .reference)) {
                                              return Icon(
                                                Icons.favorite_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tometoRed,
                                                size: 24.0,
                                              );
                                            } else {
                                              return Icon(
                                                Icons.favorite_border,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tometoRed,
                                                size: 24.0,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 38.0, 13.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      columnFarmsRecord.farmName,
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                  StreamBuilder<List<OrderRecord>>(
                                    stream: queryOrderRecord(
                                      queryBuilder: (orderRecord) =>
                                          orderRecord.where(
                                        'farm_ref',
                                        isEqualTo: columnFarmsRecord.reference,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primarytheme,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<OrderRecord>
                                          containerOrderRecordList =
                                          snapshot.data!;

                                      return Container(
                                        decoration: BoxDecoration(),
                                        child: Visibility(
                                          visible: containerOrderRecordList
                                                  .where((e) =>
                                                      (e.levaeReview == true) &&
                                                      (e.review.reviewStatus ==
                                                          'Approved'))
                                                  .toList()
                                                  .length !=
                                              0,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .harvestYellow,
                                                  size: 24.0,
                                                ),
                                                Text(
                                                  '${(functions.avargeRating(containerOrderRecordList.map((e) => e.review.rate).toList()).clamp(0.0, 5.0)).toString()}(${containerOrderRecordList.where((e) => (e.levaeReview == true) && (e.review.reviewStatus == 'Approved')).toList().length.toString()}${FFLocalizations.of(context).getVariableText(
                                                    enText: ' Reviews )',
                                                    frText: 'Commentaires )',
                                                  )}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textsecondary,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 24.0, 0.0, 24.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          child: Container(
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x1A3BB273),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  color: Color(0x1A3BB273),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(999.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 2.0, 12.0, 2.0),
                                                child: Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    '4o5tn889' /* Organic */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primarytheme,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      columnFarmsRecord.aboutFarm,
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textsecondary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 28.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (columnFarmsRecord
                                                .farmAvailability.length !=
                                            0)
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .card,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boderdivder,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, -1.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'f868d1rp' /* Farm Availability Hours */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .textprimary,
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 12.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final farmava =
                                                            columnFarmsRecord
                                                                .farmAvailability
                                                                .toList();

                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: List.generate(
                                                              farmava.length,
                                                              (farmavaIndex) {
                                                            final farmavaItem =
                                                                farmava[
                                                                    farmavaIndex];
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      farmavaItem
                                                                          .day,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).textsecondary,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      farmavaItem
                                                                              .isAvavible
                                                                          ? '${dateTimeFormat(
                                                                              "jm",
                                                                              farmavaItem.startTime,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            )} - ${dateTimeFormat(
                                                                              "jm",
                                                                              farmavaItem.endtime,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            )}'
                                                                          : 'Closed',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).textsecondary,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (farmavaItem
                                                                        .isAvavible &&
                                                                    farmavaItem
                                                                        .isBreak)
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            '8mfchhko' /* Break */,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          '${dateTimeFormat(
                                                                            "jm",
                                                                            farmavaItem.breakStart,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )} - ${dateTimeFormat(
                                                                            "jm",
                                                                            farmavaItem.breakEnd,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            );
                                                          }).divide(SizedBox(
                                                              height: 12.0)),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 28.0, 0.0, 28.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        _model.chatfind =
                                            await queryChatRecordOnce(
                                          queryBuilder: (chatRecord) =>
                                              chatRecord.where(
                                            'users',
                                            arrayContains: currentUserReference,
                                          ),
                                        );
                                        if (_model.chatfind
                                                ?.where((e) => e.users.contains(
                                                    columnFarmsRecord.userRef))
                                                .toList()
                                                ?.length !=
                                            0) {
                                          context.pushNamed(
                                            ChatConversationWidget.routeName,
                                            queryParameters: {
                                              'chatRef': serializeParam(
                                                _model.chatfind
                                                    ?.where((e) => e.users
                                                        .contains(
                                                            columnFarmsRecord
                                                                .userRef))
                                                    .toList()
                                                    ?.firstOrNull,
                                                ParamType.Document,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              'chatRef': _model.chatfind
                                                  ?.where((e) => e.users
                                                      .contains(
                                                          columnFarmsRecord
                                                              .userRef))
                                                  .toList()
                                                  ?.firstOrNull,
                                            },
                                          );
                                        } else {
                                          _model.usersRef = [];
                                          safeSetState(() {});
                                          _model.addToUsersRef(
                                              currentUserReference!);
                                          safeSetState(() {});
                                          _model.addToUsersRef(
                                              columnFarmsRecord.userRef!);
                                          safeSetState(() {});

                                          var chatRecordReference =
                                              ChatRecord.collection.doc();
                                          await chatRecordReference.set({
                                            ...createChatRecordData(
                                              createdAt: getCurrentTimestamp,
                                              farmRef:
                                                  columnFarmsRecord.reference,
                                              isSuspend: false,
                                              usera: currentUserReference,
                                              timea: getCurrentTimestamp,
                                              userb: columnFarmsRecord.userRef,
                                              timeb: getCurrentTimestamp,
                                            ),
                                            ...mapToFirestore(
                                              {
                                                'users': _model.usersRef,
                                              },
                                            ),
                                          });
                                          _model.chatcreate =
                                              ChatRecord.getDocumentFromData({
                                            ...createChatRecordData(
                                              createdAt: getCurrentTimestamp,
                                              farmRef:
                                                  columnFarmsRecord.reference,
                                              isSuspend: false,
                                              usera: currentUserReference,
                                              timea: getCurrentTimestamp,
                                              userb: columnFarmsRecord.userRef,
                                              timeb: getCurrentTimestamp,
                                            ),
                                            ...mapToFirestore(
                                              {
                                                'users': _model.usersRef,
                                              },
                                            ),
                                          }, chatRecordReference);

                                          context.pushNamed(
                                            ChatConversationWidget.routeName,
                                            queryParameters: {
                                              'chatRef': serializeParam(
                                                _model.chatcreate,
                                                ParamType.Document,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              'chatRef': _model.chatcreate,
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        '28obpcaq' /* Contact */,
                                      ),
                                      icon: Icon(
                                        FFIcons.kchat,
                                        size: 24.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 48.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconAlignment: IconAlignment.end,
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        iconColor: FlutterFlowTheme.of(context)
                                            .offwhite,
                                        color: FlutterFlowTheme.of(context)
                                            .primarytheme,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Satoshi',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFAF9F6),
                                      borderRadius: BorderRadius.circular(99.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .boderdivder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              _model.index = 0;
                                              safeSetState(() {});
                                            },
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              '83x1gouv' /* Products */,
                                            ),
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: _model.index == 0
                                                  ? Color(0xFFF7F6F3)
                                                  : FlutterFlowTheme.of(context)
                                                      .offwhite,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Satoshi',
                                                    color: _model.index == 0
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              elevation:
                                                  _model.index == 0 ? 2.0 : 0.0,
                                              borderSide: BorderSide(
                                                color: _model.index == 0
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .boderdivder
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .offwhite,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(99.0),
                                                topRight: Radius.circular(
                                                    valueOrDefault<double>(
                                                  _model.index == 0
                                                      ? 99.0
                                                      : 0.0,
                                                  0.0,
                                                )),
                                                bottomLeft:
                                                    Radius.circular(99.0),
                                                bottomRight: Radius.circular(
                                                    valueOrDefault<double>(
                                                  _model.index == 0
                                                      ? 99.0
                                                      : 0.0,
                                                  0.0,
                                                )),
                                              ),
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              _model.index = 1;
                                              safeSetState(() {});
                                            },
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              '484l3dx2' /* About */,
                                            ),
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: _model.index == 1
                                                  ? Color(0xFFF7F6F3)
                                                  : FlutterFlowTheme.of(context)
                                                      .offwhite,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Satoshi',
                                                    color: _model.index == 1
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              elevation:
                                                  _model.index == 1 ? 2.0 : 0.0,
                                              borderSide: BorderSide(
                                                color: _model.index == 1
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .boderdivder
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .offwhite,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      valueOrDefault<double>(
                                                _model.index == 1 ? 99.0 : 0.0,
                                                0.0,
                                              )),
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              _model.index = 2;
                                              safeSetState(() {});
                                            },
                                            text: FFLocalizations.of(context)
                                                .getText(
                                              'yissxlww' /* Reviews */,
                                            ),
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: _model.index == 2
                                                  ? Color(0xFFF7F6F3)
                                                  : FlutterFlowTheme.of(context)
                                                      .offwhite,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Satoshi',
                                                    color: _model.index == 2
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .primarytheme
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .textsecondary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                              elevation:
                                                  _model.index == 2 ? 2.0 : 0.0,
                                              borderSide: BorderSide(
                                                color: _model.index == 2
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .boderdivder
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .offwhite,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    valueOrDefault<double>(
                                                  _model.index == 2
                                                      ? 99.0
                                                      : 0.0,
                                                  0.0,
                                                )),
                                                topRight: Radius.circular(99.0),
                                                bottomLeft: Radius.circular(
                                                    valueOrDefault<double>(
                                                  _model.index == 2
                                                      ? 99.0
                                                      : 0.0,
                                                  0.0,
                                                )),
                                                bottomRight:
                                                    Radius.circular(99.0),
                                              ),
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 30.0),
                                    child: StreamBuilder<UsersRecord>(
                                      stream: UsersRecord.getDocument(
                                          columnFarmsRecord.userRef!),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return DataLoadWidget(
                                            height: 250.0,
                                            width: 300.0,
                                            cmncolor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                          );
                                        }

                                        final conditionalBuilderUsersRecord =
                                            snapshot.data!;

                                        return Builder(
                                          builder: (context) {
                                            if (_model.index == 1) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 35.0, 0.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if ((conditionalBuilderUsersRecord
                                                                  .subscriptionActive ==
                                                              true) &&
                                                          ((conditionalBuilderUsersRecord
                                                                      .subscriptionPlanName ==
                                                                  'harvest_plan') ||
                                                              (conditionalBuilderUsersRecord
                                                                      .subscriptionPlanName ==
                                                                  'harvest_plan_yearly')) &&
                                                          (columnFarmsRecord
                                                                  .selfManagedSetup
                                                                  .freedelievryAmmount !=
                                                              0.0))
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            8.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'yiexbrf5' /* Free delivery from   */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Satoshi',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .textprimary,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            8.0),
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    columnFarmsRecord
                                                                        .selfManagedSetup
                                                                        .freedelievryAmmount
                                                                        .toString(),
                                                                    '0',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Satoshi',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      if (columnFarmsRecord
                                                              .farmingMethod
                                                              .length !=
                                                          0)
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        8.0),
                                                            child: Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'q1328y1k' /* Farming Methods */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Satoshi',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .textprimary,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    4.0,
                                                                    0.0,
                                                                    0.0,
                                                                    24.0),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final farmingMethod =
                                                                columnFarmsRecord
                                                                    .farmingMethod
                                                                    .toList();

                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: List.generate(
                                                                  farmingMethod
                                                                      .length,
                                                                  (farmingMethodIndex) {
                                                                final farmingMethodItem =
                                                                    farmingMethod[
                                                                        farmingMethodIndex];
                                                                return Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            5.0,
                                                                        height:
                                                                            5.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primarytheme,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          3.0),
                                                                      child:
                                                                          Text(
                                                                        farmingMethodItem,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          10.0)),
                                                                );
                                                              }).divide(
                                                                  SizedBox(
                                                                      height:
                                                                          5.0)),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      8.0),
                                                          child: Text(
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                              '4wsdq54i' /* Location */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Satoshi',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .textprimary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (columnFarmsRecord
                                                              .doyouofferyourowndeliveryservice &&
                                                          columnFarmsRecord
                                                              .selfManagedSetup
                                                              .clickCollect)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 100.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .card,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .boderdivder,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        FFLocalizations.of(context)
                                                                            .getText(
                                                                          'gz1kip71' /* Farm Pickup */,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textprimary,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'acn2ejpb' /* Collect directly from our barn... */,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).textsecondary,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0x213BB273),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            99.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0,
                                                                            6.0,
                                                                            12.0,
                                                                            6.0),
                                                                    child: Text(
                                                                      FFLocalizations.of(
                                                                              context)
                                                                          .getText(
                                                                        'fe2puti0' /* Free */,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primarytheme,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      if ((columnFarmsRecord
                                                                  .doyouofferyourowndeliveryservice &&
                                                              columnFarmsRecord
                                                                  .selfManagedSetup
                                                                  .ownDelivery) ||
                                                          columnFarmsRecord
                                                              .agricooDelivery)
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      12.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 100.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .card,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .boderdivder,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        FFLocalizations.of(context)
                                                                            .getText(
                                                                          'g2l2qx4n' /* Farm Delivery */,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textprimary,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            4.0),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'xscy18qu' /* Delivery offered by the farm */,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).textsecondary,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      if (columnFarmsRecord
                                                                              .doyouofferyourowndeliveryservice &&
                                                                          columnFarmsRecord
                                                                              .selfManagedSetup
                                                                              .ownDelivery)
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              FFLocalizations.of(context).getText(
                                                                                'ltho0dim' /* delivery price: */,
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Satoshi',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    letterSpacing: 0.0,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                valueOrDefault<String>(
                                                                                  columnFarmsRecord.selfManagedSetup.flatDeliveryFee.toString(),
                                                                                  '0',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Satoshi',
                                                                                      color: FlutterFlowTheme.of(context).tertiary,
                                                                                      fontSize: 13.0,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0x213BB273),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              99.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          6.0,
                                                                          12.0,
                                                                          6.0),
                                                                      child:
                                                                          Text(
                                                                        FFLocalizations.of(context)
                                                                            .getText(
                                                                          'skf297bu' /* Charges */,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    22.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 328.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          child: Builder(
                                                              builder:
                                                                  (context) {
                                                            final _googleMapMarker =
                                                                columnFarmsRecord
                                                                    .farmLocation;
                                                            return FlutterFlowGoogleMap(
                                                              controller: _model
                                                                  .googleMapsController,
                                                              onCameraIdle:
                                                                  (latLng) =>
                                                                      _model.googleMapsCenter =
                                                                          latLng,
                                                              initialLocation: _model
                                                                      .googleMapsCenter ??=
                                                                  columnFarmsRecord
                                                                      .farmLocation!,
                                                              markers: [
                                                                if (_googleMapMarker !=
                                                                    null)
                                                                  FlutterFlowMarker(
                                                                    _googleMapMarker
                                                                        .serialize(),
                                                                    _googleMapMarker,
                                                                  ),
                                                              ],
                                                              markerColor:
                                                                  GoogleMarkerColor
                                                                      .red,
                                                              mapType: MapType
                                                                  .normal,
                                                              style:
                                                                  GoogleMapStyle
                                                                      .standard,
                                                              initialZoom: 16.0,
                                                              allowInteraction:
                                                                  true,
                                                              allowZoom: true,
                                                              showZoomControls:
                                                                  true,
                                                              showLocation:
                                                                  true,
                                                              showCompass:
                                                                  false,
                                                              showMapToolbar:
                                                                  false,
                                                              showTraffic:
                                                                  false,
                                                              centerMapOnMarkerTap:
                                                                  true,
                                                              mapTakesGesturePreference:
                                                                  false,
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else if (_model.index == 2) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 21.0, 0.0, 21.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                  child: StreamBuilder<
                                                      List<OrderRecord>>(
                                                    stream: queryOrderRecord(
                                                      queryBuilder: (orderRecord) =>
                                                          orderRecord
                                                              .where(
                                                                'levae_review',
                                                                isEqualTo: true,
                                                              )
                                                              .where(
                                                                'review.review_status',
                                                                isEqualTo:
                                                                    'Approved',
                                                              )
                                                              .orderBy(
                                                                  'review.created_at',
                                                                  descending:
                                                                      true),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return DataLoadWidget(
                                                          height: 100.0,
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                          cmncolor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .offwhite,
                                                        );
                                                      }
                                                      List<OrderRecord>
                                                          columnOrderRecordList =
                                                          snapshot.data!;
                                                      if (columnOrderRecordList
                                                          .isEmpty) {
                                                        return Center(
                                                          child:
                                                              NoChatProducerWidget(
                                                            message:
                                                                'No reviews yet',
                                                            submsg:
                                                                'This farm hasn’t received any reviews so far. Be the first to share your experience.',
                                                            index: 0,
                                                          ),
                                                        );
                                                      }

                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: List.generate(
                                                            columnOrderRecordList
                                                                .length,
                                                            (columnIndex) {
                                                          final columnOrderRecord =
                                                              columnOrderRecordList[
                                                                  columnIndex];
                                                          return ReviewcardWidget(
                                                            key: Key(
                                                                'Keyzyi_${columnIndex}_of_${columnOrderRecordList.length}'),
                                                            orderRef:
                                                                columnOrderRecord
                                                                    .reference,
                                                          );
                                                        }).divide(SizedBox(
                                                            height: 16.0)),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Builder(
                                                  builder: (context) {
                                                    if (conditionalBuilderUsersRecord
                                                            .stripeConnectStatus ==
                                                        'active') {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          StreamBuilder<
                                                              List<
                                                                  ProductRecord>>(
                                                            stream:
                                                                queryProductRecord(
                                                              queryBuilder:
                                                                  (productRecord) =>
                                                                      productRecord
                                                                          .where(
                                                                            'farm_ref',
                                                                            isEqualTo:
                                                                                columnFarmsRecord.reference,
                                                                          )
                                                                          .where(
                                                                            'approval_status',
                                                                            isEqualTo:
                                                                                true,
                                                                          ),
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return DataLoadWidget(
                                                                  height: 150.0,
                                                                  width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width,
                                                                  cmncolor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .offwhite,
                                                                );
                                                              }
                                                              List<ProductRecord>
                                                                  containerProductRecordList =
                                                                  snapshot
                                                                      .data!;

                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            24.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Builder(
                                                                          builder:
                                                                              (context) {
                                                                            final viewall =
                                                                                containerProductRecordList.where((e) => (e.productStatus == 'Active') && (e.isSuspend == false)).toList();
                                                                            if (viewall.isEmpty) {
                                                                              return Center(
                                                                                child: NoChatProducerWidget(
                                                                                  message: 'No products available right now',
                                                                                  submsg: 'This farm doesn’t have any products listed at the moment. Check back soon or explore other farms on Agricoo.',
                                                                                  index: 0,
                                                                                ),
                                                                              );
                                                                            }

                                                                            return Wrap(
                                                                              spacing: 10.0,
                                                                              runSpacing: 10.0,
                                                                              alignment: WrapAlignment.start,
                                                                              crossAxisAlignment: WrapCrossAlignment.start,
                                                                              direction: Axis.horizontal,
                                                                              runAlignment: WrapAlignment.start,
                                                                              verticalDirection: VerticalDirection.down,
                                                                              clipBehavior: Clip.none,
                                                                              children: List.generate(viewall.length, (viewallIndex) {
                                                                                final viewallItem = viewall[viewallIndex];
                                                                                return InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    context.pushNamed(
                                                                                      ProductDetailsPageWidget.routeName,
                                                                                      queryParameters: {
                                                                                        'product': serializeParam(
                                                                                          viewallItem.reference,
                                                                                          ParamType.DocumentReference,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 160.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 10.0,
                                                                                          color: Color(0x1000000F),
                                                                                          offset: Offset(
                                                                                            0.0,
                                                                                            2.0,
                                                                                          ),
                                                                                          spreadRadius: 0.0,
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                                      border: Border.all(
                                                                                        color: Color(0xFFE2E6EA),
                                                                                      ),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 11.0, 8.0, 8.0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                                            child: Container(
                                                                                              width: double.infinity,
                                                                                              height: 120.0,
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                                    child: CachedNetworkImage(
                                                                                                      fadeInDuration: Duration(milliseconds: 500),
                                                                                                      fadeOutDuration: Duration(milliseconds: 500),
                                                                                                      imageUrl: viewallItem.productImage,
                                                                                                      width: double.infinity,
                                                                                                      height: 120.0,
                                                                                                      fit: BoxFit.cover,
                                                                                                      errorWidget: (context, error, stackTrace) => Image.asset(
                                                                                                        'assets/images/error_image.png',
                                                                                                        width: double.infinity,
                                                                                                        height: 120.0,
                                                                                                        fit: BoxFit.cover,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Align(
                                                                                                    alignment: AlignmentDirectional(-0.05, 1.24),
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(14.0, 8.0, 14.0, 0.0),
                                                                                                      child: Container(
                                                                                                        height: 25.0,
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Color(0x34000000),
                                                                                                          boxShadow: [
                                                                                                            BoxShadow(
                                                                                                              blurRadius: 10.0,
                                                                                                              color: Color(0x34000000),
                                                                                                              offset: Offset(
                                                                                                                0.0,
                                                                                                                0.0,
                                                                                                              ),
                                                                                                              spreadRadius: 0.0,
                                                                                                            )
                                                                                                          ],
                                                                                                          borderRadius: BorderRadius.circular(9999.0),
                                                                                                        ),
                                                                                                        child: Align(
                                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                          child: Text(
                                                                                                            valueOrDefault<String>(
                                                                                                              viewallItem.badges.firstOrNull,
                                                                                                              'Organic',
                                                                                                            ),
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: 'Satoshi',
                                                                                                                  color: FlutterFlowTheme.of(context).offwhite,
                                                                                                                  fontSize: 12.0,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Align(
                                                                                                    alignment: AlignmentDirectional(1.0, -1.0),
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 2.0, 0.0),
                                                                                                      child: Container(
                                                                                                        width: 24.0,
                                                                                                        height: 24.0,
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                          shape: BoxShape.circle,
                                                                                                        ),
                                                                                                        child: Align(
                                                                                                          alignment: AlignmentDirectional(1.0, -1.0),
                                                                                                          child: InkWell(
                                                                                                            splashColor: Colors.transparent,
                                                                                                            focusColor: Colors.transparent,
                                                                                                            hoverColor: Colors.transparent,
                                                                                                            highlightColor: Colors.transparent,
                                                                                                            onTap: () async {
                                                                                                              if (containerUsersRecord.myFavouriteProduct.contains(viewallItem.reference)) {
                                                                                                                await containerUsersRecord.reference.update({
                                                                                                                  ...mapToFirestore(
                                                                                                                    {
                                                                                                                      'my_favourite_product': FieldValue.arrayRemove([viewallItem.reference]),
                                                                                                                    },
                                                                                                                  ),
                                                                                                                });
                                                                                                              } else {
                                                                                                                await containerUsersRecord.reference.update({
                                                                                                                  ...mapToFirestore(
                                                                                                                    {
                                                                                                                      'my_favourite_product': FieldValue.arrayUnion([viewallItem.reference]),
                                                                                                                    },
                                                                                                                  ),
                                                                                                                });
                                                                                                              }
                                                                                                            },
                                                                                                            child: Builder(
                                                                                                              builder: (context) {
                                                                                                                if (containerUsersRecord.myFavouriteProduct.contains(viewallItem.reference)) {
                                                                                                                  return Align(
                                                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                                                      child: Icon(
                                                                                                                        Icons.favorite_sharp,
                                                                                                                        color: FlutterFlowTheme.of(context).tometoRed,
                                                                                                                        size: 20.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                } else {
                                                                                                                  return Align(
                                                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                                                      child: Icon(
                                                                                                                        Icons.favorite_border,
                                                                                                                        color: FlutterFlowTheme.of(context).tometoRed,
                                                                                                                        size: 20.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                }
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                children: [
                                                                                                  Flexible(
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                                                      child: Text(
                                                                                                        viewallItem.productName,
                                                                                                        textAlign: TextAlign.start,
                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                              fontFamily: 'Satoshi',
                                                                                                              color: FlutterFlowTheme.of(context).textprimary,
                                                                                                              fontSize: 14.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                child: Text(
                                                                                                  columnFarmsRecord.farmName,
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: 'Satoshi',
                                                                                                        color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                        fontSize: 12.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                              if (responsiveVisibility(
                                                                                                context: context,
                                                                                                phone: false,
                                                                                                tablet: false,
                                                                                                tabletLandscape: false,
                                                                                                desktop: false,
                                                                                              ))
                                                                                                Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                  child: Text(
                                                                                                    FFLocalizations.of(context).getText(
                                                                                                      '11hlg9ql' /* 4.5 km • 0.2 lbs CO₂ saved */,
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: AutoSizeText(
                                                                                                        '${FFLocalizations.of(context).languageCode != 'fr' ? '\$' : ''}${viewallItem.price.toString()}${FFLocalizations.of(context).languageCode != 'en' ? '€' : ''}/${viewallItem.unit}',
                                                                                                        maxLines: 1,
                                                                                                        minFontSize: 4.0,
                                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                              fontFamily: 'Satoshi',
                                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                              fontSize: 16.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    StreamBuilder<List<CartRecord>>(
                                                                                                      stream: queryCartRecord(
                                                                                                        parent: currentUserReference,
                                                                                                        queryBuilder: (cartRecord) => cartRecord.where(
                                                                                                          'productRef',
                                                                                                          isEqualTo: viewallItem.reference,
                                                                                                        ),
                                                                                                        singleRecord: true,
                                                                                                      ),
                                                                                                      builder: (context, snapshot) {
                                                                                                        // Customize what your widget looks like when it's loading.
                                                                                                        if (!snapshot.hasData) {
                                                                                                          return Center(
                                                                                                            child: SizedBox(
                                                                                                              width: 50.0,
                                                                                                              height: 50.0,
                                                                                                              child: CircularProgressIndicator(
                                                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                                                  FlutterFlowTheme.of(context).primarytheme,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          );
                                                                                                        }
                                                                                                        List<CartRecord> containerCartRecordList = snapshot.data!;
                                                                                                        final containerCartRecord = containerCartRecordList.isNotEmpty ? containerCartRecordList.first : null;

                                                                                                        return Container(
                                                                                                          decoration: BoxDecoration(),
                                                                                                          child: Builder(
                                                                                                            builder: (context) {
                                                                                                              if (containerCartRecord?.reference == null) {
                                                                                                                return Visibility(
                                                                                                                  visible: conditionalBuilderUsersRecord.subscriptionActive && ((conditionalBuilderUsersRecord.subscriptionPlanName != 'root_plan_yearly') && (conditionalBuilderUsersRecord.subscriptionPlanName != 'root_plan')) && (viewallItem.stockQuantity > 0),
                                                                                                                  child: InkWell(
                                                                                                                    splashColor: Colors.transparent,
                                                                                                                    focusColor: Colors.transparent,
                                                                                                                    hoverColor: Colors.transparent,
                                                                                                                    highlightColor: Colors.transparent,
                                                                                                                    onTap: () async {
                                                                                                                      if (containerCartRecord?.reference != null) {
                                                                                                                        await containerCartRecord!.reference.delete();
                                                                                                                        FFAppState().cartlist = FFAppState().cartlist + (FFAppState().cartlist >= 1 ? -1 : 0);
                                                                                                                        safeSetState(() {});
                                                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                          SnackBar(
                                                                                                                            content: Text(
                                                                                                                              '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                                                enText: ' has been removed from cart',
                                                                                                                                frText: 'a été retiré du panier',
                                                                                                                              )}',
                                                                                                                              style: TextStyle(
                                                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            duration: Duration(milliseconds: 4000),
                                                                                                                            backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                                          ),
                                                                                                                        );
                                                                                                                      } else {
                                                                                                                        _model.carts = await queryCartRecordOnce(
                                                                                                                          parent: containerUsersRecord.reference,
                                                                                                                        );
                                                                                                                        if (_model.carts?.length != 0) {
                                                                                                                          if (_model.carts?.firstOrNull?.farmRef == columnFarmsRecord.reference) {
                                                                                                                            await CartRecord.createDoc(containerUsersRecord.reference).set(createCartRecordData(
                                                                                                                              productRef: viewallItem.reference,
                                                                                                                              quantity: 1,
                                                                                                                              pricePerProduct: viewallItem.price,
                                                                                                                              farmRef: viewallItem.farmRef,
                                                                                                                            ));
                                                                                                                            FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                                                            safeSetState(() {});
                                                                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                              SnackBar(
                                                                                                                                content: Text(
                                                                                                                                  '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                                                    enText: ' has been added in cart',
                                                                                                                                    frText: ' a été ajouté au panier',
                                                                                                                                  )}',
                                                                                                                                  style: TextStyle(
                                                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                                duration: Duration(milliseconds: 4000),
                                                                                                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                                              ),
                                                                                                                            );
                                                                                                                          } else {
                                                                                                                            _model.oldfarm = await FarmsRecord.getDocumentOnce(_model.carts!.firstOrNull!.farmRef!);
                                                                                                                            ScaffoldMessenger.of(context).clearSnackBars();
                                                                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                              SnackBar(
                                                                                                                                content: Text(
                                                                                                                                  '${FFLocalizations.of(context).getVariableText(
                                                                                                                                    enText: 'Oops! You already have delicious items from ',
                                                                                                                                    frText: 'Oups ! Vous avez déjà de délicieux articles de',
                                                                                                                                  )}${_model.oldfarm?.farmName}${FFLocalizations.of(context).getVariableText(
                                                                                                                                    enText: ' in your cart. To add items from ',
                                                                                                                                    frText: 'dans votre panier. Pour ajouter des articles depuis',
                                                                                                                                  )}${columnFarmsRecord.farmName}${FFLocalizations.of(context).getVariableText(
                                                                                                                                    enText: ', you\'ll need to start a new order.',
                                                                                                                                    frText: ', Vous devrez passer une nouvelle commande.',
                                                                                                                                  )}',
                                                                                                                                  style: TextStyle(
                                                                                                                                    color: FlutterFlowTheme.of(context).textprimary,
                                                                                                                                  ),
                                                                                                                                  textAlign: TextAlign.center,
                                                                                                                                ),
                                                                                                                                duration: Duration(milliseconds: 4850),
                                                                                                                                backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                              ),
                                                                                                                            );
                                                                                                                          }
                                                                                                                        } else {
                                                                                                                          await CartRecord.createDoc(containerUsersRecord.reference).set(createCartRecordData(
                                                                                                                            productRef: viewallItem.reference,
                                                                                                                            quantity: 1,
                                                                                                                            pricePerProduct: viewallItem.price,
                                                                                                                            farmRef: viewallItem.farmRef,
                                                                                                                          ));
                                                                                                                          FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                                                          safeSetState(() {});
                                                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                            SnackBar(
                                                                                                                              content: Text(
                                                                                                                                '${viewallItem.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                                                  enText: ' has been added in cart',
                                                                                                                                  frText: ' a été ajouté au panier',
                                                                                                                                )}',
                                                                                                                                style: TextStyle(
                                                                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              duration: Duration(milliseconds: 4000),
                                                                                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                                            ),
                                                                                                                          );
                                                                                                                        }
                                                                                                                      }

                                                                                                                      safeSetState(() {});
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      width: 26.0,
                                                                                                                      height: 26.0,
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        color: Color(0x1A3BB273),
                                                                                                                        borderRadius: BorderRadius.circular(4.0),
                                                                                                                        border: Border.all(
                                                                                                                          color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      child: Icon(
                                                                                                                        Icons.add,
                                                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                        size: 24.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              } else {
                                                                                                                return Visibility(
                                                                                                                  visible: viewallItem.stockQuantity > 0,
                                                                                                                  child: Container(
                                                                                                                    width: 70.0,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      color: FlutterFlowTheme.of(context).seconadrybutton,
                                                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                                                      border: Border.all(
                                                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsets.all(4.0),
                                                                                                                      child: Row(
                                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                        children: [
                                                                                                                          InkWell(
                                                                                                                            splashColor: Colors.transparent,
                                                                                                                            focusColor: Colors.transparent,
                                                                                                                            hoverColor: Colors.transparent,
                                                                                                                            highlightColor: Colors.transparent,
                                                                                                                            onTap: () async {
                                                                                                                              if (containerCartRecord!.quantity >= 2) {
                                                                                                                                await containerCartRecord!.reference.update({
                                                                                                                                  ...mapToFirestore(
                                                                                                                                    {
                                                                                                                                      'quantity': FieldValue.increment(-(1)),
                                                                                                                                    },
                                                                                                                                  ),
                                                                                                                                });
                                                                                                                              } else {
                                                                                                                                await containerCartRecord!.reference.delete();
                                                                                                                              }

                                                                                                                              _model.updatePage(() {});
                                                                                                                            },
                                                                                                                            child: FaIcon(
                                                                                                                              FaIconData(const IconData(/* minus */ 0xf068, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter')),
                                                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                              size: 16.0,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          Flexible(
                                                                                                                            child: Text(
                                                                                                                              valueOrDefault<String>(
                                                                                                                                containerCartRecord?.quantity?.toString(),
                                                                                                                                '0',
                                                                                                                              ),
                                                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                                    fontFamily: 'Satoshi',
                                                                                                                                    color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                                    fontSize: 12.0,
                                                                                                                                    letterSpacing: 0.0,
                                                                                                                                  ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          InkWell(
                                                                                                                            splashColor: Colors.transparent,
                                                                                                                            focusColor: Colors.transparent,
                                                                                                                            hoverColor: Colors.transparent,
                                                                                                                            highlightColor: Colors.transparent,
                                                                                                                            onTap: () async {
                                                                                                                              if (containerCartRecord!.quantity < viewallItem.stockQuantity) {
                                                                                                                                await containerCartRecord!.reference.update({
                                                                                                                                  ...mapToFirestore(
                                                                                                                                    {
                                                                                                                                      'quantity': FieldValue.increment(1),
                                                                                                                                    },
                                                                                                                                  ),
                                                                                                                                });
                                                                                                                              } else {
                                                                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                                  SnackBar(
                                                                                                                                    content: Text(
                                                                                                                                      FFLocalizations.of(context).getVariableText(
                                                                                                                                        enText: 'Not enough stock available',
                                                                                                                                        frText: 'Pas assez de stock disponible',
                                                                                                                                      ),
                                                                                                                                      style: TextStyle(
                                                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    duration: Duration(milliseconds: 4000),
                                                                                                                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                                                  ),
                                                                                                                                );
                                                                                                                              }

                                                                                                                              safeSetState(() {});
                                                                                                                            },
                                                                                                                            child: Icon(
                                                                                                                              Icons.add,
                                                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                                              size: 16.0,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              }
                                                                                                            },
                                                                                                          ),
                                                                                                        );
                                                                                                      },
                                                                                                    ),
                                                                                                  ].divide(SizedBox(width: 4.0)),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (((conditionalBuilderUsersRecord.subscriptionPlanName == 'root_plan') ||
                                                                            (conditionalBuilderUsersRecord.subscriptionPlanName ==
                                                                                'root_plan_yearly') ||
                                                                            (conditionalBuilderUsersRecord.subscriptionPlanName ==
                                                                                'Free Trial') ||
                                                                            (conditionalBuilderUsersRecord.subscriptionPlanName == null ||
                                                                                conditionalBuilderUsersRecord.subscriptionPlanName ==
                                                                                    '')) &&
                                                                        (containerProductRecordList.length !=
                                                                            0))
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            16.0,
                                                                            0.0,
                                                                            16.0),
                                                                        child:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'pc1nv7wn' /* Products from this farm are cu... */,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).textprimary,
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          StreamBuilder<
                                                              List<
                                                                  ScaduleProductRecord>>(
                                                            stream:
                                                                queryScaduleProductRecord(
                                                              queryBuilder:
                                                                  (scaduleProductRecord) =>
                                                                      scaduleProductRecord
                                                                          .where(
                                                                'farmRef',
                                                                isEqualTo:
                                                                    columnFarmsRecord
                                                                        .reference,
                                                              ),
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<ScaduleProductRecord>
                                                                  containerScaduleProductRecordList =
                                                                  snapshot
                                                                      .data!;

                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    if (containerScaduleProductRecordList
                                                                            .length !=
                                                                        0)
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              12.0),
                                                                          child:
                                                                              Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              'q6429qyq' /* Harvest Schedule */,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Satoshi',
                                                                                  color: FlutterFlowTheme.of(context).textprimary,
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          45.0),
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          final containerVar =
                                                                              containerScaduleProductRecordList.toList();

                                                                          return Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                List.generate(containerVar.length, (containerVarIndex) {
                                                                              final containerVarItem = containerVar[containerVarIndex];
                                                                              return Container(
                                                                                width: double.infinity,
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).card,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                  border: Border.all(
                                                                                    color: FlutterFlowTheme.of(context).boderdivder,
                                                                                  ),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: CachedNetworkImage(
                                                                                                fadeInDuration: Duration(milliseconds: 500),
                                                                                                fadeOutDuration: Duration(milliseconds: 500),
                                                                                                imageUrl: containerVarItem.image,
                                                                                                width: 44.0,
                                                                                                height: 44.0,
                                                                                                fit: BoxFit.cover,
                                                                                                errorWidget: (context, error, stackTrace) => Image.asset(
                                                                                                  'assets/images/error_image.png',
                                                                                                  width: 44.0,
                                                                                                  height: 44.0,
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    containerVarItem.name,
                                                                                                    maxLines: 1,
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                                          fontSize: 16.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                        ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    containerVarItem.address,
                                                                                                    maxLines: 1,
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: 'Satoshi',
                                                                                                          color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                          letterSpacing: 0.0,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(height: 4.0)),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: () {
                                                                                                  if (containerVarItem.productStatus == 'Growing') {
                                                                                                    return Color(0x1AFF8D28);
                                                                                                  } else if (containerVarItem.productStatus == 'Ready') {
                                                                                                    return FlutterFlowTheme.of(context).seconadrybutton;
                                                                                                  } else {
                                                                                                    return Color(0x393FA9F5);
                                                                                                  }
                                                                                                }(),
                                                                                                borderRadius: BorderRadius.circular(24.0),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsetsDirectional.fromSTEB(13.0, 2.0, 13.0, 2.0),
                                                                                                child: Text(
                                                                                                  containerVarItem.productStatus,
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: 'Satoshi',
                                                                                                        color: () {
                                                                                                          if (containerVarItem.productStatus == 'Growing') {
                                                                                                            return Color(0xFFFF8D28);
                                                                                                          } else if (containerVarItem.productStatus == 'Ready') {
                                                                                                            return FlutterFlowTheme.of(context).primarytheme;
                                                                                                          } else {
                                                                                                            return FlutterFlowTheme.of(context).skyblue;
                                                                                                          }
                                                                                                        }(),
                                                                                                        letterSpacing: 0.0,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                FFLocalizations.of(context).getText(
                                                                                                  'bgbmp9ro' /* Planted */,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                      fontSize: 12.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                    ),
                                                                                              ),
                                                                                              Text(
                                                                                                dateTimeFormat(
                                                                                                  "yMMMd",
                                                                                                  containerVarItem.plantedDate!,
                                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Satoshi',
                                                                                                      color: FlutterFlowTheme.of(context).textprimary,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                    ),
                                                                                              ),
                                                                                            ].divide(SizedBox(height: 4.0)),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  FFLocalizations.of(context).getText(
                                                                                                    'rzbrcg65' /* Expected Harvest */,
                                                                                                  ),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: 'Satoshi',
                                                                                                        color: FlutterFlowTheme.of(context).textsecondary,
                                                                                                        fontSize: 12.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                      ),
                                                                                                ),
                                                                                                Text(
                                                                                                  dateTimeFormat(
                                                                                                    "yMMMd",
                                                                                                    containerVarItem.expectedHarvestDate!,
                                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                                  ),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: 'Satoshi',
                                                                                                        color: FlutterFlowTheme.of(context).textprimary,
                                                                                                        fontSize: 16.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(SizedBox(height: 4.0)),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      StyledDivider(
                                                                                        thickness: 1.0,
                                                                                        color: FlutterFlowTheme.of(context).textsecondary,
                                                                                        lineStyle: DividerLineStyle.dashed,
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Text(
                                                                                          'Expected Quantity : ${containerVarItem.expectedQuantity.toString()} ${containerVarItem.unit}',
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                fontSize: 12.0,
                                                                                                letterSpacing: 0.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 16.0)),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).divide(SizedBox(height: 10.0)),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Container(
                                                        child: wrapWithModel(
                                                          model: _model
                                                              .noChatProducerModel,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              NoChatProducerWidget(
                                                            message:
                                                                'No products available right now',
                                                            submsg:
                                                                'This farm doesn’t have any products listed at the moment. Check back soon or explore other farms on Agricoo.',
                                                            index: 0,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (containerUsersRecord.isSuspend)
                    PointerInterceptor(
                      intercepting: isWeb,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4.0,
                            sigmaY: 4.0,
                          ),
                          child: wrapWithModel(
                            model: _model.suspendModel,
                            updateCallback: () => safeSetState(() {}),
                            child: SuspendWidget(
                              action: () async {
                                context
                                    .pushNamed(HelpandsupportWidget.routeName);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
