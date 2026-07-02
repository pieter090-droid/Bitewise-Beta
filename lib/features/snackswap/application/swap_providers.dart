import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/utils/result.dart';
import 'package:bitewise/features/onboarding/data/user_goals_repository.dart';
import 'package:bitewise/features/onboarding/domain/goal_type.dart';
import 'package:bitewise/features/onboarding/domain/user_goal.dart';
import 'package:bitewise/features/snackswap/data/swap_service.dart';
import 'package:bitewise/features/snackswap/domain/swap_recommendation.dart';
import 'package:bitewise/features/tracker/application/tracker_providers.dart';
import 'package:bitewise/features/tracker/domain/day_log.dart';

/// Bouwt de dagcontext-payload voor de aanbeveling.
Map<String, dynamic> _dayContextJson(DailySummary s) => {
      'kcal_consumed': s.kcal,
      'kcal_remaining': s.remainingKcal,
      'protein_consumed': s.protein,
      'protein_remaining': s.remainingProtein,
      'sugar_consumed': s.sugar,
      'sugar_remaining': s.sugarRemaining,
      'over_sugar_limit': s.overSugarLimit,
    };

/// Haalt swap-aanbevelingen op voor een product, met doel + dagcontext.
final swapRecommendationsProvider = FutureProvider.family<
    Result<List<SwapRecommendation>>, String>((ref, barcode) async {
  final goal = ref.watch(activeGoalProvider).valueOrNull ??
      UserGoal.defaultsFor(GoalType.maintain);
  final summary = ref.watch(dailySummaryProvider);

  return ref.watch(swapServiceProvider).recommend(
        barcode: barcode,
        goalContext: goal.toContextJson(),
        dayContext: _dayContextJson(summary),
      );
});
