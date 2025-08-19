// Path: lib/services/user_agent_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserAgentMode { system, mobile, desktop }

class UserAgentService extends ChangeNotifier {
 UserAgentService._internal();
 static final UserAgentService instance = UserAgentService._internal();

 static const _key = 'user_agent_mode';
 UserAgentMode _mode = UserAgentMode.mobile;

 Future<void> load() async {
 final sp = await SharedPreferences.getInstance();
 final idx = sp.getInt(_key);
 if (idx != null && idx >= 0 && idx < UserAgentMode.values.length) {
 _mode = UserAgentMode.values[idx];
 }
 notifyListeners();
 }

 Future<void> setMode(UserAgentMode mode) async {
 _mode = mode;
 final sp = await SharedPreferences.getInstance();
 await sp.setInt(_key, mode.index);
 notifyListeners();
 }

 Future<void> toggleDesktop() async {
 await setMode(_mode == UserAgentMode.desktop ? UserAgentMode.mobile : UserAgentMode.desktop);
 }

 UserAgentMode get mode => _mode;

 Future<String?> currentUserAgent() async {
 switch (_mode) {
 case UserAgentMode.system:
 return null; // Use default
 case UserAgentMode.mobile:
 return 'Mozilla/5.0 (Linux; Android 12; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Mobile Safari/537.36';
 case UserAgentMode.desktop:
 return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36';
 }
 }
}