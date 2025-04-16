import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper dbHero = DBHelper._secretDBConstructor();
  static Database? _database;

  DBHelper._secretDBConstructor();

  Future<Database?> get dataBase async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database; 
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }


void _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE my_table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT
    )
  ''');
}

Future<int> insertDb(Map<String, dynamic> row) async {
  Database? db = await dataBase;
  return db!.insert('my_table', row);

}

Future<List<Map<String, dynamic>>> readDb() async {
    Database? db = await dataBase;
    return db!.query('my_table');
  }

  Future<int> updateDb(Map<String, dynamic> row) async {
    Database? db = await dataBase;
    return db!.update('my_table', row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> deleteDb(int id) async {
    Database? db = await dataBase;
    return db!.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }

}