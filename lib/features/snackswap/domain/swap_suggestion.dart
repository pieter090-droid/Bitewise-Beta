/// Eén aanbeveling uit `recommend_swaps`.
///
/// Let op: de voedingswaarden zijn **per portie** (`kcal`, `sugar_g`,
/// `protein_g`, …), niet per 100 g. Alle velden zijn optioneel/defensief.
class SwapSuggestion {
  const SwapSuggestion({
    required this.barcode,
    required this.name,
    required this.score,
    this.brand,
    this.explanation,
    this.description,
    this.tag,
    this.kcal,
    this.sugarG,
    this.proteinG,
    this.fatG,
    this.carbsG,
    this.grams,
    this.basisLabel = 'per 100 g',
    this.highlights = const [],
    this.warnings = const [],
  });

  final String barcode;
  final String name;
  final String? brand;
  final double score;
  final String? explanation;
  final String? description;
  final String? tag;

  final double? kcal;
  final double? sugarG;
  final double? proteinG;
  final double? fatG;
  final double? carbsG;
  final double? grams;
  final String basisLabel;
  final List<String> highlights;
  final List<String> warnings;

  factory SwapSuggestion.fromJson(Map<String, dynamic> json) {
    double? d(Object? v) => v == null ? null : (v as num).toDouble();
    return SwapSuggestion(
      barcode: json['barcode']?.toString() ?? '',
      name: (json['name'] as String?) ?? 'Onbekend product',
      brand: json['brand'] as String?,
      score: d(json['score']) ?? 0,
      explanation: (json['explanation'] ?? json['reason']) as String?,
      description: json['description'] as String?,
      tag: json['tag'] as String?,
      kcal: d(json['kcal']),
      sugarG: d(json['sugar_g']),
      proteinG: d(json['protein_g']),
      fatG: d(json['fat_g']),
      carbsG: d(json['carbs_g']),
      grams: d(json['grams']),
      basisLabel: json['basis_label'] as String? ?? 'per 100 g',
      highlights: (json['highlights'] as List?)?.whereType<String>().toList() ??
          const [],
      warnings:
          (json['warnings'] as List?)?.whereType<String>().toList() ?? const [],
    );
  }
}
