import 'package:flutter_test/flutter_test.dart';

import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/nutrition_calculator.dart';

void main() {
  // Referentiepersoon: vrouw, 30 jaar, 170 cm, 70 kg, gemiddeld actief.
  CalculatorInput input(GoalType goal, {double? kg, int? weeks}) =>
      CalculatorInput(
        sex: Sex.female,
        age: 30,
        heightCm: 170,
        weightKg: 70,
        activity: ActivityLevel.moderate,
        goal: goal,
        targetLossKg: kg,
        weeks: weeks,
      );

  group('calculateNeeds', () {
    test('onderhoud gebruikt de TDEE', () {
      final r = calculateNeeds(input(GoalType.maintain));
      // BMR 1451.5 × 1.55 ≈ 2250 kcal.
      expect(r.calorieTarget, 2250);
      expect(r.proteinTarget, 100); // 70 kg × 1.4
      expect(r.sugarLimit, 55); // 10% van energie
    });

    test('spieropbouw voegt een overschot toe', () {
      final maintain = calculateNeeds(input(GoalType.maintain));
      final muscle = calculateNeeds(input(GoalType.buildMuscle));
      expect(muscle.calorieTarget, greaterThan(maintain.calorieTarget));
      expect(muscle.proteinTarget, greaterThan(maintain.proteinTarget));
    });

    test('afvallen levert een tekort t.o.v. onderhoud', () {
      final maintain = calculateNeeds(input(GoalType.maintain));
      final loss = calculateNeeds(input(GoalType.loseWeight, kg: 5, weeks: 10));
      expect(loss.calorieTarget, lessThan(maintain.calorieTarget));
    });

    test('minder suiker verlaagt de suikerlimiet', () {
      final maintain = calculateNeeds(input(GoalType.maintain));
      final lessSugar = calculateNeeds(input(GoalType.lessSugar));
      expect(lessSugar.sugarLimit, lessThan(maintain.sugarLimit));
    });

    test('respecteert het veilige calorie-minimum bij extreem tempo', () {
      // 20 kg in 4 weken is onrealistisch snel → moet begrensd worden.
      final r = calculateNeeds(input(GoalType.loseWeight, kg: 20, weeks: 4));
      expect(r.calorieTarget, greaterThanOrEqualTo(1200));
      expect(r.note, isNotNull);
    });
  });
}
