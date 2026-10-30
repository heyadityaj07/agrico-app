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

class LocalizedListDisplayWidget extends StatefulWidget {
  const LocalizedListDisplayWidget({
    super.key,
    this.width,
    this.height,
    required this.items,
    required this.isBadge,
  });

  final double? width;
  final double? height;
  final List<String> items;
  final bool isBadge;

  @override
  State<LocalizedListDisplayWidget> createState() =>
      _LocalizedListDisplayWidgetState();
}

class _LocalizedListDisplayWidgetState
    extends State<LocalizedListDisplayWidget> {
  String _getTranslatedText(String item) {
    if (item == 'Monsoon') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Monsoon', frText: 'Mousson');
    } else if (item == 'Winter') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Winter', frText: 'Hiver');
    } else if (item == 'Summer') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Summer', frText: 'Été');
    } else if (item == 'Spring') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Spring', frText: 'Printemps');
    } else if (item == 'Autumn') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Autumn', frText: 'Automne');
    } else if (item == 'Organic') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Organic', frText: 'Biologique');
    } else if (item == 'Pesticide-Free') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Pesticide-Free', frText: 'Sans pesticide');
    } else if (item == 'Local Harvest') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Local Harvest', frText: 'Récolte locale');
    } else if (item == 'Seasonal') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Seasonal', frText: 'De saison');
    } else if (item == 'Farm Fresh') {
      return FFLocalizations.of(context)
          .getVariableText(enText: 'Farm Fresh', frText: 'Frais de la ferme');
    } else if (item == 'Naturally Ripened') {
      return FFLocalizations.of(context).getVariableText(
          enText: 'Naturally Ripened', frText: 'Mûri naturellement');
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.isBadge) {
    //   return Wrap(
    //     spacing: 10.0,
    //     runSpacing: 10.0,
    //     alignment: WrapAlignment.start,
    //     crossAxisAlignment: WrapCrossAlignment.start,
    //     direction: Axis.horizontal,
    //     runAlignment: WrapAlignment.start,
    //     verticalDirection: VerticalDirection.down,
    //     clipBehavior: Clip.none,
    //     children: List.generate(widget.items.length, (index) {
    //       final bedgeItem = widget.items[index];
    //       return Container(
    //         height: 25.0,
    //         decoration: BoxDecoration(
    //           color: Color(0x1A3BB273),
    //           boxShadow: [
    //             BoxShadow(
    //               blurRadius: 10.0,
    //               color: Color(0x1A3BB273),
    //               offset: Offset(0.0, 2.0),
    //             )
    //           ],
    //           borderRadius: BorderRadius.circular(999.0),
    //         ),
    //         child: Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 12.0, 2.0),
    //           child: Text(
    //             _getTranslatedText(bedgeItem),
    //             style: FlutterFlowTheme.of(context).bodyMedium.override(
    //                   fontFamily: 'Satoshi',
    //                   color: FlutterFlowTheme.of(context).primary,
    //                   letterSpacing: 0.0,
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //           ),
    //         ),
    //       );
    //     }),
    //   );
    // } else {
    return Text(
      widget.items.map((item) => _getTranslatedText(item)).join(', '),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Satoshi',
            color: FlutterFlowTheme.of(context).textsecondary,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.normal,
          ),
    );
    // }
  }
}
