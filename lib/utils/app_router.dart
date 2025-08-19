// Path: lib/utils/app_router.dart
import 'package:flutter/material.dart';
import 'package:atri/screens/home_screen.dart';
import 'package:atri/screens/search_input_screen.dart';
import 'package:atri/screens/tab_switcher_screen.dart';
import 'package:atri/screens/settings_screen.dart';
import 'package:atri/screens/placeholder_screen.dart';
import 'package:atri/screens/browser_screen.dart';
import 'package:atri/screens/history_screen.dart';
import 'package:atri/screens/bookmarks_screen.dart';
import 'package:atri/screens/downloads_screen.dart';
import 'package:atri/screens/user_agent_screen.dart';
import 'package:atri/screens/cookies_manager_screen.dart';

class AppRouter {
 static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

 static const String homeRoute = '/';
 static const String searchInputRoute = '/search_input';
 static const String searchResultsRoute = '/search_results';
 static const String tabSwitcherRoute = '/tab_switcher';
 static const String settingsRoute = '/settings';
 static const String placeholderRoute = '/placeholder';
 static const String historyRoute = '/history';
 static const String bookmarksRoute = '/bookmarks';
 static const String downloadsRoute = '/downloads';
 static const String userAgentRoute = '/user_agent';
 static const String cookiesManagerRoute = '/cookies_manager';

 static Map<String, WidgetBuilder> routes = {
 homeRoute: (context) => const HomeScreen(),
 searchInputRoute: (context) => const SearchInputScreen(),
 searchResultsRoute: (context) => const BrowserScreen(),
 tabSwitcherRoute: (context) => const TabSwitcherScreen(),
 settingsRoute: (context) => const SettingsScreen(),
 placeholderRoute: (context) => const PlaceholderScreen(),
 historyRoute: (context) => const HistoryScreen(),
 bookmarksRoute: (context) => const BookmarksScreen(),
 downloadsRoute: (context) => const DownloadsScreen(),
 userAgentRoute: (context) => const UserAgentScreen(),
 cookiesManagerRoute: (context) => const CookiesManagerScreen(),
 };

 static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
 Navigator.pushNamed(context, routeName, arguments: arguments);
 }
}