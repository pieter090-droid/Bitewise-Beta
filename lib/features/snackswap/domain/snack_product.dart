/// Een product zoals de Edge Function `lookup_product` het teruggeeft.
///
/// De voedingswaarden zijn platte velden per 100 g/ml (`*_100g`), precies zoals
/// de backend ze levert. `source` komt uit het antwoord-omhulsel
/// (`"supabase"` of `"open_food_facts_saved"`).
class SnackProduct {
  const SnackProduct({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.source,
    this.kcal100,
    this.sugar100,
    this.protein100,
    this.fat100,
    this.carbs100,
    this.fiber100,
    this.salt100,
    this.saturatedFat100,
    this.servingQuantity,
    this.kcalServing,
    this.proteinServing,
    this.sugarServing,
    this.fiberServing,
    this.saltServing,
    this.saturatedFatServing,
    this.swapFamily,
    this.relatedFamilies = const [],
    this.allergens,
    this.dataQualityScore,
  });

  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final String? source;

  final double? kcal100;
  final double? sugar100;
  final double? protein100;
  final double? fat100;
  final double? carbs100;
  final double? fiber100;
  final double? salt100;
  final double? saturatedFat100;

  final double? servingQuantity;
  final double? kcalServing;
  final double? proteinServing;
  final double? sugarServing;
  final double? fiberServing;
  final double? saltServing;
  final double? saturatedFatServing;

  final String? swapFamily;
  final List<String> relatedFamilies;
  final String? allergens;
  final double? dataQualityScore;

  factory SnackProduct.fromJson(Map<String, dynamic> json, {String? source}) {
    double? d(Object? v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    final nutrients = json['nutriments'] is Map
        ? (json['nutriments'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    Object? value(String flat, String nested) =>
        json[flat] ?? nutrients[nested];
    final related = json['related_families'];
    return SnackProduct(
      barcode: json['barcode']?.toString() ?? '',
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Onbekend product',
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      source: source ?? json['source'] as String?,
      kcal100: d(value('kcal_100g', 'kcal')),
      sugar100: d(value('sugar_100g', 'sugar')),
      protein100: d(value('protein_100g', 'protein')),
      fat100: d(value('fat_100g', 'fat')),
      carbs100: d(value('carbs_100g', 'carbs')),
      fiber100: d(value('fiber_100g', 'fiber')),
      salt100: d(value('salt_100g', 'salt')),
      saturatedFat100: d(value('saturated_fat_100g', 'saturated_fat')),
      servingQuantity:
          d(json['serving_quantity'] ?? json['serving_size_grams']),
      kcalServing: d(json['kcal_serving']),
      proteinServing: d(json['proteins_serving']),
      sugarServing: d(json['sugars_serving']),
      fiberServing: d(json['fiber_serving']),
      saltServing: d(json['salt_serving']),
      saturatedFatServing: d(json['saturated_fat_serving']),
      swapFamily: json['swap_family'] as String?,
      relatedFamilies: related is List
          ? related.whereType<String>().toList(growable: false)
          : const [],
      allergens: json['allergens'] as String?,
      dataQualityScore: d(json['data_quality_score'] ?? json['quality_score']),
    );
  }
}
