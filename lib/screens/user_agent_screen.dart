// Path: lib/screens/user_agent_screen.dart
import 'package:atri/services/user_agent_service.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';

class UserAgentScreen extends StatefulWidget {
 const UserAgentScreen({super.key});
 @override
 State<UserAgentScreen> createState() => _UserAgentScreenState();
}

class _UserAgentScreenState extends State<UserAgentScreen> {
 final _svc = UserAgentService.instance;

 @override
 void initState() {
 super.initState();
 _svc.addListener(_onChange);
 _svc.load();
 }

 @override
 void dispose() {
 _svc.removeListener(_onChange);
 super.dispose();
 }

 void _onChange() => setState(() {});

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const Text('User Agent', style: TextStyle(color: kGoogleChromeDarkGrey)),
 backgroundColor: Colors.white, elevation: 0.5,
 ),
 body: Column(
 children: [
 RadioListTile<UserAgentMode>(
 title: const Text('System default'),
 value: UserAgentMode.system,
 groupValue: _svc.mode,
 onChanged: (v) => _svc.setMode(v!),
 ),
 RadioListTile<UserAgentMode>(
 title: const Text('Mobile (Chrome Android)'),
 value: UserAgentMode.mobile,
 groupValue: _svc.mode,
 onChanged: (v) => _svc.setMode(v!),
 ),
 RadioListTile<UserAgentMode>(
 title: const Text('Desktop (Chrome Windows)'),
 value: UserAgentMode.desktop,
 groupValue: _svc.mode,
 onChanged: (v) => _svc.setMode(v!),
 ),
 const Padding(
 padding: EdgeInsets.all(16),
 child: Text('Changes will apply to new pages or after reloading.', style: kSmallDescriptionTextStyle),
 ),
 ],
 ),
 );
 }
}