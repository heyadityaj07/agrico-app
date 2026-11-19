/// Persistent checkout-attempt storage backed by the app's existing
/// `shared_preferences` dependency.
///
/// The key includes the authenticated user ID so one customer's pending
/// checkout can never be reused by another account on the same device.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'checkout_v1_client.dart';

class SharedPreferencesCheckoutAttemptStore implements CheckoutAttemptStore {
  SharedPreferencesCheckoutAttemptStore({
    required String ownerUid,
    SharedPreferences? preferences,
  })  : _ownerUid = _validateOwner(ownerUid),
        _preferences = preferences;

  final String _ownerUid;
  SharedPreferences? _preferences;

  String get _key => 'checkout_v1_attempt_$_ownerUid';

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<CheckoutAttemptLoadResult> load() async {
    final prefs = await _prefs();
    if (!prefs.containsKey(_key)) {
      return const CheckoutAttemptLoadResult.absent();
    }

    final stored = prefs.get(_key);
    if (stored is! String) {
      return CheckoutAttemptLoadResult.invalid(
        rawValue: stored?.toString() ?? '',
        reason: 'stored_attempt_not_a_string',
      );
    }
    if (stored.trim().isEmpty) {
      return CheckoutAttemptLoadResult.invalid(
        rawValue: stored,
        reason: 'stored_attempt_empty',
      );
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(stored);
    } catch (_) {
      return CheckoutAttemptLoadResult.invalid(
        rawValue: stored,
        reason: 'stored_attempt_malformed_json',
      );
    }

    if (decoded is! Map) {
      return CheckoutAttemptLoadResult.invalid(
        rawValue: stored,
        reason: 'stored_attempt_not_an_object',
      );
    }

    final attempt = CheckoutAttempt.maybeFromJson(
      decoded.cast<String, dynamic>(),
    );
    if (attempt == null) {
      return CheckoutAttemptLoadResult.invalid(
        rawValue: stored,
        reason: 'stored_attempt_invalid_fields',
      );
    }
    return CheckoutAttemptLoadResult.found(attempt);
  }

  @override
  Future<void> save(CheckoutAttempt attempt) async {
    final prefs = await _prefs();
    await prefs.setString(_key, jsonEncode(attempt.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(_key);
  }
}

String _validateOwner(String value) {
  final owner = value.trim();
  if (owner.isEmpty) {
    throw ArgumentError.value(value, 'ownerUid', 'A user ID is required');
  }
  return owner;
}
