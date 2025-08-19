import 'package:atri/models/tab_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';

class TabPreviewCard extends StatelessWidget {
  final TabItem tab;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const TabPreviewCard({
    super.key,
    required this.tab,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(kSmallPadding / 2),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: kGoogleChromeBlue.withOpacity(0.1),
                    child: const Icon(Icons.search,
                        size: 12, color: kGoogleChromeBlue),
                  ),
                  const SizedBox(width: kSmallPadding / 2),
                  Expanded(
                    child: Text(
                      tab.title,
                      style: const TextStyle(
                          fontSize: 12, color: kGoogleChromeDarkGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: onClose,
                    child: const Icon(Icons.close,
                        size: 16, color: kGoogleChromeMediumGrey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Image.asset(
                  tab.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image,
                            size: 40, color: kGoogleChromeMediumGrey),
                        Text(
                          'No preview',
                          style: kDescriptionTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Original Imports/Constants (assuming these exist in your project)
// Path: utils/app_constants.dart
