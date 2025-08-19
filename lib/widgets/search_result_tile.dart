
import 'package:atri/models/search_item.dart';
import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:flutter/material.dart';

class SearchResultTile extends StatelessWidget {
  final SearchItem item;

  const SearchResultTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.isHistory) {
      return _buildHistoryTile(context);
    } else {
      return _buildSearchResultTile(context);
    }
  }

  Widget _buildHistoryTile(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tapped history: ${item.title}');
        // Simulate navigating to search results for this query
        Navigator.pushReplacementNamed(
            context,
            '/search_results',
            arguments: item.title // Pass the search query
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding, vertical: kSmallPadding),
        child: Row(
          children: [
            const Icon(kHistoryIcon, color: kGoogleChromeMediumGrey),
            const SizedBox(width: kMediumPadding),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(color: kGoogleChromeDarkGrey, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.north_west, color: kGoogleChromeMediumGrey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultTile(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding, vertical: kSmallPadding / 2),
      shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
      child: InkWell(
onTap: () {
  Navigator.pushNamed(
    context,
    AppRouter.searchResultsRoute, // Use the defined route name
    arguments: (item.url.isNotEmpty ? item.url : item.title), // Pass the URL or title
  );
},
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrl == null)
                CircleAvatar(
                  radius: 12,
                  backgroundColor: kGoogleChromeBlue.withOpacity(0.1),
                  child: const Icon(Icons.link, size: 16, color: kGoogleChromeBlue),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    item.imageUrl!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 16, color: Colors.grey),
                    ),
                  ),
                ),
              const SizedBox(width: kSmallPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.url,
                      style: kUrlTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: kTitleTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description!,
                        style: kDescriptionTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.price!,
                        style: kTitleTextStyle.copyWith(color: kGoogleChromeDarkGrey),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: kSmallPadding),
              if (item.imageUrl != null && item.imageUrl!.isNotEmpty && item.imageUrl!.contains('laptop'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    item.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80, height: 80, color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
                    ),
                  ),
                )
              else
                const Icon(Icons.more_vert, color: kGoogleChromeMediumGrey),
            ],
          ),
        ),
      ),
    );
  }
}