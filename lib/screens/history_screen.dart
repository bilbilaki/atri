// Path: lib/screens/history_screen.dart
import 'package:atri/models/history_item.dart';
import 'package:atri/services/history_service.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<HistoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryService.instance.getAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = HistoryService.instance.getAll();
    });
  }

  Map<String, List<HistoryItem>> _groupByDate(List<HistoryItem> items) {
    final now = DateTime.now();
    String labelFor(DateTime d) {
      final date = DateTime(d.year, d.month, d.day);
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      if (date == today) return 'Today';
      if (date == yesterday) return 'Yesterday';
      return DateFormat.yMMMMd().format(date);
    }

    final map = <String, List<HistoryItem>>{};
    for (final item in items) {
      final key = labelFor(item.visitedAt);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: kGoogleChromeDarkGrey)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: kGoogleChromeDarkGrey),
            onPressed: () async {
              await HistoryService.instance.clearHistory();
              _refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<HistoryItem>>(
          future: _future,
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snap.data!;
            if (items.isEmpty) {
              return const Center(child: Text('No history yet'));
            }
            final grouped = _groupByDate(items);
            final sections = grouped.keys.toList();
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
              itemCount: sections.length,
              itemBuilder: (ctx, i) {
                final section = sections[i];
                final list = grouped[section]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kMediumPadding, kMediumPadding, kMediumPadding, kSmallPadding),
                      child: Text(section, style: kSettingsTitleStyle),
                    ),
                    ...list.map((item) => ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(Icons.history, color: kGoogleChromeDarkGrey, size: 18),
                          ),
                          title: Text(item.title ?? item.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(item.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              if (item.id != null) {
                                await HistoryService.instance.delete(item.id!);
                                _refresh();
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/search_results', arguments: item.url);
                          },
                        )),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}