import 'package:flutter/material.dart';

import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/nutrition_calculator.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';
import 'package:bitewise/features/onboarding/presentation/calculator_sheet.dart';

/// Bottom sheet om het actieve doel bij te werken. Geeft de nieuwe [UserGoal]
/// terug via Navigator.pop.
class EditGoalSheet extends StatefulWidget {
  const EditGoalSheet({required this.initial, super.key});

  final UserGoal initial;

  @override
  State<EditGoalSheet> createState() => _EditGoalSheetState();
}

class _EditGoalSheetState extends State<EditGoalSheet> {
  late UserGoal _goal = widget.initial;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Text('Doel wijzigen',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in GoalType.values)
                        ChoiceChip(
                          label: Text(t.label),
                          selected: _goal.goalType == t,
                          onSelected: (_) => setState(
                              () => _goal = _goal.copyWith(goalType: t)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final res =
                          await showModalBottomSheet<NutritionSuggestion>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => CalculatorSheet(goal: _goal.goalType),
                      );
                      if (res != null) {
                        setState(() => _goal = _goal.copyWith(
                              calorieTarget: res.calorieTarget,
                              proteinTarget: res.proteinTarget,
                              sugarLimit: res.sugarLimit,
                              carbsTarget: res.carbsTarget,
                            ));
                      }
                    },
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Bereken mijn behoefte'),
                  ),
                  const SizedBox(height: 12),
                  _slider(
                      'Calorieën',
                      _goal.calorieTarget.toDouble(),
                      1200,
                      3500,
                      46,
                      'kcal',
                      (v) => setState(() =>
                          _goal = _goal.copyWith(calorieTarget: v.round()))),
                  _slider(
                      'Eiwit',
                      _goal.proteinTarget.toDouble(),
                      40,
                      220,
                      36,
                      'g',
                      (v) => setState(() =>
                          _goal = _goal.copyWith(proteinTarget: v.round()))),
                  _slider(
                      'Suikerlimiet',
                      _goal.sugarLimit.toDouble(),
                      10,
                      90,
                      16,
                      'g',
                      (v) => setState(
                          () => _goal = _goal.copyWith(sugarLimit: v.round()))),
                  _slider(
                      'Koolhydraten',
                      _goal.carbsTarget.toDouble(),
                      50,
                      500,
                      90,
                      'g',
                      (v) => setState(() =>
                          _goal = _goal.copyWith(carbsTarget: v.round()))),
                  const SizedBox(height: 12),
                  const Text('Voorkeuren',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in DietPreference.values)
                        FilterChip(
                          label: Text(p.label),
                          selected: _goal.preferences.contains(p),
                          onSelected: (_) => setState(() {
                            final next = {..._goal.preferences};
                            next.contains(p) ? next.remove(p) : next.add(p);
                            _goal = _goal.copyWith(preferences: next);
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Allergieën',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in Allergy.values)
                        FilterChip(
                          label: Text(a.label),
                          selected: _goal.allergies.contains(a),
                          onSelected: (_) => setState(() {
                            final next = {..._goal.allergies};
                            next.contains(a) ? next.remove(a) : next.add(a);
                            _goal = _goal.copyWith(allergies: next);
                          }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _goal),
                child: const Text('Opslaan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double value, double min, double max,
      int divisions, String unit, ValueChanged<double> onChanged) {
    return Column(
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
    );
  }
}
