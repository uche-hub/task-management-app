import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// handles all database setup, versioning, and migrations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // get the database, create it if it doesn't exist yet
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  // create the database file and set it up
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // creates all tables
  Future<void> _createDB(Database db, int version) async {
    // stores task lists
    await db.execute('''
      CREATE TABLE lists (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // actual tasks
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        list_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date INTEGER,
        priority INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (list_id) REFERENCES lists (id) ON DELETE CASCADE
      )
    ''');

    // stores all available tags
    await db.execute('''
      CREATE TABLE tags (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        color INTEGER NOT NULL
      )
    ''');

    // link tasks to tags
    await db.execute('''
      CREATE TABLE task_tags (
        task_id TEXT NOT NULL,
        tag_id TEXT NOT NULL,
        PRIMARY KEY (task_id, tag_id),
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
      )
    ''');

    // settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // make searches faster
    await db.execute('CREATE INDEX idx_tasks_list_id ON tasks(list_id)');
    await db.execute('CREATE INDEX idx_tasks_status ON tasks(status)');
    await db.execute('CREATE INDEX idx_tasks_due_date ON tasks(due_date)');
  }

  // handle version upgrades
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // version 1 to 2: added settings table
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    }
  }

  // safely close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // wipe everything (useful for testing)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}