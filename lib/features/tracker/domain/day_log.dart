import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Eén gelogd item op een dag (voedingswaarden voor de gelogde portie).
class DayLog {
  const DayLog({
    required this.id,
    required this.productName,
    required this.mealType,
    required this.grams,
    required this.kcal,
    required this.protein,
    required this.sugar,
    required this.carbs,
    required this.fat,
    required this.logDate,
    this.barcode,
  });

  final int id;
  final String? barcode;
  final String productName;
  final MealType mealType;
  final double grams;
  final double kcal;
  final double protein;
  final double sugar;
  final double carbs;
  final double fat;
  final DateTime logDate;
}

/// Geaggregeerde dagtotalen, afgezet tegen de doelen.
class DailySummary {
  const DailySummary({
    required this.kcal,
    required this.protein,
    required this.sugar,
    required this.carbs,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.sugarLimit,
    required this.carbsTarget,
  });

  final double kcal;
  final double protein;
  final double sugar;
  final double carbs;
  final int calorieTarget;
  final int proteinTarget;
  final int sugarLimit;
  final int carbsTarget;

  double get remainingKcal => (calorieTarget - kcal).clamp(-9999, 999999);

  double get kcalProgress =>
      calorieTarget == 0 ? 0 : (kcal / calorieTarget).clamp(0, 1);
  double get proteinProgress =>
      proteinTarget == 0 ? 0 : (protein / proteinTarget).clamp(0, 1);
  double get sugarProgress =>
      sugarLimit == 0 ? 0 : (sugar / sugarLimit).clamp(0, 1);
  double get carbsProgress =>
      carbsTarget == 0 ? 0 : (carbs / carbsTarget).clamp(0, 1);

  bool get overSugarLimit => sugar > sugarLimit;

  static const empty = DailySummary(
    kcal: 0,
    protein: 0,
    sugar: 0,
    carbs: 0,
    calorieTarget: 2000,
    proteinTarget: 100,
    sugarLimit: 50,
    carbsTarget: 250,
  );
}
