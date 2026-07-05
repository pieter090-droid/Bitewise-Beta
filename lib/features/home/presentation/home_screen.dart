import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/home/presentation/widgets/macro_bar.dart';
import 'package:bitewise/features/home/presentation/widgets/progress_ring.dart';
import 'package:bitewise/features/home/presentation/widgets/week_chart.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';
import 'package:bitewise/features/tracker/presentation/widgets/meal_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);
    final logsByMeal = ref.watch(logsByMealProvider);
    final weekDays = ref.watch(weeklyKcalProvider).valueOrNull ?? const [];

    final day = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dagboek'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.go(Routes.scan),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _DateNavigator(day: day, ref: ref),
          const SizedBox(height: 12),
          _DayHeaderCard(
            kcal: summary.kcal.round(),
            remaining: summary.remainingKcal.round(),
            progress: summary.kcalProgress,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  MacroBar(
                    label: 'Eiwit',
                    progress: summary.proteinProgress,
                    color: AppColors.protein,
                    valueText:
                        '${summary.protein.round()} / ${summary.proteinTarget} g',
                  ),
                  const SizedBox(height: 18),
                  MacroBar(
                    label: 'Koolhydraten',
                    progress: summary.carbsProgress,
                    color: AppColors.carbs,
                    valueText:
                        '${summary.carbs.round()} / ${summary.carbsTarget} g',
                  ),
                  const SizedBox(height: 18),
                  MacroBar(
                    label: 'Suiker',
                    progress: summary.sugarProgress,
                    color: AppColors.sugar,
                    warning: summary.overSugarLimit,
                    valueText:
                        '${summary.sugar.round()} / ${summary.sugarLimit} g',
                  ),
                ],
              ),
            ),
          ),
          if (weekDays.isNotEmpty) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deze week',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    WeekChart(
                      days: weekDays,
                      calorieTarget: summary.calorieTarget,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text('Eetmomenten',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final meal in MealType.values)
            MealSection(meal: meal, logs: logsByMeal[meal] ?? const []),
        ],
      ),
    );
  }
}

class _DateNavigator extends StatelessWidget {
  const _DateNavigator({required this.day, required this.ref});

  final DateTime day;
  final WidgetRef ref;

  static const _days = ['ma', 'di', 'wo', 'do', 'vr', 'za', 'zo'];
  static const _months = [
    'jan', 'feb', 'mrt', 'apr', 'mei', 'jun',
    'jul', 'aug', 'sep', 'okt', 'nov', 'dec'
  ];

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Vandaag';
    if (diff == 1) return 'Gisteren';
    return '${_days[day.weekday - 1]} ${day.day} ${_months[day.month - 1]}';
  }

  void _shift(int days) {
    final next = day.add(Duration(days: days));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (next.isAfter(today)) return; // niet in de toekomst
    ref.read(selectedDayProvider.notifier).state =
        DateTime(next.year, next.month, next.day);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _shift(-1),
        ),
        Expanded(
          child: Center(
            child: Text(_label(),
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.navy)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: isToday ? AppColors.mist : null,
          onPressed: isToday ? null : () => _shift(1),
        ),
      ],
    );
  }
}

class _DayHeaderCard extends StatelessWidget {
  const _DayHeaderCard({
    required this.kcal,
    required this.remaining,
    required this.progress,
  });

  final int kcal;
  final int remaining;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ProgressRing(
              progress: progress,
              color: AppColors.gold,
              centerValue: '$kcal',
              centerUnit: 'kcal',
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dagprogressie',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    remaining >= 0
                        ? '$remaining kcal over'
                        : '${remaining.abs()} kcal boven doel',
                    style: TextStyle(
                      fontSize: 15,
                      color: remaining >= 0 ? AppColors.slate : AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rustig op weg naar je doel.',
                    style: TextStyle(color: AppColors.slate),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
