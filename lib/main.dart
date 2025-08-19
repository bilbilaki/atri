import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/*
 * Copyright (C) 2023-2025 moluopro. All rights reserved.
 * Github: https://github.com/moluopro
 */

// Required to use AppExitResponse for Fluter 3.10 or later

Future<void> main() async {
    // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(new MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrome Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Default font, adjust if needed
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
