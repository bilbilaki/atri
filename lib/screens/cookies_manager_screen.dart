// Path: lib/screens/cookies_manager_screen.dart
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CookiesManagerScreen extends StatefulWidget {
 const CookiesManagerScreen({super.key});
 @override
 State<CookiesManagerScreen> createState() => _CookiesManagerScreenState();
}

class _CookiesManagerScreenState extends State<CookiesManagerScreen> {
 final _urlCtrl = TextEditingController(text: 'https://www.google.com');
 List<Cookie> _cookies = [];
 bool _loading = false;

 Future<void> _loadCookies() async {
 final text = _urlCtrl.text.trim();
 if (text.isEmpty) return;
 setState(() => _loading = true);
 try {
 final uri = WebUri(text);
 final cookies = await CookieManager.instance().getCookies(url: uri);
 setState(() => _cookies = cookies);
 } finally {
 setState(() => _loading = false);
 }
 }

 Future<void> _clearForSite() async {
 final text = _urlCtrl.text.trim();
 if (text.isEmpty) return;
 final uri = WebUri(text);
 await CookieManager.instance().deleteCookies(url: uri, domain: uri.host);
 await _loadCookies();
 }

 Future<void> _clearAll() async {
 await CookieManager.instance().deleteAllCookies();
 setState(() => _cookies = []);
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const Text('Cookies', style: TextStyle(color: kGoogleChromeDarkGrey)),
 backgroundColor: Colors.white, elevation: 0.5,
 ),
 body: Padding(
 padding: const EdgeInsets.all(kMediumPadding),
 child: Column(
 children: [
 TextField(
 controller: _urlCtrl,
 decoration: const InputDecoration(
 labelText: 'Site URL',
 hintText: 'https://example.com',
 border: OutlineInputBorder(),
 ),
 ),
 const SizedBox(height: kMediumPadding),
 Row(
 children: [
 ElevatedButton(onPressed: _loadCookies, child: const Text('Load')),
 const SizedBox(width: kSmallPadding),
 ElevatedButton(onPressed: _clearForSite, child: const Text('Clear for site')),
 const SizedBox(width: kSmallPadding),
 ElevatedButton(onPressed: _clearAll, child: const Text('Clear all')),
 ],
 ),
 const SizedBox(height: kMediumPadding),
 Expanded(
 child: _loading
 ? const Center(child: CircularProgressIndicator())
 : _cookies.isEmpty
 ? const Center(child: Text('No cookies'))
 : ListView.separated(
 itemCount: _cookies.length,
 separatorBuilder: (_, __) => const Divider(height: 0),
 itemBuilder: (ctx, i) {
 final c = _cookies[i];
 return ListTile(
 title: Text('${c.name}=${c.value}', maxLines: 2, overflow: TextOverflow.ellipsis),
 subtitle: Text('${c.domain} • Path: ${c.path} • HttpOnly: ${c.isHttpOnly} • Secure: ${c.isSecure}'),
 );
 },
 ),
 ),
 ],
 ),
 ),
 );
 }
}