import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@injectable
class DatabaseManager {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      "maechatasks.db",
      version: 1,
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      """
      CREATE TABLE tasks (
        title TEXT PRIMARY KEY NOT NULL,
        desc TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        priority TEXT NOT NULL,
        notify INTEGER NOT NULL,
        done INTEGER NOT NULL
      )
      """,
    );
  }

  Future<void> initializeDatabase() async {
    await database; // Cela déclenche l'initialisation au démarrage de l'app
  }
}
