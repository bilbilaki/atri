// Path: models/tab_item.dart
import 'package:uuid/uuid.dart'; // Add uuid package to pubspec.yaml if not already present

class TabItem {
  final String id; // Added unique ID
  final String title;
  final String url;
  final String imageUrl;
  bool isActive;

  TabItem({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    this.isActive = false,
  });

  // Factory constructor to create new TabItem with a unique ID
  factory TabItem.create({
    required String title,
    required String url,
    required String imageUrl,
    bool isActive = false,
  }) {
    // A simple way to generate unique IDs. For robust apps, consider `uuid` package.
    const uuid = Uuid();
    return TabItem(
      id: uuid.v4(), // Generates a UUID
      title: title,
      url: url,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }
}