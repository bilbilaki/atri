

import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:flutter/material.dart';


class HomeSearchBar extends StatelessWidget {
  final String hintText;
  final bool autofocus;
  final bool showGoogleIcon;
  final bool showMicIcon;
  final VoidCallback? onTap; // Optional tap handler to navigate to search input screen

  const HomeSearchBar({
    super.key,
    this.hintText = 'Search Google or type URL',
    this.autofocus = false,
    this.showGoogleIcon = true,
    this.showMicIcon = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Default action: navigate to search input screen
        AppRouter.navigateTo(context, AppRouter.searchInputRoute);
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        decoration: BoxDecoration(
          color: kGoogleChromeGrey,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (showGoogleIcon)
              const Icon(Icons.search, color: kGoogleChromeMediumGrey), // Google icon
            const SizedBox(width: kSmallPadding),
            Expanded(
              child: Text(
                hintText,
                style: const TextStyle(color: kGoogleChromeMediumGrey, fontSize: 16),
              ),
            ),
            if (showMicIcon)
              const Icon(kMicIcon, color: kGoogleChromeMediumGrey),
          ],
        ),
      ),
    );
  }
}


class TabSwitcherSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const TabSwitcherSearchBar({
    super.key,
    this.hintText = 'Search your tabs',
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Can optionally navigate to a dedicated tab search screen or just activate text field
        print('Search tabs field tapped');
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        decoration: BoxDecoration(
          color: kGoogleChromeGrey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Icon(kSearchIcon, color: kGoogleChromeMediumGrey),
            const SizedBox(width: kSmallPadding),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: kGoogleChromeMediumGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(color: kGoogleChromeDarkGrey),
                autofocus: false, // Don't autofocus here, as it's a tap gesture
                readOnly: true, // Make it read-only to simulate tap-to-activate
                onTap: onTap, // Ensure the onTap also works on the TextField
              ),
            ),
          ],
        ),
      ),
    );
  }
}