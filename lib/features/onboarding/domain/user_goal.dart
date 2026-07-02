import 'package:bitewise/features/onboarding/domain/goal_type.dart';

/// Het volledige, actieve voedingsdoel van de gebruiker.
class UserGoal {
  const UserGoal({
    required this.goalType,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.sugarLimit,
    this.preferences = const {},
    this.allergies = const {},
  });

  final GoalType goalType;

  /// Dagelijks caloriedoel (kcal).
  final int calorieTarget;

  /// Dagelijks eiwitdoel (g).
  final int proteinTarget;

  /// Dagelijkse suikerlimiet (g).
  final int sugarLimit;

  final Set<DietPreference> preferences;
  final Set<Allergy> allergies;

  /// Verstandige startwaarden voor een net gekozen doel.
  factory UserGoal.defaultsFor(GoalType type) {
    return switch (type) {
      GoalType.loseWeight =>
        const UserGoal(goalType: GoalType.loseWeight, calorieTarget: 1800, proteinTarget: 110, sugarLimit: 40),
      GoalType.maintain =>
        const UserGoal(goalType: GoalType.maintain, calorieTarget: 2200, proteinTarget: 90, sugarLimit: 50),
      GoalType.buildMuscle =>
        const UserGoal(goalType: GoalType.buildMuscle, calorieTarget: 2600, proteinTarget: 150, sugarLimit: 55),
      GoalType.lessSugar =>
        const UserGoal(goalType: GoalType.lessSugar, calorieTarget: 2000, proteinTarget: 100, sugarLimit: 25),
    };
  }

  UserGoal copyWith({
    GoalType? goalType,
    int? calorieTarget,
    int? proteinTarget,
    int? sugarLimit,
    Set<DietPreference>? preferences,
    Set<Allergy>? allergies,
  }) {
    return UserGoal(
      goalType: goalType ?? this.goalType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      sugarLimit: sugarLimit ?? this.sugarLimit,
      preferences: preferences ?? this.preferences,
      allergies: allergies ?? this.allergies,
    );
  }

  /// Compacte payload voor de recommend_swaps Edge Function.
  Map<String, dynamic> toContextJson() => {
        'goal_type': goalType.name,
        'calorie_target': calorieTarget,
        'protein_target': proteinTarget,
        'sugar_limit': sugarLimit,
        'preferences': preferences.map((p) => p.name).toList(),
        'allergies': allergies.map((a) => a.name).toList(),
      };
}
