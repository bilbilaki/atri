// Path: lib/screens/search_input_screen.dart
import 'dart:async';
import 'dart:convert';
import 'package:atri/models/search_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/widgets/search_result_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchInputScreen extends StatefulWidget {
 const SearchInputScreen({super.key});
 @override
 State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
 final TextEditingController _searchController = TextEditingController(text: '');
 final FocusNode _focusNode = FocusNode();

 final List<SearchItem> _searchHistory = [
 SearchItem(title: 'figma anime streaming', url: '', isHistory: true),
 SearchItem(title: 'gemini', url: '', isHistory: true),
 SearchItem(title: 'deepseek', url: '', isHistory: true),
 SearchItem(title: 'flutter awesome', url: '', isHistory: true),
 SearchItem(title: 'ai studio', url: '', isHistory: true),
 SearchItem(title: 'bir proxy satın al', url: '', isHistory: true),
 SearchItem(title: 'shamiko github', url: '', isHistory: true),
 SearchItem(title: 'flutter gem', url: '', isHistory: true),
 ];

 List<String> _suggestions = [];
 Timer? _debounce;

 @override
 void initState() {
 super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
 _searchController.addListener(_onQueryChanged);
 }

 @override
 void dispose() {
 _debounce?.cancel();
 _searchController.removeListener(_onQueryChanged);
 _searchController.dispose();
 _focusNode.dispose();
 super.dispose();
 }

 void _onQueryChanged() {
 _debounce?.cancel();
 _debounce = Timer(const Duration(milliseconds: 250), () {
 _fetchSuggestions(_searchController.text);
 });
 }

 Future<void> _fetchSuggestions(String q) async {
 final query = q.trim();
 if (query.isEmpty) {
 setState(() => _suggestions = []);
 return;
 }
 try {
 final uri = Uri.parse('https://suggestqueries.google.com/complete/search?client=firefox&q=${Uri.encodeQueryComponent(query)}');
 final resp = await http.get(uri);
 if (resp.statusCode == 200) {
 final data = jsonDecode(utf8.decode(resp.bodyBytes));
 final List<dynamic> arr = data[1] as List<dynamic>;
 setState(() => _suggestions = arr.map((e) => e.toString()).toList());
 }
 } catch (_) {
 // ignore errors
 }
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: PreferredSize(
 preferredSize: const Size.fromHeight(kToolbarHeight),
 child: _buildCustomSearchAppBar(),
 ),
 body: Column(
 children: [
 Expanded(
 child: ListView.builder(
 padding: EdgeInsets.zero,
 itemCount: _suggestions.isNotEmpty ? _suggestions.length : _searchHistory.length,
 itemBuilder: (context, index) {
 if (_suggestions.isNotEmpty) {
 final s = _suggestions[index];
 return ListTile(
 leading: const Icon(Icons.search, color: kGoogleChromeMediumGrey),
 title: Text(s, maxLines: 1, overflow: TextOverflow.ellipsis),
 onTap: () => AppRouter.navigateTo(context, AppRouter.searchResultsRoute, arguments: s),
 );
 } else {
 return SearchResultTile(item: _searchHistory[index]);
 }
 },
 ),
 ),
 ],
 ),
 );
 }

 Widget _buildCustomSearchAppBar() {
 return AppBar(
 backgroundColor: Colors.white,
 elevation: 0,
 leading: IconButton(
 icon: const Icon(Icons.arrow_back, color: kGoogleChromeDarkGrey),
 onPressed: () => Navigator.pop(context),
 ),
 titleSpacing: 0,
 title: Container(
 height: kToolbarHeight * 0.7,
 padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
 decoration: BoxDecoration(color: kGoogleChromeGrey, borderRadius: BorderRadius.circular(20)),
 child: Row(
 children: [
 const Icon(Icons.search, color: kGoogleChromeMediumGrey, size: 20),
 const SizedBox(width: kSmallPadding),
 Expanded(
 child: TextField(
 controller: _searchController,
 focusNode: _focusNode,
 decoration: const InputDecoration(
 hintText: 'Search Google or type URL',
 hintStyle: TextStyle(color: kGoogleChromeMediumGrey),
 border: InputBorder.none,
 contentPadding: EdgeInsets.zero,
 isDense: true,
 ),
 style: const TextStyle(color: kGoogleChromeDarkGrey, fontSize: 16),
 onSubmitted: (query) {
 if (query.isNotEmpty) AppRouter.navigateTo(context, AppRouter.searchResultsRoute, arguments: query);
 },
 ),
 ),
 IconButton(
 icon: const Icon(Icons.close, color: kGoogleChromeMediumGrey, size: 20),
 onPressed: () {
 _searchController.clear();
 setState(() => _suggestions = []);
 },
 ),
 ],
 ),
 ),
 actions: [
 IconButton(
 icon: const Icon(kMicIcon, color: kGoogleChromeDarkGrey),
 onPressed: () {},
 ),
 const SizedBox(width: kSmallPadding),
 ],
 );
 }

 // (Mock keyboard left unchanged)
}