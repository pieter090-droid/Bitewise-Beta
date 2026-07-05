import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserGoals,
    DayLogs,
    CachedProducts,
    FavoriteProducts,
    SwapFeedbacks,
    Recipes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _defaultConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Sync-velden toegevoegd aan day_logs.
            await m.addColumn(dayLogs, dayLogs.remoteId);
            await m.addColumn(dayLogs, dayLogs.dirty);
          }
          if (from < 3) {
            // Koolhydraten/vet in logs, koolhydraat-doel, en gerechten.
            await m.addColumn(dayLogs, dayLogs.carbs);
            await m.addColumn(dayLogs, dayLogs.fat);
            await m.addColumn(userGoals, userGoals.carbsTarget);
            await m.createTable(recipes);
          }
        },
      );

  static QueryExecutor _defaultConnection() {
    // drift_flutter kiest de juiste native SQLite per platform. Op web wijzen
    // we expliciet naar de assets in web/ (sqlite3.wasm + drift_worker.js).
    return driftDatabase(
      name: 'bitewise_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}

/// Eén gedeelde database-instance voor de hele app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
