import 'package:flutter/foundation.dart';

@immutable
class Bookmark {
  final int? id;
  final String title;
  final String url;
  final String? faviconUrl;
  final DateTime createdAt;

  const Bookmark({
    this.id,
    required this.title,
    required this.url,
    this.faviconUrl,
    required this.createdAt,
  });

  Bookmark copyWith({
    int? id,
    String? title,
    String? url,
    String? faviconUrl,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Bookmark.fromMap(Map<String, Object?> map) => Bookmark(
        id: map['id'] as int?,
        title: map['title'] as String,
        url: map['url'] as String,
        faviconUrl: map['favicon_url'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'url': url,
        'favicon_url': faviconUrl,
        'created_at': createdAt.millisecondsSinceEpoch,
      };
}