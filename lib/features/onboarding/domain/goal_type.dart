/// Het overkoepelende voedingsdoel dat de gebruiker kiest bij onboarding.
enum GoalType {
  loseWeight(
    label: 'Afvallen',
    description: 'Kleiner calorieoverschot, meer verzadiging.',
  ),
  maintain(
    label: 'Op gewicht blijven',
    description: 'Balans houden met bewuste keuzes.',
  ),
  buildMuscle(
    label: 'Spieropbouw',
    description: 'Hoger eiwit, voldoende energie.',
  ),
  lessSugar(
    label: 'Minder suiker',
    description: 'Suikerpieken vermijden, stabiele energie.',
  );

  const GoalType({required this.label, required this.description});

  final String label;
  final String description;

  static GoalType fromIndex(int index) =>
      GoalType.values[index.clamp(0, GoalType.values.length - 1)];
}

/// Voorkeuren en dieetstijlen (multi-select).
enum DietPreference {
  vegetarian('Vegetarisch'),
  vegan('Veganistisch'),
  highProtein('High protein'),
  lowCarb('Low carb'),
  lowSugar('Suikerarm'),
  glutenFree('Glutenvrij');

  const DietPreference(this.label);
  final String label;
}

/// Veelvoorkomende allergieën (multi-select).
enum Allergy {
  nuts('Noten'),
  peanuts('Pinda'),
  lactose('Lactose'),
  gluten('Gluten'),
  soy('Soja'),
  egg('Ei'),
  fish('Vis'),
  shellfish('Schaaldieren');

  const Allergy(this.label);
  final String label;
}
