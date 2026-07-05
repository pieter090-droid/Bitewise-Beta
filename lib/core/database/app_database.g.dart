// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserGoalsTable extends UserGoals
    with TableInfo<$UserGoalsTable, UserGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _goalTypeIndexMeta =
      const VerificationMeta('goalTypeIndex');
  @override
  late final GeneratedColumn<int> goalTypeIndex = GeneratedColumn<int>(
      'goal_type_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _calorieTargetMeta =
      const VerificationMeta('calorieTarget');
  @override
  late final GeneratedColumn<int> calorieTarget = GeneratedColumn<int>(
      'calorie_target', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _proteinTargetMeta =
      const VerificationMeta('proteinTarget');
  @override
  late final GeneratedColumn<int> proteinTarget = GeneratedColumn<int>(
      'protein_target', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sugarLimitMeta =
      const VerificationMeta('sugarLimit');
  @override
  late final GeneratedColumn<int> sugarLimit = GeneratedColumn<int>(
      'sugar_limit', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carbsTargetMeta =
      const VerificationMeta('carbsTarget');
  @override
  late final GeneratedColumn<int> carbsTarget = GeneratedColumn<int>(
      'carbs_target', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(250));
  static const VerificationMeta _preferencesJsonMeta =
      const VerificationMeta('preferencesJson');
  @override
  late final GeneratedColumn<String> preferencesJson = GeneratedColumn<String>(
      'preferences_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _allergiesJsonMeta =
      const VerificationMeta('allergiesJson');
  @override
  late final GeneratedColumn<String> allergiesJson = GeneratedColumn<String>(
      'allergies_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalTypeIndex,
        calorieTarget,
        proteinTarget,
        sugarLimit,
        carbsTarget,
        preferencesJson,
        allergiesJson,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_goals';
  @override
  VerificationContext validateIntegrity(Insertable<UserGoalRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_type_index')) {
      context.handle(
          _goalTypeIndexMeta,
          goalTypeIndex.isAcceptableOrUnknown(
              data['goal_type_index']!, _goalTypeIndexMeta));
    } else if (isInserting) {
      context.missing(_goalTypeIndexMeta);
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
          _calorieTargetMeta,
          calorieTarget.isAcceptableOrUnknown(
              data['calorie_target']!, _calorieTargetMeta));
    } else if (isInserting) {
      context.missing(_calorieTargetMeta);
    }
    if (data.containsKey('protein_target')) {
      context.handle(
          _proteinTargetMeta,
          proteinTarget.isAcceptableOrUnknown(
              data['protein_target']!, _proteinTargetMeta));
    } else if (isInserting) {
      context.missing(_proteinTargetMeta);
    }
    if (data.containsKey('sugar_limit')) {
      context.handle(
          _sugarLimitMeta,
          sugarLimit.isAcceptableOrUnknown(
              data['sugar_limit']!, _sugarLimitMeta));
    } else if (isInserting) {
      context.missing(_sugarLimitMeta);
    }
    if (data.containsKey('carbs_target')) {
      context.handle(
          _carbsTargetMeta,
          carbsTarget.isAcceptableOrUnknown(
              data['carbs_target']!, _carbsTargetMeta));
    }
    if (data.containsKey('preferences_json')) {
      context.handle(
          _preferencesJsonMeta,
          preferencesJson.isAcceptableOrUnknown(
              data['preferences_json']!, _preferencesJsonMeta));
    }
    if (data.containsKey('allergies_json')) {
      context.handle(
          _allergiesJsonMeta,
          allergiesJson.isAcceptableOrUnknown(
              data['allergies_json']!, _allergiesJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGoalRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      goalTypeIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal_type_index'])!,
      calorieTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calorie_target'])!,
      proteinTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}protein_target'])!,
      sugarLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sugar_limit'])!,
      carbsTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carbs_target'])!,
      preferencesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferences_json'])!,
      allergiesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergies_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserGoalsTable createAlias(String alias) {
    return $UserGoalsTable(attachedDatabase, alias);
  }
}

class UserGoalRow extends DataClass implements Insertable<UserGoalRow> {
  final int id;

  /// Opgeslagen als enum-index van [GoalType].
  final int goalTypeIndex;
  final int calorieTarget;
  final int proteinTarget;
  final int sugarLimit;
  final int carbsTarget;

  /// JSON-array van voorkeuren (bv. ["vegetarisch","high_protein"]).
  final String preferencesJson;

  /// JSON-array van allergieën (bv. ["noten","lactose"]).
  final String allergiesJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserGoalRow(
      {required this.id,
      required this.goalTypeIndex,
      required this.calorieTarget,
      required this.proteinTarget,
      required this.sugarLimit,
      required this.carbsTarget,
      required this.preferencesJson,
      required this.allergiesJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_type_index'] = Variable<int>(goalTypeIndex);
    map['calorie_target'] = Variable<int>(calorieTarget);
    map['protein_target'] = Variable<int>(proteinTarget);
    map['sugar_limit'] = Variable<int>(sugarLimit);
    map['carbs_target'] = Variable<int>(carbsTarget);
    map['preferences_json'] = Variable<String>(preferencesJson);
    map['allergies_json'] = Variable<String>(allergiesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserGoalsCompanion toCompanion(bool nullToAbsent) {
    return UserGoalsCompanion(
      id: Value(id),
      goalTypeIndex: Value(goalTypeIndex),
      calorieTarget: Value(calorieTarget),
      proteinTarget: Value(proteinTarget),
      sugarLimit: Value(sugarLimit),
      carbsTarget: Value(carbsTarget),
      preferencesJson: Value(preferencesJson),
      allergiesJson: Value(allergiesJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserGoalRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGoalRow(
      id: serializer.fromJson<int>(json['id']),
      goalTypeIndex: serializer.fromJson<int>(json['goalTypeIndex']),
      calorieTarget: serializer.fromJson<int>(json['calorieTarget']),
      proteinTarget: serializer.fromJson<int>(json['proteinTarget']),
      sugarLimit: serializer.fromJson<int>(json['sugarLimit']),
      carbsTarget: serializer.fromJson<int>(json['carbsTarget']),
      preferencesJson: serializer.fromJson<String>(json['preferencesJson']),
      allergiesJson: serializer.fromJson<String>(json['allergiesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalTypeIndex': serializer.toJson<int>(goalTypeIndex),
      'calorieTarget': serializer.toJson<int>(calorieTarget),
      'proteinTarget': serializer.toJson<int>(proteinTarget),
      'sugarLimit': serializer.toJson<int>(sugarLimit),
      'carbsTarget': serializer.toJson<int>(carbsTarget),
      'preferencesJson': serializer.toJson<String>(preferencesJson),
      'allergiesJson': serializer.toJson<String>(allergiesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserGoalRow copyWith(
          {int? id,
          int? goalTypeIndex,
          int? calorieTarget,
          int? proteinTarget,
          int? sugarLimit,
          int? carbsTarget,
          String? preferencesJson,
          String? allergiesJson,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserGoalRow(
        id: id ?? this.id,
        goalTypeIndex: goalTypeIndex ?? this.goalTypeIndex,
        calorieTarget: calorieTarget ?? this.calorieTarget,
        proteinTarget: proteinTarget ?? this.proteinTarget,
        sugarLimit: sugarLimit ?? this.sugarLimit,
        carbsTarget: carbsTarget ?? this.carbsTarget,
        preferencesJson: preferencesJson ?? this.preferencesJson,
        allergiesJson: allergiesJson ?? this.allergiesJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserGoalRow copyWithCompanion(UserGoalsCompanion data) {
    return UserGoalRow(
      id: data.id.present ? data.id.value : this.id,
      goalTypeIndex: data.goalTypeIndex.present
          ? data.goalTypeIndex.value
          : this.goalTypeIndex,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTarget: data.proteinTarget.present
          ? data.proteinTarget.value
          : this.proteinTarget,
      sugarLimit:
          data.sugarLimit.present ? data.sugarLimit.value : this.sugarLimit,
      carbsTarget:
          data.carbsTarget.present ? data.carbsTarget.value : this.carbsTarget,
      preferencesJson: data.preferencesJson.present
          ? data.preferencesJson.value
          : this.preferencesJson,
      allergiesJson: data.allergiesJson.present
          ? data.allergiesJson.value
          : this.allergiesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGoalRow(')
          ..write('id: $id, ')
          ..write('goalTypeIndex: $goalTypeIndex, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('sugarLimit: $sugarLimit, ')
          ..write('carbsTarget: $carbsTarget, ')
          ..write('preferencesJson: $preferencesJson, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      goalTypeIndex,
      calorieTarget,
      proteinTarget,
      sugarLimit,
      carbsTarget,
      preferencesJson,
      allergiesJson,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGoalRow &&
          other.id == this.id &&
          other.goalTypeIndex == this.goalTypeIndex &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTarget == this.proteinTarget &&
          other.sugarLimit == this.sugarLimit &&
          other.carbsTarget == this.carbsTarget &&
          other.preferencesJson == this.preferencesJson &&
          other.allergiesJson == this.allergiesJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserGoalsCompanion extends UpdateCompanion<UserGoalRow> {
  final Value<int> id;
  final Value<int> goalTypeIndex;
  final Value<int> calorieTarget;
  final Value<int> proteinTarget;
  final Value<int> sugarLimit;
  final Value<int> carbsTarget;
  final Value<String> preferencesJson;
  final Value<String> allergiesJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserGoalsCompanion({
    this.id = const Value.absent(),
    this.goalTypeIndex = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.sugarLimit = const Value.absent(),
    this.carbsTarget = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.allergiesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserGoalsCompanion.insert({
    this.id = const Value.absent(),
    required int goalTypeIndex,
    required int calorieTarget,
    required int proteinTarget,
    required int sugarLimit,
    this.carbsTarget = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.allergiesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : goalTypeIndex = Value(goalTypeIndex),
        calorieTarget = Value(calorieTarget),
        proteinTarget = Value(proteinTarget),
        sugarLimit = Value(sugarLimit);
  static Insertable<UserGoalRow> custom({
    Expression<int>? id,
    Expression<int>? goalTypeIndex,
    Expression<int>? calorieTarget,
    Expression<int>? proteinTarget,
    Expression<int>? sugarLimit,
    Expression<int>? carbsTarget,
    Expression<String>? preferencesJson,
    Expression<String>? allergiesJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalTypeIndex != null) 'goal_type_index': goalTypeIndex,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTarget != null) 'protein_target': proteinTarget,
      if (sugarLimit != null) 'sugar_limit': sugarLimit,
      if (carbsTarget != null) 'carbs_target': carbsTarget,
      if (preferencesJson != null) 'preferences_json': preferencesJson,
      if (allergiesJson != null) 'allergies_json': allergiesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserGoalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? goalTypeIndex,
      Value<int>? calorieTarget,
      Value<int>? proteinTarget,
      Value<int>? sugarLimit,
      Value<int>? carbsTarget,
      Value<String>? preferencesJson,
      Value<String>? allergiesJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserGoalsCompanion(
      id: id ?? this.id,
      goalTypeIndex: goalTypeIndex ?? this.goalTypeIndex,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      sugarLimit: sugarLimit ?? this.sugarLimit,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      preferencesJson: preferencesJson ?? this.preferencesJson,
      allergiesJson: allergiesJson ?? this.allergiesJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalTypeIndex.present) {
      map['goal_type_index'] = Variable<int>(goalTypeIndex.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<int>(calorieTarget.value);
    }
    if (proteinTarget.present) {
      map['protein_target'] = Variable<int>(proteinTarget.value);
    }
    if (sugarLimit.present) {
      map['sugar_limit'] = Variable<int>(sugarLimit.value);
    }
    if (carbsTarget.present) {
      map['carbs_target'] = Variable<int>(carbsTarget.value);
    }
    if (preferencesJson.present) {
      map['preferences_json'] = Variable<String>(preferencesJson.value);
    }
    if (allergiesJson.present) {
      map['allergies_json'] = Variable<String>(allergiesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGoalsCompanion(')
          ..write('id: $id, ')
          ..write('goalTypeIndex: $goalTypeIndex, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('sugarLimit: $sugarLimit, ')
          ..write('carbsTarget: $carbsTarget, ')
          ..write('preferencesJson: $preferencesJson, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DayLogsTable extends DayLogs with TableInfo<$DayLogsTable, DayLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeIndexMeta =
      const VerificationMeta('mealTypeIndex');
  @override
  late final GeneratedColumn<int> mealTypeIndex = GeneratedColumn<int>(
      'meal_type_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
      'grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<double> kcal = GeneratedColumn<double>(
      'kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
      'sugar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
      'carbs', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _logDateMeta =
      const VerificationMeta('logDate');
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
      'log_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        barcode,
        productName,
        mealTypeIndex,
        grams,
        kcal,
        protein,
        sugar,
        carbs,
        fat,
        logDate,
        createdAt,
        remoteId,
        dirty
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DayLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('meal_type_index')) {
      context.handle(
          _mealTypeIndexMeta,
          mealTypeIndex.isAcceptableOrUnknown(
              data['meal_type_index']!, _mealTypeIndexMeta));
    } else if (isInserting) {
      context.missing(_mealTypeIndexMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
          _gramsMeta, grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta));
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('kcal')) {
      context.handle(
          _kcalMeta, kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta));
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(
          _sugarMeta, sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta));
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
          _carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(_logDateMeta,
          logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta));
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      mealTypeIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_type_index'])!,
      grams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grams'])!,
      kcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}kcal'])!,
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein'])!,
      sugar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sugar'])!,
      carbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs'])!,
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat'])!,
      logDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}log_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
    );
  }

  @override
  $DayLogsTable createAlias(String alias) {
    return $DayLogsTable(attachedDatabase, alias);
  }
}

class DayLogRow extends DataClass implements Insertable<DayLogRow> {
  final int id;
  final String? barcode;
  final String productName;

  /// Enum-index van [MealType].
  final int mealTypeIndex;

  /// Hoeveelheid in gram/ml die gelogd is.
  final double grams;
  final double kcal;
  final double protein;
  final double sugar;
  final double carbs;
  final double fat;

  /// Datum (zonder tijd) waarvoor het log telt.
  final DateTime logDate;
  final DateTime createdAt;

  /// Server-id (user_day_logs.id) na een geslaagde upload; anders null.
  final String? remoteId;

  /// true = nog niet (of opnieuw) naar de server geüpload.
  final bool dirty;
  const DayLogRow(
      {required this.id,
      this.barcode,
      required this.productName,
      required this.mealTypeIndex,
      required this.grams,
      required this.kcal,
      required this.protein,
      required this.sugar,
      required this.carbs,
      required this.fat,
      required this.logDate,
      required this.createdAt,
      this.remoteId,
      required this.dirty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['product_name'] = Variable<String>(productName);
    map['meal_type_index'] = Variable<int>(mealTypeIndex);
    map['grams'] = Variable<double>(grams);
    map['kcal'] = Variable<double>(kcal);
    map['protein'] = Variable<double>(protein);
    map['sugar'] = Variable<double>(sugar);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    map['log_date'] = Variable<DateTime>(logDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  DayLogsCompanion toCompanion(bool nullToAbsent) {
    return DayLogsCompanion(
      id: Value(id),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      productName: Value(productName),
      mealTypeIndex: Value(mealTypeIndex),
      grams: Value(grams),
      kcal: Value(kcal),
      protein: Value(protein),
      sugar: Value(sugar),
      carbs: Value(carbs),
      fat: Value(fat),
      logDate: Value(logDate),
      createdAt: Value(createdAt),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      dirty: Value(dirty),
    );
  }

  factory DayLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayLogRow(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      productName: serializer.fromJson<String>(json['productName']),
      mealTypeIndex: serializer.fromJson<int>(json['mealTypeIndex']),
      grams: serializer.fromJson<double>(json['grams']),
      kcal: serializer.fromJson<double>(json['kcal']),
      protein: serializer.fromJson<double>(json['protein']),
      sugar: serializer.fromJson<double>(json['sugar']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String?>(barcode),
      'productName': serializer.toJson<String>(productName),
      'mealTypeIndex': serializer.toJson<int>(mealTypeIndex),
      'grams': serializer.toJson<double>(grams),
      'kcal': serializer.toJson<double>(kcal),
      'protein': serializer.toJson<double>(protein),
      'sugar': serializer.toJson<double>(sugar),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'logDate': serializer.toJson<DateTime>(logDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'remoteId': serializer.toJson<String?>(remoteId),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  DayLogRow copyWith(
          {int? id,
          Value<String?> barcode = const Value.absent(),
          String? productName,
          int? mealTypeIndex,
          double? grams,
          double? kcal,
          double? protein,
          double? sugar,
          double? carbs,
          double? fat,
          DateTime? logDate,
          DateTime? createdAt,
          Value<String?> remoteId = const Value.absent(),
          bool? dirty}) =>
      DayLogRow(
        id: id ?? this.id,
        barcode: barcode.present ? barcode.value : this.barcode,
        productName: productName ?? this.productName,
        mealTypeIndex: mealTypeIndex ?? this.mealTypeIndex,
        grams: grams ?? this.grams,
        kcal: kcal ?? this.kcal,
        protein: protein ?? this.protein,
        sugar: sugar ?? this.sugar,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        logDate: logDate ?? this.logDate,
        createdAt: createdAt ?? this.createdAt,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        dirty: dirty ?? this.dirty,
      );
  DayLogRow copyWithCompanion(DayLogsCompanion data) {
    return DayLogRow(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      mealTypeIndex: data.mealTypeIndex.present
          ? data.mealTypeIndex.value
          : this.mealTypeIndex,
      grams: data.grams.present ? data.grams.value : this.grams,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      protein: data.protein.present ? data.protein.value : this.protein,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayLogRow(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('productName: $productName, ')
          ..write('mealTypeIndex: $mealTypeIndex, ')
          ..write('grams: $grams, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('sugar: $sugar, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      barcode,
      productName,
      mealTypeIndex,
      grams,
      kcal,
      protein,
      sugar,
      carbs,
      fat,
      logDate,
      createdAt,
      remoteId,
      dirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayLogRow &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.productName == this.productName &&
          other.mealTypeIndex == this.mealTypeIndex &&
          other.grams == this.grams &&
          other.kcal == this.kcal &&
          other.protein == this.protein &&
          other.sugar == this.sugar &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.logDate == this.logDate &&
          other.createdAt == this.createdAt &&
          other.remoteId == this.remoteId &&
          other.dirty == this.dirty);
}

class DayLogsCompanion extends UpdateCompanion<DayLogRow> {
  final Value<int> id;
  final Value<String?> barcode;
  final Value<String> productName;
  final Value<int> mealTypeIndex;
  final Value<double> grams;
  final Value<double> kcal;
  final Value<double> protein;
  final Value<double> sugar;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<DateTime> logDate;
  final Value<DateTime> createdAt;
  final Value<String?> remoteId;
  final Value<bool> dirty;
  const DayLogsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.productName = const Value.absent(),
    this.mealTypeIndex = const Value.absent(),
    this.grams = const Value.absent(),
    this.kcal = const Value.absent(),
    this.protein = const Value.absent(),
    this.sugar = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.logDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dirty = const Value.absent(),
  });
  DayLogsCompanion.insert({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    required String productName,
    required int mealTypeIndex,
    required double grams,
    required double kcal,
    required double protein,
    required double sugar,
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    required DateTime logDate,
    this.createdAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.dirty = const Value.absent(),
  })  : productName = Value(productName),
        mealTypeIndex = Value(mealTypeIndex),
        grams = Value(grams),
        kcal = Value(kcal),
        protein = Value(protein),
        sugar = Value(sugar),
        logDate = Value(logDate);
  static Insertable<DayLogRow> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<String>? productName,
    Expression<int>? mealTypeIndex,
    Expression<double>? grams,
    Expression<double>? kcal,
    Expression<double>? protein,
    Expression<double>? sugar,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<DateTime>? logDate,
    Expression<DateTime>? createdAt,
    Expression<String>? remoteId,
    Expression<bool>? dirty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (productName != null) 'product_name': productName,
      if (mealTypeIndex != null) 'meal_type_index': mealTypeIndex,
      if (grams != null) 'grams': grams,
      if (kcal != null) 'kcal': kcal,
      if (protein != null) 'protein': protein,
      if (sugar != null) 'sugar': sugar,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (logDate != null) 'log_date': logDate,
      if (createdAt != null) 'created_at': createdAt,
      if (remoteId != null) 'remote_id': remoteId,
      if (dirty != null) 'dirty': dirty,
    });
  }

  DayLogsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? barcode,
      Value<String>? productName,
      Value<int>? mealTypeIndex,
      Value<double>? grams,
      Value<double>? kcal,
      Value<double>? protein,
      Value<double>? sugar,
      Value<double>? carbs,
      Value<double>? fat,
      Value<DateTime>? logDate,
      Value<DateTime>? createdAt,
      Value<String?>? remoteId,
      Value<bool>? dirty}) {
    return DayLogsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      mealTypeIndex: mealTypeIndex ?? this.mealTypeIndex,
      grams: grams ?? this.grams,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      sugar: sugar ?? this.sugar,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      logDate: logDate ?? this.logDate,
      createdAt: createdAt ?? this.createdAt,
      remoteId: remoteId ?? this.remoteId,
      dirty: dirty ?? this.dirty,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (mealTypeIndex.present) {
      map['meal_type_index'] = Variable<int>(mealTypeIndex.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<double>(kcal.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayLogsCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('productName: $productName, ')
          ..write('mealTypeIndex: $mealTypeIndex, ')
          ..write('grams: $grams, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('sugar: $sugar, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('logDate: $logDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }
}

class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [barcode, name, brand, imageUrl, dataJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(Insertable<CachedProductRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {barcode};
  @override
  CachedProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProductRow(
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProductRow extends DataClass
    implements Insertable<CachedProductRow> {
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;

  /// Volledige [Product] als JSON, zodat detail-scherm offline werkt.
  final String dataJson;
  final DateTime updatedAt;
  const CachedProductRow(
      {required this.barcode,
      required this.name,
      this.brand,
      this.imageUrl,
      required this.dataJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['barcode'] = Variable<String>(barcode);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['data_json'] = Variable<String>(dataJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      barcode: Value(barcode),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      dataJson: Value(dataJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedProductRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProductRow(
      barcode: serializer.fromJson<String>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'barcode': serializer.toJson<String>(barcode),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'dataJson': serializer.toJson<String>(dataJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedProductRow copyWith(
          {String? barcode,
          String? name,
          Value<String?> brand = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          String? dataJson,
          DateTime? updatedAt}) =>
      CachedProductRow(
        barcode: barcode ?? this.barcode,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        dataJson: dataJson ?? this.dataJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CachedProductRow copyWithCompanion(CachedProductsCompanion data) {
    return CachedProductRow(
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductRow(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(barcode, name, brand, imageUrl, dataJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProductRow &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.imageUrl == this.imageUrl &&
          other.dataJson == this.dataJson &&
          other.updatedAt == this.updatedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProductRow> {
  final Value<String> barcode;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> imageUrl;
  final Value<String> dataJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String barcode,
    required String name,
    this.brand = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required String dataJson,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : barcode = Value(barcode),
        name = Value(name),
        dataJson = Value(dataJson);
  static Insertable<CachedProductRow> custom({
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? imageUrl,
    Expression<String>? dataJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (imageUrl != null) 'image_url': imageUrl,
      if (dataJson != null) 'data_json': dataJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith(
      {Value<String>? barcode,
      Value<String>? name,
      Value<String?>? brand,
      Value<String?>? imageUrl,
      Value<String>? dataJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CachedProductsCompanion(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      dataJson: dataJson ?? this.dataJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('dataJson: $dataJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteProductsTable extends FavoriteProducts
    with TableInfo<$FavoriteProductsTable, FavoriteProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [barcode, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_products';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteProductRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {barcode};
  @override
  FavoriteProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteProductRow(
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoriteProductsTable createAlias(String alias) {
    return $FavoriteProductsTable(attachedDatabase, alias);
  }
}

class FavoriteProductRow extends DataClass
    implements Insertable<FavoriteProductRow> {
  final String barcode;
  final String name;
  final DateTime createdAt;
  const FavoriteProductRow(
      {required this.barcode, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['barcode'] = Variable<String>(barcode);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoriteProductsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteProductsCompanion(
      barcode: Value(barcode),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteProductRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteProductRow(
      barcode: serializer.fromJson<String>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'barcode': serializer.toJson<String>(barcode),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteProductRow copyWith(
          {String? barcode, String? name, DateTime? createdAt}) =>
      FavoriteProductRow(
        barcode: barcode ?? this.barcode,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoriteProductRow copyWithCompanion(FavoriteProductsCompanion data) {
    return FavoriteProductRow(
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteProductRow(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(barcode, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteProductRow &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class FavoriteProductsCompanion extends UpdateCompanion<FavoriteProductRow> {
  final Value<String> barcode;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoriteProductsCompanion({
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteProductsCompanion.insert({
    required String barcode,
    required String name,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : barcode = Value(barcode),
        name = Value(name);
  static Insertable<FavoriteProductRow> custom({
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteProductsCompanion copyWith(
      {Value<String>? barcode,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FavoriteProductsCompanion(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteProductsCompanion(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SwapFeedbacksTable extends SwapFeedbacks
    with TableInfo<$SwapFeedbacksTable, SwapFeedbackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwapFeedbacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fromBarcodeMeta =
      const VerificationMeta('fromBarcode');
  @override
  late final GeneratedColumn<String> fromBarcode = GeneratedColumn<String>(
      'from_barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toBarcodeMeta =
      const VerificationMeta('toBarcode');
  @override
  late final GeneratedColumn<String> toBarcode = GeneratedColumn<String>(
      'to_barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positiveMeta =
      const VerificationMeta('positive');
  @override
  late final GeneratedColumn<bool> positive = GeneratedColumn<bool>(
      'positive', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("positive" IN (0, 1))'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fromBarcode, toBarcode, positive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swap_feedbacks';
  @override
  VerificationContext validateIntegrity(Insertable<SwapFeedbackRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_barcode')) {
      context.handle(
          _fromBarcodeMeta,
          fromBarcode.isAcceptableOrUnknown(
              data['from_barcode']!, _fromBarcodeMeta));
    } else if (isInserting) {
      context.missing(_fromBarcodeMeta);
    }
    if (data.containsKey('to_barcode')) {
      context.handle(_toBarcodeMeta,
          toBarcode.isAcceptableOrUnknown(data['to_barcode']!, _toBarcodeMeta));
    } else if (isInserting) {
      context.missing(_toBarcodeMeta);
    }
    if (data.containsKey('positive')) {
      context.handle(_positiveMeta,
          positive.isAcceptableOrUnknown(data['positive']!, _positiveMeta));
    } else if (isInserting) {
      context.missing(_positiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwapFeedbackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwapFeedbackRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fromBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_barcode'])!,
      toBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_barcode'])!,
      positive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}positive'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SwapFeedbacksTable createAlias(String alias) {
    return $SwapFeedbacksTable(attachedDatabase, alias);
  }
}

class SwapFeedbackRow extends DataClass implements Insertable<SwapFeedbackRow> {
  final int id;
  final String fromBarcode;
  final String toBarcode;

  /// true = duim omhoog, false = duim omlaag.
  final bool positive;
  final DateTime createdAt;
  const SwapFeedbackRow(
      {required this.id,
      required this.fromBarcode,
      required this.toBarcode,
      required this.positive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_barcode'] = Variable<String>(fromBarcode);
    map['to_barcode'] = Variable<String>(toBarcode);
    map['positive'] = Variable<bool>(positive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SwapFeedbacksCompanion toCompanion(bool nullToAbsent) {
    return SwapFeedbacksCompanion(
      id: Value(id),
      fromBarcode: Value(fromBarcode),
      toBarcode: Value(toBarcode),
      positive: Value(positive),
      createdAt: Value(createdAt),
    );
  }

  factory SwapFeedbackRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwapFeedbackRow(
      id: serializer.fromJson<int>(json['id']),
      fromBarcode: serializer.fromJson<String>(json['fromBarcode']),
      toBarcode: serializer.fromJson<String>(json['toBarcode']),
      positive: serializer.fromJson<bool>(json['positive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromBarcode': serializer.toJson<String>(fromBarcode),
      'toBarcode': serializer.toJson<String>(toBarcode),
      'positive': serializer.toJson<bool>(positive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SwapFeedbackRow copyWith(
          {int? id,
          String? fromBarcode,
          String? toBarcode,
          bool? positive,
          DateTime? createdAt}) =>
      SwapFeedbackRow(
        id: id ?? this.id,
        fromBarcode: fromBarcode ?? this.fromBarcode,
        toBarcode: toBarcode ?? this.toBarcode,
        positive: positive ?? this.positive,
        createdAt: createdAt ?? this.createdAt,
      );
  SwapFeedbackRow copyWithCompanion(SwapFeedbacksCompanion data) {
    return SwapFeedbackRow(
      id: data.id.present ? data.id.value : this.id,
      fromBarcode:
          data.fromBarcode.present ? data.fromBarcode.value : this.fromBarcode,
      toBarcode: data.toBarcode.present ? data.toBarcode.value : this.toBarcode,
      positive: data.positive.present ? data.positive.value : this.positive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwapFeedbackRow(')
          ..write('id: $id, ')
          ..write('fromBarcode: $fromBarcode, ')
          ..write('toBarcode: $toBarcode, ')
          ..write('positive: $positive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromBarcode, toBarcode, positive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwapFeedbackRow &&
          other.id == this.id &&
          other.fromBarcode == this.fromBarcode &&
          other.toBarcode == this.toBarcode &&
          other.positive == this.positive &&
          other.createdAt == this.createdAt);
}

class SwapFeedbacksCompanion extends UpdateCompanion<SwapFeedbackRow> {
  final Value<int> id;
  final Value<String> fromBarcode;
  final Value<String> toBarcode;
  final Value<bool> positive;
  final Value<DateTime> createdAt;
  const SwapFeedbacksCompanion({
    this.id = const Value.absent(),
    this.fromBarcode = const Value.absent(),
    this.toBarcode = const Value.absent(),
    this.positive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SwapFeedbacksCompanion.insert({
    this.id = const Value.absent(),
    required String fromBarcode,
    required String toBarcode,
    required bool positive,
    this.createdAt = const Value.absent(),
  })  : fromBarcode = Value(fromBarcode),
        toBarcode = Value(toBarcode),
        positive = Value(positive);
  static Insertable<SwapFeedbackRow> custom({
    Expression<int>? id,
    Expression<String>? fromBarcode,
    Expression<String>? toBarcode,
    Expression<bool>? positive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromBarcode != null) 'from_barcode': fromBarcode,
      if (toBarcode != null) 'to_barcode': toBarcode,
      if (positive != null) 'positive': positive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SwapFeedbacksCompanion copyWith(
      {Value<int>? id,
      Value<String>? fromBarcode,
      Value<String>? toBarcode,
      Value<bool>? positive,
      Value<DateTime>? createdAt}) {
    return SwapFeedbacksCompanion(
      id: id ?? this.id,
      fromBarcode: fromBarcode ?? this.fromBarcode,
      toBarcode: toBarcode ?? this.toBarcode,
      positive: positive ?? this.positive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromBarcode.present) {
      map['from_barcode'] = Variable<String>(fromBarcode.value);
    }
    if (toBarcode.present) {
      map['to_barcode'] = Variable<String>(toBarcode.value);
    }
    if (positive.present) {
      map['positive'] = Variable<bool>(positive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwapFeedbacksCompanion(')
          ..write('id: $id, ')
          ..write('fromBarcode: $fromBarcode, ')
          ..write('toBarcode: $toBarcode, ')
          ..write('positive: $positive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, itemsJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class RecipeRow extends DataClass implements Insertable<RecipeRow> {
  final int id;
  final String name;

  /// JSON-array van componenten (naam, barcode, gram + macro's per portie).
  final String itemsJson;
  final DateTime createdAt;
  const RecipeRow(
      {required this.id,
      required this.name,
      required this.itemsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['items_json'] = Variable<String>(itemsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      itemsJson: Value(itemsJson),
      createdAt: Value(createdAt),
    );
  }

  factory RecipeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecipeRow copyWith(
          {int? id, String? name, String? itemsJson, DateTime? createdAt}) =>
      RecipeRow(
        id: id ?? this.id,
        name: name ?? this.name,
        itemsJson: itemsJson ?? this.itemsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  RecipeRow copyWithCompanion(RecipesCompanion data) {
    return RecipeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, itemsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.itemsJson == this.itemsJson &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<RecipeRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> itemsJson;
  final Value<DateTime> createdAt;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String itemsJson,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        itemsJson = Value(itemsJson);
  static Insertable<RecipeRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? itemsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (itemsJson != null) 'items_json': itemsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? itemsJson,
      Value<DateTime>? createdAt}) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      itemsJson: itemsJson ?? this.itemsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserGoalsTable userGoals = $UserGoalsTable(this);
  late final $DayLogsTable dayLogs = $DayLogsTable(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $FavoriteProductsTable favoriteProducts =
      $FavoriteProductsTable(this);
  late final $SwapFeedbacksTable swapFeedbacks = $SwapFeedbacksTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userGoals,
        dayLogs,
        cachedProducts,
        favoriteProducts,
        swapFeedbacks,
        recipes
      ];
}

typedef $$UserGoalsTableCreateCompanionBuilder = UserGoalsCompanion Function({
  Value<int> id,
  required int goalTypeIndex,
  required int calorieTarget,
  required int proteinTarget,
  required int sugarLimit,
  Value<int> carbsTarget,
  Value<String> preferencesJson,
  Value<String> allergiesJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UserGoalsTableUpdateCompanionBuilder = UserGoalsCompanion Function({
  Value<int> id,
  Value<int> goalTypeIndex,
  Value<int> calorieTarget,
  Value<int> proteinTarget,
  Value<int> sugarLimit,
  Value<int> carbsTarget,
  Value<String> preferencesJson,
  Value<String> allergiesJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$UserGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get goalTypeIndex => $composableBuilder(
      column: $table.goalTypeIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calorieTarget => $composableBuilder(
      column: $table.calorieTarget, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get proteinTarget => $composableBuilder(
      column: $table.proteinTarget, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sugarLimit => $composableBuilder(
      column: $table.sugarLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carbsTarget => $composableBuilder(
      column: $table.carbsTarget, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferencesJson => $composableBuilder(
      column: $table.preferencesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergiesJson => $composableBuilder(
      column: $table.allergiesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get goalTypeIndex => $composableBuilder(
      column: $table.goalTypeIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calorieTarget => $composableBuilder(
      column: $table.calorieTarget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get proteinTarget => $composableBuilder(
      column: $table.proteinTarget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sugarLimit => $composableBuilder(
      column: $table.sugarLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carbsTarget => $composableBuilder(
      column: $table.carbsTarget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferencesJson => $composableBuilder(
      column: $table.preferencesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergiesJson => $composableBuilder(
      column: $table.allergiesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGoalsTable> {
  $$UserGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalTypeIndex => $composableBuilder(
      column: $table.goalTypeIndex, builder: (column) => column);

  GeneratedColumn<int> get calorieTarget => $composableBuilder(
      column: $table.calorieTarget, builder: (column) => column);

  GeneratedColumn<int> get proteinTarget => $composableBuilder(
      column: $table.proteinTarget, builder: (column) => column);

  GeneratedColumn<int> get sugarLimit => $composableBuilder(
      column: $table.sugarLimit, builder: (column) => column);

  GeneratedColumn<int> get carbsTarget => $composableBuilder(
      column: $table.carbsTarget, builder: (column) => column);

  GeneratedColumn<String> get preferencesJson => $composableBuilder(
      column: $table.preferencesJson, builder: (column) => column);

  GeneratedColumn<String> get allergiesJson => $composableBuilder(
      column: $table.allergiesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserGoalsTable,
    UserGoalRow,
    $$UserGoalsTableFilterComposer,
    $$UserGoalsTableOrderingComposer,
    $$UserGoalsTableAnnotationComposer,
    $$UserGoalsTableCreateCompanionBuilder,
    $$UserGoalsTableUpdateCompanionBuilder,
    (UserGoalRow, BaseReferences<_$AppDatabase, $UserGoalsTable, UserGoalRow>),
    UserGoalRow,
    PrefetchHooks Function()> {
  $$UserGoalsTableTableManager(_$AppDatabase db, $UserGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> goalTypeIndex = const Value.absent(),
            Value<int> calorieTarget = const Value.absent(),
            Value<int> proteinTarget = const Value.absent(),
            Value<int> sugarLimit = const Value.absent(),
            Value<int> carbsTarget = const Value.absent(),
            Value<String> preferencesJson = const Value.absent(),
            Value<String> allergiesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserGoalsCompanion(
            id: id,
            goalTypeIndex: goalTypeIndex,
            calorieTarget: calorieTarget,
            proteinTarget: proteinTarget,
            sugarLimit: sugarLimit,
            carbsTarget: carbsTarget,
            preferencesJson: preferencesJson,
            allergiesJson: allergiesJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int goalTypeIndex,
            required int calorieTarget,
            required int proteinTarget,
            required int sugarLimit,
            Value<int> carbsTarget = const Value.absent(),
            Value<String> preferencesJson = const Value.absent(),
            Value<String> allergiesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserGoalsCompanion.insert(
            id: id,
            goalTypeIndex: goalTypeIndex,
            calorieTarget: calorieTarget,
            proteinTarget: proteinTarget,
            sugarLimit: sugarLimit,
            carbsTarget: carbsTarget,
            preferencesJson: preferencesJson,
            allergiesJson: allergiesJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserGoalsTable,
    UserGoalRow,
    $$UserGoalsTableFilterComposer,
    $$UserGoalsTableOrderingComposer,
    $$UserGoalsTableAnnotationComposer,
    $$UserGoalsTableCreateCompanionBuilder,
    $$UserGoalsTableUpdateCompanionBuilder,
    (UserGoalRow, BaseReferences<_$AppDatabase, $UserGoalsTable, UserGoalRow>),
    UserGoalRow,
    PrefetchHooks Function()>;
typedef $$DayLogsTableCreateCompanionBuilder = DayLogsCompanion Function({
  Value<int> id,
  Value<String?> barcode,
  required String productName,
  required int mealTypeIndex,
  required double grams,
  required double kcal,
  required double protein,
  required double sugar,
  Value<double> carbs,
  Value<double> fat,
  required DateTime logDate,
  Value<DateTime> createdAt,
  Value<String?> remoteId,
  Value<bool> dirty,
});
typedef $$DayLogsTableUpdateCompanionBuilder = DayLogsCompanion Function({
  Value<int> id,
  Value<String?> barcode,
  Value<String> productName,
  Value<int> mealTypeIndex,
  Value<double> grams,
  Value<double> kcal,
  Value<double> protein,
  Value<double> sugar,
  Value<double> carbs,
  Value<double> fat,
  Value<DateTime> logDate,
  Value<DateTime> createdAt,
  Value<String?> remoteId,
  Value<bool> dirty,
});

class $$DayLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mealTypeIndex => $composableBuilder(
      column: $table.mealTypeIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcal => $composableBuilder(
      column: $table.kcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sugar => $composableBuilder(
      column: $table.sugar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));
}

class $$DayLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mealTypeIndex => $composableBuilder(
      column: $table.mealTypeIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcal => $composableBuilder(
      column: $table.kcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sugar => $composableBuilder(
      column: $table.sugar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));
}

class $$DayLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<int> get mealTypeIndex => $composableBuilder(
      column: $table.mealTypeIndex, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$DayLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DayLogsTable,
    DayLogRow,
    $$DayLogsTableFilterComposer,
    $$DayLogsTableOrderingComposer,
    $$DayLogsTableAnnotationComposer,
    $$DayLogsTableCreateCompanionBuilder,
    $$DayLogsTableUpdateCompanionBuilder,
    (DayLogRow, BaseReferences<_$AppDatabase, $DayLogsTable, DayLogRow>),
    DayLogRow,
    PrefetchHooks Function()> {
  $$DayLogsTableTableManager(_$AppDatabase db, $DayLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<int> mealTypeIndex = const Value.absent(),
            Value<double> grams = const Value.absent(),
            Value<double> kcal = const Value.absent(),
            Value<double> protein = const Value.absent(),
            Value<double> sugar = const Value.absent(),
            Value<double> carbs = const Value.absent(),
            Value<double> fat = const Value.absent(),
            Value<DateTime> logDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
          }) =>
              DayLogsCompanion(
            id: id,
            barcode: barcode,
            productName: productName,
            mealTypeIndex: mealTypeIndex,
            grams: grams,
            kcal: kcal,
            protein: protein,
            sugar: sugar,
            carbs: carbs,
            fat: fat,
            logDate: logDate,
            createdAt: createdAt,
            remoteId: remoteId,
            dirty: dirty,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            required String productName,
            required int mealTypeIndex,
            required double grams,
            required double kcal,
            required double protein,
            required double sugar,
            Value<double> carbs = const Value.absent(),
            Value<double> fat = const Value.absent(),
            required DateTime logDate,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
          }) =>
              DayLogsCompanion.insert(
            id: id,
            barcode: barcode,
            productName: productName,
            mealTypeIndex: mealTypeIndex,
            grams: grams,
            kcal: kcal,
            protein: protein,
            sugar: sugar,
            carbs: carbs,
            fat: fat,
            logDate: logDate,
            createdAt: createdAt,
            remoteId: remoteId,
            dirty: dirty,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DayLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DayLogsTable,
    DayLogRow,
    $$DayLogsTableFilterComposer,
    $$DayLogsTableOrderingComposer,
    $$DayLogsTableAnnotationComposer,
    $$DayLogsTableCreateCompanionBuilder,
    $$DayLogsTableUpdateCompanionBuilder,
    (DayLogRow, BaseReferences<_$AppDatabase, $DayLogsTable, DayLogRow>),
    DayLogRow,
    PrefetchHooks Function()>;
typedef $$CachedProductsTableCreateCompanionBuilder = CachedProductsCompanion
    Function({
  required String barcode,
  required String name,
  Value<String?> brand,
  Value<String?> imageUrl,
  required String dataJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CachedProductsTableUpdateCompanionBuilder = CachedProductsCompanion
    Function({
  Value<String> barcode,
  Value<String> name,
  Value<String?> brand,
  Value<String?> imageUrl,
  Value<String> dataJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedProductsTable,
    CachedProductRow,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProductRow,
      BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProductRow>
    ),
    CachedProductRow,
    PrefetchHooks Function()> {
  $$CachedProductsTableTableManager(
      _$AppDatabase db, $CachedProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> barcode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion(
            barcode: barcode,
            name: name,
            brand: brand,
            imageUrl: imageUrl,
            dataJson: dataJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String barcode,
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            required String dataJson,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion.insert(
            barcode: barcode,
            name: name,
            brand: brand,
            imageUrl: imageUrl,
            dataJson: dataJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedProductsTable,
    CachedProductRow,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProductRow,
      BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProductRow>
    ),
    CachedProductRow,
    PrefetchHooks Function()>;
typedef $$FavoriteProductsTableCreateCompanionBuilder
    = FavoriteProductsCompanion Function({
  required String barcode,
  required String name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$FavoriteProductsTableUpdateCompanionBuilder
    = FavoriteProductsCompanion Function({
  Value<String> barcode,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FavoriteProductsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteProductsTable> {
  $$FavoriteProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoriteProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteProductsTable> {
  $$FavoriteProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteProductsTable> {
  $$FavoriteProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoriteProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteProductsTable,
    FavoriteProductRow,
    $$FavoriteProductsTableFilterComposer,
    $$FavoriteProductsTableOrderingComposer,
    $$FavoriteProductsTableAnnotationComposer,
    $$FavoriteProductsTableCreateCompanionBuilder,
    $$FavoriteProductsTableUpdateCompanionBuilder,
    (
      FavoriteProductRow,
      BaseReferences<_$AppDatabase, $FavoriteProductsTable, FavoriteProductRow>
    ),
    FavoriteProductRow,
    PrefetchHooks Function()> {
  $$FavoriteProductsTableTableManager(
      _$AppDatabase db, $FavoriteProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> barcode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteProductsCompanion(
            barcode: barcode,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String barcode,
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteProductsCompanion.insert(
            barcode: barcode,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteProductsTable,
    FavoriteProductRow,
    $$FavoriteProductsTableFilterComposer,
    $$FavoriteProductsTableOrderingComposer,
    $$FavoriteProductsTableAnnotationComposer,
    $$FavoriteProductsTableCreateCompanionBuilder,
    $$FavoriteProductsTableUpdateCompanionBuilder,
    (
      FavoriteProductRow,
      BaseReferences<_$AppDatabase, $FavoriteProductsTable, FavoriteProductRow>
    ),
    FavoriteProductRow,
    PrefetchHooks Function()>;
typedef $$SwapFeedbacksTableCreateCompanionBuilder = SwapFeedbacksCompanion
    Function({
  Value<int> id,
  required String fromBarcode,
  required String toBarcode,
  required bool positive,
  Value<DateTime> createdAt,
});
typedef $$SwapFeedbacksTableUpdateCompanionBuilder = SwapFeedbacksCompanion
    Function({
  Value<int> id,
  Value<String> fromBarcode,
  Value<String> toBarcode,
  Value<bool> positive,
  Value<DateTime> createdAt,
});

class $$SwapFeedbacksTableFilterComposer
    extends Composer<_$AppDatabase, $SwapFeedbacksTable> {
  $$SwapFeedbacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromBarcode => $composableBuilder(
      column: $table.fromBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toBarcode => $composableBuilder(
      column: $table.toBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get positive => $composableBuilder(
      column: $table.positive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SwapFeedbacksTableOrderingComposer
    extends Composer<_$AppDatabase, $SwapFeedbacksTable> {
  $$SwapFeedbacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromBarcode => $composableBuilder(
      column: $table.fromBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toBarcode => $composableBuilder(
      column: $table.toBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get positive => $composableBuilder(
      column: $table.positive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SwapFeedbacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwapFeedbacksTable> {
  $$SwapFeedbacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromBarcode => $composableBuilder(
      column: $table.fromBarcode, builder: (column) => column);

  GeneratedColumn<String> get toBarcode =>
      $composableBuilder(column: $table.toBarcode, builder: (column) => column);

  GeneratedColumn<bool> get positive =>
      $composableBuilder(column: $table.positive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SwapFeedbacksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SwapFeedbacksTable,
    SwapFeedbackRow,
    $$SwapFeedbacksTableFilterComposer,
    $$SwapFeedbacksTableOrderingComposer,
    $$SwapFeedbacksTableAnnotationComposer,
    $$SwapFeedbacksTableCreateCompanionBuilder,
    $$SwapFeedbacksTableUpdateCompanionBuilder,
    (
      SwapFeedbackRow,
      BaseReferences<_$AppDatabase, $SwapFeedbacksTable, SwapFeedbackRow>
    ),
    SwapFeedbackRow,
    PrefetchHooks Function()> {
  $$SwapFeedbacksTableTableManager(_$AppDatabase db, $SwapFeedbacksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwapFeedbacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwapFeedbacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwapFeedbacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fromBarcode = const Value.absent(),
            Value<String> toBarcode = const Value.absent(),
            Value<bool> positive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SwapFeedbacksCompanion(
            id: id,
            fromBarcode: fromBarcode,
            toBarcode: toBarcode,
            positive: positive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fromBarcode,
            required String toBarcode,
            required bool positive,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SwapFeedbacksCompanion.insert(
            id: id,
            fromBarcode: fromBarcode,
            toBarcode: toBarcode,
            positive: positive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SwapFeedbacksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SwapFeedbacksTable,
    SwapFeedbackRow,
    $$SwapFeedbacksTableFilterComposer,
    $$SwapFeedbacksTableOrderingComposer,
    $$SwapFeedbacksTableAnnotationComposer,
    $$SwapFeedbacksTableCreateCompanionBuilder,
    $$SwapFeedbacksTableUpdateCompanionBuilder,
    (
      SwapFeedbackRow,
      BaseReferences<_$AppDatabase, $SwapFeedbacksTable, SwapFeedbackRow>
    ),
    SwapFeedbackRow,
    PrefetchHooks Function()>;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String name,
  required String itemsJson,
  Value<DateTime> createdAt,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> itemsJson,
  Value<DateTime> createdAt,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeRow,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeRow, BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow>),
    RecipeRow,
    PrefetchHooks Function()> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            name: name,
            itemsJson: itemsJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String itemsJson,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            name: name,
            itemsJson: itemsJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    RecipeRow,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (RecipeRow, BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow>),
    RecipeRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserGoalsTableTableManager get userGoals =>
      $$UserGoalsTableTableManager(_db, _db.userGoals);
  $$DayLogsTableTableManager get dayLogs =>
      $$DayLogsTableTableManager(_db, _db.dayLogs);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$FavoriteProductsTableTableManager get favoriteProducts =>
      $$FavoriteProductsTableTableManager(_db, _db.favoriteProducts);
  $$SwapFeedbacksTableTableManager get swapFeedbacks =>
      $$SwapFeedbacksTableTableManager(_db, _db.swapFeedbacks);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
}
