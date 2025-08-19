// Path: lib/services/bookmark_service.dart
import 'package:atri/data/local/daos.dart';
import 'package:atri/models/bookmark_item.dart';

class BookmarkService {
  BookmarkService._internal();
  static final BookmarkService instance = BookmarkService._internal();

  Future<int> addBookmark({
    required String title,
    required String url,
    String? faviconUrl,
    DateTime? createdAt,
  }) async {
    final bookmark = Bookmark(
      title: title,
      url: url,
      faviconUrl: faviconUrl,
      createdAt: createdAt ?? DateTime.now(),
    );
    return await BookmarkDao.insert(bookmark);
  }

  Future<List<Bookmark>> getBookmarks({int? limit, int? offset}) {
    return BookmarkDao.getAll(limit: limit, offset: offset);
  }

  Future<Bookmark?> getByUrl(String url) {
    return BookmarkDao.getByUrl(url);
  }

  Future<int> updateBookmark(Bookmark bookmark) {
    return BookmarkDao.update(bookmark);
  }

  Future<int> deleteBookmark(int id) {
    return BookmarkDao.delete(id);
  }
}