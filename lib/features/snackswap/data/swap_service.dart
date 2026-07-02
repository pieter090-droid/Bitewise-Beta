import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/constants/app_constants.dart';
import 'package:bitewise/core/supabase/supabase_service.dart';
import 'package:bitewise/core/utils/result.dart';
import 'package:bitewise/features/snackswap/domain/swap_recommendation.dart';

/// Haalt swap-aanbevelingen op via de Edge Function `recommend_swaps`.
///
/// De function selecteert bestaande producten/swaps uit Supabase en laat de AI
/// die alleen **rangschikken en uitleggen** op basis van product + doel +
/// dagcontext. De client publiceert dus nooit zelf globale data.
class SwapService {
  SwapService(this._supabase);

  final SupabaseService _supabase;

  Future<Result<List<SwapRecommendation>>> recommend({
    required String barcode,
    required Map<String, dynamic> goalContext,
    required Map<String, dynamic> dayContext,
  }) async {
    if (!_supabase.isAvailable) {
      return const Failure('Aanbevelingen vereisen een backend-verbinding.');
    }

    try {
      final response = await _supabase.client.functions.invoke(
        AppConstants.fnRecommendSwaps,
        body: {
          'barcode': barcode,
          'goal': goalContext,
          'day_context': dayContext,
        },
      );

      final data = response.data;
      if (data == null || data is! Map) {
        return const Failure('Geen aanbevelingen ontvangen.');
      }
      final map = data.cast<String, dynamic>();
      final list = (map['recommendations'] as List?) ?? const [];
      final recs = list
          .map((e) =>
              SwapRecommendation.fromJson((e as Map).cast<String, dynamic>()))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      return Success(recs);
    } catch (e) {
      return Failure('Aanbevelingen ophalen mislukt: $e');
    }
  }
}

final swapServiceProvider = Provider<SwapService>(
  (ref) => SwapService(ref.watch(supabaseServiceProvider)),
);
