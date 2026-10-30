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

import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/components/data_load_widget.dart';

class SubscriptionPriceWidget extends StatefulWidget {
  const SubscriptionPriceWidget({
    super.key,
    this.width,
    this.height,
    required this.priceId,
    required this.isYearly,
    required this.useAlignmentAndSecondaryColor,
  });

  final double? width;
  final double? height;
  final String priceId;
  final bool isYearly;
  final bool useAlignmentAndSecondaryColor;

  @override
  State<SubscriptionPriceWidget> createState() =>
      _SubscriptionPriceWidgetState();
}

class _SubscriptionPriceWidgetState extends State<SubscriptionPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: ApiManager.instance.makeApiCall(
        callName: 'price api',
        apiUrl:
            'https://api.stripe.com/v1/prices?expand[]=data.currency_options',
        callType: ApiCallType.GET,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${FFAppConstants.planKey}',
        },
        params: {
          'expand[]': "data.product",
          'lookup_keys[]': widget.priceId,
          'active': "true",
          'currency':
              FFLocalizations.of(context).languageCode == 'fr' ? 'EUR' : 'USD',
        },
        bodyType: BodyType.NONE,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return DataLoadWidget(
            height: 15.0,
            width: 150.0,
            cmncolor: FlutterFlowTheme.of(context).card,
          );
        }
        final containerPriceApiResponse = snapshot.data!;

        final priceUsd = ((valueOrDefault<int>(
                  castToType<int>(getJsonField(
                    containerPriceApiResponse.jsonBody,
                    r'''$.data[0].currency_options.usd.unit_amount''',
                  )),
                  0,
                )) /
                100)
            .toString();
        final priceEur = ((valueOrDefault<int>(
                  castToType<int>(getJsonField(
                    containerPriceApiResponse.jsonBody,
                    r'''$.data[0].currency_options.eur.unit_amount''',
                  )),
                  0,
                )) /
                100)
            .toString();

        final isFr = FFLocalizations.of(context).languageCode == 'fr';
        final prefix = isFr ? '' : '\$';
        final suffix = isFr ? '€' : '';
        final priceValue = isFr ? priceEur : priceUsd;
        final period = widget.isYearly ? 'Yearly' : 'Month';

        final textWidget = Text(
          'Price $prefix$priceValue$suffix/$period',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Satoshi',
                color: widget.useAlignmentAndSecondaryColor
                    ? FlutterFlowTheme.of(context).textsecondary
                    : FlutterFlowTheme.of(context).primarytheme,
                fontSize: 14.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
              ),
        );

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: const BoxDecoration(),
          child: widget.useAlignmentAndSecondaryColor
              ? Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: textWidget,
                )
              : textWidget,
        );
      },
    );
  }
}
