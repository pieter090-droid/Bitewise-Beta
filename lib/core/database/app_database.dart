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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _defaultConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Sync-velden toegevoegd aan day_logs.
            await m.addColumn(dayLogs, dayLogs.remoteId);
            await m.addColumn(dayLogs, dayLogs.dirty);
          }
        },
      );

  static QueryExecutor _defaultConnection() {
    // drift_flutter kiest automatisch de juiste native SQLite per platform.
    return driftDatabase(name: 'bitewise_db');
  }
}

/// Eén gedeelde database-instance voor de hele app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
