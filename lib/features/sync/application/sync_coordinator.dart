import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/sync/data/sync_service.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';

/// Uitkomst van een sync-ronde (voor UI-feedback).
class SyncOutcome {
  const SyncOutcome({this.pushed = 0, this.pulled = 0, this.error});
  final int pushed;
  final int pulled;
  final String? error;

  bool get ok => error == null;
}

/// Coördineert de optionele synchronisatie van lokale logs met Supabase.
///
/// Alles is een no-op wanneer sync uit staat of er geen backend is, zodat de
/// app privacy-first blijft: logs verlaten het toestel pas als de gebruiker
/// sync expliciet inschakelt.
class SyncCoordinator {
  SyncCoordinator(this._ref);

  final Ref _ref;

  bool get _enabled =>
      _ref.read(syncEnabledProvider) &&
      _ref.read(syncServiceProvider).available;

  String _clientId(int localId) {
    final installId =
        _ref.read(preferencesServiceProvider).getOrCreateInstallId();
    return '$installId:$localId';
  }

  /// Wordt aangeroepen na een lokale wijziging; pusht op de achtergrond.
  void onLogsChanged() {
    if (!_enabled) return;
    // Fire-and-forget; fouten worden stil geslikt (volgende sync haalt in).
    unawaited(_safe(() async {
      await _ref.read(syncServiceProvider).ensureSignedIn();
      await _pushDirty();
    }));
  }

  /// Ruimt de remote rij op bij een lokale delete.
  Future<void> handleDelete(String? remoteId) async {
    if (!_enabled || remoteId == null) return;
    await _safe(() => _ref.read(syncServiceProvider).deleteRemote(remoteId));
  }

  /// Volledige, expliciete sync (bij inschakelen of pull-to-refresh).
  Future<SyncOutcome> syncNow() async {
    if (!_ref.read(syncServiceProvider).available) {
      return const SyncOutcome(error: 'Geen backend geconfigureerd.');
    }
    try {
      await _ref.read(syncServiceProvider).ensureSignedIn();
      final pushed = await _pushDirty();
      final pulled = await _pull();
      return SyncOutcome(pushed: pushed, pulled: pulled);
    } catch (e) {
      return SyncOutcome(error: '$e');
    }
  }

  Future<int> _pushDirty() async {
    final repo = _ref.read(dayLogsRepositoryProvider);
    final sync = _ref.read(syncServiceProvider);
    final dirty = await repo.getDirtyLogs();
    var count = 0;
    for (final log in dirty) {
      final remoteId = await sync.upsertLog(
        clientId: _clientId(log.id),
        barcode: log.barcode,
        productName: log.productName,
        mealTypeIndex: log.mealType.index,
        grams: log.grams,
        kcal: log.kcal,
        protein: log.protein,
        sugar: log.sugar,
        carbs: log.carbs,
        fat: log.fat,
        logDate: log.logDate,
      );
      await repo.markSynced(log.id, remoteId);
      count++;
    }
    return count;
  }

  Future<int> _pull() async {
    final repo = _ref.read(dayLogsRepositoryProvider);
    final sync = _ref.read(syncServiceProvider);
    final remote = await sync.fetchAll();
    final known = await repo.existingRemoteIds();

    var count = 0;
    for (final row in remote) {
      final id = row['id'] as String;
      if (known.contains(id)) continue;
      final date = DateTime.parse(row['log_date'] as String);
      await repo.insertSyncedLog(
        remoteId: id,
        productName: row['product_name'] as String,
        barcode: row['barcode'] as String?,
        mealTypeIndex: (row['meal_type_index'] as num).toInt(),
        grams: (row['grams'] as num).toDouble(),
        kcal: (row['kcal'] as num).toDouble(),
        protein: (row['protein'] as num).toDouble(),
        sugar: (row['sugar'] as num).toDouble(),
        carbs: (row['carbs'] as num?)?.toDouble() ?? 0,
        fat: (row['fat'] as num?)?.toDouble() ?? 0,
        logDate: DateTime(date.year, date.month, date.day),
      );
      count++;
    }
    return count;
  }

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Bewust stil: sync mag de UX nooit blokkeren.
    }
  }
}

final syncCoordinatorProvider = Provider<SyncCoordinator>(
  (ref) => SyncCoordinator(ref),
);
