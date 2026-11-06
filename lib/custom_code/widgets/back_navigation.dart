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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

class BackNavigation extends StatefulWidget {
  const BackNavigation({
    super.key,
    this.width,
    this.height,
    this.actionexcute,
  });

  final double? width;
  final double? height;
  final Future Function()? actionexcute;

  @override
  State<BackNavigation> createState() => _BackNavigationState();
}

class _BackNavigationState extends State<BackNavigation> {
  bool _isHandlingPop = false;

  Future<void> _handlePop() async {
    // Prevent multiple simultaneous calls
    if (_isHandlingPop) return;

    setState(() => _isHandlingPop = true);

    try {
      // Execute the custom action if provided
      if (widget.actionexcute != null) {
        await widget.actionexcute!();
      }
    } finally {
      setState(() => _isHandlingPop = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevents the default back navigation
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // didPop is true if the page already popped (canPop: true case)
        if (didPop) return;

        await _handlePop();
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        // Transparent — acts as an invisible overlay interceptor
        child: const SizedBox.shrink(),
      ),
    );
  }
}
