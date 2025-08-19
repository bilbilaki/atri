import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:flutter/material.dart';


class ChromePopupMenuButton extends StatelessWidget {
  const ChromePopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: kGoogleChromeDarkGrey),
      offset: const Offset(0, kToolbarHeight), // Position below the AppBar icon
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupMenuItem(context, 'New tab', kNewTabIcon, 'new_tab'),
        _buildPopupMenuItem(context, 'New Incognito tab', kIncognitoIcon, 'incognito'),
        _buildPopupMenuItem(context, 'Add tab to new group', kNewGroupIcon, 'new_group'),
        const PopupMenuDivider(),
        _buildPopupMenuItem(context, 'History', kHistoryIcon, 'history'),
        _buildPopupMenuItem(context, 'Delete browsing data', kDeleteIcon, 'delete_data'),
        _buildPopupMenuItem(context, 'Downloads', kDownloadIcon, 'downloads'),
        _buildPopupMenuItem(context, 'Bookmarks', kStarIcon, 'bookmarks'),
        _buildPopupMenuItem(context, 'Recent tabs', kRecentTabsIcon, 'recent_tabs'),
        const PopupMenuDivider(),
        _buildPopupMenuItem(context, 'Zoom', kZoomIcon, 'zoom'),
        _buildPopupMenuItem(context, 'Share...', kShareIcon, 'share'),
        _buildPopupMenuItem(context, 'Find in page', kFindInPageIcon, 'find_in_page'),
        _buildPopupMenuItem(context, 'Translate...', kTranslateIcon, 'translate'),
        _buildPopupMenuItem(context, 'Add to Home screen', kAddHomeScreenIcon, 'add_to_home'),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'google_com',
          child: Row(
            children: [
              const Icon(Icons.search, color: kGoogleChromeDarkGrey, size: 20),
              const SizedBox(width: kSmallPadding),
              Expanded(
                child: Text('google.com', style: TextStyle(color: kGoogleChromeDarkGrey)),
              ),
              const SizedBox(width: kSmallPadding),
              ElevatedButton.icon(
                onPressed: () {
                  print('Follow google.com pressed');
                  Navigator.pop(context); // Close menu after action
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Follow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGoogleChromeBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size.zero, // Remove minimum size
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Custom padding
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                ),
              ),
            ],
          ),
        ),
        // Add "Settings" option which is common in browser menus
        _buildPopupMenuItem(context, 'Settings', Icons.settings, 'settings'),
      ],
      onSelected: (String value) {
        print('Selected: $value');
        switch (value) {
          case 'new_tab':
          // No specific screen, just opens a new tab on Home Screen
            break;
          case 'incognito':
          // No specific screen for this clone
            break;
          case 'settings':
            AppRouter.navigateTo(context, AppRouter.settingsRoute);
            break;
          case 'history':
          case 'downloads':
          case 'bookmarks':
          case 'recent_tabs':
            AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: value);
            break;
          default:
          // Handle other menu items, print for now
            print('Action for $value');
        }
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String text, IconData icon, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: kGoogleChromeDarkGrey),
          const SizedBox(width: kSmallPadding),
          Text(text, style: const TextStyle(color: kGoogleChromeDarkGrey)),
        ],
      ),
    );
  }
}
