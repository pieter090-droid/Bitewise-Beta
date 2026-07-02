/// Interface voor de sync-backend, zodat de [SyncCoordinator] testbaar is met
/// een fake in plaats van een echte Supabase-verbinding.
abstract interface class SyncApi {
  bool get available;
  String? get userId;

  Future<void> ensureSignedIn();

  Future<String> upsertLog({
    required String clientId,
    required String? barcode,
    required String productName,
    required int mealTypeIndex,
    required double grams,
    required double kcal,
    required double protein,
    required double sugar,
    required DateTime logDate,
  });

  Future<void> deleteRemote(String remoteId);

  Future<List<Map<String, dynamic>>> fetchAll();
}
