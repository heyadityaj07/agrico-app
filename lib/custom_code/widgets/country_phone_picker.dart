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

import 'index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:flutter/services.dart';

class CountryPhonePicker extends StatefulWidget {
  const CountryPhonePicker({
    super.key,
    this.width,
    this.height,
    required this.initialCountryCode,
    this.initialPhoneNumber,
    required this.onPhoneChanged,
  });

  final double? width;
  final double? height;
  final String initialCountryCode;
  final String? initialPhoneNumber;
  final Future Function(String phoneNumber) onPhoneChanged;

  @override
  State<CountryPhonePicker> createState() => _CountryPhonePickerState();
}

class _CountryPhonePickerState extends State<CountryPhonePicker> {
  final TextEditingController _controller = TextEditingController();

  late String _selectedCountry;
  late String _dialCode;
  late String _formatPattern;
  late int _maxLength;

  // 🌍 Country dataset with strict international lengths
  final List<Map<String, dynamic>> _countries = [
    {"code": "IN", "dial": "+91", "format": "##### #####"},
    {"code": "US", "dial": "+1", "format": "(###) ###-####"},
    {"code": "GB", "dial": "+44", "format": "#### ### ####"},
    {"code": "AE", "dial": "+971", "format": "## ### ####"},
    {
      "code": "FR",
      "dial": "+33",
      "format": "# ## ## ## ##"
    }, // 🇫🇷 9 digits for international standards
    {"code": "ES", "dial": "+34", "format": "### ### ###"},
    {"code": "IT", "dial": "+39", "format": "### ### ####"},
    {"code": "NL", "dial": "+31", "format": "## ### ####"},
    {"code": "BE", "dial": "+32", "format": "### ## ## ##"},
    {"code": "DE", "dial": "+49", "format": "###########"},
  ];

  int _getLengthFromFormat(String format) {
    return format.split('').where((c) => c == '#').length;
  }

  @override
  void initState() {
    super.initState();
    _initializeCountry();
    _initializePhone();
  }

  void _initializeCountry() {
    final phone = widget.initialPhoneNumber ?? "";

    if (phone.startsWith("+")) {
      for (var c in _countries) {
        if (phone.startsWith(c["dial"])) {
          _selectedCountry = c["code"];
          _dialCode = c["dial"];
          _formatPattern = c["format"];
          _maxLength = _getLengthFromFormat(_formatPattern);
          return;
        }
      }
    }

    final country = _countries.firstWhere(
      (c) => c["code"] == widget.initialCountryCode.toUpperCase(),
      orElse: () => _countries.first,
    );

    _selectedCountry = country["code"];
    _dialCode = country["dial"];
    _formatPattern = country["format"];
    _maxLength = _getLengthFromFormat(_formatPattern);
  }

  void _initializePhone() {
    if (widget.initialPhoneNumber == null) return;

    String digits =
        widget.initialPhoneNumber!.replaceAll(RegExp(r'[^0-9]'), '');

    if (widget.initialPhoneNumber!.startsWith(_dialCode)) {
      digits = digits.substring(_dialCode.replaceAll("+", "").length);
    }

    // Handle initialization if the stored value accidentally preserved a leading '0' for France
    if (_selectedCountry == "FR" &&
        digits.startsWith('0') &&
        digits.length > 9) {
      digits = digits.substring(1);
    }

    _controller.text = _applyFormat(digits);
  }

  String _applyFormat(String digits) {
    String result = "";
    int digitIndex = 0;

    for (int i = 0; i < _formatPattern.length; i++) {
      if (_formatPattern[i] == "#") {
        if (digitIndex < digits.length) {
          result += digits[digitIndex++];
        } else {
          break;
        }
      } else {
        if (digitIndex < digits.length) {
          result += _formatPattern[i];
        }
      }
    }
    return result;
  }

  void _onChanged(String value) {
    String digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    // 🇫🇷 Direct Interceptor: Strips local trunk prefix '0' instantly for France
    if (_selectedCountry == "FR" &&
        digits.startsWith('0') &&
        digits.length > 1) {
      digits = digits.substring(1);
    }

    // Hard ceiling: enforces strict country specific length limits
    if (digits.length > _maxLength) {
      digits = digits.substring(0, _maxLength);
    }

    final formatted = _applyFormat(digits);

    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    // Only triggers validation/state commits when it matches the precise country requirement
    if (digits.length == _maxLength) {
      final full = "$_dialCode$digits";
      FFAppState().phonnumber = full;
      widget.onPhoneChanged(full);
    } else {
      FFAppState().phonnumber = '';
      widget.onPhoneChanged('');
    }

    setState(() {});
  }

  void _onCountryChange(String code) {
    final country = _countries.firstWhere((c) => c["code"] == code);

    setState(() {
      _selectedCountry = country["code"];
      _dialCode = country["dial"];
      _formatPattern = country["format"];
      _maxLength = _getLengthFromFormat(_formatPattern);
      _controller.clear();
    });

    FFAppState().phonnumber = '';
    widget.onPhoneChanged('');
  }

  int get _digitLength =>
      _controller.text.replaceAll(RegExp(r'[^0-9]'), '').length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          // COUNTRY SELECTOR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: FlutterFlowTheme.of(context).boderdivder,
              ),
              borderRadius: BorderRadius.circular(10),
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountry,
                items: _countries.map<DropdownMenuItem<String>>((country) {
                  final code = country["code"] as String;
                  final dial = country["dial"] as String;
                  return DropdownMenuItem(
                    value: code,
                    child: Text("$code $dial"),
                  );
                }).toList(),
                onChanged: (val) => _onCountryChange(val!),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // PHONE FIELD
          Expanded(
            child: SizedBox(
              height: 52,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.center,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: _formatPattern,
                  suffixText: "$_digitLength/$_maxLength",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
