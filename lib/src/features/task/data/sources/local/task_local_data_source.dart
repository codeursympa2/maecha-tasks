import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:sqflite/sqflite.dart';

@injectable
class TaskLocalDataSource{
  Database? _db;

  final String _tableName="tasks";

  TaskLocalDataSource();


  Future<Database> get db async{
    if (_db != null) return _db!;
    _db=await _database();
    return _db!;
  }


  Future<void> _createTables(Database database) async{
    await database.execute(
        """
      CREATE TABLE $_tableName(
  
      title TEXT PRIMARY KEY NOT NULL,
      desc TEXT NOT NULL,
      dateTime TEXT NOT NULL, -- Utilisez TEXT pour stocker la date et l'heure en format ISO
      priority TEXT NOT NULL,
      notify INTEGER NOT NULL,
      done INTEGER NOT NULL,
      user TEXT NOT NULL
    )
        """
    );
  }

  Future<Database> _database() async{
    return openDatabase(
        "maechatasks.db", //nom db
        version: 1,
        onCreate: (Database database,int version) async{
          //on ajoute les tables
          await _createTables(database);
        }
    );
  }

  //Pour ajouter une task
  Future<void> addTask(TaskModel task) async{
    final local=await db;
    //Insertion
    await local.insert(_tableName, task.toJsonLocal(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // La liste des taches
  Future<List<TaskModel>> getAllTasks() async {
    final local = await db;

    final maps = await local.query(_tableName, orderBy: "title DESC");
    return List.generate(maps.length, (i) {
      return TaskModel.fromJsonLocal(maps[i]);
    });
  }

  // Récupération d'une tâche spécifique
  Future<bool> getTaskByTitle(String title) async {
    final local = await db;

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

}