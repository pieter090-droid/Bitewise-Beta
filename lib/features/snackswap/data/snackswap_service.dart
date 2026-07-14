import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/constants/app_constants.dart';
import 'package:bitewise/core/supabase/supabase_service.dart';
import 'package:bitewise/features/snackswap/application/swap_ranker.dart';
import 'package:bitewise/features/snackswap/domain/goal.dart';
import 'package:bitewise/features/snackswap/domain/snack_product.dart';
import 'package:bitewise/features/snackswap/domain/swap_suggestion.dart';

// --- Resultaattypes met duidelijke, aparte statussen ---

sealed class LookupOutcome {
  const LookupOutcome();
}

/// Product gevonden.
class LookupFound extends LookupOutcome {
  const LookupFound(this.product);
  final SnackProduct product;
}

/// Backend antwoordde netjes met `found: false`.
class LookupNotFound extends LookupOutcome {
  const LookupNotFound();
}

/// Netwerk-, config- of onverwachte fout (met leesbare melding).
class LookupError extends LookupOutcome {
  const LookupError(this.message);
  final String message;
}

sealed class SwapOutcome {
  const SwapOutcome();
}

class SwapFound extends SwapOutcome {
  const SwapFound(this.suggestions);
  final List<SwapSuggestion> suggestions;
}

class SwapNotFound extends SwapOutcome {
  const SwapNotFound();
}

class SwapError extends SwapOutcome {
  const SwapError(this.message);
  final String message;
}

/// Praat UITSLUITEND met de Supabase Edge Functions.
///
/// - Roept nooit Open Food Facts direct aan (dat doet de Edge Function).
/// - Gebruikt alleen de publishable (anon) key; nooit een service_role key.
class SnackSwapService {
  SnackSwapService(this._supabase);

  final SupabaseService _supabase;

  /// Basale barcode-validatie (EAN/UPC): alleen cijfers, 8–14 tekens.
  static bool isValidBarcode(String input) {
    final trimmed = input.trim();
    return RegExp(r'^\d{8,14}$').hasMatch(trimmed);
  }

  Future<LookupOutcome> lookupProduct(String barcode) async {
    final trimmed = barcode.trim();
    if (!isValidBarcode(trimmed)) {
      return const LookupError(
          'Voer een geldige barcode van 8 tot 14 cijfers in.');
    }
    if (!_supabase.isAvailable) {
      return const LookupError(
        'Geen backend geconfigureerd. Vul je Supabase-key in assets/env/env.json.',
      );
    }

    try {
      // De actuele read-only view is de betrouwbaarste bron en bevat ook de
      // classificatie- en portievelden. Dit pad wijzigt Supabase nooit.
      final resolved = await _featureByBarcode(trimmed);
      if (resolved != null) return LookupFound(resolved);

      // Alleen voor nog onbekende barcodes gebruiken we het reeds bestaande
      // lookup-pad van Bitewise. De beta deployt of wijzigt deze functie niet.
      final response = await _supabase.client.functions.invoke(
        AppConstants.fnLookupProduct,
        body: {'barcode': trimmed},
      );

      final data = response.data;
      if (data is! Map) {
        return const LookupError('Onverwacht antwoord van de server.');
      }
      final map = data.cast<String, dynamic>();

      final product = map['product'];
      if (product == null) {
        return const LookupNotFound();
      }

      return LookupFound(
        SnackProduct.fromJson(
          (product as Map).cast<String, dynamic>(),
          source: map['source'] as String? ?? 'lookup_product',
        ),
      );
    } catch (e) {
      return LookupError(_friendly(e));
    }
  }

  Future<SwapOutcome> recommendSwaps({
    required String barcode,
    required SnackGoal goal,
    int limit = 3,
  }) async {
    if (!_supabase.isAvailable) {
      return const SwapError(
        'Geen backend geconfigureerd. Vul je Supabase-key in assets/env/env.json.',
      );
    }

    try {
      final sourceRow = await _featureRowByBarcode(barcode.trim());
      if (sourceRow == null) return const SwapNotFound();
      final source = SnackProduct.fromJson(sourceRow);

      final rows = await _candidateRows(sourceRow);
      final candidates =
          rows.map(SnackProduct.fromJson).toList(growable: false);
      final suggestions = SwapRanker.rank(
        source: source,
        candidates: candidates,
        goal: goal,
        limit: limit,
      );
      return suggestions.isEmpty
          ? const SwapNotFound()
          : SwapFound(suggestions);
    } catch (e) {
      return SwapError(_friendly(e));
    }
  }

  /// Zoekt producten op naam in de Supabase `products`-tabel (voor suggesties).
  /// Leest alleen (RLS staat select toe); geeft een lege lijst bij een fout.
  Future<List<SnackProduct>> searchProducts(String query) async {
    final q = query.trim();
    if (!_supabase.isAvailable || q.length < 2) return const [];
    try {
      final rows = await _supabase.client
          .from('product_features_resolved')
          .select()
          .ilike('name', '%$q%')
          .limit(20);
      return (rows as List)
          .map((r) => SnackProduct.fromJson((r as Map).cast<String, dynamic>()))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<SnackProduct?> _featureByBarcode(String barcode) async {
    final row = await _featureRowByBarcode(barcode);
    return row == null ? null : SnackProduct.fromJson(row, source: 'bitewise');
  }

  Future<Map<String, dynamic>?> _featureRowByBarcode(String barcode) async {
    final row = await _supabase.client
        .from('product_features_resolved')
        .select()
        .eq('barcode', barcode)
        .maybeSingle();
    return row == null ? null : Map<String, dynamic>.from(row);
  }

  Future<List<Map<String, dynamic>>> _candidateRows(
    Map<String, dynamic> source,
  ) async {
    final family = source['swap_family'] as String?;
    final snackType = source['snack_type'] as String?;
    dynamic query = _supabase.client
        .from('product_features_resolved')
        .select()
        .eq('is_swap_relevant', true)
        .neq('barcode', source['barcode']);

    if (family != null && family.isNotEmpty) {
      final mapping = await _supabase.client
          .from('swap_family_mapping')
          .select('related_families')
          .eq('swap_family', family)
          .maybeSingle();
      final related = mapping?['related_families'] is List
          ? (mapping!['related_families'] as List).whereType<String>()
          : const Iterable<String>.empty();
      final families = <String>{family, ...related}.toList(growable: false);
      query = query.inFilter('swap_family', families);
    } else if (snackType != null && snackType.isNotEmpty) {
      query = query.eq('snack_type', snackType);
    } else {
      return const [];
    }

    final rows = await query.limit(250);
    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  String _friendly(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('socket') ||
        s.contains('network') ||
        s.contains('failed host') ||
        s.contains('connection')) {
      return 'Geen internetverbinding. Controleer je netwerk en probeer opnieuw.';
    }
    return 'Er ging iets mis bij de server. Probeer het later opnieuw.';
  }
}

final snackSwapServiceProvider = Provider<SnackSwapService>(
  (ref) => SnackSwapService(ref.watch(supabaseServiceProvider)),
);
