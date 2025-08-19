import 'package:flutter/foundation.dart';

enum DownloadStatus { pending, downloading, completed, failed }

extension DownloadStatusCodec on DownloadStatus {
  int get asInt => index;
  static DownloadStatus fromInt(int value) =>
      DownloadStatus.values[value.clamp(0, DownloadStatus.values.length - 1)];
}

@immutable
class DownloadItem {
  final int? id;
  final String fileName;
  final String url;
  final String savePath;
  final DownloadStatus status;
  final double progress; // 0.0 to 1.0
  final DateTime createdAt;

  const DownloadItem({
    this.id,
    required this.fileName,
    required this.url,
    required this.savePath,
    required this.status,
    required this.progress,
    required this.createdAt,
  });

  DownloadItem copyWith({
    int? id,
    String? fileName,
    String? url,
    String? savePath,
    DownloadStatus? status,
    double? progress,
    DateTime? createdAt,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      savePath: savePath ?? this.savePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DownloadItem.fromMap(Map<String, Object?> map) => DownloadItem(
        id: map['id'] as int?,
        fileName: map['file_name'] as String,
        url: map['url'] as String,
        savePath: map['save_path'] as String,
        status: DownloadStatusCodec.fromInt(map['status'] as int),
        progress: (map['progress'] as num).toDouble(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'file_name': fileName,
        'url': url,
        'save_path': savePath,
        'status': status.asInt,
        'progress': progress,
        'created_at': createdAt.millisecondsSinceEpoch,
      };
}