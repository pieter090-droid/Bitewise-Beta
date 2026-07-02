import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/constants/app_constants.dart';
import 'package:bitewise/core/supabase/supabase_service.dart';
import 'package:bitewise/core/utils/result.dart';
import 'package:bitewise/features/product/data/product_cache_repository.dart';
import 'package:bitewise/features/product/domain/product.dart';

/// Zoekt een product op via barcode.
///
/// Volgorde (zie architectuur):
/// 1. Lokale cache (Drift).
/// 2. Supabase Edge Function `lookup_product`. Die function checkt eerst de
///    `products`-tabel, valt zo nodig terug op Open Food Facts en doet een
///    upsert in Supabase `products`. De client roept OFF dus nooit direct aan.
/// 3. Resultaat wordt lokaal gecachet.
class ProductLookupService {
  ProductLookupService(this._cache, this._supabase);

  final ProductCacheRepository _cache;
  final SupabaseService _supabase;

  Future<Result<Product>> lookup(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) {
      return const Failure('Lege barcode.');
    }

    // 1. Lokaal.
    final local = await _cache.getByBarcode(trimmed);
    if (local != null) return Success(local);

    // 2. Remote via Edge Function.
    if (!_supabase.isAvailable) {
      return const Failure(
        'Product niet lokaal gevonden en geen backend geconfigureerd.',
      );
    }

    try {
      final response = await _supabase.client.functions.invoke(
        AppConstants.fnLookupProduct,
        body: {'barcode': trimmed},
      );

      final data = response.data;
      if (data == null || data is! Map) {
        return const Failure('Geen product gevonden voor deze barcode.');
      }
      final map = data.cast<String, dynamic>();
      if (map['product'] == null) {
        return Failure(
          (map['error'] as String?) ?? 'Geen product gevonden.',
        );
      }

      final product = Product.fromJson(
        (map['product'] as Map).cast<String, dynamic>(),
      );

      // 3. Cache lokaal voor snelle herhaalde toegang.
      await _cache.upsert(product);
      return Success(product);
    } catch (e) {
      return Failure('Opzoeken mislukt: $e');
    }
  }
}

final productLookupServiceProvider = Provider<ProductLookupService>(
  (ref) => ProductLookupService(
    ref.watch(productCacheRepositoryProvider),
    ref.watch(supabaseServiceProvider),
  ),
);

/// Async lookup als family provider op barcode.
final productByBarcodeProvider =
    FutureProvider.family<Result<Product>, String>((ref, barcode) {
  return ref.watch(productLookupServiceProvider).lookup(barcode);
});
