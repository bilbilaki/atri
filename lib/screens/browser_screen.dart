// Path: lib/screens/browser_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as ct;

import 'package:atri/services/history_service.dart';
import 'package:atri/services/bookmark_service.dart';
import 'package:atri/services/download_service.dart';
import 'package:atri/services/tab_service.dart';
import 'package:atri/services/user_agent_service.dart';

class BrowserScreen extends StatefulWidget {
 const BrowserScreen({super.key});

 @override
 State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> with WidgetsBindingObserver {
 InAppWebViewController? _controller;
 PullToRefreshController? _pullToRefreshController;

 String _currentUrl = '';
 String _initialInput = '';
 String _title = '';
 double _progress = 0.0;
 bool _canGoBack = false;
 bool _canGoForward = false;

 final TextEditingController _urlController = TextEditingController();

 // Tab
 String? _tabId;

 @override
 void initState() {
 super.initState();
 WidgetsBinding.instance.addObserver(this);
 _pullToRefreshController = PullToRefreshController(
 onRefresh: () async {
 if (Platform.isAndroid) {
 await _controller?.reload();
 } else if (Platform.isIOS) {
 final url = await _controller?.getUrl();
 if (url != null) await _controller?.loadUrl(urlRequest: URLRequest(url: url));
 }
 },
 );

 DownloadService.instance.initialize().ignore();
 }

 @override
 void didChangeDependencies() {
 super.didChangeDependencies();
 final args = ModalRoute.of(context)?.settings.arguments;
 if (args is String) {
 _initialInput = args;
 } else if (args is Map) {
 _initialInput = (args['input'] as String?) ?? '';
 _tabId = args['tabId'] as String?;
 }
 // Ensure tab exists
 final normalized = _normalizeInputToUrl(_initialInput.isEmpty ? 'https://www.google.com' : _initialInput);
 if (_tabId == null) {
 final tab = TabService.instance.createTab(title: 'Loading...', url: normalized);
 _tabId = tab.id;
 } else {
 // If provided tabId exists, mark active
 TabService.instance.setActive(_tabId!);
 }
 }

 @override
 void dispose() {
 WidgetsBinding.instance.removeObserver(this);
 _urlController.dispose();
 super.dispose();
 }

 @override
 void didChangeAppLifecycleState(AppLifecycleState state) {
 if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
 _captureAndSavePreview().ignore();
 }
 }

 String _normalizeInputToUrl(String input) {
 final trimmed = input.trim();
 if (trimmed.isEmpty) return 'https://www.google.com';
 final hasScheme = trimmed.startsWith('http://') || trimmed.startsWith('https://');
 final looksLikeUrl = RegExp(r'^[^\s]+\.[^\s]{2,}(/.*)?$').hasMatch(trimmed);
 if (hasScheme) return trimmed;
 if (looksLikeUrl && !trimmed.contains(' ')) return 'https://$trimmed';
 final encodedQuery = Uri.encodeQueryComponent(trimmed);
 return 'https://www.google.com/search?q=$encodedQuery';
 }

 Future<void> _applyUserAgent() async {
 final ua = await UserAgentService.instance.currentUserAgent();
 await _controller?.setSettings(settings: InAppWebViewSettings(
 userAgent: ua,
 ));
 }

 Future<void> _loadInput(String input) async {
 final url = _normalizeInputToUrl(input);
 _urlController.text = url;
 await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
 }

 Future<void> _updateNavState() async {
 final canBack = await _controller?.canGoBack() ?? false;
 final canFwd = await _controller?.canGoForward() ?? false;
 setState(() {
 _canGoBack = canBack;
 _canGoForward = canFwd;
 });
 }

 Future<void> _findInPage() async {
 final query = await showDialog<String>(
 context: context,
 builder: (ctx) {
 final tc = TextEditingController();
 return AlertDialog(
 title: const Text('Find in page'),
 content: TextField(
 controller: tc,
 decoration: const InputDecoration(hintText: 'Enter text'),
 autofocus: true,
 textInputAction: TextInputAction.search,
 onSubmitted: (v) => Navigator.of(ctx).pop(v),
 ),
 actions: [
 TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
 TextButton(onPressed: () => Navigator.of(ctx).pop(tc.text), child: const Text('Find')),
 ],
 );
 },
 );
 if (query == null || query.trim().isEmpty) return;
 await _controller?.findAllAsync(find: query);
 if (mounted) {
 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Searching in page...')));
 }
 }

 Future<void> _openExternally() async {
 final uri = await _controller?.getUrl();
 if (uri != null) {
 await launchUrl(Uri.parse(uri.toString()), mode: LaunchMode.externalApplication);
 }
 }

 Future<void> _share() async {
 final uri = await _controller?.getUrl();
 if (uri != null) await Share.share(uri.toString());
 }

 Future<void> _copyLink() async {
 final uri = await _controller?.getUrl();
 if (uri == null) return;
 await Clipboard.setData(ClipboardData(text: uri.toString()));
 if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied')));
 }

 Future<String?> _getBestFaviconUrl() async {
 try {
 final favs = await _controller?.getFavicons();
 if (favs == null || favs.isEmpty) return null;
 favs.sort((a, b) => (b.width ?? 0).compareTo(a.width ?? 0));
 return favs.first.url.toString();
 } catch (_) {
 return null;
 }
 }

 Future<void> _addBookmark() async {
 final url = await _controller?.getUrl();
 if (url == null) return;
 final title = await _controller?.getTitle() ?? url.toString();
 final favicon = await _getBestFaviconUrl();
 try {
 await BookmarkService.instance.addBookmark(title: title, url: url.toString(), faviconUrl: favicon);
 if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bookmark added')));
 } catch (_) {
 if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already bookmarked')));
 }
 }

 Future<void> _clearCookiesForCurrentSite() async {
 final uri = await _controller?.getUrl();
 if (uri == null) return;
 await CookieManager.instance().deleteCookies(url: uri, domain: uri.host);
 if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Site cookies cleared')));
 }

 Future<void> _captureAndSavePreview() async {
 if (_controller == null || _tabId == null) return;
 try {
 final bytes = await _controller!.takeScreenshot();
 if (bytes == null) return;
 final dir = await getTemporaryDirectory();
 final previewsDir = Directory(p.join(dir.path, 'tab_previews'));
 if (!previewsDir.existsSync()) previewsDir.createSync(recursive: true);
 final path = p.join(previewsDir.path, 'tab_$_tabId.png');
 final file = File(path);
 await file.writeAsBytes(bytes, flush: true);
 TabService.instance.updatePreviewPath(_tabId!, path);
 } catch (_) {}
 }

 bool _isOAuthUrl(WebUri uri) {
 final host = (uri.host ?? '').toLowerCase();
 final path = (uri.path ?? '').toLowerCase();
 if (host.contains('accounts.google') ||
 host.contains('auth') ||
 path.contains('oauth') ||
 path.contains('authorize')) {
 return true;
 }
 return false;
 }

 Future<bool> _openInCustomTab(WebUri uri) async {
 try {
 await ct.launchUrl(
 uri,
 customTabsOptions: const ct.CustomTabsOptions(
 shareState: ct.CustomTabsShareState.on,
 instantAppsEnabled: true,
 showTitle: true,
 urlBarHidingEnabled: true,
 ),
 safariVCOptions: const ct.SafariViewControllerOptions(
 barCollapsingEnabled: true,
 entersReaderIfAvailable: false,
 dismissButtonStyle: ct.SafariViewControllerDismissButtonStyle.close,
 ),
 );
 return true;
 } catch (_) {
 return false;
 }
 }

 @override
 Widget build(BuildContext context) {
 final theme = Theme.of(context);
 return Scaffold(
 appBar: AppBar(
 backgroundColor: Colors.white,
 elevation: 0.5,
 leading: IconButton(
 icon: Icon(Icons.arrow_back, color: _canGoBack ? Colors.black87 : Colors.black26),
 onPressed: _canGoBack ? () async { await _controller?.goBack(); await _updateNavState(); } : null,
 tooltip: 'Back',
 ),
 titleSpacing: 0,
 title: Container(
 height: 40,
 decoration: BoxDecoration(color: const Color(0xFFF1F3F4), borderRadius: BorderRadius.circular(20)),
 padding: const EdgeInsets.symmetric(horizontal: 12),
 alignment: Alignment.center,
 child: Row(
 children: [
 const Icon(Icons.lock_outline, size: 16, color: Color(0xFF5F6368)),
 const SizedBox(width: 8),
 Expanded(
 child: TextField(
 controller: _urlController,
 decoration: const InputDecoration(hintText: 'Search or type URL', border: InputBorder.none, isDense: true),
 style: const TextStyle(fontSize: 14),
 textInputAction: TextInputAction.go,
 onSubmitted: _loadInput,
 ),
 ),
 if (_progress < 1.0)
 IconButton(splashRadius: 18, icon: const Icon(Icons.close, size: 18, color: Color(0xFF5F6368)), onPressed: () => _controller?.stopLoading())
 else
 IconButton(splashRadius: 18, icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF5F6368)), onPressed: () => _controller?.reload()),
 ],
 ),
 ),
 actions: [
 IconButton(
 icon: Icon(Icons.arrow_forward, color: _canGoForward ? Colors.black87 : Colors.black26),
 onPressed: _canGoForward ? () async { await _controller?.goForward(); await _updateNavState(); } : null,
 ),
 PopupMenuButton<String>(
 icon: const Icon(Icons.more_vert, color: Colors.black87),
 onSelected: (v) async {
 switch (v) {
 case 'share': await _share(); break;
 case 'copy': await _copyLink(); break;
 case 'external': await _openExternally(); break;
 case 'find': await _findInPage(); break;
 case 'bookmark_add': await _addBookmark(); break;
 case 'desktop_toggle':
 await UserAgentService.instance.toggleDesktop();
 await _applyUserAgent();
 final current = await _controller?.getUrl();
 if (current != null) await _controller?.loadUrl(urlRequest: URLRequest(url: current));
 break;
 case 'clear_cache':
 await _controller?.clearCache();
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
 break;
 case 'clear_cookies_all':
 await CookieManager.instance().deleteAllCookies();
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All cookies cleared')));
 break;
 case 'clear_cookies_site':
 await _clearCookiesForCurrentSite();
 break;
 }
 },
 itemBuilder: (ctx) => [
 const PopupMenuItem(value: 'share', child: Text('Share')),
 const PopupMenuItem(value: 'copy', child: Text('Copy link')),
 const PopupMenuItem(value: 'external', child: Text('Open in browser')),
 const PopupMenuItem(value: 'find', child: Text('Find in page')),
 const PopupMenuItem(value: 'bookmark_add', child: Text('Add bookmark')),
 const PopupMenuItem(value: 'desktop_toggle', child: Text('Toggle Desktop/Mobile UA')),
 const PopupMenuDivider(),
 const PopupMenuItem(value: 'clear_cache', child: Text('Clear cache')),
 const PopupMenuItem(value: 'clear_cookies_site', child: Text('Clear cookies for this site')),
 const PopupMenuItem(value: 'clear_cookies_all', child: Text('Clear all cookies')),
 ],
 ),
 ],
 ),
 body: Column(
 children: [
 if (_progress < 1.0)
 LinearProgressIndicator(value: _progress, minHeight: 2, color: theme.colorScheme.primary, backgroundColor: Colors.grey.shade200),
 Expanded(
 child: InAppWebView(
 initialUrlRequest: URLRequest(url: WebUri(_normalizeInputToUrl(_initialInput.isEmpty ? 'https://www.google.com' : _initialInput))),
 initialSettings: InAppWebViewSettings(
 javaScriptEnabled: true,
 mediaPlaybackRequiresUserGesture: false,
 allowsInlineMediaPlayback: true,
 useShouldOverrideUrlLoading: true,
 preferredContentMode: UserPreferredContentMode.RECOMMENDED,
 transparentBackground: false,
 allowsBackForwardNavigationGestures: true,
 ),
 pullToRefreshController: _pullToRefreshController,
 onWebViewCreated: (controller) async {
 _controller = controller;
 await _applyUserAgent();
 },
 onPermissionRequest: (controller, request) async {
 final resources = request.resources;
 final allow = await showDialog<bool>(
 context: context,
 builder: (ctx) => AlertDialog(
 title: const Text('Website requests permissions'),
 content: Text('Allow access to: ${resources.map((e) => e).join(', ')} ?'),
 actions: [
 TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Deny')),
 TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Allow')),
 ],
 ),
 );
 return PermissionResponse(
 resources: resources,
 action: (allow ?? false) ? PermissionResponseAction.GRANT : PermissionResponseAction.DENY,
 );
 },
 onTitleChanged: (controller, title) {
 _title = title ?? '';
 if (_tabId != null) {
 TabService.instance.updateTabMeta(id: _tabId!, title: _title.isEmpty ? 'Loading...' : _title);
 }
 setState(() {});
 },
 onLoadStart: (controller, url) {
 final u = url?.toString() ?? '';
 _currentUrl = u;
 _urlController.text = u;
 if (_tabId != null) {
 TabService.instance.updateTabMeta(id: _tabId!, url: u);
 TabService.instance.setActive(_tabId!);
 }
 _updateNavState();
 },
 onLoadStop: (controller, url) async {
 final u = url?.toString() ?? '';
 _currentUrl = u;
 _urlController.text = u;
 _progress = 1.0;
 _pullToRefreshController?.endRefreshing();
 await _updateNavState();

 final favicon = await _getBestFaviconUrl();
 if (_tabId != null && favicon != null) {
 TabService.instance.updateTabMeta(id: _tabId!, faviconUrl: favicon);
 }
 await _captureAndSavePreview();

 await HistoryService.instance.addHistoryItem(
 title: _title.isEmpty ? u : _title,
 url: u,
 faviconUrl: favicon,
 );
 setState(() {});
 },
 onProgressChanged: (controller, progress) {
 setState(() => _progress = progress / 100.0);
 },
 shouldOverrideUrlLoading: (controller, action) async {
 final uri = action.request.url;
 if (uri == null) return NavigationActionPolicy.ALLOW;

 // OAuth handling
 if (_isOAuthUrl(uri)) {
 final opened = await _openInCustomTab(uri);
 return opened ? NavigationActionPolicy.CANCEL : NavigationActionPolicy.ALLOW;
 }

 final scheme = uri.scheme.toLowerCase();
 if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(scheme)) {
 try {
 await launchUrl(Uri.parse(uri.toString()));
 return NavigationActionPolicy.CANCEL;
 } catch (_) {
 return NavigationActionPolicy.CANCEL;
 }
 }
 return NavigationActionPolicy.ALLOW;
 },
 onDownloadStartRequest: (controller, request) async {
 final url = request.url.toString();
 final suggested = request.suggestedFilename ?? Uri.parse(url).pathSegments.lastOrNull ?? 'file.bin';
 await DownloadService.instance.enqueueDownload(url: url, suggestedFileName: suggested);
 if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading $suggested')));
 },
 ),
 ),
 ],
 ),
 );
 }
}

extension _ListExt<T> on List<T> {
 T? get lastOrNull => isEmpty ? null : last;
}