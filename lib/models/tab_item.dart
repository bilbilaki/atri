// Path: lib/models/tab_item.dart
import 'package:uuid/uuid.dart';

class TabItem {
  final String id;
  final String title;
  final String url;
  final String imageUrl;
  final String? previewPath; // dynamic preview saved to file
  final String? faviconUrl; // optional favicon
   bool isActive;

  TabItem({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    this.previewPath,
    this.faviconUrl,
    this.isActive = false,
  });

  factory TabItem.create({
    required String title,
    required String url,
    required String imageUrl,
    bool isActive = false,
    String? previewPath,
    String? faviconUrl,
  }) {
    const uuid = Uuid();
    return TabItem(
      id: uuid.v4(),
      title: title,
      url: url,
      imageUrl: imageUrl,
      previewPath: previewPath,
      faviconUrl: faviconUrl,
      isActive: isActive,
    );
  }

  TabItem copyWith({
    String? id,
    String? title,
    String? url,
    String? imageUrl,
    String? previewPath,
    String? faviconUrl,
    bool? isActive,
  }) {
    return TabItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      previewPath: previewPath ?? this.previewPath,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
