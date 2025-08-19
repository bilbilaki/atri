
class SearchItem {
  final String title;
  final String url;
  final String? description;
  final String? imageUrl;
  final String? price; // For items like "Animax UI Kit"
  final bool isHistory; // To differentiate history from search results

  SearchItem({
    required this.title,
    required this.url,
    this.description,
    this.imageUrl,
    this.price,
    this.isHistory = false,
  });
}
