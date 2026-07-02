import 'package:flutter/material.dart';

/// Eetmomenten waarop een product gelogd kan worden.
enum MealType {
  breakfast('Ontbijt', Icons.wb_twilight_outlined),
  lunch('Lunch', Icons.lunch_dining_outlined),
  dinner('Diner', Icons.dinner_dining_outlined),
  snack('Snack', Icons.cookie_outlined);

  const MealType(this.label, this.icon);

  final String label;
  final IconData icon;

  static MealType fromIndex(int index) =>
      MealType.values[index.clamp(0, MealType.values.length - 1)];

  /// Verstandig standaard-eetmoment op basis van het huidige uur.
  static MealType suggestForNow([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 10) return MealType.breakfast;
    if (hour < 14) return MealType.lunch;
    if (hour < 18) return MealType.snack;
    return MealType.dinner;
  }
}
