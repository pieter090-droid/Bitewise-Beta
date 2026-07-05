import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/features/recipes/domain/recipe.dart';

/// Beheert zelfgemaakte gerechten (lokaal in Drift).
class RecipesRepository {
  RecipesRepository(this._db);

  final AppDatabase _db;

  Stream<List<Recipe>> watchAll() {
    final q = _db.select(_db.recipes)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> save({
    required String name,
    required List<RecipeItem> items,
  }) async {
    await _db.into(_db.recipes).insert(
          RecipesCompanion.insert(
            name: name,
            itemsJson: jsonEncode(items.map((i) => i.toJson()).toList()),
          ),
        );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.recipes)..where((t) => t.id.equals(id))).go();
  }

  Recipe _toDomain(RecipeRow row) {
    final items = (jsonDecode(row.itemsJson) as List)
        .map((e) => RecipeItem.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    return Recipe(id: row.id, name: row.name, items: items);
  }
}

final recipesRepositoryProvider = Provider<RecipesRepository>(
  (ref) => RecipesRepository(ref.watch(appDatabaseProvider)),
);

final recipesProvider = StreamProvider<List<Recipe>>(
  (ref) => ref.watch(recipesRepositoryProvider).watchAll(),
);
