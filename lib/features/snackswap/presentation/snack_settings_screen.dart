import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/snackswap/application/snackswap_providers.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';

class SnackSettingsScreen extends ConsumerWidget {
  const SnackSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(defaultGoalProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: const Text('Instellingen'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Standaarddoel',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.navy)),
            const SizedBox(height: 4),
            const Text(
              'Dit doel wordt standaard gebruikt bij het zoeken naar swaps.',
              style: TextStyle(color: AppColors.slate),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.mist),
              ),
              child: Column(
                children: [
                  for (final g in SnackGoal.values)
                    RadioListTile<SnackGoal>(
                      value: g,
                      groupValue: goal,
                      activeColor: AppColors.gold,
                      title: Text(g.label),
                      onChanged: (selected) async {
                        if (selected == null) return;
                        await ref
                            .read(preferencesServiceProvider)
                            .setDefaultGoal(selected.apiValue);
                        ref.read(defaultGoalProvider.notifier).state = selected;
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.mist),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, color: AppColors.slate),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Nog geen account nodig. Je instellingen blijven op dit toestel.',
                      style: TextStyle(color: AppColors.slate),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('Bitewise · SnackSwap MVP',
                  style: TextStyle(color: AppColors.slate)),
            ),
          ],
        ),
      ),
    );
  }
}
