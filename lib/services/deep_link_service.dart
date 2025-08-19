// Path: lib/services/deep_link_service.dart
import 'dart:async';
import 'package:atri/utils/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  DeepLinkService._internal();
  static final DeepLinkService instance = DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> initialize() async {
    try {
      // Get initial link
      final initial = await _appLinks.getInitialLinkString();
      if (initial != null && (initial.startsWith('http://') || initial.startsWith('https://'))) {
        AppRouter.navigatorKey.currentState?.pushNamed(
          '/search_results',
          arguments: initial,
        );
      }

      // Listen for future links
      _sub?.cancel();
      _sub = _appLinks.uriLinkStream.listen((uri) {
        final link = uri.toString();
        if (link.startsWith('http://') || link.startsWith('https://')) {
          AppRouter.navigatorKey.currentState?.pushNamed(
            '/search_results',
            arguments: link,
          );
        }
      }, onError: (e) {
        if (kDebugMode) print('DeepLink error: $e');
      });
    } catch (e) {
      if (kDebugMode) print('DeepLink init failed: $e');
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }
}
