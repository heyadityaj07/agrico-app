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

import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/empty_widget.dart';

class ProducerProductReviewsWidget extends StatefulWidget {
  const ProducerProductReviewsWidget({
    super.key,
    this.width,
    this.height,
    this.productRef,
    this.farmRef,
    required this.reviewtitle,
  });

  final double? width;
  final double? height;
  final DocumentReference? productRef;
  final DocumentReference? farmRef;
  final String reviewtitle;

  @override
  State<ProducerProductReviewsWidget> createState() =>
      _ProducerProductReviewsWidgetState();
}

class _ProducerProductReviewsWidgetState
    extends State<ProducerProductReviewsWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.farmRef == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText(
              'wdqc6g96' /* Customer Reviews */,
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Satoshi',
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          StreamBuilder<List<OrderRecord>>(
            stream: queryOrderRecord(
              queryBuilder: (orderRecord) => orderRecord.where(
                'farm_ref',
                isEqualTo: widget.farmRef,
              ),
            ),
            builder: (context, snapshot) {
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

              // Filter for valid reviews for this product
              List<OrderRecord> columnOrderRecordList =
                  snapshot.data!.where((order) {
                if (!order.hasReview() || order.review.rate <= 0) return false;
                if (order.review.createdAt == null) return false;
                return order.orderItems
                    .any((item) => item.productRef == widget.productRef);
              }).toList();

              if (columnOrderRecordList.isEmpty) {
                return EmptyWidget();
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    List.generate(columnOrderRecordList.length, (columnIndex) {
                  final columnOrderRecord = columnOrderRecordList[columnIndex];
                  final review = columnOrderRecord.review;
                  final isReported = review.reviewStatus == 'Reported' ||
                      review.reviewStatus == 'Abusive';

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: FlutterFlowTheme.of(context)
                                        .harvestYellow,
                                    size: 24.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    valueOrDefault<String>(
                                      review.rate.toString(),
                                      '0',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Satoshi',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              if (isReported)
                                Text(
                                  "Reported",
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Satoshi',
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                )
                              else
                                InkWell(
                                  onTap: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Report Review"),
                                        content: Text(
                                            "Are you sure you want to report this review as abusive or inappropriate?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              "Report",
                                              style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await columnOrderRecord.reference.update({
                                        'review.review_status': 'Reported',
                                      });
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Review reported successfully."),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .success,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Icon(
                                    Icons.flag_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 22,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            review.comment,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Satoshi',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 5.0),
                          if (review.createdAt != null)
                            Text(
                              dateTimeFormat(
                                "yMMMd",
                                review.createdAt!,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Satoshi',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
