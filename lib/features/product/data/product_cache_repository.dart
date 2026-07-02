import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/features/product/domain/product.dart';

/// Lokale cache van producten zodat detail/scan offline en snel werkt.
class ProductCacheRepository {
  ProductCacheRepository(this._db);

  final AppDatabase _db;

  Future<Product?> getByBarcode(String barcode) async {
    final row = await (_db.select(_db.cachedProducts)
          ..where((t) => t.barcode.equals(barcode)))
        .getSingleOrNull();
    if (row == null) return null;
    final map = (jsonDecode(row.dataJson) as Map).cast<String, dynamic>();
    return Product.fromJson(map).copyWith(source: 'local');
  }

  Future<void> upsert(Product product) async {
    await _db.into(_db.cachedProducts).insertOnConflictUpdate(
          CachedProductsCompanion.insert(
            barcode: product.barcode,
            name: product.name,
            brand: Value(product.brand),
            imageUrl: Value(product.imageUrl),
            dataJson: jsonEncode(product.toJson()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}

final productCacheRepositoryProvider = Provider<ProductCacheRepository>(
  (ref) => ProductCacheRepository(ref.watch(appDatabaseProvider)),
);
