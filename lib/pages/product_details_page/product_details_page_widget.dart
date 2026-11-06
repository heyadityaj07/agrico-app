import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/carts/view_cart/view_cart_widget.dart';
import '/components/caculation_card_widget.dart';
import '/components/data_load_widget.dart';
import '/components/suspend_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'product_details_page_model.dart';
export 'product_details_page_model.dart';

class ProductDetailsPageWidget extends StatefulWidget {
  const ProductDetailsPageWidget({
    super.key,
    required this.product,
  });

  final DocumentReference? product;

  static String routeName = 'productDetailsPage';
  static String routePath = '/productDetailsPage';

  @override
  State<ProductDetailsPageWidget> createState() =>
      _ProductDetailsPageWidgetState();
}

class _ProductDetailsPageWidgetState extends State<ProductDetailsPageWidget> {
  late ProductDetailsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.config = await queryConfigRecordOnce(
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.weightDepositPercent = _model.config?.weightProductDeposit;
      safeSetState(() {});
      _model.product = await ProductRecord.getDocumentOnce(widget.product!);
      _model.farm = await FarmsRecord.getDocumentOnce(_model.product!.farmRef!);
      _model.standardProductPrice = _model.product?.price;
      safeSetState(() {});
      _model.farmlocation = await actions.getAddressFromLatLng(
        _model.farm!.farmLocation!,
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

        final productDetailsPageUsersRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).offwhite,
            body: StreamBuilder<ProductRecord>(
              stream: ProductRecord.getDocument(widget.product!),
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

                final stackProductRecord = snapshot.data!;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: stackProductRecord.productImage,
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
                                    19.0, 40.0, 21.0, 0.0),
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
                                            color: FlutterFlowTheme.of(context)
                                                .card,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
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
                                        if ((currentUserDocument
                                                    ?.myFavouriteProduct
                                                    .toList() ??
                                                [])
                                            .contains(
                                                stackProductRecord.reference)) {
                                          await currentUserReference!.update({
                                            ...mapToFirestore(
                                              {
                                                'my_favourite_product':
                                                    FieldValue.arrayRemove([
                                                  stackProductRecord.reference
                                                ]),
                                              },
                                            ),
                                          });
                                        } else {
                                          await currentUserReference!.update({
                                            ...mapToFirestore(
                                              {
                                                'my_favourite_product':
                                                    FieldValue.arrayUnion([
                                                  stackProductRecord.reference
                                                ]),
                                              },
                                            ),
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x67FFFFFF),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .card,
                                          ),
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            if ((currentUserDocument
                                                        ?.myFavouriteProduct
                                                        .toList() ??
                                                    [])
                                                .contains(stackProductRecord
                                                    .reference)) {
                                              return Icon(
                                                Icons.favorite,
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 38.0, 0.0, 0.0),
                            child: StreamBuilder<FarmsRecord>(
                              stream: FarmsRecord.getDocument(
                                  stackProductRecord.farmRef!),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return DataLoadWidget(
                                    height: 800.0,
                                    width: MediaQuery.sizeOf(context).width,
                                    cmncolor:
                                        FlutterFlowTheme.of(context).offwhite,
                                  );
                                }

                                final columnFarmsRecord = snapshot.data!;

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 13.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            stackProductRecord.productName,
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textprimary,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                          if (!stackProductRecord
                                              .isVariableWeight)
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                if (FFLocalizations.of(context)
                                                        .languageCode !=
                                                    'fr')
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '5ouuribn' /* $ */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primarytheme,
                                                          fontSize: 24.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    stackProductRecord.price
                                                        .toString(),
                                                    '0',
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
                                                        fontSize: 24.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                if (FFLocalizations.of(context)
                                                        .languageCode !=
                                                    'en')
                                                  Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'fiyl4ap3' /* € */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primarytheme,
                                                          fontSize: 24.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                Text(
                                                  ' / ${stackProductRecord.unit}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primarytheme,
                                                        fontSize: 24.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (stackProductRecord.isVariableWeight ==
                                        true)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 13.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              (FFMainAxisAlignment.start)
                                                  .flutterValue,
                                          crossAxisAlignment:
                                              (FFCrossAxisAlignment.start)
                                                  .flutterValue,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'jd8jdtqu' /* Choose a weight bracket */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textprimary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                            ),
                                            Builder(
                                              builder: (context) {
                                                final weight =
                                                    stackProductRecord
                                                        .productWeight
                                                        .toList();

                                                return Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 8.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: List.generate(
                                                      weight.length,
                                                      (weightIndex) {
                                                    final weightItem =
                                                        weight[weightIndex];
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
                                                        _model.selectedWeightBracket =
                                                            weightItem;
                                                        safeSetState(() {});
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (_model.selectedWeightBracket !=
                                                                      null) &&
                                                                  (_model.selectedWeightBracket
                                                                          ?.minWeight ==
                                                                      weightItem
                                                                          .minWeight) &&
                                                                  (_model.selectedWeightBracket
                                                                          ?.maxWeight ==
                                                                      weightItem
                                                                          .maxWeight)
                                                              ? Color(
                                                                  0x1A3BB273)
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                            color: (_model.selectedWeightBracket !=
                                                                        null) &&
                                                                    (_model.selectedWeightBracket
                                                                            ?.minWeight ==
                                                                        weightItem
                                                                            .minWeight) &&
                                                                    (_model.selectedWeightBracket
                                                                            ?.maxWeight ==
                                                                        weightItem
                                                                            .maxWeight)
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .boderdivder,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                (FFMainAxisAlignment
                                                                        .start)
                                                                    .flutterValue,
                                                            crossAxisAlignment:
                                                                (FFCrossAxisAlignment
                                                                        .start)
                                                                    .flutterValue,
                                                            textBaseline:
                                                                TextBaseline
                                                                    .alphabetic,
                                                            children: [
                                                              Text(
                                                                '${formatNumber(
                                                                  weightItem
                                                                      .minWeight,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )} - ${formatNumber(
                                                                  weightItem
                                                                      .maxWeight,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )} kg',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .textprimary,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                              Text(
                                                                'Price per kg: ${formatNumber(
                                                                  weightItem
                                                                      .pricePerKg,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .textsecondary,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 4.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                            if (_model.selectedWeightBracket !=
                                                null)
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .boderdivder,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        (FFMainAxisAlignment
                                                                .start)
                                                            .flutterValue,
                                                    crossAxisAlignment:
                                                        (FFCrossAxisAlignment
                                                                .start)
                                                            .flutterValue,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            (FFMainAxisAlignment
                                                                    .start)
                                                                .flutterValue,
                                                        crossAxisAlignment:
                                                            (FFCrossAxisAlignment
                                                                    .center)
                                                                .flutterValue,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calculate_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme,
                                                            size: 18.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                '712ejhno' /* Live Pricing Breakdown */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Satoshi',
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x1F2E7D32),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.0),
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          3.0,
                                                                          8.0,
                                                                          3.0),
                                                              child: Text(
                                                                '${formatNumber(
                                                                  _model
                                                                      .weightDepositPercent,
                                                                  formatType:
                                                                      FormatType
                                                                          .custom,
                                                                  format:
                                                                      '#.##',
                                                                  locale: '',
                                                                )}% Deposit Rule',
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
                                                                          11.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 6.0)),
                                                      ),
                                                      Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .boderdivder,
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            (FFMainAxisAlignment
                                                                    .start)
                                                                .flutterValue,
                                                        crossAxisAlignment:
                                                            (FFCrossAxisAlignment
                                                                    .center)
                                                                .flutterValue,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: [
                                                          wrapWithModel(
                                                            model: _model
                                                                .caculationCardModel1,
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                CaculationCardWidget(
                                                              label:
                                                                  'Est. Weight Range:',
                                                              value: ((_model.selectedWeightBracket!
                                                                              .minWeight ??
                                                                          0) >
                                                                      0)
                                                                  ? '${formatNumber(
                                                                      _model
                                                                          .selectedWeightBracket
                                                                          ?.minWeight,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )} - ${formatNumber(
                                                                      _model
                                                                          .selectedWeightBracket
                                                                          ?.maxWeight,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )} kg (Avg: ${formatNumber(
                                                                      (_model.selectedWeightBracket!.minWeight +
                                                                              _model.selectedWeightBracket!.maxWeight) /
                                                                          2,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )} kg)'
                                                                  : '--',
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                            ),
                                                          ),
                                                          wrapWithModel(
                                                            model: _model
                                                                .caculationCardModel2,
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                CaculationCardWidget(
                                                              label:
                                                                  'Estimated Average Price:',
                                                              value: ((_model.selectedWeightBracket!
                                                                              .minWeight ??
                                                                          0) >
                                                                      0)
                                                                  ? '${formatNumber(
                                                                      ((_model.selectedWeightBracket!.minWeight + _model.selectedWeightBracket!.maxWeight) /
                                                                              2) *
                                                                          (_model.selectedWeightBracket!.pricePerKg ??
                                                                              0),
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )}'
                                                                  : '--',
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                            ),
                                                          ),
                                                          wrapWithModel(
                                                            model: _model
                                                                .caculationCardModel3,
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                CaculationCardWidget(
                                                              label:
                                                                  'Deposit due at checkout (${formatNumber(
                                                                _model
                                                                    .weightDepositPercent,
                                                                formatType:
                                                                    FormatType
                                                                        .custom,
                                                                format: '#.##',
                                                                locale: '',
                                                              )}%):',
                                                              value: ((_model.selectedWeightBracket!
                                                                              .minWeight ??
                                                                          0) >
                                                                      0)
                                                                  ? '${formatNumber(
                                                                      (((_model.selectedWeightBracket!.minWeight + _model.selectedWeightBracket!.maxWeight) / 2) *
                                                                              (_model.selectedWeightBracket!.pricePerKg ??
                                                                                  0)) *
                                                                          ((_model.weightDepositPercent!) ??
                                                                              0) /
                                                                          100,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )}'
                                                                  : '--',
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                            ),
                                                          ),
                                                          wrapWithModel(
                                                            model: _model
                                                                .caculationCardModel4,
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                CaculationCardWidget(
                                                              label:
                                                                  'Remaining balance on delivery (${formatNumber(
                                                                100 -
                                                                    ((_model.weightDepositPercent!) ??
                                                                        0),
                                                                formatType:
                                                                    FormatType
                                                                        .custom,
                                                                format: '#.##',
                                                                locale: '',
                                                              )}%):',
                                                              value: ((_model.selectedWeightBracket!
                                                                              .minWeight ??
                                                                          0) >
                                                                      0)
                                                                  ? '${formatNumber(
                                                                      (((_model.selectedWeightBracket!.minWeight + _model.selectedWeightBracket!.maxWeight) / 2) *
                                                                              (_model.selectedWeightBracket!.pricePerKg ??
                                                                                  0)) *
                                                                          (100 -
                                                                              ((_model.weightDepositPercent!) ?? 0)) /
                                                                          100,
                                                                      formatType:
                                                                          FormatType
                                                                              .custom,
                                                                      format:
                                                                          '#.##',
                                                                      locale:
                                                                          '',
                                                                    )}'
                                                                  : '--',
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .textprimary,
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 6.0)),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 8.0)),
                                                  ),
                                                ),
                                              ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                      ),
                                    StreamBuilder<List<OrderRecord>>(
                                      stream: queryOrderRecord(
                                        queryBuilder: (orderRecord) =>
                                            orderRecord.where(
                                          'order_items',
                                          arrayContains:
                                              getOrderItemsFirestoreData(
                                            OrderItemsStruct(
                                              productRef: widget.product,
                                            ),
                                            true,
                                          ),
                                        ),
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 40.0,
                                              height: 40.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.transparent,
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
                                                    .length !=
                                                0,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 8.0, 16.0, 0.0),
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
                                                    '${(functions.avargeRating(containerOrderRecordList.map((e) => valueOrDefault<double>(
                                                          e.review.rate,
                                                          0.0,
                                                        )).toList()).clamp(0.0, 5.0)).toString()}(${containerOrderRecordList.where((e) => (e.levaeReview == true) && (e.review.reviewStatus == 'Approved')).toList().length.toString()}${FFLocalizations.of(context).getVariableText(
                                                      enText: ' Reviews )',
                                                      frText: 'Commentaires )',
                                                    )}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 12.0,
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
                                          16.0, 8.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            FFIcons.khome,
                                            color: FlutterFlowTheme.of(context)
                                                .primarytheme,
                                            size: 24.0,
                                          ),
                                          Text(
                                            columnFarmsRecord.farmName,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primarytheme,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 4.0)),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 28.0, 13.0, 24.0),
                                        child: Builder(
                                          builder: (context) {
                                            final bedge = stackProductRecord
                                                .badges
                                                .toList();

                                            return Wrap(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              runAlignment: WrapAlignment.start,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              clipBehavior: Clip.none,
                                              children: List.generate(
                                                  bedge.length, (bedgeIndex) {
                                                final bedgeItem =
                                                    bedge[bedgeIndex];
                                                return Container(
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0x1A3BB273),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10.0,
                                                        color:
                                                            Color(0x1A3BB273),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 2.0,
                                                                12.0, 2.0),
                                                    child: Text(
                                                      bedgeItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primarytheme,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                    Divider(
                                      height: 0.0,
                                      thickness: 1.0,
                                      indent: 16.0,
                                      endIndent: 13.0,
                                      color: FlutterFlowTheme.of(context)
                                          .boderdivder,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 28.0, 13.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (responsiveVisibility(
                                            context: context,
                                            phone: false,
                                          ))
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'zyb0xsv9' /* Origin: */,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textsecondary,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        lineHeight: 1.5,
                                                      ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    _model.farmlocation,
                                                    'Farm loc',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Satoshi',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .textsecondary,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '0uh9fa9q' /* Season: */,
                                                ),
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1.5,
                                                        ),
                                              ),
                                              Stack(
                                                children: [
                                                  if (false)
                                                    Text(
                                                      (List<String> var1) {
                                                        return var1.join(',');
                                                      }(stackProductRecord
                                                          .sesson
                                                          .toList()),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Satoshi',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textsecondary,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                  custom_widgets
                                                      .LocalizedListDisplayWidget(
                                                    width: 100.0,
                                                    height: 50.0,
                                                    isBadge: true,
                                                    items: stackProductRecord
                                                        .sesson,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'fn9xpy3g' /* Storage: */,
                                                ),
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1.5,
                                                        ),
                                              ),
                                              Text(
                                                stackProductRecord.storageType,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'cych588f' /* Preparation: */,
                                                ),
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1.5,
                                                        ),
                                              ),
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'csulp82c' /* Same day */,
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  't3jgia1b' /* Stock: */,
                                                ),
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1.5,
                                                        ),
                                              ),
                                              Text(
                                                '${stackProductRecord.stockQuantity.toString()} available',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Satoshi',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .textsecondary,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 10.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 28.0, 13.0, 28.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          _model.chatfind =
                                              await queryChatRecordOnce(
                                            queryBuilder: (chatRecord) =>
                                                chatRecord.where(
                                              'users',
                                              arrayContains:
                                                  currentUserReference,
                                            ),
                                          );
                                          if (_model.chatfind
                                                  ?.where((e) => e.users
                                                      .contains(
                                                          columnFarmsRecord
                                                              .userRef))
                                                  .toList()
                                                  .length !=
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
                                                      .firstOrNull,
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
                                                    .firstOrNull,
                                              },
                                            );
                                          } else {
                                            _model.usersref = [];
                                            safeSetState(() {});
                                            _model.addToUsersref(
                                                currentUserReference!);
                                            safeSetState(() {});
                                            _model.addToUsersref(
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
                                                userb:
                                                    columnFarmsRecord.userRef,
                                                timeb: getCurrentTimestamp,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'users': _model.usersref,
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
                                                userb:
                                                    columnFarmsRecord.userRef,
                                                timeb: getCurrentTimestamp,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'users': _model.usersref,
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
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '5acsopa9' /* Contact */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kchat,
                                          size: 24.0,
                                        ),
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 48.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconAlignment: IconAlignment.end,
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconColor:
                                              FlutterFlowTheme.of(context)
                                                  .offwhite,
                                          color: FlutterFlowTheme.of(context)
                                              .primarytheme,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
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
                                    Divider(
                                      height: 0.0,
                                      thickness: 1.0,
                                      indent: 16.0,
                                      endIndent: 13.0,
                                      color: FlutterFlowTheme.of(context)
                                          .boderdivder,
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 28.0, 13.0, 0.0),
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            '4swbd93p' /* Batch Information */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textprimary,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 13.0, 0.0),
                                        child: Text(
                                          stackProductRecord.batchInformation,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primarytheme,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 28.0, 13.0, 28.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            stackProductRecord.description,
                                            '-',
                                          ),
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textsecondary,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ].addToEnd(SizedBox(height: 100.0)),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: StreamBuilder<UsersRecord>(
                        stream: UsersRecord.getDocument(
                            stackProductRecord.userRef!),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return DataLoadWidget(
                              height: 100.0,
                              width: MediaQuery.sizeOf(context).width,
                              cmncolor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            );
                          }

                          final containerUsersRecord = snapshot.data!;

                          return Container(
                            height: 100.0,
                            decoration: BoxDecoration(),
                            child: Builder(
                              builder: (context) {
                                if (containerUsersRecord.subscriptionActive &&
                                    ((containerUsersRecord
                                                .subscriptionPlanName !=
                                            'root_plan') &&
                                        (containerUsersRecord
                                                .subscriptionPlanName !=
                                            'root_plan_yearly'))) {
                                  return StreamBuilder<List<CartRecord>>(
                                    stream: queryCartRecord(
                                      parent: currentUserReference,
                                      queryBuilder: (cartRecord) =>
                                          cartRecord.where(
                                        'productRef',
                                        isEqualTo: stackProductRecord.reference,
                                      ),
                                      singleRecord: true,
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return DataLoadWidget(
                                          height: 80.0,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          cmncolor: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        );
                                      }
                                      List<CartRecord>
                                          conditionalBuilderCartRecordList =
                                          snapshot.data!;
                                      final conditionalBuilderCartRecord =
                                          conditionalBuilderCartRecordList
                                                  .isNotEmpty
                                              ? conditionalBuilderCartRecordList
                                                  .first
                                              : null;

                                      return Builder(
                                        builder: (context) {
                                          if (conditionalBuilderCartRecord
                                                  ?.reference ==
                                              null) {
                                            return Builder(
                                              builder: (context) {
                                                if (stackProductRecord
                                                        .stockQuantity >
                                                    0) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    13.0,
                                                                    20.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            if ((stackProductRecord
                                                                        .isVariableWeight ==
                                                                    true) &&
                                                                (_model.selectedWeightBracket ==
                                                                    null)) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Select a weight bracket before adding to cart',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .textprimary,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          4000),
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primarytheme,
                                                                ),
                                                              );
                                                            } else if (conditionalBuilderCartRecord
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
                                                                _model.farm1 = await FarmsRecord
                                                                    .getDocumentOnce(
                                                                        stackProductRecord
                                                                            .farmRef!);
                                                                if (_model
                                                                        .carts
                                                                        ?.firstOrNull
                                                                        ?.farmRef ==
                                                                    _model.farm1
                                                                        ?.reference) {
                                                                  await CartRecord
                                                                          .createDoc(
                                                                              currentUserReference!)
                                                                      .set(
                                                                          createCartRecordData(
                                                                    productRef:
                                                                        stackProductRecord
                                                                            .reference,
                                                                    quantity: 1,
                                                                    pricePerProduct: stackProductRecord
                                                                            .isVariableWeight
                                                                        ? (((_model.selectedWeightBracket!.minWeight + _model.selectedWeightBracket!.maxWeight) /
                                                                                2) *
                                                                            (_model.selectedWeightBracket!.pricePerKg ??
                                                                                0))
                                                                        : _model
                                                                            .standardProductPrice,
                                                                    farmRef:
                                                                        stackProductRecord
                                                                            .farmRef,
                                                                    isVariableWeight:
                                                                        stackProductRecord
                                                                            .isVariableWeight,
                                                                    minWeight: _model
                                                                        .selectedWeightBracket
                                                                        ?.minWeight,
                                                                    maxWeight: _model
                                                                        .selectedWeightBracket
                                                                        ?.maxWeight,
                                                                    pricePerKg: _model
                                                                        .selectedWeightBracket
                                                                        ?.pricePerKg,
                                                                    depositAmount: ((_model.selectedWeightBracket!.minWeight +
                                                                                _model
                                                                                    .selectedWeightBracket!.maxWeight) /
                                                                            2) *
                                                                        (_model.selectedWeightBracket!.pricePerKg ??
                                                                            0) *
                                                                        ((_model.weightDepositPercent!) ??
                                                                            0) /
                                                                        100,
                                                                  ));
                                                                  FFAppState()
                                                                          .cartlist =
                                                                      FFAppState()
                                                                              .cartlist +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        '${stackProductRecord.productName}${FFLocalizations.of(context).getVariableText(
                                                                          enText:
                                                                              ' has been added in cart',
                                                                          frText:
                                                                              ' a été ajouté au panier',
                                                                        )}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
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
                                                                              'dans votre panier. Pour ajouter des articles depuis',
                                                                        )}${_model.farm1?.farmName}${FFLocalizations.of(context).getVariableText(
                                                                          enText:
                                                                              ', you\'ll need to start a new order.',
                                                                          frText:
                                                                              ', Vous devrez passer une nouvelle commande.',
                                                                        )}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).textprimary,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
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
                                                                  productRef:
                                                                      stackProductRecord
                                                                          .reference,
                                                                  quantity: 1,
                                                                  pricePerProduct: stackProductRecord
                                                                          .isVariableWeight
                                                                      ? (((_model.selectedWeightBracket!.minWeight + _model.selectedWeightBracket!.maxWeight) /
                                                                              2) *
                                                                          (_model.selectedWeightBracket!.pricePerKg ??
                                                                              0))
                                                                      : _model
                                                                          .standardProductPrice,
                                                                  farmRef:
                                                                      stackProductRecord
                                                                          .farmRef,
                                                                  isVariableWeight:
                                                                      stackProductRecord
                                                                          .isVariableWeight,
                                                                  minWeight: _model
                                                                      .selectedWeightBracket
                                                                      ?.minWeight,
                                                                  maxWeight: _model
                                                                      .selectedWeightBracket
                                                                      ?.maxWeight,
                                                                  pricePerKg: _model
                                                                      .selectedWeightBracket
                                                                      ?.pricePerKg,
                                                                  depositAmount: ((_model.selectedWeightBracket!.minWeight +
                                                                              _model
                                                                                  .selectedWeightBracket!.maxWeight) /
                                                                          2) *
                                                                      (_model.selectedWeightBracket!
                                                                              .pricePerKg ??
                                                                          0) *
                                                                      ((_model.weightDepositPercent!) ??
                                                                          0) /
                                                                      100,
                                                                ));
                                                                FFAppState()
                                                                        .cartlist =
                                                                    FFAppState()
                                                                            .cartlist +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      '${stackProductRecord.productName}${FFLocalizations.of(context).getVariableText(
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
                                                              }
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                          text: conditionalBuilderCartRecord
                                                                      ?.reference !=
                                                                  null
                                                              ? 'View Cart'
                                                              : 'Add to Cart',
                                                          options:
                                                              FFButtonOptions(
                                                            width:
                                                                double.infinity,
                                                            height: 48.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: conditionalBuilderCartRecord
                                                                        ?.reference !=
                                                                    null
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primarytheme,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Satoshi',
                                                                      color: Colors
                                                                          .white,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 20.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'qsjjip25' /* Out of Stock */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Satoshi',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          } else {
                                            return StreamBuilder<
                                                List<CartRecord>>(
                                              stream: queryCartRecord(
                                                parent: currentUserReference,
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return DataLoadWidget(
                                                    height: 80.0,
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    cmncolor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                  );
                                                }
                                                List<CartRecord>
                                                    containerCartRecordList =
                                                    snapshot.data!;

                                                return Container(
                                                  width: double.infinity,
                                                  height: 96.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .card,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                18.0,
                                                                16.0,
                                                                18.0,
                                                                16.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      1.0, 0.0),
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (containerCartRecordList
                                                                          .length >
                                                                      1) {
                                                                    return Container(
                                                                      width:
                                                                          90.0,
                                                                      child:
                                                                          Stack(
                                                                        alignment: AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                StreamBuilder<ProductRecord>(
                                                                              stream: ProductRecord.getDocument(containerCartRecordList.firstOrNull!.productRef!),
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

                                                                                final transformProductRecord = snapshot.data!;

                                                                                return Transform.rotate(
                                                                                  angle: 197.0 * (math.pi / 180),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: CachedNetworkImage(
                                                                                      fadeInDuration: Duration(milliseconds: 500),
                                                                                      fadeOutDuration: Duration(milliseconds: 500),
                                                                                      imageUrl: transformProductRecord.productImage,
                                                                                      width: 45.0,
                                                                                      height: 45.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                          FutureBuilder<
                                                                              ProductRecord>(
                                                                            future:
                                                                                ProductRecord.getDocumentOnce(containerCartRecordList.lastOrNull!.productRef!),
                                                                            builder:
                                                                                (context, snapshot) {
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

                                                                              final transformProductRecord = snapshot.data!;

                                                                              return Transform.rotate(
                                                                                angle: 62.0 * (math.pi / 180),
                                                                                child: Visibility(
                                                                                  visible: transformProductRecord.reference != null,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: CachedNetworkImage(
                                                                                      fadeInDuration: Duration(milliseconds: 500),
                                                                                      fadeOutDuration: Duration(milliseconds: 500),
                                                                                      imageUrl: transformProductRecord.productImage,
                                                                                      width: 45.0,
                                                                                      height: 45.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child: StreamBuilder<
                                                                          ProductRecord>(
                                                                        stream: ProductRecord.getDocument(containerCartRecordList
                                                                            .firstOrNull!
                                                                            .productRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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

                                                                          final transformProductRecord =
                                                                              snapshot.data!;

                                                                          return Transform
                                                                              .rotate(
                                                                            angle:
                                                                                0.0 * (math.pi / 180),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: CachedNetworkImage(
                                                                                fadeInDuration: Duration(milliseconds: 500),
                                                                                fadeOutDuration: Duration(milliseconds: 500),
                                                                                imageUrl: transformProductRecord.productImage,
                                                                                width: 45.0,
                                                                                height: 45.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    (FFMainAxisAlignment
                                                                            .center)
                                                                        .flutterValue,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        '${containerCartRecordList.length.toString()}${FFLocalizations.of(context).getVariableText(
                                                                          enText:
                                                                              ' Item',
                                                                          frText:
                                                                              'Article',
                                                                        )}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).textprimary,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            await showModalBottomSheet(
                                                                              isScrollControlled: true,
                                                                              backgroundColor: Colors.transparent,
                                                                              enableDrag: false,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    FocusScope.of(context).unfocus();
                                                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                    child: ViewCartWidget(),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ).then((value) =>
                                                                                safeSetState(() {}));
                                                                          },
                                                                          child:
                                                                              FaIcon(
                                                                            FaIconData(const IconData(/* angleUp */ 0xf106,
                                                                                fontFamily: 'FontAwesomeSolid',
                                                                                fontPackage: 'font_awesome_flutter')),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).orange,
                                                                            size:
                                                                                15.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        'Total ',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                      if (FFLocalizations.of(context)
                                                                              .languageCode !=
                                                                          'fr')
                                                                        Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            '8yc8uohd' /* $ */,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          functions
                                                                              .cartTotal(containerCartRecordList.toList())
                                                                              .toStringAsFixed(2),
                                                                          '0',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Satoshi',
                                                                              color: FlutterFlowTheme.of(context).primarytheme,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                      if (FFLocalizations.of(context)
                                                                              .languageCode ==
                                                                          'fr')
                                                                        Text(
                                                                          FFLocalizations.of(context)
                                                                              .getText(
                                                                            'dsjj3mae' /* € */,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Satoshi',
                                                                                color: FlutterFlowTheme.of(context).primarytheme,
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        5.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.0, 0.0),
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              context.pushNamed(
                                                                  CartWidget
                                                                      .routeName);
                                                            },
                                                            text: FFLocalizations
                                                                    .of(context)
                                                                .getText(
                                                              'gqb8j1wj' /* View Cart */,
                                                            ),
                                                            options:
                                                                FFButtonOptions(
                                                              height: 40.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primarytheme,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Satoshi',
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                              elevation: 0.0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 15.0, 16.0, 15.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '0lhe9opr' /* Products from this farm are cu... */,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Satoshi',
                                            color: FlutterFlowTheme.of(context)
                                                .textprimary,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (productDetailsPageUsersRecord.isSuspend)
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
                                context
                                    .pushNamed(HelpandsupportWidget.routeName);
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
