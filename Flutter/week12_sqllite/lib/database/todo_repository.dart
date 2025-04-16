import 'package:week12_sqllite/database/db_helper.dart';
import 'package:week12_sqllite/models/todo_model.dart';

class TodoRepository {

  final DBHelper _dbHelper = DBHelper.dbHero;

  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.readDb();
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<int> update(Todo todo) async {
    return await _dbHelper.updateDb(todo.toMap());
  }

  Future<int> delete(int id) async {
    return await _dbHelper.deleteDb(id);
  }

  Future<int> insert(Todo todo) async {
    return await _dbHelper.insertDb(todo.toMap());
  }
}