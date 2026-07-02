import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Toont één eetmoment met de gelogde items eronder.
class MealSection extends ConsumerWidget {
  const MealSection({required this.meal, required this.logs, super.key});

  final MealType meal;
  final List<DayLog> logs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = logs.fold<double>(0, (sum, l) => sum + l.kcal).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              ],
            ),
            if (logs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 4),
                child: Text('Nog niets gelogd.',
                    style: TextStyle(color: AppColors.slate)),
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
      onDismissed: (_) async {
        final remoteId =
            await ref.read(dayLogsRepositoryProvider).deleteLog(log.id);
        await ref.read(syncCoordinatorProvider).handleDelete(remoteId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.productName,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${log.grams.round()} g · ${log.protein.round()}g eiwit',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.slate)),
                ],
              ),
            ),
            Text('${log.kcal.round()} kcal',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
