/// Eén aanbeveling uit `recommend_swaps`.
///
/// Velden defensief geparsed: de backend levert minimaal `name`, `score` en
/// `explanation`; voedingswaarden (`*_100g`) zijn optioneel.
class SwapSuggestion {
  const SwapSuggestion({
    required this.name,
    required this.score,
    this.explanation,
    this.brand,
    this.barcode,
    this.kcal100,
    this.sugar100,
    this.protein100,
    this.fat100,
    this.carbs100,
  });

  final String name;
  final double score;
  final String? explanation;
  final String? brand;
  final String? barcode;

  final double? kcal100;
  final double? sugar100;
  final double? protein100;
  final double? fat100;
  final double? carbs100;

  factory SwapSuggestion.fromJson(Map<String, dynamic> json) {
    double? d(Object? v) => v == null ? null : (v as num).toDouble();
    return SwapSuggestion(
      name: (json['name'] as String?) ?? 'Onbekend product',
      score: d(json['score']) ?? 0,
      explanation: json['explanation'] as String?,
      brand: json['brand'] as String?,
      barcode: json['barcode']?.toString(),
      kcal100: d(json['kcal_100g']),
      sugar100: d(json['sugar_100g']),
      protein100: d(json['protein_100g']),
      fat100: d(json['fat_100g']),
      carbs100: d(json['carbs_100g']),
    );
  }
}
