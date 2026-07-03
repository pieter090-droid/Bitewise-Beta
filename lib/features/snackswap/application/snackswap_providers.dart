import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';

/// Het lokaal opgeslagen standaarddoel. Wordt gebruikt als beginkeuze op het
/// swap-scherm en is aan te passen in Instellingen.
final defaultGoalProvider = StateProvider<SnackGoal>((ref) {
  final stored = ref.watch(preferencesServiceProvider).defaultGoal;
  return SnackGoal.fromApi(stored);
});
