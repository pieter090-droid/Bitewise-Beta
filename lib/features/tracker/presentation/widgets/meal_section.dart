import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Toont één eetmoment met de gelogde items eronder, met een '+' om toe te
/// voegen (eetmoment voorgeselecteerd) en een verwijderknop per item.
class MealSection extends ConsumerWidget {
  const MealSection({required this.meal, required this.logs, super.key});

  final MealType meal;
  final List<DayLog> logs;

  void _addToMeal(BuildContext context, WidgetRef ref) {
    ref.read(pendingMealProvider.notifier).state = meal;
    context.go(Routes.scan);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = logs.fold<double>(0, (sum, l) => sum + l.kcal).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(meal.icon, color: AppColors.navy600, size: 22),
                const SizedBox(width: 10),
                Text(meal.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.navy)),
                const Spacer(),
                Text('$total kcal',
                    style: const TextStyle(
                        color: AppColors.slate, fontWeight: FontWeight.w600)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.add_circle, color: AppColors.gold),
                  tooltip: 'Voeg toe aan ${meal.label}',
                  onPressed: () => _addToMeal(context, ref),
                ),
              ],
            ),
            if (logs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 4),
                child: GestureDetector(
                  onTap: () => _addToMeal(context, ref),
                  child: const Text('Nog niets gelogd — tik op +',
                      style: TextStyle(color: AppColors.slate)),
                ),
              )
            else
              ...logs.map((log) => _LogTile(log: log)),
          ],
        ),
      ),
    );
  }
}

class _LogTile extends ConsumerWidget {
  const _LogTile({required this.log});

  final DayLog log;

  Future<void> _delete(WidgetRef ref) async {
    final remoteId =
        await ref.read(dayLogsRepositoryProvider).deleteLog(log.id);
    await ref.read(syncCoordinatorProvider).handleDelete(remoteId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('log_${log.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.danger.withValues(alpha: 0.1),
        child: const Icon(Icons.delete_outline, color: AppColors.danger),
      ),
      onDismissed: (_) => _delete(ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.productName,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                      '${log.grams > 0 ? '${log.grams.round()} g' : '1 portie'} · ${log.protein.round()}g eiwit',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.slate)),
                ],
              ),
            ),
            Text('${log.kcal.round()} kcal',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, size: 20, color: AppColors.slate),
              tooltip: 'Verwijder',
              onPressed: () => _delete(ref),
            ),
          ],
        ),
      ),
    );
  }
}
