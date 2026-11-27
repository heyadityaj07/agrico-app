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
