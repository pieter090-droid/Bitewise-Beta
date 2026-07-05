import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/features/onboarding/data/user_goals_repository.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// De dag die de gebruiker bekijkt (default vandaag).
final selectedDayProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Het eetmoment dat is voorgeselecteerd via de '+'-knop op het dashboard.
/// Het productscherm gebruikt dit als standaard-eetmoment (eenmalig).
final pendingMealProvider = StateProvider<MealType?>((ref) => null);

/// Alle logs voor de geselecteerde dag.
final dayLogsProvider = StreamProvider<List<DayLog>>((ref) {
  final day = ref.watch(selectedDayProvider);
  return ref.watch(dayLogsRepositoryProvider).watchForDay(day);
});

/// Logs gegroepeerd per eetmoment.
final logsByMealProvider = Provider<Map<MealType, List<DayLog>>>((ref) {
  final logs = ref.watch(dayLogsProvider).valueOrNull ?? const [];
  final map = {for (final m in MealType.values) m: <DayLog>[]};
  for (final log in logs) {
    map[log.mealType]!.add(log);
  }
  return map;
});

/// Eén dag in het weekoverzicht.
class DayKcal {
  const DayKcal({required this.day, required this.kcal});
  final DateTime day;
  final double kcal;
}

/// De laatste 7 dagen t/m de geselecteerde dag, oplopend gesorteerd.
/// Ontbrekende dagen worden op 0 gezet zodat de grafiek altijd 7 staven heeft.
final weeklyKcalProvider = StreamProvider<List<DayKcal>>((ref) {
  final anchor = ref.watch(selectedDayProvider);
  final start = DateTime(anchor.year, anchor.month, anchor.day)
      .subtract(const Duration(days: 6));
  return ref
      .watch(dayLogsRepositoryProvider)
      .watchKcalByDay(start, anchor)
      .map((byDay) => List.generate(7, (i) {
            final d = DateTime(start.year, start.month, start.day)
                .add(Duration(days: i));
            return DayKcal(day: d, kcal: byDay[d] ?? 0);
          }));
});

/// Geaggregeerde dagtotalen, afgezet tegen het actieve doel.
final dailySummaryProvider = Provider<DailySummary>((ref) {
  final logs = ref.watch(dayLogsProvider).valueOrNull ?? const [];
  final goal = ref.watch(activeGoalProvider).valueOrNull;

  var kcal = 0.0, protein = 0.0, sugar = 0.0;
  for (final log in logs) {
    kcal += log.kcal;
    protein += log.protein;
    sugar += log.sugar;
  }

  return DailySummary(
    kcal: kcal,
    protein: protein,
    sugar: sugar,
    calorieTarget: goal?.calorieTarget ?? DailySummary.empty.calorieTarget,
    proteinTarget: goal?.proteinTarget ?? DailySummary.empty.proteinTarget,
    sugarLimit: goal?.sugarLimit ?? DailySummary.empty.sugarLimit,
  );
});
