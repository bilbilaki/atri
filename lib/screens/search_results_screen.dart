import 'package:atri/models/search_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/widgets/app_bars.dart';
import 'package:atri/widgets/search_result_tile.dart';
import 'package:flutter/material.dart';


class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _searchQuery = '';

  final List<SearchItem> _searchResults = [
    SearchItem(
      title: 'Epic Anime - An Anime Streaming Website | Landing Page Design',
      url: 'https://www.google.com/search?q',
      description: 'A sleek and immersive anime streaming website. This design showcases a modern UI with an emphasis on user experience and engagement.',
      imageUrl: 'assets/images/laptop_preview.png',
    ),
    SearchItem(
      title: 'AniArk - Anime Streaming App',
      url: 'https://www.figma.com',
      description: 'Dive into a vast library of your favorite anime, streaming fast from an extensive collection of genres, bringing the ultimate anime experience right to your ...',
      imageUrl: 'assets/images/figma_icon.png', // Using figma icon as placeholder
    ),
    SearchItem(
      title: 'Animax - Anime Streaming App UI Kit',
      url: 'https://www.figma.com',
      description: 'Animax is a Premium & High Quality UI Kit with All Full Features of Anime Streaming App. Animax came with unique style and niche, you can easily...',
      imageUrl: 'assets/images/animark_icon.png', // Using animark icon as placeholder for Figma asset
      price: 'US\$33.00',
    ),
    SearchItem(
      title: 'Anime Streaming Website (Tokyo Calling) - Landing Page Design',
      url: 'https://www.google.com/search?q',
      description: 'Landing page of a brand called Tokyo Calling. Tokyo Calling is a weeb\'s go-to destination for everything anime - from news and blogs to streams and watch ...',
      imageUrl: 'assets/images/laptop_preview.png',
    ),
    // Add more dummy data if needed
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? query = ModalRoute.of(context)?.settings.arguments as String?;
    if (query != null && query.isNotEmpty) {
      setState(() {
        _searchQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchScreenAppBar(
        urlOrSearchQuery: _searchQuery.isEmpty
            ? 'google.com/search?q'
            : 'google.com/search?q=$_searchQuery',
        showGoogleIcon: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return SearchResultTile(item: _searchResults[index]);
        },
      ),
    );
  }
}