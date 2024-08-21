import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

part 'drift_test.g.dart';

class DriftTest extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get data => text()();
}

@DriftDatabase(
  tables: [
    DriftTest,
  ],
)
class TestDatabase extends _$TestDatabase {
  TestDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<DriftTestData>> getDriftTests() {
    return (select(driftTest)).get();
  }

  Stream<List<DriftTestData>> watchDriftTests(String data) {
    return (select(driftTest)..where((tbl) => tbl.data.equals(data))).watch();
  }

  Future<int> createDriftTestWDuplicate(DriftTestCompanion data) async {
    return into(driftTest).insert(data);
  }

  Future<int> createDriftTest(DriftTestCompanion data) async {
    final existingData = await (select(driftTest)
          ..where((tbl) => tbl.data.equals(data.data.value)))
        .get();
    if (existingData.isEmpty) {
      print('insert data');
      return into(driftTest).insert(data);
    } else {
      print('failed data');
      return 0;
    }
  }

  Future<int> removeDriftTest(int id) {
    return (delete(driftTest)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAll() {
    return (delete(driftTest).go());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'testdb.sqlite'));
    return NativeDatabase(file);
  });
}
