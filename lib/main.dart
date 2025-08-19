// Path: lib/main.dart
import 'package:atri/data/local/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:atri/services/deep_link_service.dart';
import 'package:atri/services/user_agent_service.dart';
import 'package:atri/services/audio_service_manager.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await AppDatabase.instance.database;

 if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
 await InAppWebViewController.setWebContentsDebuggingEnabled(true);
 }

 try { await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true); } catch (_) {}
 await UserAgentService.instance.load();
 await AudioServiceManager.initialize();

 runApp(const MyApp());

 // Initialize deep links after app start (uses navigatorKey)
 DeepLinkService.instance.initialize();
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 title: 'Chrome Clone',
 debugShowCheckedModeBanner: false,
 navigatorKey: AppRouter.navigatorKey,
 theme: ThemeData(
 primarySwatch: Colors.blue,
 scaffoldBackgroundColor: Colors.white,
 fontFamily: 'Roboto',
 appBarTheme: const AppBarTheme(
 backgroundColor: Colors.white,
 foregroundColor: kGoogleChromeDarkGrey,
 elevation: 0,
 ),
 ),
 initialRoute: AppRouter.homeRoute,
 routes: AppRouter.routes,
 );
 }
}