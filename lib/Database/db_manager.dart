import '../model/customer_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbManager {
  Database? _database = null;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "sqliteExample.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE person (id INTEGER PRIMARY KEY autoincrement, name TEXT, email TEXT, mobileNumber TEXT)",
      );
    });
    return _database;
  }

  Future<int?> insertData(Model model) async {
    await openDb();
    int? a = await _database?.insert('person', model.toJson());
    return a;
  }

  Future<List<Model>> getDataList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database!.rawQuery('SELECT * FROM person');

    return List.generate(maps.length, (i) {
      return Model(
          id: maps[i]['id'],
          personName: maps[i]['name'],
          email: maps[i]['email'],
          mobileNumber: maps[i]['mobileNumber']);
    });
  }

  Future<int> updateData(Model model) async {
    await openDb();
    return await _database!.update('person', model.toJson(),
        where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteData(Model model) async {
    await openDb();
    await _database!.delete('person', where: "id = ?", whereArgs: [model.id]);
  }
}
