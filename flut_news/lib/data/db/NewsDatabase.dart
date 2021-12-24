import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FlutNewsDatabase {
  static final FlutNewsDatabase instance = FlutNewsDatabase._init();

  FlutNewsDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDb("flutNews.db");
    }

    return _database!;
  }

  Future<Database> _initDb(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE NEWS(
        title TEXT NOT NULL PRIMARY KEY,
        author TEXT NOT NULL,
        content TEXT NOT NULL,
        imageUrl TEXT,
        category TEXT,
        isFavourite BOOLEAN NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE USERS(
            username TEXT NOT NULL PRIMARY KEY,
            password TEXT NOT NULL,
            email TEXT,
            imageUrl TEXT NOT NULL
    )
    ''');
  }

  Future closeDb() async {
    final db = await instance.database;
    db.close();
  }
}
