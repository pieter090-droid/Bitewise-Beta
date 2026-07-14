import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/nutrition_calculator.dart';

/// Bottom sheet die je dagbehoefte berekent en de voorgestelde targets via
/// Navigator.pop teruggeeft als [NutritionSuggestion].
class CalculatorSheet extends ConsumerStatefulWidget {
  const CalculatorSheet({required this.goal, super.key});

  final GoalType goal;

  @override
  ConsumerState<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends ConsumerState<CalculatorSheet> {
  Sex _sex = Sex.female;
  int _age = 30;
  int _heightCm = 170;
  double _weightKg = 70;
  ActivityLevel _activity = ActivityLevel.moderate;
  double _targetLossKg = 5;
  int _weeks = 10;

  NutritionSuggestion? _suggestion;

  bool get _isLoss => widget.goal == GoalType.loseWeight;

  @override
  void initState() {
    super.initState();
    final raw = ref.read(preferencesServiceProvider).calculatorProfileJson;
    if (raw != null) {
      try {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        _sex = Sex.values[((m['sex'] as int?) ?? 1).clamp(0, 1)];
        _age = ((m['age'] as int?) ?? 30).clamp(14, 90);
        _heightCm = ((m['height'] as int?) ?? 170).clamp(130, 215);
        _weightKg = ((m['weight'] as num?) ?? 70).toDouble().clamp(40.0, 200.0);
        _activity =
            ActivityLevel.values[((m['activity'] as int?) ?? 2).clamp(0, 4)];
      } catch (_) {/* val terug op defaults */}
    }
  }

  void _calculate() {
    final input = CalculatorInput(
      sex: _sex,
      age: _age,
      heightCm: _heightCm,
      weightKg: _weightKg,
      activity: _activity,
      goal: widget.goal,
      targetLossKg: _isLoss ? _targetLossKg : null,
      weeks: _isLoss ? _weeks : null,
    );
    ref.read(preferencesServiceProvider).setCalculatorProfileJson(jsonEncode({
          'sex': _sex.index,
          'age': _age,
          'height': _heightCm,
          'weight': _weightKg,
          'activity': _activity.index,
        }));
    setState(() => _suggestion = calculateNeeds(input));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
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
                  Text('Bereken mijn behoefte',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  const Text(
                    'Een schatting op basis van je gegevens en doel. Geen '
                    'medisch advies.',
                    style: TextStyle(color: AppColors.slate),
                  ),
                  const SizedBox(height: 20),
                  const _Label('Geslacht'),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final s in Sex.values)
                        ChoiceChip(
                          label: Text(s.label),
                          selected: _sex == s,
                          onSelected: (_) => setState(() => _sex = s),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _slider('Leeftijd', _age.toDouble(), 14, 90, 76, 'jaar',
                      (v) => setState(() => _age = v.round())),
                  _slider('Lengte', _heightCm.toDouble(), 130, 215, 85, 'cm',
                      (v) => setState(() => _heightCm = v.round())),
                  _slider('Gewicht', _weightKg, 40, 200, 160, 'kg',
                      (v) => setState(() => _weightKg = v.roundToDouble())),
                  const SizedBox(height: 8),
                  const _Label('Beweging'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in ActivityLevel.values)
                        ChoiceChip(
                          label: Text(a.label),
                          selected: _activity == a,
                          onSelected: (_) => setState(() => _activity = a),
                        ),
                    ],
                  ),
                  if (_isLoss) ...[
                    const SizedBox(height: 16),
                    const _Label('Afvaldoel'),
                    _slider(
                        'Hoeveel afvallen',
                        _targetLossKg,
                        1,
                        30,
                        29,
                        'kg',
                        (v) =>
                            setState(() => _targetLossKg = v.roundToDouble())),
                    _slider('In hoeveel weken', _weeks.toDouble(), 4, 52, 48,
                        'weken', (v) => setState(() => _weeks = v.round())),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Bereken'),
                  ),
                  if (_suggestion != null) ...[
                    const SizedBox(height: 20),
                    _ResultCard(suggestion: _suggestion!),
                  ],
                ],
              ),
            ),
            if (_suggestion != null)
              SafeArea(
                minimum: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _suggestion),
                  child: const Text('Neem deze targets over'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double value, double min, double max,
      int divisions, String unit, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
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

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.navy)),
      );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.suggestion});
  final NutritionSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ons voorstel',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              _metric('${suggestion.calorieTarget}', 'kcal'),
              _metric('${suggestion.carbsTarget} g', 'koolhydraten'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _metric('${suggestion.proteinTarget} g', 'eiwit'),
              _metric('${suggestion.sugarLimit} g', 'suikerlimiet'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ruststofwisseling ~${suggestion.bmr} kcal · '
            'onderhoud ~${suggestion.tdee} kcal',
            style: const TextStyle(color: AppColors.slate, fontSize: 12),
          ),
          if (suggestion.note != null) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(suggestion.note!,
                      style: const TextStyle(
                          color: AppColors.slate, fontSize: 13)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(String value, String label) => Expanded(
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
