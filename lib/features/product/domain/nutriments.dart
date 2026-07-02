/// Voedingswaarden genormaliseerd naar **per 100 g/ml**.
class Nutriments {
  const Nutriments({
    required this.kcal,
    required this.protein,
    required this.sugar,
    this.fat,
    this.saturatedFat,
    this.carbs,
    this.salt,
    this.fiber,
  });

  final double kcal;
  final double protein;
  final double sugar;
  final double? fat;
  final double? saturatedFat;
  final double? carbs;
  final double? salt;
  final double? fiber;

  factory Nutriments.fromJson(Map<String, dynamic> json) {
    double? d(Object? v) => v == null ? null : (v as num).toDouble();
    return Nutriments(
      kcal: d(json['kcal']) ?? 0,
      protein: d(json['protein']) ?? 0,
      sugar: d(json['sugar']) ?? 0,
      fat: d(json['fat']),
      saturatedFat: d(json['saturated_fat']),
      carbs: d(json['carbs']),
      salt: d(json['salt']),
      fiber: d(json['fiber']),
    );
  }

  Map<String, dynamic> toJson() => {
        'kcal': kcal,
        'protein': protein,
        'sugar': sugar,
        'fat': fat,
        'saturated_fat': saturatedFat,
        'carbs': carbs,
        'salt': salt,
        'fiber': fiber,
      };

  /// Schaal alle waarden naar een portie in gram/ml.
  Nutriments scaledToGrams(double grams) {
    final factor = grams / 100.0;
    double? s(double? v) => v == null ? null : v * factor;
    return Nutriments(
      kcal: kcal * factor,
      protein: protein * factor,
      sugar: sugar * factor,
      fat: s(fat),
      saturatedFat: s(saturatedFat),
      carbs: s(carbs),
      salt: s(salt),
      fiber: s(fiber),
    );
  }
}
