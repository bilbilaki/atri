// Path: draggable_closable_tab_bar.dart
import 'package:flutter/material.dart';

// A simple data model to represent a tab's essential properties for the bar
class TabData {
  final String id;
  String title;
  bool isSelected;

  TabData({required this.id, required this.title, this.isSelected = false});
}

// Widget for displaying an individual draggable, selectable, and closable tab
class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.title,
    required this.selected,
    required this.onSelect,
    required this.onClose,
  });

  final String title;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator icon
            const Icon(Icons.drag_indicator, size: 16),
            const SizedBox(width: 6),
            // Tab title
            Flexible( // Use Flexible to prevent overflow
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            // Close button
            InkWell(
              onTap: onClose,
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// The main widget providing draggable, selectable, and closable tabs horizontally
class DraggableClosableTabBar extends StatefulWidget {
  final List<TabData> tabs;
  final ValueChanged<String> onTabSelected; // Callback when a tab is selected (tabId)
  final Function(int oldIndex, int newIndex) onTabReordered; // Callback when tabs are reordered
  final ValueChanged<String> onTabClosed; // Callback when a tab's close button is pressed (tabId)
  final double height; // Height of the tab bar

  const DraggableClosableTabBar({
    super.key,
    required this.tabs,
    required this.onTabSelected,
    required this.onTabReordered,
    required this.onTabClosed,
    this.height = 48.0,
  });

  @override
  State<DraggableClosableTabBar> createState() => _DraggableClosableTabBarState();
}

class _DraggableClosableTabBarState extends State<DraggableClosableTabBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false, // Custom drag handles are provided by _TabChip
        onReorder: (oldIndex, newIndex) {
          // Adjust newIndex if moving to a position later in the list
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          widget.onTabReordered(oldIndex, newIndex);
        },
        itemCount: widget.tabs.length,
        itemBuilder: (ctx, i) {
          final tab = widget.tabs[i];
          return ReorderableDragStartListener(
            key: ValueKey(tab.id), // Unique key for each reorderable item
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 6,
                right: 6,
                top: 6,
                bottom: 8,
              ),
              child: _TabChip(
                title: tab.title,
                selected: tab.isSelected,
                onSelect: () => widget.onTabSelected(tab.id),
                onClose: () => widget.onTabClosed(tab.id),
              ),
            ),
          );
        },
      ),
    );
  }
}