/// De vier voedingsdoelen die de gebruiker kan kiezen voor een swap.
///
/// [apiValue] is exact wat de Edge Function `recommend_swaps` verwacht in het
/// veld `user_goal`.
enum SnackGoal {
  balanced('balanced', 'Gebalanceerd'),
  lessSugar('less_sugar', 'Minder suiker'),
  lessCalories('less_calories', 'Minder calorieën'),
  moreProtein('more_protein', 'Meer eiwit');

  const SnackGoal(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static SnackGoal fromApi(String value) => SnackGoal.values.firstWhere(
        (g) => g.apiValue == value,
        orElse: () => SnackGoal.balanced,
      );
}
