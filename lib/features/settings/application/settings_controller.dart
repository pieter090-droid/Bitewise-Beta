import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/onboarding/data/user_goals_repository.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';

/// Acties voor het instellingenscherm: doel bijwerken, privacy en data beheren.
class SettingsController {
  SettingsController(this._ref);

  final Ref _ref;

  Future<void> updateGoal(UserGoal goal) =>
      _ref.read(userGoalsRepositoryProvider).saveGoal(goal);

  Future<void> setSyncEnabled(bool value) async {
    await _ref.read(preferencesServiceProvider).setSyncEnabled(value);
    _ref.read(syncEnabledProvider.notifier).state = value;
  }

  Future<void> setAnalyticsEnabled(bool value) =>
      _ref.read(preferencesServiceProvider).setAnalyticsEnabled(value);

  /// Verwijdert alle persoonlijke lokale data (logs, favorieten, feedback, cache).
  /// Het gekozen doel blijft staan.
  Future<void> clearPersonalData() async {
    final db = _ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.delete(db.dayLogs).go();
      await db.delete(db.favoriteProducts).go();
      await db.delete(db.swapFeedbacks).go();
      await db.delete(db.cachedProducts).go();
    });
  }

  /// Reset de hele app: wist alles én het opgeslagen doel + onboarding-vlag.
  Future<void> resetEverything() async {
    final db = _ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.delete(db.dayLogs).go();
      await db.delete(db.favoriteProducts).go();
      await db.delete(db.swapFeedbacks).go();
      await db.delete(db.cachedProducts).go();
      await db.delete(db.userGoals).go();
    });
    await _ref.read(preferencesServiceProvider).setOnboardingComplete(false);
    _ref.read(onboardingCompleteProvider.notifier).state = false;
  }
}

final settingsControllerProvider = Provider<SettingsController>(
  (ref) => SettingsController(ref),
);
