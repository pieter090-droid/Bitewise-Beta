// Integratietest voor de sync-coördinator.
//
// Gebruikt een in-memory Drift-database en een fake SyncApi, zodat de push/pull-
// logica end-to-end getest wordt zonder echte Supabase-verbinding.
//
// NB: Drift's NativeDatabase.memory() vereist een beschikbare sqlite3-library
// op de testhost (standaard aanwezig op macOS/Linux; op Windows sqlite3.dll op
// PATH). Draai met `flutter test`.

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bitewise/core/database/app_database.dart';
import 'package:bitewise/core/preferences/preferences_service.dart';
import 'package:bitewise/features/product/domain/nutriments.dart';
import 'package:bitewise/features/product/domain/product.dart';
import 'package:bitewise/features/sync/application/sync_coordinator.dart';
import 'package:bitewise/features/sync/data/sync_api.dart';
import 'package:bitewise/features/sync/data/sync_service.dart';
import 'package:bitewise/features/tracker/data/day_logs_repository.dart';
import 'package:bitewise/features/tracker/domain/meal_type.dart';

/// Fake die uploads registreert en een extra "remote-only" log teruggeeft.
class FakeSyncApi implements SyncApi {
  final List<String> upserted = [];
  final List<String> deleted = [];
  int _counter = 0;
  bool signedIn = false;

  @override
  bool get available => true;

  @override
  String? get userId => 'user-1';

  @override
  Future<void> ensureSignedIn() async => signedIn = true;

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
    required DateTime logDate,
  }) async {
    _counter++;
    final id = 'remote-$_counter';
    upserted.add(clientId);
    return id;
  }

  @override
  Future<void> deleteRemote(String remoteId) async => deleted.add(remoteId);

  @override
  Future<List<Map<String, dynamic>>> fetchAll() async {
    // Geeft de reeds gepushte rijen terug (remote-1..n) plus één die alleen op
    // de server bestaat, om de pull-tak te testen.
    return [
      for (var i = 1; i <= _counter; i++)
        _remoteRow('remote-$i', 'Gepusht $i'),
      _remoteRow('remote-extra', 'Alleen server'),
    ];
  }

  Map<String, dynamic> _remoteRow(String id, String name) => {
        'id': id,
        'barcode': null,
        'product_name': name,
        'meal_type_index': MealType.snack.index,
        'grams': 100,
        'kcal': 150,
        'protein': 5,
        'sugar': 8,
        'log_date': '2026-07-01',
      };
}

Product _product() => const Product(
      barcode: '111',
      name: 'Testproduct',
      nutriments: Nutriments(kcal: 100, protein: 10, sugar: 5),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FakeSyncApi fake;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    fake = FakeSyncApi();

    container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      sharedPreferencesProvider.overrideWithValue(prefs),
      syncServiceProvider.overrideWithValue(fake),
      syncEnabledProvider.overrideWith((ref) => true),
    ]);
    addTearDown(container.dispose);
    addTearDown(db.close);
  });

  test('syncNow pusht dirty logs en pullt ontbrekende serverlogs', () async {
    final repo = container.read(dayLogsRepositoryProvider);

    // Twee lokale logs (dirty).
    await repo.logProduct(
        product: _product(), mealType: MealType.lunch, grams: 100);
    await repo.logProduct(
        product: _product(), mealType: MealType.dinner, grams: 200);

    expect((await repo.getDirtyLogs()).length, 2);

    final outcome = await container.read(syncCoordinatorProvider).syncNow();

    // Push: beide logs geüpload en niet langer dirty.
    expect(fake.signedIn, isTrue);
    expect(fake.upserted.length, 2);
    expect(outcome.pushed, 2);
    expect((await repo.getDirtyLogs()), isEmpty);

    // Pull: alleen de 'remote-extra' rij is nieuw en wordt lokaal toegevoegd.
    expect(outcome.pulled, 1);
    final remoteIds = await repo.existingRemoteIds();
    expect(remoteIds, contains('remote-extra'));
  });

  test('handleDelete ruimt de serverrij op wanneer sync aan staat', () async {
    await container.read(syncCoordinatorProvider).handleDelete('remote-9');
    expect(fake.deleted, contains('remote-9'));
  });
}
