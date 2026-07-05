import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';

/// Eenvoudig favorietmodel (lokaal).
class Favorite {
  const Favorite({required this.barcode, required this.name, required this.createdAt});
  final String barcode;
  final String name;
  final DateTime createdAt;
}

/// Beheert lokale favorieten (blijven op het toestel).
class FavoritesRepository {
  FavoritesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Favorite>> watchAll() {
    final q = _db.select(_db.favoriteProducts)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map(
          (rows) => rows
              .map((r) => Favorite(
                    barcode: r.barcode,
                    name: r.name,
                    createdAt: r.createdAt,
                  ))
              .toList(),
        );
  }

  Stream<bool> watchIsFavorite(String barcode) {
    final q = _db.select(_db.favoriteProducts)
      ..where((t) => t.barcode.equals(barcode));
    return q.watch().map((rows) => rows.isNotEmpty);
  }

  /// Zet een product aan/uit als favoriet op basis van barcode + naam.
  Future<void> toggle({required String barcode, required String name}) async {
    final existing = await (_db.select(_db.favoriteProducts)
          ..where((t) => t.barcode.equals(barcode)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.favoriteProducts)
            ..where((t) => t.barcode.equals(barcode)))
          .go();
    } else {
      await _db.into(_db.favoriteProducts).insert(
            FavoriteProductsCompanion.insert(barcode: barcode, name: name),
          );
    }
  }

  /// Voegt toe als favoriet (idempotent — geen dubbele).
  Future<void> add({required String barcode, required String name}) async {
    await _db.into(_db.favoriteProducts).insertOnConflictUpdate(
          FavoriteProductsCompanion.insert(barcode: barcode, name: name),
        );
  }

  Future<void> remove(String barcode) async {
    await (_db.delete(_db.favoriteProducts)
          ..where((t) => t.barcode.equals(barcode)))
        .go();
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(appDatabaseProvider)),
);

final favoritesProvider = StreamProvider<List<Favorite>>(
  (ref) => ref.watch(favoritesRepositoryProvider).watchAll(),
);

final isFavoriteProvider = StreamProvider.family<bool, String>(
  (ref, barcode) =>
      ref.watch(favoritesRepositoryProvider).watchIsFavorite(barcode),
);
