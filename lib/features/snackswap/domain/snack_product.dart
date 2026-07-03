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

  factory SnackProduct.fromJson(Map<String, dynamic> json, {String? source}) {
    double? d(Object? v) => v == null ? null : (v as num).toDouble();
    return SnackProduct(
      barcode: json['barcode']?.toString() ?? '',
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Onbekend product',
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      source: source ?? json['source'] as String?,
      kcal100: d(json['kcal_100g']),
      sugar100: d(json['sugar_100g']),
      protein100: d(json['protein_100g']),
      fat100: d(json['fat_100g']),
      carbs100: d(json['carbs_100g']),
    );
  }
}
