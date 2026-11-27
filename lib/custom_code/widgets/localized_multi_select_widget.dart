// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
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
    const Map<String, String> translations = {
      // Seasons
      'Spring': 'Printemps',
      'Summer': 'Été',
      'Autumn': 'Automne',
      'Winter': 'Hiver',
      'Monsoon': 'Mousson',
      'Dry Season': 'Saison sèche',
      'Rainy Season': 'Saison des pluies',
      'Year-round': "Toute l'année",

      // Common production practices
      'Organic': 'Biologique',
      'Conventional': 'Conventionnel',
      'Integrated Farming': 'Agriculture raisonnée',
      'Regenerative Agriculture': 'Agriculture régénératrice',
      'Agroecology': 'Agroécologie',
      'Biodynamic': 'Biodynamie',
      'Traditional Production': 'Production traditionnelle',
      'Artisanal Production': 'Production artisanale',
      'Non-GMO': 'Sans OGM',

      // Plant production
      'Permaculture': 'Permaculture',
      'Pesticide-Free': 'Sans pesticides',
      'No Synthetic Pesticides': 'Sans pesticides de synthèse',
      'No Herbicides': 'Sans herbicides',
      'Open Field': 'Cultivé en plein champ',
      'Greenhouse Grown': 'Cultivé sous serre',
      'Naturally Ripened': 'Mûri naturellement',

      // Animal production
      'Antibiotic-Free': 'Sans antibiotiques',
      'Raised Without Vaccination': 'Élevé sans vaccination',
      'Hormone-Free': 'Sans hormones',
      'Free-Range': 'Élevé en plein air',
      'Grass-Fed': "Nourri à l'herbe",
      'Pasture-Raised': 'Élevé au pâturage',

      // Beekeeping
      'Raw Honey': 'Miel brut',
      'Unheated Honey': 'Miel non chauffé',

      // Processed products
      'Farm Processed': 'Transformé à la ferme',
      'No Added Preservatives': 'Sans conservateurs ajoutés',
      'No Added Colors': 'Sans colorants ajoutés',
      'No Added Sugar': 'Sans sucres ajoutés',

      // Legacy values
      'Local Harvest': 'Récolte locale',
      'Seasonal': 'De saison',
      'Farm Fresh': 'Frais de la ferme',
    };

    return FFLocalizations.of(context).getVariableText(
      enText: item,
      frText: translations[item] ?? item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      //height: widget.height,
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
