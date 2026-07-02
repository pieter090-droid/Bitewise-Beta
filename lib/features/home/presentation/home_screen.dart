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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vandaag'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.go(Routes.scanner),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
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
