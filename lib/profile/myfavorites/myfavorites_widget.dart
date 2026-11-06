import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/components/no_chat_producer_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myfavorites_model.dart';
export 'myfavorites_model.dart';

class MyfavoritesWidget extends StatefulWidget {
  const MyfavoritesWidget({super.key});

  static String routeName = 'Myfavorites';
  static String routePath = '/myfavorites';

  @override
  State<MyfavoritesWidget> createState() => _MyfavoritesWidgetState();
}

class _MyfavoritesWidgetState extends State<MyfavoritesWidget> {
  late MyfavoritesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyfavoritesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primarytheme,
                  ),
                ),
              ),
            ),
          );
        }

        final myfavoritesUsersRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).offwhite,
              automaticallyImplyLeading: true,
              leading: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: InkWell(
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
              title: Text(
                FFLocalizations.of(context).getText(
                  'ecm4ig0d' /* My Favorites */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Satoshi',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFFAF9F6),
                            borderRadius: BorderRadius.circular(99.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).boderdivder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.tabindex = 0;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'zll5gg8c' /* Products */,
                                  ),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: _model.tabindex == 0
                                        ? Color(0xFFF7F6F3)
                                        : FlutterFlowTheme.of(context).offwhite,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: _model.tabindex == 0
                                              ? FlutterFlowTheme.of(context)
                                                  .primarytheme
                                              : FlutterFlowTheme.of(context)
                                                  .textsecondary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    elevation: _model.tabindex == 0 ? 2.0 : 0.0,
                                    borderSide: BorderSide(
                                      color: _model.tabindex == 0
                                          ? FlutterFlowTheme.of(context)
                                              .boderdivder
                                          : FlutterFlowTheme.of(context)
                                              .offwhite,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(99.0),
                                      topRight: Radius.circular(
                                          valueOrDefault<double>(
                                        _model.tabindex == 0 ? 99.0 : 0.0,
                                        0.0,
                                      )),
                                      bottomLeft: Radius.circular(99.0),
                                      bottomRight: Radius.circular(
                                          valueOrDefault<double>(
                                        _model.tabindex == 0 ? 99.0 : 0.0,
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
                                    _model.tabindex = 1;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'ufwhunit' /* Farms */,
                                  ),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: _model.tabindex == 1
                                        ? Color(0xFFF7F6F3)
                                        : FlutterFlowTheme.of(context).offwhite,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: _model.tabindex == 1
                                              ? FlutterFlowTheme.of(context)
                                                  .primarytheme
                                              : FlutterFlowTheme.of(context)
                                                  .textsecondary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    elevation: _model.tabindex == 1 ? 2.0 : 0.0,
                                    borderSide: BorderSide(
                                      color: _model.tabindex == 1
                                          ? FlutterFlowTheme.of(context)
                                              .boderdivder
                                          : FlutterFlowTheme.of(context)
                                              .offwhite,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          valueOrDefault<double>(
                                        _model.tabindex == 1 ? 99.0 : 0.0,
                                        0.0,
                                      )),
                                      topRight: Radius.circular(99.0),
                                      bottomLeft: Radius.circular(
                                          valueOrDefault<double>(
                                        _model.tabindex == 1 ? 99.0 : 0.0,
                                        0.0,
                                      )),
                                      bottomRight: Radius.circular(99.0),
                                    ),
                                  ),
                                  showLoadingIndicator: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 21.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                if (_model.tabindex == 1) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final farms = myfavoritesUsersRecord
                                            .myFavouriteFarm
                                            .toList();
                                        if (farms.isEmpty) {
                                          return Center(
                                            child: NoChatProducerWidget(
                                              message: 'No favorites yet',
                                              submsg:
                                                  'Save your favorite products and farms to find them quickly later.',
                                              index: 0,
                                            ),
                                          );
                                        }

                                        return SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                farms.length, (farmsIndex) {
                                              final farmsItem =
                                                  farms[farmsIndex];
                                              return StreamBuilder<FarmsRecord>(
                                                stream: FarmsRecord.getDocument(
                                                    farmsItem),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primarytheme,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  final containerFarmsRecord =
                                                      snapshot.data!;

                                                  return InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        FarmProfileWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'farm':
                                                              serializeParam(
                                                            containerFarmsRecord
                                                                .reference,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .card,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .boderdivder,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      12.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      12.0),
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              fadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              fadeOutDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              imageUrl:
                                                                  containerFarmsRecord
                                                                      .farmProfilePhoto,
                                                              width: double
                                                                  .infinity,
                                                              height: 105.0,
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Image.asset(
                                                                'assets/images/error_image.png',
                                                                width: double
                                                                    .infinity,
                                                                height: 105.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        8.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
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
                                                                      containerFarmsRecord
                                                                          .farmName,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Satoshi',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            lineHeight:
                                                                                1.5,
                                                                          ),
                                                                    ),
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await myfavoritesUsersRecord
                                                                            .reference
                                                                            .update({
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'my_favourite_farm': FieldValue.arrayRemove([
                                                                                farmsItem
                                                                              ]),
                                                                            },
                                                                          ),
                                                                        });
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tometoRed,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    containerFarmsRecord
                                                                        .aboutFarm,
                                                                    maxLines: 2,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Satoshi',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).textsecondary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 4.0)),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, -1.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          8.0),
                                                              child: Text(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  'de7ouydt' /* View Farm */,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primarytheme,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).divide(SizedBox(height: 16.0)),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 24.0, 0.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final favourite = myfavoritesUsersRecord
                                            .myFavouriteProduct
                                            .toList();
                                        if (favourite.isEmpty) {
                                          return NoChatProducerWidget(
                                            message: FFLocalizations.of(context)
                                                .getText(
                                              'f8l50fru' /* No favorites yet */,
                                            ),
                                            submsg:
                                                'Save your favorite products and farms to find them quickly later.',
                                            index: 0,
                                          );
                                        }

                                        return SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                    favourite.length,
                                                    (favouriteIndex) {
                                              final favouriteItem =
                                                  favourite[favouriteIndex];
                                              return StreamBuilder<
                                                  ProductRecord>(
                                                stream:
                                                    ProductRecord.getDocument(
                                                        favouriteItem),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primarytheme,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  final containerProductRecord =
                                                      snapshot.data!;

                                                  return Container(
                                                    decoration: BoxDecoration(),
                                                    child: Visibility(
                                                      visible:
                                                          !containerProductRecord
                                                              .isSuspend,
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            ProductDetailsPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'product':
                                                                  serializeParam(
                                                                containerProductRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
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
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        11.0,
                                                                        8.0,
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          1.0,
                                                                          -1.0),
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration(milliseconds: 500),
                                                                        fadeOutDuration:
                                                                            Duration(milliseconds: 500),
                                                                        imageUrl:
                                                                            containerProductRecord.productImage,
                                                                        width:
                                                                            120.0,
                                                                        height:
                                                                            120.0,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        errorWidget: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Image.asset(
                                                                          'assets/images/error_image.png',
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              120.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              1.0,
                                                                              -1.0),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            8.0,
                                                                            8.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              69.0,
                                                                          height:
                                                                              25.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0x34000000),
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(9999.0),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                containerProductRecord.badges.firstOrNull,
                                                                                'organic',
                                                                              ),
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
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: StreamBuilder<
                                                                        FarmsRecord>(
                                                                      stream: FarmsRecord.getDocument(
                                                                          containerProductRecord
                                                                              .farmRef!),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return DataLoadWidget(
                                                                            height:
                                                                                110.0,
                                                                            width:
                                                                                200.0,
                                                                            cmncolor:
                                                                                FlutterFlowTheme.of(context).card,
                                                                          );
                                                                        }

                                                                        final columnFarmsRecord =
                                                                            snapshot.data!;

                                                                        return Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Text(
                                                                                    containerProductRecord.productName,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Satoshi',
                                                                                          color: FlutterFlowTheme.of(context).textprimary,
                                                                                          fontSize: 16.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    await myfavoritesUsersRecord.reference.update({
                                                                                      ...mapToFirestore(
                                                                                        {
                                                                                          'my_favourite_product': FieldValue.arrayRemove([
                                                                                            favouriteItem
                                                                                          ]),
                                                                                        },
                                                                                      ),
                                                                                    });
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.favorite_sharp,
                                                                                    color: FlutterFlowTheme.of(context).tometoRed,
                                                                                    size: 24.0,
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
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      if (FFLocalizations.of(context).languageCode != 'fr')
                                                                                        Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            'l5d5u4ux' /* $ */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                        ),
                                                                                      Text(
                                                                                        valueOrDefault<String>(
                                                                                          containerProductRecord.price.toString(),
                                                                                          '0',
                                                                                        ),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                      if (FFLocalizations.of(context).languageCode == 'fr')
                                                                                        Text(
                                                                                          FFLocalizations.of(context).getText(
                                                                                            '3a3foko5' /* € */,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Satoshi',
                                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                        ),
                                                                                      Text(
                                                                                        ' / ${containerProductRecord.unit}',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Satoshi',
                                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                StreamBuilder<UsersRecord>(
                                                                                  stream: UsersRecord.getDocument(columnFarmsRecord.userRef!),
                                                                                  builder: (context, snapshot) {
                                                                                    // Customize what your widget looks like when it's loading.
                                                                                    if (!snapshot.hasData) {
                                                                                      return Center(
                                                                                        child: SizedBox(
                                                                                          width: 40.0,
                                                                                          height: 40.0,
                                                                                          child: CircularProgressIndicator(
                                                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                                                              Colors.transparent,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }

                                                                                    final containerfmuserUsersRecord = snapshot.data!;

                                                                                    return Container(
                                                                                      decoration: BoxDecoration(),
                                                                                      child: Visibility(
                                                                                        visible: containerfmuserUsersRecord.subscriptionActive && ((containerfmuserUsersRecord.subscriptionPlanName != 'root_plan') && (containerfmuserUsersRecord.subscriptionPlanName != 'root_plan_yearly')) && (containerProductRecord.stockQuantity > 0),
                                                                                        child: StreamBuilder<List<CartRecord>>(
                                                                                          stream: queryCartRecord(
                                                                                            parent: myfavoritesUsersRecord.reference,
                                                                                            queryBuilder: (cartRecord) => cartRecord.where(
                                                                                              'productRef',
                                                                                              isEqualTo: containerProductRecord.reference,
                                                                                            ),
                                                                                            singleRecord: true,
                                                                                          ),
                                                                                          builder: (context, snapshot) {
                                                                                            // Customize what your widget looks like when it's loading.
                                                                                            if (!snapshot.hasData) {
                                                                                              return Center(
                                                                                                child: SizedBox(
                                                                                                  width: 40.0,
                                                                                                  height: 40.0,
                                                                                                  child: CircularProgressIndicator(
                                                                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                                                                      Colors.transparent,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            }
                                                                                            List<CartRecord> containerCartRecordList = snapshot.data!;
                                                                                            final containerCartRecord = containerCartRecordList.isNotEmpty ? containerCartRecordList.first : null;

                                                                                            return InkWell(
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
                                                                                                        '${containerProductRecord.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                          enText: ' has been removed from cart',
                                                                                                          frText: ' a été retiré du panier',
                                                                                                        )}',
                                                                                                        style: TextStyle(
                                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        ),
                                                                                                      ),
                                                                                                      duration: Duration(milliseconds: 4000),
                                                                                                      backgroundColor: FlutterFlowTheme.of(context).primarytheme,
                                                                                                    ),
                                                                                                  );
                                                                                                } else {
                                                                                                  _model.carts = await queryCartRecordOnce(
                                                                                                    parent: myfavoritesUsersRecord.reference,
                                                                                                  );
                                                                                                  if (_model.carts?.length != 0) {
                                                                                                    if (_model.carts?.firstOrNull?.farmRef == containerProductRecord.farmRef) {
                                                                                                      await CartRecord.createDoc(myfavoritesUsersRecord.reference).set(createCartRecordData(
                                                                                                        productRef: containerProductRecord.reference,
                                                                                                        quantity: 1,
                                                                                                        pricePerProduct: containerProductRecord.price,
                                                                                                        farmRef: containerProductRecord.farmRef,
                                                                                                      ));
                                                                                                      FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                                      safeSetState(() {});
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                        SnackBar(
                                                                                                          content: Text(
                                                                                                            '${containerProductRecord.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                              enText: ' has been added in cart',
                                                                                                              frText: ' a été ajouté au panier',
                                                                                                            )}',
                                                                                                            style: TextStyle(
                                                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                                                            ),
                                                                                                          ),
                                                                                                          duration: Duration(milliseconds: 4000),
                                                                                                          backgroundColor: FlutterFlowTheme.of(context).primarytheme,
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
                                                                                                              frText: 'Oups ! Vous avez déjà de délicieux articles de ',
                                                                                                            )}${_model.oldfarm?.farmName}${FFLocalizations.of(context).getVariableText(
                                                                                                              enText: ' in your cart. To add items from ',
                                                                                                              frText: 'dans votre panier. Pour ajouter des articles depuis ',
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
                                                                                                    await CartRecord.createDoc(myfavoritesUsersRecord.reference).set(createCartRecordData(
                                                                                                      productRef: containerProductRecord.reference,
                                                                                                      quantity: 1,
                                                                                                      pricePerProduct: containerProductRecord.price,
                                                                                                      farmRef: containerProductRecord.farmRef,
                                                                                                    ));
                                                                                                    FFAppState().cartlist = FFAppState().cartlist + 1;
                                                                                                    safeSetState(() {});
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                                      SnackBar(
                                                                                                        content: Text(
                                                                                                          '${containerProductRecord.productName}${FFLocalizations.of(context).getVariableText(
                                                                                                            enText: ' has been added in cart',
                                                                                                            frText: ' a été ajouté au panier',
                                                                                                          )}',
                                                                                                          style: TextStyle(
                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                          ),
                                                                                                        ),
                                                                                                        duration: Duration(milliseconds: 4000),
                                                                                                        backgroundColor: FlutterFlowTheme.of(context).primarytheme,
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
                                                                                                  color: containerCartRecord?.reference == null ? Color(0x1A3BB273) : Color(0x39E63946),
                                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                                  border: Border.all(
                                                                                                    color: containerCartRecord?.reference == null ? FlutterFlowTheme.of(context).primarytheme : FlutterFlowTheme.of(context).tometoRed,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Builder(
                                                                                                  builder: (context) {
                                                                                                    if (containerCartRecord?.reference == null) {
                                                                                                      return Icon(
                                                                                                        Icons.add,
                                                                                                        color: FlutterFlowTheme.of(context).primarytheme,
                                                                                                        size: 24.0,
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Icon(
                                                                                                        Icons.remove,
                                                                                                        color: FlutterFlowTheme.of(context).tometoRed,
                                                                                                        size: 24.0,
                                                                                                      );
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            })
                                                .divide(SizedBox(height: 16.0))
                                                .addToEnd(
                                                    SizedBox(height: 15.0)),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (myfavoritesUsersRecord.isSuspend)
                    ClipRRect(
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
                              context.pushNamed(HelpandsupportWidget.routeName);
                            },
                          ),
                        ),
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
