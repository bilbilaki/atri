import 'package:flutter/foundation.dart';

@immutable
class HistoryItem {
  final int? id;
  final String? title;
  final String url;
  final String? faviconUrl;
  final DateTime visitedAt;

  const HistoryItem({
    this.id,
    this.title,
    required this.url,
    this.faviconUrl,
    required this.visitedAt,
  });

  HistoryItem copyWith({
    int? id,
    String? title,
    String? url,
    String? faviconUrl,
    DateTime? visitedAt,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }

  factory HistoryItem.fromMap(Map<String, Object?> map) => HistoryItem(
        id: map['id'] as int?,
        title: map['title'] as String?,
        url: map['url'] as String,
        faviconUrl: map['favicon_url'] as String?,
        visitedAt: DateTime.fromMillisecondsSinceEpoch(map['visited_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'url': url,
        'favicon_url': faviconUrl,
        'visited_at': visitedAt.millisecondsSinceEpoch,
      };
}