import 'package:atri/models/search_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/widgets/search_result_tile.dart';
import 'package:flutter/material.dart';


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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // Auto-focus on text field
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                return SearchResultTile(item: _searchHistory[index]);
              },
            ),
          ),
          // Placeholder for keyboard - not a real keyboard
          _buildMockKeyboard(),
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
        decoration: BoxDecoration(
          color: kGoogleChromeGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: kGoogleChromeMediumGrey, size: 20),
            const SizedBox(width: kSmallPadding),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search Google or type URL',
                  hintStyle: const TextStyle(color: kGoogleChromeMediumGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(color: kGoogleChromeDarkGrey, fontSize: 16),
                onSubmitted: (query) {
  if (query.isNotEmpty) {
    AppRouter.navigateTo(context, AppRouter.searchResultsRoute, arguments: query);
  }

                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: kGoogleChromeMediumGrey, size: 20),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(kMicIcon, color: kGoogleChromeDarkGrey),
          onPressed: () {
            print('Mic pressed');
          },
        ),
        const SizedBox(width: kSmallPadding),
      ],
    );
  }


  Widget _buildMockKeyboard() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(kSmallPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildKeyboardIcon(Icons.grid_view),
              _buildKeyboardIcon(Icons.gif_box_outlined),
              _buildKeyboardIcon(Icons.content_copy),
              _buildKeyboardIcon(Icons.settings_outlined),
              _buildKeyboardIcon(Icons.palette_outlined),
              _buildKeyboardIcon(Icons.emoji_emotions_outlined),
              _buildKeyboardIcon(Icons.mic_none),
            ],
          ),
          const SizedBox(height: kSmallPadding),
          // Simplified number row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(10, (index) => _buildKey('${index == 9 ? 0 : index + 1}')),
          ),
          const SizedBox(height: kSmallPadding / 2),
          // Simplified letter rows (only A-Z for brevity)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: 'qwertyuiop'.split('').map((e) => _buildKey(e)).toList(),
          ),
          const SizedBox(height: kSmallPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShiftKey(),
              ...('asdfghjkl'.split('').map((e) => _buildKey(e)).toList()),
              _buildDeleteKey(),
            ],
          ),
          const SizedBox(height: kSmallPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSpecialKey('?123'),
              _buildSpecialKey('/'),
              _buildSpecialKey('🌎'),
              _buildSpecialKey('English'),
              _buildSpecialKey('➡️'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String text) {
    return Container(
      width: 32,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildKeyboardIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, color: Colors.grey[700], size: 20),
    );
  }

  Widget _buildShiftKey() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.arrow_upward, size: 20),
    );
  }

  Widget _buildDeleteKey() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.backspace_outlined, size: 20),
    );
  }

  Widget _buildSpecialKey(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}