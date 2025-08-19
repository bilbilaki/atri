// Path: lib/screens/downloads_screen.dart
import 'package:atri/models/downlooad_item.dart';
import 'package:atri/services/download_service.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late Future<List<DownloadItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = DownloadService.instance.getDownloads();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = DownloadService.instance.getDownloads();
    });
  }

  Color _statusColor(DownloadStatus s) {
    switch (s) {
      case DownloadStatus.pending:
      case DownloadStatus.downloading:
        return Colors.blue;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
    }
  }

  String _statusText(DownloadStatus s) {
    switch (s) {
      case DownloadStatus.pending:
        return 'Pending';
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.completed:
        return 'Completed';
      case DownloadStatus.failed:
        return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads', style: TextStyle(color: kGoogleChromeDarkGrey)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<DownloadItem>>(
          future: _future,
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snap.data!;
            if (items.isEmpty) {
              return const Center(child: Text('No downloads yet'));
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (ctx, i) {
                final d = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: _statusColor(d.status).withOpacity(0.1),
                    child: Icon(Icons.download, color: _statusColor(d.status)),
                  ),
                  title: Text(d.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.url, maxLines: 1, overflow: TextOverflow.ellipsis, style: kSmallDescriptionTextStyle),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(_statusText(d.status)),
                          const SizedBox(width: 8),
                          if (d.status == DownloadStatus.downloading ||
                              d.status == DownloadStatus.pending)
                            Expanded(
                              child: LinearProgressIndicator(value: d.progress, minHeight: 2),
                            ),
                        ],
                      ),
                    ],
                  ),
                  trailing: _buildActions(d),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions(DownloadItem d) {
    switch (d.status) {
      case DownloadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () => OpenFilex.open(d.savePath),
          tooltip: 'Open',
        );
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async {
            await DownloadService.instance.enqueueDownload(url: d.url, suggestedFileName: d.fileName);
            _refresh();
          },
          tooltip: 'Retry',
        );
      case DownloadStatus.downloading:
      case DownloadStatus.pending:
        return IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () async {
            // Optional: Cancel via flutter_downloader if taskId tracked.
            await DownloadService.instance.delete(d.id!);
            _refresh();
          },
          tooltip: 'Cancel',
        );
    }
  }
}