import 'package:intl/intl.dart';

String currencyCodeForLanguage(String? languageCode) {
  return languageCode?.toLowerCase() == 'fr' ? 'EUR' : 'USD';
}

String formatLanguageCurrency(
  double? amount,
  String? languageCode, {
  int decimalDigits = 2,
}) {
  final code = currencyCodeForLanguage(languageCode);
  return formatCurrencyAmount(amount, code, decimalDigits: decimalDigits);
}

/// Formats an amount using the currency recorded with it (for example the
/// rejection refund currency persisted by the backend). Returns an empty
/// string when no currency is recorded, so callers never display an amount in
/// a guessed currency.
String formatCurrencyAmount(
  double? amount,
  String? currencyCode, {
  int decimalDigits = 2,
}) {
  final code = (currencyCode ?? '').trim().toUpperCase();
  if (code.isEmpty) return '';
  return NumberFormat.simpleCurrency(
    name: code,
    decimalDigits: decimalDigits,
  ).format(amount ?? 0);
}
