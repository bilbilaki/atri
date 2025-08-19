import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  InAppWebViewController? _controller;
  PullToRefreshController? _pullToRefreshController;

  String _currentUrl = '';
  String _initialInput = '';
  String _title = '';
  double _progress = 0.0;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _isDesktopMode = false;

  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          await _controller?.reload();
        } else if (Platform.isIOS) {
          final url = await _controller?.getUrl();
          if (url != null) {
            await _controller?.loadUrl(urlRequest: URLRequest(url: url));
          }
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _initialInput = args;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String _normalizeInputToUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'https://www.google.com';

    final hasScheme = trimmed.startsWith('http://') || trimmed.startsWith('https://');
    final looksLikeUrl = RegExp(r'^[^\s]+\.[^\s]{2,}(/.*)?$').hasMatch(trimmed);

    if (hasScheme) return trimmed;
    if (looksLikeUrl && !trimmed.contains(' ')) {
      return 'https://$trimmed';
    }

    final encodedQuery = Uri.encodeQueryComponent(trimmed);
    return 'https://www.google.com/search?q=$encodedQuery';
  }

  UserPreferredContentMode get _preferredContentMode =>
      _isDesktopMode ? UserPreferredContentMode.DESKTOP : UserPreferredContentMode.MOBILE;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: const [
            Icon(Icons.find_in_page, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Searching in page...')),
          ]),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleDesktopMode() async {
    setState(() => _isDesktopMode = !_isDesktopMode);
    await _controller?.setSettings(settings: InAppWebViewSettings(
      preferredContentMode: UserPreferredContentMode.RECOMMENDED,
      userAgent: _isDesktopMode
          ? 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36'
          : '', // Default user agent for mobile
    ));
    final current = await _controller?.getUrl();
    if (current != null) {
      await _controller?.loadUrl(urlRequest: URLRequest(url: current));
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
    if (uri != null) {
      await Share.share(uri.toString());
    }
  }

  Future<void> _copyLink() async {
    final uri = await _controller?.getUrl();
    if (uri != null) {
      await Clipboard.setData(ClipboardData(text: uri.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link copied')),
        );
      }
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
          onPressed: _canGoBack
              ? () async {
                  await _controller?.goBack();
                  await _updateNavState();
                }
              : null,
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Icon(Icons.lock_outline, size: 16, color: Color(0xFF5F6368)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    hintText: 'Search or type URL',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                  textInputAction: TextInputAction.go,
                  onSubmitted: _loadInput,
                ),
              ),
              if (_progress < 1.0)
                IconButton(
                  splashRadius: 18,
                  icon: const Icon(Icons.close, size: 18, color: Color(0xFF5F6368)),
                  onPressed: () => _controller?.stopLoading(),
                  tooltip: 'Stop',
                )
              else
                IconButton(
                  splashRadius: 18,
                  icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF5F6368)),
                  onPressed: () => _controller?.reload(),
                  tooltip: 'Reload',
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward, color: _canGoForward ? Colors.black87 : Colors.black26),
            onPressed: _canGoForward
                ? () async {
                    await _controller?.goForward();
                    await _updateNavState();
                  }
                : null,
            tooltip: 'Forward',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (v) async {
              switch (v) {
                case 'share':
                  await _share();
                  break;
                case 'copy':
                  await _copyLink();
                  break;
                case 'external':
                  await _openExternally();
                  break;
                case 'find':
                  await _findInPage();
                  break;
                case 'desktop':
                  await _toggleDesktopMode();
                  break;
                case 'clear_cache':
                  await _controller?.clearCache();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
                  }
                  break;
                case 'clear_cookies':
                  await CookieManager.instance().deleteAllCookies();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cookies cleared')));
                  }
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'share', child: Text('Share')),
              const PopupMenuItem(value: 'copy', child: Text('Copy link')),
              const PopupMenuItem(value: 'external', child: Text('Open in browser')),
              const PopupMenuItem(value: 'find', child: Text('Find in page')),
              PopupMenuItem(
                value: 'desktop',
                child: Row(
                  children: [
                    const Text('Desktop site'),
                    const Spacer(),
                    if (_isDesktopMode) const Icon(Icons.check, size: 16),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'clear_cache', child: Text('Clear cache')),
              const PopupMenuItem(value: 'clear_cookies', child: Text('Clear cookies')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              minHeight: 2,
              color: theme.colorScheme.primary,
              backgroundColor: Colors.grey.shade200,
            ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_normalizeInputToUrl(_initialInput.isEmpty ? 'https://www.google.com' : _initialInput)),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                useShouldOverrideUrlLoading: true,
                preferredContentMode: _preferredContentMode,
                transparentBackground: false,
                allowsBackForwardNavigationGestures: true,
              ),
              pullToRefreshController: _pullToRefreshController,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onTitleChanged: (controller, title) {
                setState(() => _title = title ?? '');
              },
              onLoadStart: (controller, url) {
                final u = url?.toString() ?? '';
                setState(() {
                  _currentUrl = u;
                  _urlController.text = u;
                });
                _updateNavState();
              },
              onLoadStop: (controller, url) async {
                final u = url?.toString() ?? '';
                setState(() {
                  _currentUrl = u;
                  _urlController.text = u;
                  _progress = 1.0;
                });
                _pullToRefreshController?.endRefreshing();
                _updateNavState();
              },
              onProgressChanged: (controller, progress) {
                setState(() => _progress = progress / 100.0);
              },
              shouldOverrideUrlLoading: (controller, action) async {
                final uri = action.request.url;
                if (uri == null) return NavigationActionPolicy.ALLOW;

                final scheme = uri.scheme.toLowerCase();
                if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(scheme)) {
                  try {
                    // Attempt to launch non-web URLs externally
                    await launchUrl(Uri.parse(uri.toString()));
                    return NavigationActionPolicy.CANCEL; // Prevent the WebView from trying to load it
                  } catch (_) {
                    // Handle cases where launchUrl might fail
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                // Allow http, https, and other recognized schemes within the WebView
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedError: (controller, request, error) {
                _pullToRefreshController?.endRefreshing();
                // Optionally, you can display an error message or a custom error page here
                debugPrint('WebView Error: ${error.description} for URL: ${request.url}');
              },
            ),
          ),
        ],
      ),
    );
  }
}