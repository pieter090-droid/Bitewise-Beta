import 'package:flutter_test/flutter_test.dart';

import 'package:bitewise/features/snackswap/application/swap_ranker.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';

SnackProduct product({
  required String barcode,
  required String name,
  double? kcal,
  double? sugar,
  double? protein,
  double? fiber,
  String family = 'chocolate_spread',
  double? serving,
}) =>
    SnackProduct(
      barcode: barcode,
      name: name,
      kcal100: kcal,
      sugar100: sugar,
      protein100: protein,
      fiber100: fiber,
      swapFamily: family,
      servingQuantity: serving,
      dataQualityScore: 80,
      allergens: 'en:milk',
    );

void main() {
  group('SwapRanker', () {
    test('minder suiker vereist een betekenisvolle verbetering', () {
      final source =
          product(barcode: '1', name: 'Bron', kcal: 540, sugar: 56, protein: 6);
      final good = product(
          barcode: '2',
          name: 'Minder suiker',
          kcal: 480,
          sugar: 20,
          protein: 7);
      final neutral = product(
          barcode: '3',
          name: 'Vrijwel gelijk',
          kcal: 535,
          sugar: 55,
          protein: 6);

      final result = SwapRanker.rank(
        source: source,
        candidates: [neutral, good],
        goal: SnackGoal.lessSugar,
      );

      expect(result, hasLength(1));
      expect(result.single.barcode, '2');
      expect(result.single.highlights.join(' '), contains('minder suiker'));
    });

    test('meer eiwit wijst een kandidaat met te weinig winst af', () {
      final source =
          product(barcode: '1', name: 'Bron', kcal: 200, sugar: 8, protein: 10);
      final good = product(
          barcode: '2', name: 'Eiwitrijk', kcal: 205, sugar: 7, protein: 15);
      final weak = product(
          barcode: '3',
          name: 'Nauwelijks meer',
          kcal: 195,
          sugar: 7,
          protein: 10.5);

      final result = SwapRanker.rank(
        source: source,
        candidates: [weak, good],
        goal: SnackGoal.moreProtein,
      );

      expect(result.map((e) => e.barcode), ['2']);
    });

    test('onbetrouwbare portie valt terug op per 100 gram', () {
      final source = product(
        barcode: '1',
        name: 'Brood',
        kcal: 250,
        sugar: 5,
        protein: 8,
        serving: 900,
        family: 'bread_bakery',
      );
      final candidate = product(
        barcode: '2',
        name: 'Lichter brood',
        kcal: 200,
        sugar: 3,
        protein: 9,
        serving: 35,
        family: 'bread_bakery',
      );

      final result = SwapRanker.rank(
        source: source,
        candidates: [candidate],
        goal: SnackGoal.lessCalories,
      ).single;

      expect(result.basisLabel, 'per 100 g/ml');
      expect(result.grams, 100);
      expect(result.warnings.join(' '), contains('Portiedata'));
    });

    test('ontbrekende voedingswaarde wordt niet als nul behandeld', () {
      final source =
          product(barcode: '1', name: 'Bron', kcal: 200, sugar: 20, protein: 5);
      final unknownSugar =
          product(barcode: '2', name: 'Onbekend', kcal: 180, protein: 6);

      final result = SwapRanker.rank(
        source: source,
        candidates: [unknownSugar],
        goal: SnackGoal.lessSugar,
      );

      expect(result, isEmpty);
    });
  });

  test('SnackProduct accepteert platte en geneste lookup-data', () {
    final item = SnackProduct.fromJson({
      'barcode': '12345678',
      'name': 'Test',
      'nutriments': {'kcal': 120, 'sugar': 4, 'protein': 9},
      'serving_size_grams': 40,
    });

    expect(item.kcal100, 120);
    expect(item.sugar100, 4);
    expect(item.protein100, 9);
    expect(item.servingQuantity, 40);
  });
}
