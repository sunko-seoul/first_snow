import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

part 'bt_communicate.g.dart';

class BTCommunicate extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get data => text()();
}

@DriftDatabase(
  tables: [
    BTCommunicate,
  ],
)
class BTDatabase extends _$BTDatabase {
  BTDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<BTCommunicateData>> getBTCommunicates() {
    return (select(bTCommunicate)).get();
  }

  Stream<List<BTCommunicateData>> watchBTCommunicates(String data) {
    return (select(bTCommunicate)..where((tbl) => tbl.data.equals(data)))
        .watch();
  }

  Future<int> createBTCommunicateWDup(BTCommunicateCompanion data) async {
    return into(bTCommunicate).insert(data);
  }

  Future<int> createBTCommunicate(BTCommunicateCompanion data) async {
    final existingData = await (select(bTCommunicate)
          ..where((tbl) {
            return tbl.data.equals(data.data.value);
          }))
        .get();
    if (existingData.isEmpty) {
      print('insert data');
      return into(bTCommunicate).insert(data);
    } else {
      print('failed data');
      return 0;
    }
  }

  Future<void> removeDuplicates() async {
    await customStatement('''
      DELETE FROM b_t_communicate
      WHERE rowid NOT IN (
        SELECT MIN(rowid)
        FROM b_t_communicate
        GROUP BY data
      );
    ''');
  }

  Future<int> removeBTCommunicate(int id) {
    return (delete(bTCommunicate)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAll() async {
    return (delete(bTCommunicate).go());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'btdb.sqlite'));
    return NativeDatabase(file);
  });
}
