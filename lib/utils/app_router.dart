import 'package:flutter/material.dart';
import 'package:atri/screens/home_screen.dart';
import 'package:atri/screens/search_input_screen.dart';
import 'package:atri/screens/tab_switcher_screen.dart';
import 'package:atri/screens/settings_screen.dart';
import 'package:atri/screens/placeholder_screen.dart';
import 'package:atri/screens/browser_screen.dart'; // Import the BrowserScreen

class AppRouter {
  static const String homeRoute = '/';
  static const String searchInputRoute = '/search_input';
  static const String searchResultsRoute = '/search_results'; // Now points to BrowserScreen
  static const String tabSwitcherRoute = '/tab_switcher';
  static const String settingsRoute = '/settings';
  static const String placeholderRoute = '/placeholder';

  static Map<String, WidgetBuilder> routes = {
    homeRoute: (context) => const HomeScreen(),
    searchInputRoute: (context) => const SearchInputScreen(),
    searchResultsRoute: (context) => const BrowserScreen(), // Updated to BrowserScreen
    tabSwitcherRoute: (context) => const TabSwitcherScreen(),
    settingsRoute: (context) => const SettingsScreen(),
    placeholderRoute: (context) => const PlaceholderScreen(),
  };

  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }
}