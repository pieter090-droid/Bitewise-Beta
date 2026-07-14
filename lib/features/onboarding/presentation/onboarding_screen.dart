import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/onboarding/application/onboarding_controller.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/nutrition_calculator.dart';
import 'package:bitewise/features/onboarding/presentation/calculator_sheet.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  static const _lastPage = 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _lastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    // Router redirect brengt de gebruiker automatisch naar Home.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Text('Bitewise',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  _StepDots(current: _page, total: _lastPage + 1),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _GoalStep(),
                  _TargetsStep(),
                  _PreferencesStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_page > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        ),
                        child: const Text('Terug'),
                      ),
                    ),
                  if (_page > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _next,
                      child:
                          Text(_page == _lastPage ? 'Aan de slag' : 'Volgende'),
                    ),
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

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 6),
            width: i == current ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == current ? AppColors.gold : AppColors.mist,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

// -------- Stap 1: doeltype --------
class _GoalStep extends ConsumerWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingControllerProvider).goalType;
    final ctrl = ref.read(onboardingControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Wat is je doel?',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text(
            'We stemmen je vergelijkingen hierop af. Alles blijft standaard lokaal.',
            style: TextStyle(color: AppColors.slate)),
        const SizedBox(height: 20),
        for (final type in GoalType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectCard(
              title: type.label,
              subtitle: type.description,
              selected: selected == type,
              onTap: () => ctrl.selectGoalType(type),
            ),
          ),
      ],
    );
  }
}

// -------- Stap 2: targets --------
class _TargetsStep extends ConsumerWidget {
  const _TargetsStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Je dagdoelen', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Pas gerust aan, of laat ze berekenen.',
            style: TextStyle(color: AppColors.slate)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () async {
            final res = await showModalBottomSheet<NutritionSuggestion>(
              context: context,
              isScrollControlled: true,
              builder: (_) => CalculatorSheet(goal: goal.goalType),
            );
            if (res != null) {
              ctrl.setCalorieTarget(res.calorieTarget);
              ctrl.setProteinTarget(res.proteinTarget);
              ctrl.setSugarLimit(res.sugarLimit);
              ctrl.setCarbsTarget(res.carbsTarget);
            }
          },
          icon: const Icon(Icons.calculate_outlined),
          label: const Text('Bereken mijn behoefte'),
        ),
        const SizedBox(height: 12),
        _SliderTile(
          label: 'Calorieën',
          value: goal.calorieTarget.toDouble(),
          min: 1200,
          max: 3500,
          divisions: 46,
          unit: 'kcal',
          onChanged: (v) => ctrl.setCalorieTarget(v.round()),
        ),
        _SliderTile(
          label: 'Eiwit',
          value: goal.proteinTarget.toDouble(),
          min: 40,
          max: 220,
          divisions: 36,
          unit: 'g',
          onChanged: (v) => ctrl.setProteinTarget(v.round()),
        ),
        _SliderTile(
          label: 'Suikerlimiet',
          value: goal.sugarLimit.toDouble(),
          min: 10,
          max: 90,
          divisions: 16,
          unit: 'g',
          onChanged: (v) => ctrl.setSugarLimit(v.round()),
        ),
        _SliderTile(
          label: 'Koolhydraten',
          value: goal.carbsTarget.toDouble(),
          min: 50,
          max: 500,
          divisions: 90,
          unit: 'g',
          onChanged: (v) => ctrl.setCarbsTarget(v.round()),
        ),
      ],
    );
  }
}

// -------- Stap 3: voorkeuren + allergieën --------
class _PreferencesStep extends ConsumerWidget {
  const _PreferencesStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Voorkeuren', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final pref in DietPreference.values)
              FilterChip(
                label: Text(pref.label),
                selected: goal.preferences.contains(pref),
                onSelected: (_) => ctrl.togglePreference(pref),
              ),
          ],
        ),
        const SizedBox(height: 28),
        Text('Allergieën', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text(
            'We gebruiken dit als filter, maar controleer altijd zelf het etiket.',
            style: TextStyle(color: AppColors.slate)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in Allergy.values)
              FilterChip(
                label: Text(a.label),
                selected: goal.allergies.contains(a),
                onSelected: (_) => ctrl.toggleAllergy(a),
              ),
          ],
        ),
      ],
    );
  }
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.mist,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: AppColors.slate)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppColors.gold : AppColors.mist,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.navy)),
              Text('${value.round()} $unit',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.gold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.navy,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
