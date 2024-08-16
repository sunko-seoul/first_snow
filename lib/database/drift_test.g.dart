// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_test.dart';

// ignore_for_file: type=lint
class $DriftTestTable extends DriftTest
    with TableInfo<$DriftTestTable, DriftTestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftTestTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_test';
  @override
  VerificationContext validateIntegrity(Insertable<DriftTestData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftTestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftTestData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $DriftTestTable createAlias(String alias) {
    return $DriftTestTable(attachedDatabase, alias);
  }
}

class DriftTestData extends DataClass implements Insertable<DriftTestData> {
  final int id;
  final DateTime date;
  final String data;
  const DriftTestData(
      {required this.id, required this.date, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['data'] = Variable<String>(data);
    return map;
  }

  DriftTestCompanion toCompanion(bool nullToAbsent) {
    return DriftTestCompanion(
      id: Value(id),
      date: Value(date),
      data: Value(data),
    );
  }

  factory DriftTestData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftTestData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'data': serializer.toJson<String>(data),
    };
  }

  DriftTestData copyWith({int? id, DateTime? date, String? data}) =>
      DriftTestData(
        id: id ?? this.id,
        date: date ?? this.date,
        data: data ?? this.data,
      );
  DriftTestData copyWithCompanion(DriftTestCompanion data) {
    return DriftTestData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftTestData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftTestData &&
          other.id == this.id &&
          other.date == this.date &&
          other.data == this.data);
}

class DriftTestCompanion extends UpdateCompanion<DriftTestData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> data;
  const DriftTestCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.data = const Value.absent(),
  });
  DriftTestCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String data,
  })  : date = Value(date),
        data = Value(data);
  static Insertable<DriftTestData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (data != null) 'data': data,
    });
  }

  DriftTestCompanion copyWith(
      {Value<int>? id, Value<DateTime>? date, Value<String>? data}) {
    return DriftTestCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftTestCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$TestDatabase extends GeneratedDatabase {
  _$TestDatabase(QueryExecutor e) : super(e);
  $TestDatabaseManager get managers => $TestDatabaseManager(this);
  late final $DriftTestTable driftTest = $DriftTestTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftTest];
}

typedef $$DriftTestTableCreateCompanionBuilder = DriftTestCompanion Function({
  Value<int> id,
  required DateTime date,
  required String data,
});
typedef $$DriftTestTableUpdateCompanionBuilder = DriftTestCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> data,
});

class $$DriftTestTableTableManager extends RootTableManager<
    _$TestDatabase,
    $DriftTestTable,
    DriftTestData,
    $$DriftTestTableFilterComposer,
    $$DriftTestTableOrderingComposer,
    $$DriftTestTableCreateCompanionBuilder,
    $$DriftTestTableUpdateCompanionBuilder> {
  $$DriftTestTableTableManager(_$TestDatabase db, $DriftTestTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DriftTestTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DriftTestTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> data = const Value.absent(),
          }) =>
              DriftTestCompanion(
            id: id,
            date: date,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String data,
          }) =>
              DriftTestCompanion.insert(
            id: id,
            date: date,
            data: data,
          ),
        ));
}

class $$DriftTestTableFilterComposer
    extends FilterComposer<_$TestDatabase, $DriftTestTable> {
  $$DriftTestTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DriftTestTableOrderingComposer
    extends OrderingComposer<_$TestDatabase, $DriftTestTable> {
  $$DriftTestTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $TestDatabaseManager {
  final _$TestDatabase _db;
  $TestDatabaseManager(this._db);
  $$DriftTestTableTableManager get driftTest =>
      $$DriftTestTableTableManager(_db, _db.driftTest);
}
