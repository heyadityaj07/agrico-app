import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'commancard_model.dart';
export 'commancard_model.dart';

class CommancardWidget extends StatefulWidget {
  const CommancardWidget({
    super.key,
    required this.product,
  });

  final ProductRecord? product;

  @override
  State<CommancardWidget> createState() => _CommancardWidgetState();
}

class _CommancardWidgetState extends State<CommancardWidget> {
  late CommancardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommancardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
              widget!.product?.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        width: 150.0,
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
                          imageUrl: widget!.product!.productImage,
                          width: double.infinity,
                          height: 120.0,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              Image.asset(
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              14.0, 8.0, 14.0, 0.0),
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
                                  widget!.product?.badges?.firstOrNull,
                                  'Organic',
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).offwhite,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 2.0, 2.0, 0.0),
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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
                                  if ((currentUserDocument?.myFavouriteProduct
                                              ?.toList() ??
                                          [])
                                      .contains(widget!.product?.reference)) {
                                    await currentUserReference!.update({
                                      ...mapToFirestore(
                                        {
                                          'my_favourite_product':
                                              FieldValue.arrayRemove(
                                                  [widget!.product?.reference]),
                                        },
                                      ),
                                    });
                                  } else {
                                    await currentUserReference!.update({
                                      ...mapToFirestore(
                                        {
                                          'my_favourite_product':
                                              FieldValue.arrayUnion(
                                                  [widget!.product?.reference]),
                                        },
                                      ),
                                    });
                                  }
                                },
                                child: Builder(
                                  builder: (context) {
                                    if ((currentUserDocument?.myFavouriteProduct
                                                ?.toList() ??
                                            [])
                                        .contains(widget!.product?.reference)) {
                                      return Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 2.0, 0.0, 0.0),
                                          child: Icon(
                                            Icons.favorite_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .tometoRed,
                                            size: 20.0,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 2.0, 0.0, 0.0),
                                          child: Icon(
                                            Icons.favorite_border,
                                            color: FlutterFlowTheme.of(context)
                                                .tometoRed,
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
              Flexible(
                child: StreamBuilder<FarmsRecord>(
                  stream: FarmsRecord.getDocument(widget!.product!.farmRef!),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }

                    final columnFarmsRecord = snapshot.data!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    widget!.product?.productName,
                                    'product name',
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .textprimary,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              columnFarmsRecord.farmName,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .textsecondary,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                              overflow: TextOverflow.ellipsis,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'c42ws7zs' /* 4.5 km • 0.2 lbs CO₂ saved */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .textsecondary,
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget!.product?.isVariableWeight ?? true)
                                Expanded(
                                  child: Text(
                                    '${widget!.product?.productWeight?.length?.toString()} weight brackets',
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                              if (!widget!.product!.isVariableWeight)
                                Expanded(
                                  child: AutoSizeText(
                                    '${FFLocalizations.of(context).languageCode != 'fr' ? '\$' : ''}${formatNumber(
                                      widget!.product?.price,
                                      formatType: FormatType.custom,
                                      format: '#.##',
                                      locale: '',
                                    )}${FFLocalizations.of(context).languageCode != 'en' ? '€' : ''}/${widget!.product?.unit}',
                                    maxLines: 1,
                                    minFontSize: 4.0,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                              if (!widget!.product!.isVariableWeight)
                                Align(
                                  alignment: AlignmentDirectional(1.0, 0.0),
                                  child: StreamBuilder<UsersRecord>(
                                    stream: UsersRecord.getDocument(
                                        columnFarmsRecord.userRef!),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final containerfmuserUsersRecord =
                                          snapshot.data!;

                                      return Container(
                                        decoration: BoxDecoration(),
                                        child: StreamBuilder<List<CartRecord>>(
                                          stream: queryCartRecord(
                                            parent: currentUserReference,
                                            queryBuilder: (cartRecord) =>
                                                cartRecord.where(
                                              'productRef',
                                              isEqualTo:
                                                  widget!.product?.reference,
                                            ),
                                            singleRecord: true,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            List<CartRecord>
                                                containerCartRecordList =
                                                snapshot.data!;
                                            final containerCartRecord =
                                                containerCartRecordList
                                                        .isNotEmpty
                                                    ? containerCartRecordList
                                                        .first
                                                    : null;

                                            return Container(
                                              decoration: BoxDecoration(),
                                              child: Builder(
                                                builder: (context) {
                                                  if (containerCartRecord
                                                          ?.reference ==
                                                      null) {
                                                    return Visibility(
                                                      visible: containerfmuserUsersRecord
                                                              .subscriptionActive &&
                                                          ((valueOrDefault<
                                                                      String>(
                                                                    containerfmuserUsersRecord
                                                                        .subscriptionPlanName,
                                                                    'Free Trial',
                                                                  ) !=
                                                                  'root_plan_yearly') &&
                                                              (valueOrDefault<
                                                                      String>(
                                                                    containerfmuserUsersRecord
                                                                        .subscriptionPlanName,
                                                                    'Free Trial',
                                                                  ) !=
                                                                  'root_plan')) &&
                                                          (widget!.product!
                                                                  .stockQuantity >
                                                              0),
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
                                                          _model.cart =
                                                              await queryCartRecordOnce(
                                                            parent:
                                                                currentUserReference,
                                                            queryBuilder:
                                                                (cartRecord) =>
                                                                    cartRecord
                                                                        .where(
                                                              'productRef',
                                                              isEqualTo: widget!
                                                                  .product
                                                                  ?.reference,
                                                            ),
                                                            singleRecord: true,
                                                          ).then((s) => s
                                                                  .firstOrNull);
                                                          if (_model.cart
                                                                  ?.reference !=
                                                              null) {
                                                          } else {
                                                            _model.carts =
                                                                await queryCartRecordOnce(
                                                              parent:
                                                                  currentUserReference,
                                                            );
                                                            if (_model.carts
                                                                    ?.length !=
                                                                0) {
                                                              if (_model
                                                                      .carts
                                                                      ?.firstOrNull
                                                                      ?.farmRef ==
                                                                  widget!
                                                                      .product
                                                                      ?.farmRef) {
                                                                await CartRecord
                                                                        .createDoc(
                                                                            currentUserReference!)
                                                                    .set(
                                                                        createCartRecordData(
                                                                  productRef: widget!
                                                                      .product
                                                                      ?.reference,
                                                                  quantity: 1,
                                                                  pricePerProduct:
                                                                      widget!
                                                                          .product
                                                                          ?.price,
                                                                  farmRef: widget!
                                                                      .product
                                                                      ?.farmRef,
                                                                ));
                                                                FFAppState()
                                                                        .cartlist =
                                                                    FFAppState()
                                                                            .cartlist +
                                                                        1;
                                                                FFAppState()
                                                                    .update(
                                                                        () {});
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      '${widget!.product?.productName}${FFLocalizations.of(context).getVariableText(
                                                                        enText:
                                                                            ' has been added in cart',
                                                                        frText:
                                                                            ' a été ajouté au panier',
                                                                      )}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                  ),
                                                                );
                                                              } else {
                                                                _model.oldfarm =
                                                                    await FarmsRecord.getDocumentOnce(_model
                                                                        .carts!
                                                                        .firstOrNull!
                                                                        .farmRef!);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .clearSnackBars();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      '${FFLocalizations.of(context).getVariableText(
                                                                        enText:
                                                                            'Oops! You already have delicious items from ',
                                                                        frText:
                                                                            'Oups ! Vous avez déjà de délicieux articles de ',
                                                                      )}${_model.oldfarm?.farmName}${FFLocalizations.of(context).getVariableText(
                                                                        enText:
                                                                            ' in your cart. To add items from ',
                                                                        frText:
                                                                            ' dans votre panier. Pour ajouter des articles depuis',
                                                                      )}${columnFarmsRecord.farmName}${FFLocalizations.of(context).getVariableText(
                                                                        enText:
                                                                            ', you\'ll need to start a new order.',
                                                                        frText:
                                                                            ', Vous devrez passer une nouvelle commande.',
                                                                      )}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .textprimary,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4850),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                  ),
                                                                );
                                                              }
                                                            } else {
                                                              await CartRecord
                                                                      .createDoc(
                                                                          currentUserReference!)
                                                                  .set(
                                                                      createCartRecordData(
                                                                productRef: widget!
                                                                    .product
                                                                    ?.reference,
                                                                quantity: 1,
                                                                pricePerProduct:
                                                                    widget!
                                                                        .product
                                                                        ?.price,
                                                                farmRef: widget!
                                                                    .product
                                                                    ?.farmRef,
                                                              ));
                                                              FFAppState()
                                                                      .cartlist =
                                                                  FFAppState()
                                                                          .cartlist +
                                                                      1;
                                                              FFAppState()
                                                                  .update(
                                                                      () {});
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    '${widget!.product?.productName}${FFLocalizations.of(context).getVariableText(
                                                                      enText:
                                                                          ' has been added in cart',
                                                                      frText:
                                                                          ' a été ajouté au panier',
                                                                    )}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          4000),
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                ),
                                                              );
                                                            }
                                                          }

                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width: 26.0,
                                                          height: 26.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0x1A3BB273),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primarytheme,
                                                            ),
                                                          ),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Visibility(
                                                      visible: widget!.product!
                                                              .stockQuantity >
                                                          0,
                                                      child: Container(
                                                        width: 70.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .seconadrybutton,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  if (containerCartRecord!
                                                                          .quantity >=
                                                                      2) {
                                                                    await containerCartRecord!
                                                                        .reference
                                                                        .update({
                                                                      ...mapToFirestore(
                                                                        {
                                                                          'quantity':
                                                                              FieldValue.increment(-(1)),
                                                                        },
                                                                      ),
                                                                    });
                                                                  } else {
                                                                    await containerCartRecord!
                                                                        .reference
                                                                        .delete();
                                                                  }

                                                                  _model
                                                                      .updatePage(
                                                                          () {});
                                                                },
                                                                child: FaIcon(
                                                                  FaIconData(const IconData(
                                                                      /* minus */ 0xf068,
                                                                      fontFamily:
                                                                          'FontAwesomeSolid',
                                                                      fontPackage:
                                                                          'font_awesome_flutter')),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primarytheme,
                                                                  size: 16.0,
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    containerCartRecord
                                                                        ?.quantity
                                                                        ?.toString(),
                                                                    '0',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primarytheme,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  if (containerCartRecord!
                                                                          .quantity <
                                                                      widget!
                                                                          .product!
                                                                          .stockQuantity) {
                                                                    await containerCartRecord!
                                                                        .reference
                                                                        .update({
                                                                      ...mapToFirestore(
                                                                        {
                                                                          'quantity':
                                                                              FieldValue.increment(1),
                                                                        },
                                                                      ),
                                                                    });
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                          FFLocalizations.of(context)
                                                                              .getVariableText(
                                                                            enText:
                                                                                'Not enough stock available',
                                                                            frText:
                                                                                'Pas assez de stock disponible',
                                                                          ),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                          ),
                                                                        ),
                                                                        duration:
                                                                            Duration(milliseconds: 4000),
                                                                        backgroundColor:
                                                                            FlutterFlowTheme.of(context).secondary,
                                                                      ),
                                                                    );
                                                                  }

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primarytheme,
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
                                      );
                                    },
                                  ),
                                ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
