/// Eén component van een gerecht: een product met een gekozen portie en de
/// (al berekende) macro's voor die portie.
class RecipeItem {
  const RecipeItem({
    required this.name,
    required this.grams,
    required this.kcal,
    required this.protein,
    required this.sugar,
    required this.carbs,
    required this.fat,
    this.barcode,
  });

  final String name;
  final String? barcode;
  final double grams;
  final double kcal;
  final double protein;
  final double sugar;
  final double carbs;
  final double fat;

  Map<String, dynamic> toJson() => {
        'name': name,
        'barcode': barcode,
        'grams': grams,
        'kcal': kcal,
        'protein': protein,
        'sugar': sugar,
        'carbs': carbs,
        'fat': fat,
      };

  factory RecipeItem.fromJson(Map<String, dynamic> j) {
    double d(Object? v) => (v as num?)?.toDouble() ?? 0;
    return RecipeItem(
      name: j['name'] as String? ?? '',
      barcode: j['barcode'] as String?,
      grams: d(j['grams']),
      kcal: d(j['kcal']),
      protein: d(j['protein']),
      sugar: d(j['sugar']),
      carbs: d(j['carbs']),
      fat: d(j['fat']),
    );
  }
}

/// Een zelfgemaakt gerecht: een naam + een lijst componenten. In één keer toe
/// te voegen aan de tracker.
class Recipe {
  const Recipe({required this.id, required this.name, required this.items});

  final int id;
  final String name;
  final List<RecipeItem> items;

  double get totalKcal => items.fold(0, (s, i) => s + i.kcal);
  double get totalProtein => items.fold(0, (s, i) => s + i.protein);
  double get totalSugar => items.fold(0, (s, i) => s + i.sugar);
  double get totalCarbs => items.fold(0, (s, i) => s + i.carbs);
  double get totalFat => items.fold(0, (s, i) => s + i.fat);
}
