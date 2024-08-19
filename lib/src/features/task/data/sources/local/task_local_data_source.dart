import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/data/sources/local/database_manager.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class TaskLocalDataSource{
  final DatabaseManager _db;
  final String _tableName="tasks";

  TaskLocalDataSource(this._db);


  //Pour ajouter une task
  Future<void> addTask(TaskModel task) async{
    final local=await _db.database;
    //Insertion
    await local.insert(_tableName, task.toJsonLocal(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // La liste des taches
  Future<List<TaskModel>> getAllTasks() async {
    final local=await _db.database;

    final maps = await local.query(_tableName, orderBy: "title DESC");
    return List.generate(maps.length, (i) {
      return TaskModel.fromJsonLocal(maps[i]);
    });
  }

  // Récupération d'une tâche spécifique
  Future<bool> getTaskByTitle(String title) async {
    final local=await _db.database;

    final maps = await local.query(
      _tableName,
      where: "title=?",
      whereArgs: [title],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteTask(String title) async {
    final local=await _db.database;
    await local.delete(_tableName,whereArgs: [title],where: "title=?");
  }

  Future<void> deleteAllTasks() async {
    final local=await _db.database;
    await local.delete(_tableName);
  }

  Future<int> countTasks() async {
    final local=await _db.database;
    final result = await local.rawQuery('SELECT COUNT(*) as count FROM $_tableName');

    // Extraire le nombre total à partir du résultat de la requête
    int totalCount = Sqflite.firstIntValue(result) ?? 0;
    return totalCount;
  }

}