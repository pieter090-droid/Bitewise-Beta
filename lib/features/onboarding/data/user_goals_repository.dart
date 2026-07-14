import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';

/// Leest en schrijft het actieve [UserGoal] naar de lokale Drift-database.
class UserGoalsRepository {
  UserGoalsRepository(this._db);

  final AppDatabase _db;

  /// Het meest recente doel, of null als er nog geen onboarding is gedaan.
  Future<UserGoal?> getActiveGoal() async {
    final row = await (_db.select(_db.userGoals)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return _toDomain(row);
  }

  Stream<UserGoal?> watchActiveGoal() {
    final query = _db.select(_db.userGoals)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(1);
    return query
        .watchSingleOrNull()
        .map((r) => r == null ? null : _toDomain(r));
  }

  /// Vervangt het bestaande doel (we houden er één actief).
  Future<void> saveGoal(UserGoal goal) async {
    await _db.transaction(() async {
      await _db.delete(_db.userGoals).go();
      await _db.into(_db.userGoals).insert(
            UserGoalsCompanion.insert(
              goalTypeIndex: goal.goalType.index,
              calorieTarget: goal.calorieTarget,
              proteinTarget: goal.proteinTarget,
              sugarLimit: goal.sugarLimit,
              carbsTarget: Value(goal.carbsTarget),
              preferencesJson: Value(
                jsonEncode(goal.preferences.map((p) => p.name).toList()),
              ),
              allergiesJson: Value(
                jsonEncode(goal.allergies.map((a) => a.name).toList()),
              ),
              updatedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  UserGoal _toDomain(UserGoalRow row) {
    final prefs = (jsonDecode(row.preferencesJson) as List)
        .cast<String>()
        .map(_prefFromName)
        .whereType<DietPreference>()
        .toSet();
    final allergies = (jsonDecode(row.allergiesJson) as List)
        .cast<String>()
        .map(_allergyFromName)
        .whereType<Allergy>()
        .toSet();
    return UserGoal(
      goalType: GoalType.fromIndex(row.goalTypeIndex),
      calorieTarget: row.calorieTarget,
      proteinTarget: row.proteinTarget,
      sugarLimit: row.sugarLimit,
      carbsTarget: row.carbsTarget,
      preferences: prefs,
      allergies: allergies,
    );
  }

  DietPreference? _prefFromName(String name) {
    for (final p in DietPreference.values) {
      if (p.name == name) return p;
    }
    return null;
  }

  Allergy? _allergyFromName(String name) {
    for (final a in Allergy.values) {
      if (a.name == name) return a;
    }
    return null;
  }
}

final userGoalsRepositoryProvider = Provider<UserGoalsRepository>(
  (ref) => UserGoalsRepository(ref.watch(appDatabaseProvider)),
);

/// Reactief actief doel voor de hele app.
final activeGoalProvider = StreamProvider<UserGoal?>(
  (ref) => ref.watch(userGoalsRepositoryProvider).watchActiveGoal(),
);
