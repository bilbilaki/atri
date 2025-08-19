// Path: lib/screens/bookmarks_screen.dart
import 'package:atri/models/bookmark_item.dart';
import 'package:atri/services/bookmark_service.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late Future<List<Bookmark>> _future;

  @override
  void initState() {
    super.initState();
    _future = BookmarkService.instance.getBookmarks();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = BookmarkService.instance.getBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks', style: TextStyle(color: kGoogleChromeDarkGrey)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Bookmark>>(
          future: _future,
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snap.data!;
            if (items.isEmpty) {
              return const Center(child: Text('No bookmarks yet'));
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (ctx, i) {
                final b = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow.shade100,
                    child: const Icon(Icons.star, color: Colors.amber),
                  ),
                  title: Text(b.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(b.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      if (b.id != null) {
                        await BookmarkService.instance.deleteBookmark(b.id!);
                        _refresh();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/search_results', arguments: b.url);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}