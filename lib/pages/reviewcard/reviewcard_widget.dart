import '/backend/backend.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reviewcard_model.dart';
export 'reviewcard_model.dart';

class ReviewcardWidget extends StatefulWidget {
  const ReviewcardWidget({
    super.key,
    this.review,
  });

  final PublicReviewsRecord? review;

  @override
  State<ReviewcardWidget> createState() => _ReviewcardWidgetState();
}

class _ReviewcardWidgetState extends State<ReviewcardWidget> {
  late ReviewcardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewcardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                  crossAxisAlignment:
                      (FFCrossAxisAlignment.center).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      width: 32.0,
                      height: 32.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        widget!.review?.authorPhotoUrl != null &&
                                widget!.review?.authorPhotoUrl != ''
                            ? widget!.review!.authorPhotoUrl
                            : 'https://firebasestorage.googleapis.com/v0/b/agricoo-b9c46.firebasestorage.app/o/emptyfarm.png?alt=media&token=96750024-1b52-44f4-8e36-52b74593c198',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/error_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        widget!.review!.authorDisplayName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).textsecondary,
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ],
                ),
                Text(
                  dateTimeFormat(
                    "yMMMd",
                    widget!.review!.createdAt!,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: RatingBar.builder(
                onRatingUpdate: (newValue) =>
                    safeSetState(() => _model.ratingBarValue = newValue),
                itemBuilder: (context, index) => Icon(
                  Icons.star_rounded,
                  color: FlutterFlowTheme.of(context).harvestYellow,
                ),
                direction: Axis.horizontal,
                initialRating: _model.ratingBarValue ??= widget!.review!.rating,
                unratedColor: Color(0x7CF5B703),
                itemCount: 5,
                itemSize: 24.0,
                glowColor: FlutterFlowTheme.of(context).harvestYellow,
              ),
            ),
            if (widget!.review?.comment != null &&
                widget!.review?.comment != '')
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: Text(
                  widget!.review!.comment,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).textprimary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
          ].divide(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
