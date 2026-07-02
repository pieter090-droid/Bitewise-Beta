import 'package:flutter_test/flutter_test.dart';

import 'package:bitewise/features/product/domain/nutriments.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';

void main() {
  group('Nutriments.scaledToGrams', () {
    const per100 = Nutriments(kcal: 500, protein: 10, sugar: 40, fat: 20);

    test('schaalt lineair naar portiegrootte', () {
      final scaled = per100.scaledToGrams(50);
      expect(scaled.kcal, 250);
      expect(scaled.protein, 5);
      expect(scaled.sugar, 20);
      expect(scaled.fat, 10);
    });

    test('nul gram levert nul op', () {
      final scaled = per100.scaledToGrams(0);
      expect(scaled.kcal, 0);
      expect(scaled.protein, 0);
    });
  });

  group('DailySummary', () {
    test('berekent resterende kcal en voortgang', () {
      const s = DailySummary(
        kcal: 500,
        protein: 50,
        sugar: 30,
        calorieTarget: 2000,
        proteinTarget: 100,
        sugarLimit: 50,
      );
      expect(s.remainingKcal, 1500);
      expect(s.kcalProgress, 0.25);
      expect(s.proteinProgress, 0.5);
      expect(s.overSugarLimit, isFalse);
    });

    test('detecteert overschrijding suikerlimiet', () {
      const s = DailySummary(
        kcal: 0,
        protein: 0,
        sugar: 60,
        calorieTarget: 2000,
        proteinTarget: 100,
        sugarLimit: 50,
      );
      expect(s.overSugarLimit, isTrue);
      expect(s.sugarProgress, 1); // geclamped op 1
    });
  });
}
