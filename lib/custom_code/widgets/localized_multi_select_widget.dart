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

class LocalizedMultiSelectWidget extends StatefulWidget {
  const LocalizedMultiSelectWidget({
    super.key,
    this.width,
    this.height,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });

  final double? width;
  final double? height;
  final List<String> options;
  final List<String> selectedOptions;
  final Future Function(List<String> value) onChanged;

  @override
  State<LocalizedMultiSelectWidget> createState() =>
      _LocalizedMultiSelectWidgetState();
}

class _LocalizedMultiSelectWidgetState
    extends State<LocalizedMultiSelectWidget> {
  late List<String> _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = List.from(widget.selectedOptions);
  }

  @override
  void didUpdateWidget(covariant LocalizedMultiSelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOptions != widget.selectedOptions) {
      _currentSelection = List.from(widget.selectedOptions);
    }
  }

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
    return Container(
      width: widget.width,
      height: widget.height,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: List.generate(widget.options.length, (index) {
          final item = widget.options[index];
          final isSelected = _currentSelection.contains(item);
          return InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (isSelected) {
                _currentSelection.remove(item);
              } else {
                _currentSelection.add(item);
              }
              setState(() {});
              await widget.onChanged(_currentSelection);
            },
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).orange
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  _getTranslatedText(item),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Satoshi',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
