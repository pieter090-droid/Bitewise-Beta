import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/features/product/domain/nutriments.dart';
import 'package:bitewise/features/product/domain/product.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// UI-state voor de portiecalculator op het productdetail-scherm.
class PortionState {
  const PortionState({required this.grams, required this.mealType});

  final double grams;
  final MealType mealType;

  PortionState copyWith({double? grams, MealType? mealType}) => PortionState(
        grams: grams ?? this.grams,
        mealType: mealType ?? this.mealType,
      );
}

class PortionController extends Notifier<PortionState> {
  @override
  PortionState build() => PortionState(
        grams: 100,
        mealType: MealType.suggestForNow(),
      );

  void initFor(Product product) {
    state = PortionState(
      grams: product.displayServing,
      mealType: MealType.suggestForNow(),
    );
  }

  void setGrams(double grams) =>
      state = state.copyWith(grams: grams.clamp(1, 2000));

  void setMealType(MealType meal) => state = state.copyWith(mealType: meal);

  /// Berekende voedingswaarden voor de gekozen portie.
  Nutriments nutrimentsFor(Product product) =>
      product.nutriments.scaledToGrams(state.grams);
}

final portionControllerProvider =
    NotifierProvider<PortionController, PortionState>(PortionController.new);
