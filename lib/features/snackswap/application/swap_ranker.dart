import 'dart:math' as math;

import 'package:bitewise/features/snackswap/domain/goal.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';
import 'package:bitewise/features/snackswap/domain/swap_suggestion.dart';

/// Transparante, volledig lokale rangschikking voor de webbeta.
/// De database levert alleen producten en classificatie; deze klasse schrijft
/// niets terug en gebruikt geen AI.
abstract final class SwapRanker {
  static List<SwapSuggestion> rank({
    required SnackProduct source,
    required List<SnackProduct> candidates,
    required SnackGoal goal,
    int limit = 8,
  }) {
    final ranked = <SwapSuggestion>[];
    for (final candidate in candidates) {
      if (candidate.barcode == source.barcode) continue;
      final item = _score(source, candidate, goal);
      if (item != null) ranked.add(item);
    }
    ranked.sort((a, b) => b.score.compareTo(a.score));
    return ranked.take(limit).toList(growable: false);
  }

  static SwapSuggestion? _score(
    SnackProduct source,
    SnackProduct candidate,
    SnackGoal goal,
  ) {
    final useServing =
        _hasPlausibleServing(source) && _hasPlausibleServing(candidate);
    final s = _values(source, useServing);
    final c = _values(candidate, useServing);
    if (s.kcal == null || c.kcal == null) return null;

    final kcalDown = _relativeDown(s.kcal, c.kcal);
    final sugarDown = _relativeDown(s.sugar, c.sugar);
    final proteinUp = _relativeUp(s.protein, c.protein);
    final fiberUp = _relativeUp(s.fiber, c.fiber);
    final saltUp = _relativeUp(s.salt, c.salt);
    final satFatUp = _relativeUp(s.saturatedFat, c.saturatedFat);

    var qualifies = true;
    var score = 0.0;
    switch (goal) {
      case SnackGoal.moreProtein:
        qualifies = (proteinUp != null && proteinUp >= .20) ||
            _absoluteGain(s.protein, c.protein, 2);
        score = 55 * _positive(proteinUp) +
            20 * _positive(fiberUp) +
            25 * _preservation(kcalDown);
        if (_relativeUp(s.kcal, c.kcal, nullSafe: true)! > .15) score -= 30;
        if (_relativeUp(s.sugar, c.sugar, nullSafe: true)! > .20) score -= 20;
        break;
      case SnackGoal.lessCalories:
        qualifies = (kcalDown != null && kcalDown >= .10) ||
            _absoluteReduction(s.kcal, c.kcal, 25);
        score = 65 * _positive(kcalDown) +
            20 * _preservation(proteinUp) +
            15 * _preservation(fiberUp);
        if (_relativeDown(s.protein, c.protein, nullSafe: true)! > .30) {
          score -= 25;
        }
        if (_relativeUp(s.sugar, c.sugar, nullSafe: true)! > .20) score -= 20;
        break;
      case SnackGoal.lessSugar:
        qualifies = (sugarDown != null && sugarDown >= .20) ||
            _absoluteReduction(s.sugar, c.sugar, 2);
        score = 70 * _positive(sugarDown) +
            20 * _preservation(kcalDown) +
            10 * _preservation(proteinUp);
        if (_relativeUp(s.kcal, c.kcal, nullSafe: true)! > .15) score -= 25;
        if (satFatUp != null && satFatUp > .20) score -= 20;
        break;
      case SnackGoal.balanced:
        score = 30 * _positive(kcalDown) +
            25 * _positive(sugarDown) +
            20 * _positive(proteinUp) +
            15 * _positive(fiberUp) -
            5 * _positive(saltUp) -
            5 * _positive(satFatUp);
        qualifies = score > 4;
        break;
    }
    if (!qualifies) return null;

    final sameFamily =
        source.swapFamily != null && source.swapFamily == candidate.swapFamily;
    score += sameFamily ? 15 : 5;
    score += ((candidate.dataQualityScore ?? 50).clamp(0, 100) / 100) * 5;
    score = score.clamp(0, 100);

    final highlights = <String>[];
    if (kcalDown != null && kcalDown >= .05) {
      highlights.add('${(kcalDown * 100).round()}% minder kcal');
    }
    if (sugarDown != null && sugarDown >= .10) {
      highlights.add('${(sugarDown * 100).round()}% minder suiker');
    }
    if (proteinUp != null && proteinUp >= .10) {
      highlights.add('${(proteinUp * 100).round()}% meer eiwit');
    }
    if (fiberUp != null && fiberUp >= .10) {
      highlights.add('${(fiberUp * 100).round()}% meer vezels');
    }

    final warnings = <String>[];
    if (candidate.allergens == null || candidate.allergens!.trim().isEmpty) {
      warnings
          .add('Allergeneninformatie is onvolledig; controleer het etiket.');
    }
    if (!sameFamily) {
      warnings
          .add('Dit is een verwant alternatief, geen directe productwissel.');
    }
    if (!useServing) {
      warnings.add(
          'Portiedata ontbreekt of is onbetrouwbaar; vergelijking per 100 g/ml.');
    }

    final basis = useServing ? 'per opgegeven portie' : 'per 100 g/ml';
    final amount = useServing ? candidate.servingQuantity : 100.0;
    final explanation = highlights.isEmpty
        ? 'Past op basis van de beschikbare voedingswaarden beter bij ${goal.label.toLowerCase()}.'
        : '${highlights.take(2).join(' en ')} $basis.';

    return SwapSuggestion(
      barcode: candidate.barcode,
      name: candidate.name,
      brand: candidate.brand,
      score: score,
      explanation: explanation,
      tag: sameFamily ? 'Direct vergelijkbaar' : 'Verwant alternatief',
      kcal: c.kcal,
      sugarG: c.sugar,
      proteinG: c.protein,
      fatG: useServing
          ? _scaled(candidate.fat100, candidate.servingQuantity)
          : candidate.fat100,
      carbsG: useServing
          ? _scaled(candidate.carbs100, candidate.servingQuantity)
          : candidate.carbs100,
      grams: amount,
      basisLabel: basis,
      highlights: highlights,
      warnings: warnings,
    );
  }

  static bool _hasPlausibleServing(SnackProduct p) {
    final q = p.servingQuantity;
    if (q == null || q < 5 || q > 500) return false;
    if (p.kcalServing == null && p.kcal100 == null) return false;
    return true;
  }

  static _Nutrition _values(SnackProduct p, bool serving) => _Nutrition(
        kcal: serving
            ? p.kcalServing ?? _scaled(p.kcal100, p.servingQuantity)
            : p.kcal100,
        protein: serving
            ? p.proteinServing ?? _scaled(p.protein100, p.servingQuantity)
            : p.protein100,
        sugar: serving
            ? p.sugarServing ?? _scaled(p.sugar100, p.servingQuantity)
            : p.sugar100,
        fiber: serving
            ? p.fiberServing ?? _scaled(p.fiber100, p.servingQuantity)
            : p.fiber100,
        salt: serving
            ? p.saltServing ?? _scaled(p.salt100, p.servingQuantity)
            : p.salt100,
        saturatedFat: serving
            ? p.saturatedFatServing ??
                _scaled(p.saturatedFat100, p.servingQuantity)
            : p.saturatedFat100,
      );

  static double? _scaled(double? per100, double? grams) =>
      per100 == null || grams == null ? null : per100 * grams / 100;

  static double? _relativeDown(double? source, double? candidate,
      {bool nullSafe = false}) {
    if (source == null || candidate == null || source <= 0) {
      return nullSafe ? 0 : null;
    }
    return (source - candidate) / source;
  }

  static double? _relativeUp(double? source, double? candidate,
      {bool nullSafe = false}) {
    if (source == null || candidate == null || source <= 0) {
      return nullSafe ? 0 : null;
    }
    return (candidate - source) / source;
  }

  static bool _absoluteGain(double? source, double? candidate, double min) =>
      source != null && candidate != null && candidate - source >= min;
  static bool _absoluteReduction(
          double? source, double? candidate, double min) =>
      source != null && candidate != null && source - candidate >= min;
  static double _positive(double? value) =>
      math.max(0, value ?? 0).clamp(0, 1).toDouble();
  static double _preservation(double? improvement) =>
      improvement == null ? .5 : (1 + improvement).clamp(0, 1);
}

class _Nutrition {
  const _Nutrition(
      {this.kcal,
      this.protein,
      this.sugar,
      this.fiber,
      this.salt,
      this.saturatedFat});
  final double? kcal;
  final double? protein;
  final double? sugar;
  final double? fiber;
  final double? salt;
  final double? saturatedFat;
}
