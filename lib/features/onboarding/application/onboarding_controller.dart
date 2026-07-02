import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/onboarding/data/user_goals_repository.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';

/// Houdt de draft [UserGoal] bij tijdens de stapsgewijze onboarding.
class OnboardingController extends Notifier<UserGoal> {
  @override
  UserGoal build() => UserGoal.defaultsFor(GoalType.maintain);

  /// Wanneer de gebruiker een doeltype kiest, seeden we verstandige targets,
  /// maar behouden we al gekozen voorkeuren/allergieën.
  void selectGoalType(GoalType type) {
    final defaults = UserGoal.defaultsFor(type);
    state = defaults.copyWith(
      preferences: state.preferences,
      allergies: state.allergies,
    );
  }

  void setCalorieTarget(int value) => state = state.copyWith(calorieTarget: value);
  void setProteinTarget(int value) => state = state.copyWith(proteinTarget: value);
  void setSugarLimit(int value) => state = state.copyWith(sugarLimit: value);

  void togglePreference(DietPreference pref) {
    final next = {...state.preferences};
    next.contains(pref) ? next.remove(pref) : next.add(pref);
    state = state.copyWith(preferences: next);
  }

  void toggleAllergy(Allergy allergy) {
    final next = {...state.allergies};
    next.contains(allergy) ? next.remove(allergy) : next.add(allergy);
    state = state.copyWith(allergies: next);
  }

  /// Slaat het doel lokaal op en markeert onboarding als afgerond.
  Future<void> complete() async {
    await ref.read(userGoalsRepositoryProvider).saveGoal(state);
    await ref.read(preferencesServiceProvider).setOnboardingComplete(true);
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, UserGoal>(OnboardingController.new);
