// Path: lib/screens/tab_switcher_screen.dart
import 'package:atri/models/tab_item.dart';
import 'package:atri/services/tab_service.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/widgets/app_bars.dart';
import 'package:atri/widgets/draggable_closable_tab_bar.dart';
import 'package:atri/widgets/search_bar_widget.dart';
import 'package:atri/widgets/tab_preview_card.dart';
import 'package:flutter/material.dart';

class TabSwitcherScreen extends StatefulWidget {
 const TabSwitcherScreen({super.key});

 @override
 State<TabSwitcherScreen> createState() => _TabSwitcherScreenState();
}

class _TabSwitcherScreenState extends State<TabSwitcherScreen> {
 final TextEditingController _searchTabsController = TextEditingController();

 TabService get _svc => TabService.instance;

 void _addTab() {
 final newTab = _svc.createTab(
 title: 'New Tab ${_svc.tabs.length + 1}',
 url: 'https://www.google.com',
 );
 _svc.setActive(newTab.id);
 Navigator.pop(context);
 }

 void _closeTab(String tabId) => _svc.closeTab(tabId);

 void _selectTab(String tabId) {
 _svc.setActive(tabId);
 Navigator.pop(context);
 }

 void _reorderTabs(int oldIndex, int newIndex) => _svc.reorder(oldIndex, newIndex);

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const TabSwitcherAppBar(),
 actions: [
 IconButton(
 icon: const Icon(Icons.add_to_photos_outlined),
 tooltip: 'New Tab',
 onPressed: _addTab,
 ),
 ],
 ),
 body: AnimatedBuilder(
 animation: _svc,
 builder: (context, _) {
 final openTabs = _svc.tabs;
 return Column(
 children: [
 DraggableClosableTabBar(
 tabs: openTabs
 .map((t) => TabData(id: t.id, title: t.title, isSelected: t.isActive))
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
 'Inactive tab (${openTabs.where((t) => !t.isActive).length})',
 style: kTitleTextStyle.copyWith(color: kGoogleChromeMediumGrey),
 ),
 IconButton(
 icon: const Icon(Icons.arrow_forward_ios, size: 16, color: kGoogleChromeMediumGrey),
 onPressed: () {},
 ),
 ],
 ),
 ),
 const Divider(indent: kMediumPadding, endIndent: kMediumPadding, height: kMediumPadding),
 Expanded(
 child: GridView.builder(
 padding: kHorizontalPadding,
 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: 2,
 crossAxisSpacing: kMediumPadding,
 mainAxisSpacing: kMediumPadding,
 childAspectRatio: 0.7,
 ),
 itemCount: openTabs.length,
 itemBuilder: (context, index) {
 final tab = openTabs[index];
 return TabPreviewCard(
 tab: tab,
 onTap: () => _selectTab(tab.id),
 onClose: () => _closeTab(tab.id),
 );
 },
 ),
 ),
 ],
 );
 },
 ),
 floatingActionButton: FloatingActionButton.extended(
 onPressed: _addTab,
 icon: const Icon(Icons.add),
 label: const Text('New Tab'),
 ),
 );
 }
}