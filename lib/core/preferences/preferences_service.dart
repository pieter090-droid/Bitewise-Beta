import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bitewise/core/constants/app_constants.dart';

/// Dunne wrapper rond shared_preferences voor simpele app-instellingen.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  bool get onboardingComplete =>
      _prefs.getBool(AppConstants.prefOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(AppConstants.prefOnboardingComplete, value);

  bool get syncEnabled => _prefs.getBool(AppConstants.prefSyncEnabled) ?? false;

  Future<void> setSyncEnabled(bool value) =>
      _prefs.setBool(AppConstants.prefSyncEnabled, value);

  bool get analyticsEnabled =>
      _prefs.getBool(AppConstants.prefAnalyticsEnabled) ?? false;

  Future<void> setAnalyticsEnabled(bool value) =>
      _prefs.setBool(AppConstants.prefAnalyticsEnabled, value);

  /// Stabiele, anonieme installatie-id. Wordt gebruikt om lokale logs een
  /// uniforme client-sleutel te geven voor idempotente sync.
  String getOrCreateInstallId() {
    final existing = _prefs.getString(AppConstants.prefInstallId);
    if (existing != null && existing.isNotEmpty) return existing;
    final rnd = Random.secure();
    final id = List.generate(16, (_) => rnd.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    _prefs.setString(AppConstants.prefInstallId, id);
    return id;
  }
}

/// Wordt in [main] overschreven met de echte instance na async init.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences niet geïnitialiseerd'),
);

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(ref.watch(sharedPreferencesProvider)),
);

/// Reactieve onboarding-status (voor router redirect).
final onboardingCompleteProvider = StateProvider<bool>(
  (ref) => ref.watch(preferencesServiceProvider).onboardingComplete,
);

final syncEnabledProvider = StateProvider<bool>(
  (ref) => ref.watch(preferencesServiceProvider).syncEnabled,
);
