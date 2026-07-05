import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Beheert lokale day_logs (persoonlijke data, blijft op het toestel).
class DayLogsRepository {
  DayLogsRepository(this._db);

  final AppDatabase _db;

  DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Totale kcal per dag binnen [start]..[end] (inclusief), voor het weekoverzicht.
  Stream<Map<DateTime, double>> watchKcalByDay(DateTime start, DateTime end) {
    final s = _dayKey(start);
    final e = _dayKey(end);
    final query = _db.select(_db.dayLogs)
      ..where((t) => t.logDate.isBetweenValues(s, e));
    return query.watch().map((rows) {
      final map = <DateTime, double>{};
      for (final r in rows) {
        map.update(r.logDate, (v) => v + r.kcal, ifAbsent: () => r.kcal);
      }
      return map;
    });
  }

  Stream<List<DayLog>> watchForDay(DateTime day) {
    final key = _dayKey(day);
    final query = _db.select(_db.dayLogs)
      ..where((t) => t.logDate.equals(key))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// Voegt één item toe aan het daglog. De voedingswaarden zijn die van de
  /// gelogde portie (al berekend door de aanroeper). Werkt zowel voor een
  /// gescand product als voor een gekozen swap.
  Future<void> logEntry({
    String? barcode,
    required String productName,
    required MealType mealType,
    required double grams,
    required double kcal,
    required double protein,
    required double sugar,
    double carbs = 0,
    double fat = 0,
    DateTime? day,
  }) async {
    await _db.into(_db.dayLogs).insert(
          DayLogsCompanion.insert(
            barcode: Value(barcode),
            productName: productName,
            mealTypeIndex: mealType.index,
            grams: grams,
            kcal: kcal,
            protein: protein,
            sugar: sugar,
            carbs: Value(carbs),
            fat: Value(fat),
            logDate: _dayKey(day ?? DateTime.now()),
          ),
        );
  }

  /// Verwijdert een log en geeft het bijbehorende server-id terug (indien
  /// eerder gesynct), zodat de aanroeper de remote rij kan opruimen.
  Future<String?> deleteLog(int id) async {
    final row = await (_db.select(_db.dayLogs)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.dayLogs)..where((t) => t.id.equals(id))).go();
    return row?.remoteId;
  }

  // --- Sync-ondersteuning ---

  /// Alle nog niet (of opnieuw te) synchroniseren logs.
  Future<List<DayLog>> getDirtyLogs() async {
    final rows =
        await (_db.select(_db.dayLogs)..where((t) => t.dirty.equals(true)))
            .get();
    return rows.map(_toDomain).toList();
  }

  /// Markeer een lokaal log als geüpload met zijn server-id.
  Future<void> markSynced(int id, String remoteId) async {
    await (_db.update(_db.dayLogs)..where((t) => t.id.equals(id))).write(
      DayLogsCompanion(remoteId: Value(remoteId), dirty: const Value(false)),
    );
  }

  /// Server-ids die al lokaal aanwezig zijn (voor pull-deduplicatie).
  Future<Set<String>> existingRemoteIds() async {
    final rows = await (_db.select(_db.dayLogs)
          ..where((t) => t.remoteId.isNotNull()))
        .get();
    return rows.map((r) => r.remoteId!).toSet();
  }

  /// Voeg een van de server gehaald log lokaal toe (al gesynct).
  Future<void> insertSyncedLog({
    required String remoteId,
    required String productName,
    required String? barcode,
    required int mealTypeIndex,
    required double grams,
    required double kcal,
    required double protein,
    required double sugar,
    required DateTime logDate,
  }) async {
    await _db.into(_db.dayLogs).insert(
          DayLogsCompanion.insert(
            barcode: Value(barcode),
            productName: productName,
            mealTypeIndex: mealTypeIndex,
            grams: grams,
            kcal: kcal,
            protein: protein,
            sugar: sugar,
            logDate: logDate,
            remoteId: Value(remoteId),
            dirty: const Value(false),
          ),
        );
  }

  DayLog _toDomain(DayLogRow row) => DayLog(
        id: row.id,
        barcode: row.barcode,
        productName: row.productName,
        mealType: MealType.fromIndex(row.mealTypeIndex),
        grams: row.grams,
        kcal: row.kcal,
        protein: row.protein,
        sugar: row.sugar,
        carbs: row.carbs,
        fat: row.fat,
        logDate: row.logDate,
      );
}

final dayLogsRepositoryProvider = Provider<DayLogsRepository>(
  (ref) => DayLogsRepository(ref.watch(appDatabaseProvider)),
);
