import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';

/// Lokale opslag van swap-feedback (duim omhoog/omlaag).
///
/// Feedback blijft lokaal; kan later meegestuurd worden bij sync om
/// aanbevelingen te verbeteren.
class SwapFeedbackRepository {
  SwapFeedbackRepository(this._db);

  final AppDatabase _db;

  Future<void> record({
    required String fromBarcode,
    required String toBarcode,
    required bool positive,
  }) async {
    await _db.into(_db.swapFeedbacks).insert(
          SwapFeedbacksCompanion.insert(
            fromBarcode: fromBarcode,
            toBarcode: toBarcode,
            positive: positive,
          ),
        );
  }

  /// Laatste feedback voor een specifieke swap-combinatie (null = geen).
  Stream<bool?> watchFeedback(String fromBarcode, String toBarcode) {
    final q = _db.select(_db.swapFeedbacks)
      ..where((t) =>
          t.fromBarcode.equals(fromBarcode) & t.toBarcode.equals(toBarcode))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);
    return q.watchSingleOrNull().map((r) => r?.positive);
  }
}

final swapFeedbackRepositoryProvider = Provider<SwapFeedbackRepository>(
  (ref) => SwapFeedbackRepository(ref.watch(appDatabaseProvider)),
);
