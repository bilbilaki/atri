// Path: lib/services/download_service.dart
import 'dart:isolate';
import 'dart:ui';

import 'package:atri/data/local/daos.dart';
import 'package:atri/models/downlooad_item.dart';
import 'package:flutter/foundation.dart';

// Optional when you enable real downloads:
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DownloadService {
  DownloadService._internal();
  static final DownloadService instance = DownloadService._internal();

  static const String _portName = 'atri_downloader_port';
  final ReceivePort _port = ReceivePort();

  bool _initialized = false;

  Future<void> initialize({bool registerCallback = true}) async {
    if (_initialized) return;
    // Initialize flutter_downloader if plugin is available
    try {
      await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
    } catch (_) {
      // Safe to ignore if plugin not configured yet
    }

    // Register a background callback
    if (registerCallback) {
      IsolateNameServer.removePortNameMapping(_portName);
      IsolateNameServer.registerPortWithName(_port.sendPort, _portName);
      _port.listen((dynamic data) async {
        if (data is List && data.length >= 3) {
          final String taskId = data[0] as String;
          final DownloadTaskStatus status = data[1] as DownloadTaskStatus;
          final int progress = data[2] as int;

          // You could map taskId -> DB id using a simple cache; for brevity, we only log here.
          // Extend to store taskId in DB if you want full sync.
          // For demo, try to find by URL or keep a separate mapping.
          // Optionally update DB if mapped.
        }
      });

      try {
        FlutterDownloader.registerCallback(DownloadService.downloadCallback as DownloadCallback);
      } catch (_) {
        // Ignore if plugin not enabled yet
      }
    }

    _initialized = true;
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(_portName);
    send?.send([id, status, progress]);
  }

  Future<int> addToDatabase({
    required String fileName,
    required String url,
    required String savePath,
    DownloadStatus status = DownloadStatus.pending,
    double progress = 0.0,
  }) async {
    final item = DownloadItem(
      fileName: fileName,
      url: url,
      savePath: savePath,
      status: status,
      progress: progress,
      createdAt: DateTime.now(),
    );
    return await DownloadDao.insert(item);
  }

  Future<List<DownloadItem>> getDownloads({
    int? limit,
    int? offset,
    List<DownloadStatus>? statuses,
  }) {
    return DownloadDao.getAll(limit: limit, offset: offset, statuses: statuses);
  }

  Future<int> updateProgress({
    required int id,
    required double progress,
    required DownloadStatus status,
  }) {
    return DownloadDao.updateProgress(id: id, progress: progress, status: status);
  }

  Future<int> delete(int id) => DownloadDao.delete(id);

  Future<int> deleteAllWithStatus(DownloadStatus status) => DownloadDao.deleteAllWithStatus(status);

  // Enqueue real download via flutter_downloader (once plugin is configured).
  Future<void> enqueueDownload({
    required String url,
    String? suggestedFileName,
  }) async {
    // Decide save directory
    final dir = await getApplicationDocumentsDirectory();
    final downloadsDir = p.join(dir.path, 'downloads');
    final fileName = suggestedFileName ?? Uri.parse(url).pathSegments.lastOrNull ?? 'file.bin';

    // Create DB record first
    final saveFullPath = p.join(downloadsDir, fileName);
    final dbId = await addToDatabase(
      fileName: fileName,
      url: url,
      savePath: saveFullPath,
      status: DownloadStatus.pending,
      progress: 0.0,
    );

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadsDir,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      // If you want to maintain mapping between taskId and DB id, store it somewhere persistent.
      // For brevity, not stored here.
      debugPrint('Enqueued download $taskId -> DB item $dbId');
    } catch (e) {
      // Update DB as failed
      await updateProgress(id: dbId, progress: 0.0, status: DownloadStatus.failed);
    }
  }
}

extension _IterExt<E> on List<E> {
  E? get lastOrNull => isEmpty ? null : this[length - 1];
}