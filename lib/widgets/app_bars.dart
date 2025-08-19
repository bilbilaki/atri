import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:atri/widgets/chrome_popup_menu.dart';
// --- Home Screen AppBar ---
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(kHomeIcon, color: kGoogleChromeDarkGrey),
        onPressed: () {
          print('Home icon pressed');
        },
      ),
      actions: [
        CircleAvatar(
          radius: 14, // Smaller radius for profile icon
          backgroundColor: Colors.grey[300],
          child: const Text('D', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(width: kSmallPadding),
        GestureDetector(
          onTap: () {
            AppRouter.navigateTo(context, AppRouter.tabSwitcherRoute);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '2',
              style: TextStyle(color: kGoogleChromeDarkGrey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: kSmallPadding),
        ChromePopupMenuButton(),
        const SizedBox(width: kSmallPadding),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- Search Results / Search Input AppBar ---
class SearchScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String urlOrSearchQuery;
  final bool showGoogleIcon;
  final bool isSearchInput; // If true, implies it's the search input screen

  const SearchScreenAppBar({
    super.key,
    required this.urlOrSearchQuery,
    this.showGoogleIcon = false,
    this.isSearchInput = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: isSearchInput
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: kGoogleChromeDarkGrey),
              onPressed: () => Navigator.pop(context),
            )
          : null, // No leading icon for search results
      titleSpacing: isSearchInput ? 0 : null,
      title: Container(
        height: kToolbarHeight * 0.7, // Adjust height
        padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
        decoration: BoxDecoration(
          color: kGoogleChromeGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (showGoogleIcon)
              const Padding(
                padding: EdgeInsets.only(right: kSmallPadding / 2),
                child: Icon(Icons.search, color: kGoogleChromeMediumGrey, size: 20),
              ),
            Expanded(
              child: Text(
                urlOrSearchQuery,
                style: TextStyle(
                  color: kGoogleChromeDarkGrey,
                  fontSize: isSearchInput ? 16 : 14,
                  fontWeight: isSearchInput ? FontWeight.normal : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSearchInput)
              const Icon(Icons.close, color: kGoogleChromeMediumGrey, size: 20),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(kPlusIcon, color: kGoogleChromeDarkGrey),
          onPressed: () {
            print('New tab pressed');
          },
        ),
        GestureDetector(
          onTap: () {
            AppRouter.navigateTo(context, AppRouter.tabSwitcherRoute);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '2', // Placeholder tab count
              style: TextStyle(color: kGoogleChromeDarkGrey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: kSmallPadding),
        ChromePopupMenuButton(),
        const SizedBox(width: kSmallPadding),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- Tab Switcher AppBar ---
class TabSwitcherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabSwitcherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(kPlusIcon, color: kGoogleChromeDarkGrey),
        onPressed: () {
          print('Add new tab pressed');
        },
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          '1', // Placeholder tab count
          style: TextStyle(color: kGoogleChromeDarkGrey, fontWeight: FontWeight.bold),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.grid_view, color: kGoogleChromeDarkGrey),
          onPressed: () {
            print('Grid view pressed');
          },
        ),
        ChromePopupMenuButton(),
        const SizedBox(width: kSmallPadding),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- Settings AppBar ---
class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: kGoogleChromeDarkGrey),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Settings',
        style: TextStyle(color: kGoogleChromeDarkGrey, fontWeight: FontWeight.normal),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: kGoogleChromeMediumGrey),
          onPressed: () {
            print('Help icon pressed');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
