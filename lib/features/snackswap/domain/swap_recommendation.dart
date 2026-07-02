import 'package:bitewise/features/product/domain/product.dart';

/// Eén swap-aanbeveling: een alternatief product met uitleg en score.
///
/// De AI (Edge Function `recommend_swaps`) mag bestaande swaps/producten
/// alleen rangschikken en uitleggen — niet zelf nieuwe globale data publiceren.
class SwapRecommendation {
  const SwapRecommendation({
    required this.product,
    required this.reason,
    required this.score,
    this.highlights = const [],
    this.kcalDelta,
    this.proteinDelta,
    this.sugarDelta,
  });

  /// Het aanbevolen alternatief.
  final Product product;

  /// Korte uitleg waarom dit een betere swap is.
  final String reason;

  /// Relevantiescore 0..1 (hoger is beter passend).
  final double score;

  /// Kernvoordelen als korte labels (bv. "-40% suiker").
  final List<String> highlights;

  /// Verschil t.o.v. het originele product (per vergelijkbare portie).
  final double? kcalDelta;
  final double? proteinDelta;
  final double? sugarDelta;

  factory SwapRecommendation.fromJson(Map<String, dynamic> json) {
    return SwapRecommendation(
      product: Product.fromJson(
        (json['product'] as Map).cast<String, dynamic>(),
      ),
      reason: json['reason'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      highlights: (json['highlights'] as List?)?.cast<String>() ?? const [],
      kcalDelta: (json['kcal_delta'] as num?)?.toDouble(),
      proteinDelta: (json['protein_delta'] as num?)?.toDouble(),
      sugarDelta: (json['sugar_delta'] as num?)?.toDouble(),
    );
  }
}
