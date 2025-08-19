// Path: lib/services/history_service.dart
import 'package:atri/data/local/daos.dart';
import 'package:atri/models/history_item.dart';

class HistoryService {
  HistoryService._internal();
  static final HistoryService instance = HistoryService._internal();

  Future<int> addHistoryItem({
    String? title,
    required String url,
    String? faviconUrl,
    DateTime? visitedAt,
  }) async {
    final item = HistoryItem(
      title: title,
      url: url,
      faviconUrl: faviconUrl,
      visitedAt: visitedAt ?? DateTime.now(),
    );
    return await HistoryDao.insert(item);
  }

  Future<List<HistoryItem>> getAll({int? limit, int? offset}) {
    return HistoryDao.getAll(limit: limit, offset: offset);
  }

  Future<List<HistoryItem>> findByUrl(String url, {int? limit, int? offset}) {
    return HistoryDao.findByUrl(url, limit: limit, offset: offset);
  }

  Future<int> delete(int id) {
    return HistoryDao.delete(id);
  }

  Future<int> clearHistory() {
    return HistoryDao.clear();
  }
}