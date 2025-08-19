import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = 'app_data.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        final batch = db.batch();

        batch.execute('''
 CREATE TABLE bookmarks (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT NOT NULL,
 url TEXT NOT NULL UNIQUE,
 favicon_url TEXT,
 created_at INTEGER NOT NULL
 )
 ''');
        batch.execute(
            'CREATE INDEX idx_bookmarks_created_at ON bookmarks (created_at DESC)');

        batch.execute('''
 CREATE TABLE history (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT,
 url TEXT NOT NULL,
 favicon_url TEXT,
 visited_at INTEGER NOT NULL
 )
 ''');
        batch.execute(
            'CREATE INDEX idx_history_visited_at ON history (visited_at DESC)');
        batch.execute('CREATE INDEX idx_history_url ON history (url)');

        batch.execute('''
 CREATE TABLE downloads (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 file_name TEXT NOT NULL,
 url TEXT NOT NULL,
 save_path TEXT NOT NULL,
 status INTEGER NOT NULL,
 progress REAL NOT NULL,
 created_at INTEGER NOT NULL
 )
 ''');
        batch.execute(
            'CREATE INDEX idx_downloads_status ON downloads (status)');
        batch.execute(
            'CREATE INDEX idx_downloads_created_at ON downloads (created_at DESC)');

        await batch.commit(noResult: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();
        // Example future migrations:
        // if (oldVersion < 2) {
        // batch.execute('ALTER TABLE bookmarks ADD COLUMN some_new_col TEXT');
        // }
        await batch.commit(noResult: true);
      },
    );
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
      _db = null;
    }
  }

  // Optional utility for clearing all data (e.g., for testing)
  Future<void> clearAll() async {
    final db = await database;
    final batch = db.batch();
    batch.delete('bookmarks');
    batch.delete('history');
    batch.delete('downloads');
    await batch.commit(noResult: true);
  }
}