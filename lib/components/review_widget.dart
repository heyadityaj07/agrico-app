import '/backend/backend.dart';
import '/components/data_load_widget.dart';
import '/components/delete_review_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'review_model.dart';
export 'review_model.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.orderRef,
  });

  final DocumentReference? orderRef;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late ReviewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderRecord>(
      stream: OrderRecord.getDocument(widget.orderRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return DataLoadWidget(
            height: 250.0,
            width: MediaQuery.sizeOf(context).width,
            cmncolor: FlutterFlowTheme.of(context).card,
          );
        }

        final containerOrderRecord = snapshot.data!;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                FFIcons.kgiftCustom,
                                color:
                                    FlutterFlowTheme.of(context).primarytheme,
                                size: 24.0,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      6.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    '${FFLocalizations.of(context).getVariableText(
                                      enText: 'Order #',
                                      frText: 'Commande #',
                                    )}${containerOrderRecord.reference.id}',
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textprimary,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: () {
                            if (containerOrderRecord.review.reviewStatus ==
                                'Pending') {
                              return Color(0x27EE8B60);
                            } else if (containerOrderRecord
                                    .review.reviewStatus ==
                                'Approved') {
                              return Color(0x243BB273);
                            } else {
                              return Color(0x11FF5963);
                            }
                          }(),
                          borderRadius: BorderRadius.circular(99.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 4.0, 12.0, 4.0),
                          child: Text(
                            containerOrderRecord.review.reviewStatus,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Satoshi',
                                  color: () {
                                    if (containerOrderRecord
                                            .review.reviewStatus ==
                                        'Pending') {
                                      return FlutterFlowTheme.of(context)
                                          .tertiary;
                                    } else if (containerOrderRecord
                                            .review.reviewStatus ==
                                        'Approved') {
                                      return FlutterFlowTheme.of(context)
                                          .primarytheme;
                                    } else {
                                      return FlutterFlowTheme.of(context).error;
                                    }
                                  }(),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 12.0, 0.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                final orderitems =
                                    containerOrderRecord.orderItems.toList();

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(orderitems.length,
                                      (orderitemsIndex) {
                                    final orderitemsItem =
                                        orderitems[orderitemsIndex];
                                    return StreamBuilder<ProductRecord>(
                                      stream: ProductRecord.getDocument(
                                          orderitemsItem.productRef!),
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

                                        final containerProductRecord =
                                            snapshot.data!;

                                        return Container(
                                          decoration: BoxDecoration(),
                                          child: Text(
                                            containerProductRecord.productName,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Satoshi',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .textprimary,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                );
                              },
                            ),
                            StreamBuilder<FarmsRecord>(
                              stream: FarmsRecord.getDocument(
                                  containerOrderRecord.farmRef!),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final containerFarmsRecord = snapshot.data!;

                                return Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    containerFarmsRecord.farmName,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          color: FlutterFlowTheme.of(context)
                                              .textsecondary,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                    ),
                    RatingBar.builder(
                      onRatingUpdate: (newValue) =>
                          safeSetState(() => _model.ratingBarValue = newValue),
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: FlutterFlowTheme.of(context).harvestYellow,
                      ),
                      direction: Axis.horizontal,
                      initialRating: _model.ratingBarValue ??=
                          containerOrderRecord.review.rate,
                      unratedColor: Color(0x7BF5B703),
                      itemCount: 5,
                      itemSize: 24.0,
                      glowColor: FlutterFlowTheme.of(context).harvestYellow,
                    ),
                  ],
                ),
                if (containerOrderRecord.review.comment != '')
                  Text(
                    containerOrderRecord.review.comment,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).textprimary,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                StreamBuilder<FarmsRecord>(
                  stream:
                      FarmsRecord.getDocument(containerOrderRecord.farmRef!),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return DataLoadWidget(
                        height: 82.0,
                        width: 82.0,
                        cmncolor: FlutterFlowTheme.of(context).card,
                      );
                    }

                    final containerFarmsRecord = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            containerFarmsRecord.farmProfilePhoto,
                            width: 52.0,
                            height: 52.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  height: 0.0,
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).boderdivder,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateTimeFormat(
                          "d/M/y",
                          containerOrderRecord.review.createdAt!,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Satoshi',
                              color: FlutterFlowTheme.of(context).textsecondary,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: DeleteReviewWidget(
                                    delteaction: () async {
                                      await containerOrderRecord.reference
                                          .update(createOrderRecordData(
                                        levaeReview: false,
                                        review:
                                            createReviewStruct(delete: true),
                                      ));
                                      _model.updatePage(() {});
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete_outline,
                            color: FlutterFlowTheme.of(context).orange,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
