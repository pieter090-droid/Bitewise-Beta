import 'package:bitewise/features/onboarding/domain/goal_type.dart';

/// Biologisch geslacht — nodig voor de BMR-formule (Mifflin-St Jeor).
enum Sex {
  male('Man'),
  female('Vrouw');

  const Sex(this.label);
  final String label;
}

/// Beweegniveau met bijbehorende activiteitenfactor (× BMR = TDEE).
enum ActivityLevel {
  sedentary('Weinig / zittend werk', 1.2),
  light('Licht actief (1–3×/week)', 1.375),
  moderate('Gemiddeld (3–5×/week)', 1.55),
  active('Actief (6–7×/week)', 1.725),
  veryActive('Zeer actief / fysiek werk', 1.9);

  const ActivityLevel(this.label, this.factor);
  final String label;
  final double factor;
}

/// Alle invoer voor de behoefteberekening.
class CalculatorInput {
  const CalculatorInput({
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activity,
    required this.goal,
    this.targetLossKg,
    this.weeks,
  });

  final Sex sex;
  final int age;
  final int heightCm;
  final double weightKg;
  final ActivityLevel activity;
  final GoalType goal;

  /// Alleen relevant bij afvallen: gewenst gewichtsverlies (kg) …
  final double? targetLossKg;

  /// … in dit aantal weken.
  final int? weeks;
}

/// Het resultaat: voorgestelde dagdoelen + wat transparantie (BMR/TDEE).
class NutritionSuggestion {
  const NutritionSuggestion({
    required this.calorieTarget,
    required this.proteinTarget,
    required this.sugarLimit,
    required this.carbsTarget,
    required this.bmr,
    required this.tdee,
    this.note,
  });

  final int calorieTarget;
  final int proteinTarget;
  final int sugarLimit;
  final int carbsTarget;
  final int bmr;
  final int tdee;

  /// Optionele waarschuwing (bv. tempo begrensd of caloriegrens bereikt).
  final String? note;
}

/// Berekent dagbehoeftes met **Mifflin-St Jeor** (BMR) × activiteitenfactor
/// (TDEE), aangepast op het doel. Dit is een educatieve schatting, geen
/// medisch advies.
NutritionSuggestion calculateNeeds(CalculatorInput i) {
  // 1. BMR (Mifflin-St Jeor).
  final base = 10 * i.weightKg + 6.25 * i.heightCm - 5 * i.age;
  final bmr = i.sex == Sex.male ? base + 5 : base - 161;

  // 2. TDEE (onderhoudsbehoefte).
  final tdee = bmr * i.activity.factor;

  double calories;
  String? note;

  switch (i.goal) {
    case GoalType.maintain:
    case GoalType.lessSugar:
      calories = tdee;
    case GoalType.buildMuscle:
      calories = tdee + 300; // gematigd, spiervriendelijk overschot
    case GoalType.loseWeight:
      // Tekort uit gewenst tempo: 1 kg vet ≈ 7700 kcal.
      double dailyDeficit;
      final kg = i.targetLossKg ?? 0;
      final weeks = i.weeks ?? 0;
      if (kg > 0 && weeks > 0) {
        dailyDeficit = (kg * 7700) / (weeks * 7);
      } else {
        dailyDeficit = tdee * 0.20; // verstandige standaard
      }
      // Veiligheid: nooit meer dan ~1000 kcal/dag of 25% van TDEE.
      final maxDeficit = (tdee * 0.25).clamp(0, 1000).toDouble();
      if (dailyDeficit > maxDeficit) {
        dailyDeficit = maxDeficit;
        note = 'Voor een houdbaar tempo hebben we het tekort begrensd '
            '(reken op ~0,5–1 kg per week).';
      }
      calories = tdee - dailyDeficit;
  }

  // 3. Ondergrens qua calorieën (veiligheid).
  final floor = i.sex == Sex.male ? 1500.0 : 1200.0;
  if (calories < floor) {
    calories = floor;
    note = 'We hebben je doel op een veilig minimum van ${floor.round()} kcal '
        'gezet.';
  }

  // 4. Eiwit (g per kg lichaamsgewicht), afhankelijk van het doel.
  final proteinPerKg = switch (i.goal) {
    GoalType.buildMuscle => 1.9,
    GoalType.loseWeight => 1.8, // behoud spiermassa in een tekort
    GoalType.maintain => 1.4,
    GoalType.lessSugar => 1.4,
  };
  final protein = i.weightKg * proteinPerKg;

  // 5. Suikerlimiet: 5% van energie bij 'minder suiker', anders 10% (WHO).
  final sugarPct = i.goal == GoalType.lessSugar ? 0.05 : 0.10;
  final sugar = calories * sugarPct / 4; // 4 kcal per gram suiker

  int round5(num v) => (v / 5).round() * 5;

  // Koolhydraten: ~45% van de energie (4 kcal per gram).
  final carbs = calories * 0.45 / 4;

  return NutritionSuggestion(
    calorieTarget: round5(calories),
    proteinTarget: round5(protein),
    sugarLimit: round5(sugar),
    carbsTarget: round5(carbs),
    bmr: bmr.round(),
    tdee: tdee.round(),
    note: note,
  );
}
