import 'package:atri/models/bookmark_item.dart';
import 'package:atri/models/downlooad_item.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../../models/history_item.dart';

class DownloadDao {
  static Future<int> insert(DownloadItem item) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('downloads', item.toMap()..remove('id'));
  }

  static Future<DownloadItem?> getById(int id) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('downloads',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return DownloadItem.fromMap(rows.first);
  }

  static Future<List<DownloadItem>> getAll({
    int? limit,
    int? offset,
    List<DownloadStatus>? statuses,
  }) async {
    final db = await AppDatabase.instance.database;
    String? where;
    List<Object?>? whereArgs;
    if (statuses != null && statuses.isNotEmpty) {
      final qs = List.filled(statuses.length, '?').join(',');
      where = 'status IN ($qs)';
      whereArgs = statuses.map((s) => s.index).toList();
    }
    final rows = await db.query(
      'downloads',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(DownloadItem.fromMap).toList();
  }

  static Future<int> update(DownloadItem item) async {
    if (item.id == null) {
      throw ArgumentError('DownloadItem.id is required for update');
    }
    final db = await AppDatabase.instance.database;
    return await db.update(
      'downloads',
      item.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  static Future<int> updateProgress({
    required int id,
    required double progress,
    required DownloadStatus status,
  }) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'downloads',
      {
        'progress': progress,
        'status': status.index,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('downloads', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAllWithStatus(DownloadStatus status) async {
    final db = await AppDatabase.instance.database;
    return await db
        .delete('downloads', where: 'status = ?', whereArgs: [status.index]);
  }
}
class HistoryDao {
  static Future<int> insert(HistoryItem item) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('history', item.toMap()..remove('id'));
  }

  static Future<HistoryItem?> getById(int id) async {
    final db = await AppDatabase.instance.database;
    final rows =
        await db.query('history', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return HistoryItem.fromMap(rows.first);
  }

  static Future<List<HistoryItem>> getAll({
    int? limit,
    int? offset,
  }) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'history',
      orderBy: 'visited_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(HistoryItem.fromMap).toList();
  }

  static Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> clear() async {
    final db = await AppDatabase.instance.database;
    return await db.delete('history');
  }

  static Future<List<HistoryItem>> findByUrl(String url,
      {int? limit, int? offset}) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'history',
      where: 'url = ?',
      whereArgs: [url],
      orderBy: 'visited_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(HistoryItem.fromMap).toList();
  }
}
class BookmarkDao {
  static Future<int> insert(Bookmark bookmark) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(
      'bookmarks',
      bookmark.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort, // url is UNIQUE
    );
  }

  static Future<Bookmark?> getById(int id) async {
    final db = await AppDatabase.instance.database;
    final rows =
        await db.query('bookmarks', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Bookmark.fromMap(rows.first);
  }

  static Future<Bookmark?> getByUrl(String url) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('bookmarks',
        where: 'url = ?', whereArgs: [url], limit: 1);
    if (rows.isEmpty) return null;
    return Bookmark.fromMap(rows.first);
  }

  static Future<List<Bookmark>> getAll({int? limit, int? offset}) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'bookmarks',
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Bookmark.fromMap).toList();
  }

  static Future<int> update(Bookmark bookmark) async {
    if (bookmark.id == null) {
      throw ArgumentError('Bookmark.id is required for update');
    }
    final db = await AppDatabase.instance.database;
    return await db.update(
      'bookmarks',
      bookmark.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [bookmark.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  static Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }
}