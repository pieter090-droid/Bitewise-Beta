import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/onboarding/data/user_goals_repository.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';
import 'package:bitewise/features/settings/application/settings_controller.dart';
import 'package:bitewise/features/settings/presentation/edit_goal_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(activeGoalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Instellingen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _SectionTitle('Jouw doel'),
          goalAsync.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (e, _) => Card(
                child: Padding(
                    padding: const EdgeInsets.all(16), child: Text('$e'))),
            data: (goal) => _GoalCard(
              goal: goal ?? UserGoal.defaultsFor(GoalType.maintain),
              onEdit: () => _editGoal(context, ref,
                  goal ?? UserGoal.defaultsFor(GoalType.maintain)),
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Privacy'),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.shield_outlined, color: AppColors.navy),
                  title: Text('Lokale testmodus'),
                  subtitle: Text(
                    'Dagboek, doelen en favorieten blijven in deze browser. '
                    'Cloudsync en analytics staan uit in deze bèta.',
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.navy),
                  title: Text('Geen medisch advies'),
                  subtitle: Text(
                    'Controleer voedingswaarden en allergenen altijd op het productetiket.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Lokale data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined,
                      color: AppColors.navy),
                  title: const Text('Persoonlijke data wissen'),
                  subtitle:
                      const Text('Logs, favorieten, feedback en productcache.'),
                  onTap: () => _confirmClear(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.restart_alt, color: AppColors.danger),
                  title: const Text('App resetten',
                      style: TextStyle(color: AppColors.danger)),
                  subtitle:
                      const Text('Wist alles en start onboarding opnieuw.'),
                  onTap: () => _confirmReset(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text('Bitewise Web Beta · v0.2.0',
                style: TextStyle(color: AppColors.slate)),
          ),
        ],
      ),
    );
  }

  Future<void> _editGoal(
      BuildContext context, WidgetRef ref, UserGoal goal) async {
    final updated = await showModalBottomSheet<UserGoal>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditGoalSheet(initial: goal),
    );
    if (updated != null) {
      await ref.read(settingsControllerProvider).updateGoal(updated);
    }
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await _confirm(context,
        title: 'Persoonlijke data wissen?',
        message:
            'Je logs, favorieten, feedback en productcache worden verwijderd. Je doel blijft behouden.');
    if (ok) await ref.read(settingsControllerProvider).clearPersonalData();
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await _confirm(context,
        title: 'App resetten?',
        message:
            'Alle lokale data én je doel worden gewist. Je begint opnieuw met onboarding.');
    if (ok) await ref.read(settingsControllerProvider).resetEverything();
  }

  Future<bool> _confirm(BuildContext context,
      {required String title, required String message}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuleren'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bevestigen'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.slate,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.4)),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.onEdit});
  final UserGoal goal;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(goal.goalType.label,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Wijzig'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Metric(label: 'kcal', value: '${goal.calorieTarget}'),
                _Metric(label: 'eiwit', value: '${goal.proteinTarget} g'),
                _Metric(label: 'suikerlimiet', value: '${goal.sugarLimit} g'),
              ],
            ),
            if (goal.preferences.isNotEmpty || goal.allergies.isNotEmpty) ...[
              const Divider(height: 24),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final p in goal.preferences)
                    Chip(
                        label: Text(p.label),
                        visualDensity: VisualDensity.compact),
                  for (final a in goal.allergies)
                    Chip(
                      label: Text('⚠ ${a.label}'),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
          Text(label,
              style: const TextStyle(color: AppColors.slate, fontSize: 12)),
        ],
      ),
    );
  }
}
