import 'package:todolist/database/db.dart';
import 'package:todolist/logic/todolist_logic.dart';

class TaskController {
  DB dbHelper = DB();

  Future<void> addTask(String title) async {
    final db = await dbHelper.database;
    await db.insert('tasks', Task(title: title).toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await dbHelper.database;
    final maps = await db.query('tasks');
    return maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> deleteTask(int id) async {
    final db = await dbHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task) async {
    final db = await dbHelper.database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
  Future<void> toggleTask(Task task) async {
    final db = await dbHelper.database;
    task.isDone = task.isDone == 0 ? 1 : 0;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}