// Path: tab_switcher_screen.dart
import 'package:atri/models/tab_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/widgets/app_bars.dart';
import 'package:atri/widgets/draggable_closable_tab_bar.dart';
import 'package:atri/widgets/search_bar_widget.dart';
import 'package:atri/widgets/tab_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:atri/widgets/draggable_closable_tab_bar.dart'; // Import the new tab bar widget

class TabSwitcherScreen extends StatefulWidget {
  const TabSwitcherScreen({super.key});

  @override
  State<TabSwitcherScreen> createState() => _TabSwitcherScreenState();
}

class _TabSwitcherScreenState extends State<TabSwitcherScreen> {
  final TextEditingController _searchTabsController = TextEditingController();

  List<TabItem> _openTabs = []; // Now managed by this class
  TabItem? _lastClosedTab;
  String? _activeTabId; // To keep track of the currently active tab

  @override
  void initState() {
    super.initState();
    // Initialize with some dummy tabs, ensuring one is active
    _openTabs = [
      TabItem.create(
        title: 'Epic Anime - An Anime Streaming Website | Landing Page Design',
        url: 'https://www.figma.com',
        imageUrl: 'assets/images/laptop_preview.png',
        isActive: true, // Mark this one as active initially
      ),
      TabItem.create(
        title: 'Flutter Official Website',
        url: 'https://flutter.dev',
        imageUrl: 'assets/images/laptop_preview.png',
      ),
      TabItem.create(
        title: 'Google Search',
        url: 'https://google.com',
        imageUrl: 'assets/images/laptop_preview.png',
      ),
    ];
    _activeTabId = _openTabs.first.id;
  }

  // Method to create a new tab
  void _addTab() {
    setState(() {
      final newTab = TabItem.create(
        title: 'New Tab ${_openTabs.length + 1}',
        url: 'https://example.com/new',
        imageUrl: 'assets/images/laptop_preview.png', // Placeholder
      );
      _openTabs.add(newTab);
      _selectTab(newTab.id); // Make the newly created tab active
    });
  }

  // Modified to close tab by ID, consistent with DraggableClosableTabBar
  void _closeTab(String tabId) {
    setState(() {
      final index = _openTabs.indexWhere((tab) => tab.id == tabId);
      if (index != -1) {
        _lastClosedTab = _openTabs[index];
        _openTabs.removeAt(index);
        _showUndoSnackbar();

        // If the closed tab was active, set a new active tab
        if (_activeTabId == tabId) {
          _activeTabId = _openTabs.isNotEmpty ? _openTabs.first.id : null;
          // Update isActive status for the new active tab
          if (_activeTabId != null) {
            final newActiveIndex = _openTabs.indexWhere((tab) => tab.id == _activeTabId);
            if (newActiveIndex != -1) {
              _openTabs[newActiveIndex].isActive = true;
            }
          }
        }
      }
    });
  }

  void _undoCloseTab() {
    if (_lastClosedTab != null) {
      setState(() {
        _openTabs.add(_lastClosedTab!);
        _selectTab(_lastClosedTab!.id); // Select the undone tab
        _lastClosedTab = null;
      });
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _showUndoSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check, color: Colors.white, size: 20),
            const SizedBox(width: kSmallPadding),
            Expanded(
              child: Text(
                '${_lastClosedTab?.title} Closed',
                style: kBoldWhiteTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoCloseTab,
          textColor: kGoogleChromeBlue,
        ),
        backgroundColor: kGoogleChromeDarkGrey,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(kMediumPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Method to handle tab selection
  void _selectTab(String tabId) {
    setState(() {
      for (var tab in _openTabs) {
        tab.isActive = (tab.id == tabId);
      }
      _activeTabId = tabId;
    });
    // Optionally navigate back to the main content screen
     Navigator.pop(context);
  }

  // Method to handle tab reordering
  void _reorderTabs(int oldIndex, int newIndex) {
    setState(() {
      final movedTab = _openTabs.removeAt(oldIndex);
      _openTabs.insert(newIndex, movedTab);
    });
  }

  @override
  void dispose() {
    _searchTabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
      TabSwitcherAppBar(),
        // Add action for creating new tab in AppBar if desired
        actions: [
          IconButton(
            icon: const Icon(Icons.add_to_photos_outlined),
            tooltip: 'New Tab',
            onPressed: _addTab,
          ),
          // Original PopUpMenuButton from first code example (if needed)
          // PopupMenuButton<String>(
          //   tooltip: 'Workspace actions',
          //   onSelected: (v) => _onWorkspaceAction(context, ref, active, v),
          //   itemBuilder: (ctx) => const [
          //     PopupMenuItem(value: 'rename', child: Text('Rename')),
          //     PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
          //     PopupMenuItem(value: 'export', child: Text('Export JSON')),
          //     PopupMenuItem(value: 'import', child: Text('Import JSON')),
          //     PopupMenuItem(value: 'delete', child: Text('Delete')),
          //   ],
          // ),
        ],
      ),
      body: Column(
        children: [
          // Draggable and Closable Tab Bar for active tab management
          DraggableClosableTabBar(
            tabs: _openTabs
                .map((item) => TabData(
                      id: item.id,
                      title: item.title,
                      isSelected: item.isActive,
                    ))
                .toList(),
            onTabSelected: _selectTab,
            onTabReordered: _reorderTabs,
            onTabClosed: _closeTab,
          ),
          const SizedBox(height: kMediumPadding),
          TabSwitcherSearchBar(controller: _searchTabsController),
          const SizedBox(height: kMediumPadding),
          Padding(
            padding: kHorizontalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inactive tab (${_openTabs.where((tab) => !tab.isActive).length})',
                  style:
                      kTitleTextStyle.copyWith(color: kGoogleChromeMediumGrey),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: kGoogleChromeMediumGrey),
                  onPressed: () {
                    print('Inactive tab details pressed');
                  },
                ),
              ],
            ),
          ),
          const Divider(
              indent: kMediumPadding,
              endIndent: kMediumPadding,
              height: kMediumPadding),
          Expanded(
            child: GridView.builder(
              padding: kHorizontalPadding,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: kMediumPadding,
                mainAxisSpacing: kMediumPadding,
                childAspectRatio: 0.7,
              ),
              itemCount: _openTabs.length,
              itemBuilder: (context, index) {
                return TabPreviewCard(
                  tab: _openTabs[index],
                  onTap: () {
                    print('Tapped tab: ${_openTabs[index].title}');
                    _selectTab(_openTabs[index].id); // Select the tab when its card is tapped
                    // Navigator.pop(context); // Go back to Home screen or original screen
                  },
                  onClose: () => _closeTab(_openTabs[index].id),
                );
              },
            ),
          ),
        ],
      ),
      // Optional: Add a FloatingActionButton for new tab
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTab,
        icon: const Icon(Icons.add),
        label: const Text('New Tab'),
      ),
    );
  }
}

// Keep TabPreviewCard as is, it's used by the GridView.builder
// Path: widgets/tab_preview_card.dart
