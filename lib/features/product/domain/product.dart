import 'package:bitewise/features/product/domain/nutriments.dart';

/// Een product zoals opgeslagen in Supabase `products` en lokaal gecachet.
///
/// Voedingswaarden zijn per 100 g/ml genormaliseerd (zie [Nutriments]).
class Product {
  const Product({
    required this.barcode,
    required this.name,
    required this.nutriments,
    this.brand,
    this.imageUrl,
    this.categories = const [],
    this.servingSizeGrams,
    this.novaGroup,
    this.nutriScore,
    this.source = 'supabase',
  });

  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final List<String> categories;

  /// Voedingswaarden per 100 g/ml.
  final Nutriments nutriments;

  /// Aanbevolen portiegrootte in gram/ml, indien bekend.
  final double? servingSizeGrams;

  /// NOVA-groep 1..4 (ultra-processed indicator), indien bekend.
  final int? novaGroup;

  /// Nutri-Score letter (a..e), indien bekend.
  final String? nutriScore;

  /// Herkomst: 'local', 'supabase' of 'openfoodfacts'.
  final String source;

  double get displayServing => servingSizeGrams ?? 100;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] as String,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Onbekend product',
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      categories: (json['categories'] as List?)?.cast<String>() ?? const [],
      nutriments:
          Nutriments.fromJson((json['nutriments'] as Map).cast<String, dynamic>()),
      servingSizeGrams: (json['serving_size_grams'] as num?)?.toDouble(),
      novaGroup: (json['nova_group'] as num?)?.toInt(),
      nutriScore: json['nutri_score'] as String?,
      source: json['source'] as String? ?? 'supabase',
    );
  }

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'name': name,
        'brand': brand,
        'image_url': imageUrl,
        'categories': categories,
        'nutriments': nutriments.toJson(),
        'serving_size_grams': servingSizeGrams,
        'nova_group': novaGroup,
        'nutri_score': nutriScore,
        'source': source,
      };

  Product copyWith({String? source}) => Product(
        barcode: barcode,
        name: name,
        brand: brand,
        imageUrl: imageUrl,
        categories: categories,
        nutriments: nutriments,
        servingSizeGrams: servingSizeGrams,
        novaGroup: novaGroup,
        nutriScore: nutriScore,
        source: source ?? this.source,
      );
}
