// Path: lib/services/tab_service.dart
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:atri/models/tab_item.dart';

class TabService extends ChangeNotifier {
 TabService._internal();
 static final TabService instance = TabService._internal();

 final List<TabItem> _tabs = [];
 String? _activeId;

 UnmodifiableListView<TabItem> get tabs => UnmodifiableListView(_tabs);
 String? get activeTabId => _activeId;

 TabItem createTab({required String title, required String url}) {
 final tab = TabItem.create(title: title, url: url, imageUrl: '');
 _tabs.add(tab);
 setActive(tab.id);
 return tab;
 }

 void setActive(String id) {
 for (final t in _tabs) {
 t.isActive = (t.id == id);
 }
 _activeId = id;
 notifyListeners();
 }

 void updateTabMeta({
 required String id,
 String? title,
 String? url,
 String? faviconUrl,
 }) {
 final idx = _tabs.indexWhere((t) => t.id == id);
 if (idx == -1) return;
 final t = _tabs[idx];
 _tabs[idx] = t.copyWith(
 title: title ?? t.title,
 url: url ?? t.url,
 faviconUrl: faviconUrl ?? t.faviconUrl,
 );
 notifyListeners();
 }

 void updatePreviewPath(String id, String previewPath) {
 final idx = _tabs.indexWhere((t) => t.id == id);
 if (idx == -1) return;
 final t = _tabs[idx];
 _tabs[idx] = t.copyWith(previewPath: previewPath);
 notifyListeners();
 }

 void closeTab(String id) {
 final idx = _tabs.indexWhere((t) => t.id == id);
 if (idx == -1) return;
 final closingActive = _tabs[idx].isActive;
 _tabs.removeAt(idx);
 if (closingActive) {
 if (_tabs.isNotEmpty) {
 setActive(_tabs.first.id);
 } else {
 _activeId = null;
 notifyListeners();
 }
 } else {
 notifyListeners();
 }
 }

 void reorder(int oldIndex, int newIndex) {
 final item = _tabs.removeAt(oldIndex);
 _tabs.insert(newIndex, item);
 notifyListeners();
 }
}