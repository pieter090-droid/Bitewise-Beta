import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bitewise/core/supabase/supabase_service.dart';
import 'package:bitewise/features/sync/data/sync_api.dart';

/// Praat met Supabase voor de optionele sync van persoonlijke logs.
///
/// Gebruikt **anonieme auth** zodat er een stabiele gebruikers-identiteit is
/// zonder inlogscherm. RLS zorgt dat iedere gebruiker alleen eigen rijen ziet.
class SyncService implements SyncApi {
  SyncService(this._supabase);

  final SupabaseService _supabase;

  static const _table = 'user_day_logs';

  @override
  bool get available => _supabase.isAvailable;

  @override
  String? get userId =>
      available ? _supabase.client.auth.currentUser?.id : null;

  /// Zorg voor een (anonieme) sessie. No-op zonder backend.
  @override
  Future<void> ensureSignedIn() async {
    if (!available) return;
    final auth = _supabase.client.auth;
    if (auth.currentSession == null) {
      await auth.signInAnonymously();
    }
  }

  /// Idempotente upsert; geeft het server-id terug.
  @override
  Future<String> upsertLog({
    required String clientId,
    required String? barcode,
    required String productName,
    required int mealTypeIndex,
    required double grams,
    required double kcal,
    required double protein,
    required double sugar,
    required double carbs,
    required double fat,
    required DateTime logDate,
  }) async {
    final uid = userId!;
    final row = await _supabase.client
        .from(_table)
        .upsert({
          'user_id': uid,
          'client_id': clientId,
          'barcode': barcode,
          'product_name': productName,
          'meal_type_index': mealTypeIndex,
          'grams': grams,
          'kcal': kcal,
          'protein': protein,
          'sugar': sugar,
          'carbs': carbs,
          'fat': fat,
          'log_date': _dateOnly(logDate),
        }, onConflict: 'user_id,client_id')
        .select('id')
        .single();
    return row['id'] as String;
  }

  @override
  Future<void> deleteRemote(String remoteId) async {
    if (!available) return;
    await _supabase.client.from(_table).delete().eq('id', remoteId);
  }

  /// Alle server-logs van de huidige gebruiker.
  @override
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final uid = userId;
    if (uid == null) return const [];
    final rows =
        await _supabase.client.from(_table).select().eq('user_id', uid);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  String _dateOnly(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

final syncServiceProvider = Provider<SyncApi>(
  (ref) => SyncService(ref.watch(supabaseServiceProvider)),
);
