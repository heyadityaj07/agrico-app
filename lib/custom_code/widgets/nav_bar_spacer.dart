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

class NavBarSpacer extends StatefulWidget {
  const NavBarSpacer({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<NavBarSpacer> createState() => _NavBarSpacerState();
}

class _NavBarSpacerState extends State<NavBarSpacer> {
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    // Heuristic: 3-button nav usually has a larger bottom inset
    final isThreeButton = bottom >= 40;

    if (!isThreeButton) return const SizedBox.shrink();

    return Container(
      height: bottom, // match system bottom inset
      color: Colors.transparent,
    );
  }
}
