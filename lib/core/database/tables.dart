import 'package:drift/drift.dart';

/// Eén rij met het actieve voedingsdoel van de gebruiker (lokaal).
@DataClassName('UserGoalRow')
class UserGoals extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Opgeslagen als enum-index van [GoalType].
  IntColumn get goalTypeIndex => integer()();

  IntColumn get calorieTarget => integer()();
  IntColumn get proteinTarget => integer()();
  IntColumn get sugarLimit => integer()();

  /// JSON-array van voorkeuren (bv. ["vegetarisch","high_protein"]).
  TextColumn get preferencesJson => text().withDefault(const Constant('[]'))();

  /// JSON-array van allergieën (bv. ["noten","lactose"]).
  TextColumn get allergiesJson => text().withDefault(const Constant('[]'))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Persoonlijke eetlogboeken per eetmoment. Blijft lokaal tenzij sync aan staat.
@DataClassName('DayLogRow')
class DayLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get barcode => text().nullable()();
  TextColumn get productName => text()();

  /// Enum-index van [MealType].
  IntColumn get mealTypeIndex => integer()();

  /// Hoeveelheid in gram/ml die gelogd is.
  RealColumn get grams => real()();

  // Berekende macro's voor de gelogde portie (snapshot).
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get sugar => real()();

  /// Datum (zonder tijd) waarvoor het log telt.
  DateTimeColumn get logDate => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  // --- Sync-velden (alleen relevant wanneer sync aan staat) ---
  /// Server-id (user_day_logs.id) na een geslaagde upload; anders null.
  TextColumn get remoteId => text().nullable()();

  /// true = nog niet (of opnieuw) naar de server geüpload.
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
}

/// Lokale cache van producten (barcode -> voedingswaarden JSON).
@DataClassName('CachedProductRow')
class CachedProducts extends Table {
  TextColumn get barcode => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get imageUrl => text().nullable()();

  /// Volledige [Product] als JSON, zodat detail-scherm offline werkt.
  TextColumn get dataJson => text()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {barcode};
}

/// Lokale favorieten (barcode-referentie naar cached/remote product).
@DataClassName('FavoriteProductRow')
class FavoriteProducts extends Table {
  TextColumn get barcode => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {barcode};
}

/// Lokale feedback op swap-aanbevelingen (duim omhoog/omlaag).
@DataClassName('SwapFeedbackRow')
class SwapFeedbacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromBarcode => text()();
  TextColumn get toBarcode => text()();

  /// true = duim omhoog, false = duim omlaag.
  BoolColumn get positive => boolean()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
