import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future initDB() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            createdAt TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            completedAt TEXT 
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = _database!;
    final maps = await db.query('tasks', orderBy: 'createdAt DESC');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = _database!;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    log(' task: ${task.updatedAt} ${task.updatedAt.length} ') ;
    task = task.copyWith(
      updatedAt: [...task.updatedAt, DateTime.now()]
    );
    log('Updated task: ${task.updatedAt} ${task.updatedAt.length} ${task.updatedAt.last}') ;
    final db = _database!;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = _database!;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
