import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/widgets/app_bars.dart';
import 'package:atri/widgets/quick_access_grid_item.dart';
import 'package:atri/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: kMediumPadding),
            sliver: SliverToBoxAdapter(
              child: Image.asset(
                'assets/images/google_doodle.jpg',
                height: 60,
                // Replace with actual Google Doodle if available
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    'Google',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: HomeSearchBar()),
          const SliverToBoxAdapter(child: SizedBox(height: kLargePadding)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120, // Height for the horizontal scroll view of icons
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: kHorizontalPadding,
                children: [
                  QuickAccessGridItem(
                    icon: Icons.public,
                    label: 'Internet Sp...',
                    onPressed: () => AppRouter.navigateTo(
                      context,
                      AppRouter.searchResultsRoute,
                      arguments: 'https://flutter.dev',
                    ),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    iconColor: Colors.red,
                  ),
                  const SizedBox(width: kMediumPadding),
                  QuickAccessGridItem(
                    icon: Icons.phone_android,
                    label: 'سطح دسترسی',
                    onPressed: () => AppRouter.navigateTo(
                      context,
                      AppRouter.searchResultsRoute,
                      arguments: 'https://flutter.dev',
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(width: kMediumPadding),
                  QuickAccessGridItem(
                    icon: Icons.cloud_outlined,
                    label: 'Internet Sp...',
                    onPressed: () => AppRouter.navigateTo(
                      context,
                      AppRouter.searchResultsRoute,
                      arguments: 'https://flutter.dev',
                    ),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    iconColor: Colors.orange,
                  ),
                  const SizedBox(width: kMediumPadding),
                  QuickAccessGridItem(
                    icon: Icons.star_border,
                    label: 'Google Ge...',
                    onPressed: () => AppRouter.navigateTo(
                      context,
                      AppRouter.searchResultsRoute,
                      arguments: 'https://flutter.dev',
                    ),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    iconColor: Colors.green,
                  ),
                  const SizedBox(width: kMediumPadding),
                  QuickAccessGridItem(
                    icon: Icons.camera_alt_outlined,
                    label: 'Other App',
                    onPressed: () => AppRouter.navigateTo(
                      context,
                      AppRouter.searchResultsRoute,
                      arguments: 'https://flutter.dev',
                    ),
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    iconColor: Colors.purple,
                  ),
                  const SizedBox(width: kMediumPadding),
                  // Add more items as needed
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: kLargePadding)),
          SliverToBoxAdapter(
            child: Padding(
              padding: kHorizontalPadding,
              child: Card(
                elevation: kCardElevation,
                shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(kMediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.vpn_key_outlined,
                            color: kGoogleChromeMediumGrey,
                          ),
                          const SizedBox(width: kSmallPadding),
                          Text(
                            'Safety Check',
                            style: kTitleTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSmallPadding),
                      Text('Change passwords', style: kTitleTextStyle),
                      const SizedBox(height: 2),
                      Text(
                        'Found 749 compromised passwords',
                        style: kDescriptionTextStyle,
                      ),
                      const SizedBox(height: kMediumPadding),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            print('Change passwords pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGoogleChromeBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: kLargePadding,
                              vertical: kSmallPadding,
                            ),
                          ),
                          child: const Text('Change passwords'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: kLargePadding)),
          SliverAppBar(
            pinned: true,
            toolbarHeight: 50,
            backgroundColor: Colors.white,
            elevation: 0.5,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: kGoogleChromeBlue,
                  labelColor: kGoogleChromeDarkGrey,
                  unselectedLabelColor: kGoogleChromeMediumGrey,
                  indicatorWeight: 2,
                  labelStyle: kTitleTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: kTitleTextStyle.copyWith(fontSize: 14),
                  tabs: const [
                    Tab(text: 'Discover'),
                    Tab(text: 'Following'),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: kGoogleChromeMediumGrey,
                ),
                onPressed: () {
                  print('Discover feed menu pressed');
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDiscoverFeed(),
                Center(
                  child: Text(
                    'Following feed content',
                    style: kDescriptionTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverFeed() {
    return ListView(
      padding: const EdgeInsets.only(top: kMediumPadding),
      children: [
        _buildDiscoverFeedItem(
          title: 'Sad news: Another Linux distro is shutting down',
          source: 'Neowin • 1d',
          imageUrl: 'assets/images/linux_penguin.png',
        ),
        _buildDiscoverFeedItem(
          title: 'Google Maps rolls out new features for electric car owners',
          source: 'TechCrunch • 2h',
          imageUrl: '', // No specific image for this one in screenshot
        ),
        _buildDiscoverFeedItem(
          title: 'Understanding Flutter\'s declarative UI paradigm',
          source: 'Flutter Dev • 5d',
          imageUrl: '',
        ),
        _buildDiscoverFeedItem(
          title: 'Why Dark Mode is more than just aesthetics',
          source: 'Design Insights • 1w',
          imageUrl: '',
        ),
        _buildDiscoverFeedItem(
          title: 'Future of AI: GPT-5 and beyond',
          source: 'AI Today • 3d',
          imageUrl: '',
        ),
      ],
    );
  }

  Widget _buildDiscoverFeedItem({
    required String title,
    required String source,
    String? imageUrl,
  }) {
    return Card(
      elevation: kCardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kSmallPadding / 2,
      ),
      shape: RoundedRectangleBorder(borderRadius: kCardBorderRadius),
      child: InkWell(
        onTap: () {
          print('Tapped discover item: $title');
        },
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kTitleTextStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(source, style: kSmallDescriptionTextStyle),
                    const SizedBox(height: kSmallPadding),
                    Row(
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          size: 18,
                          color: kGoogleChromeMediumGrey,
                        ),
                        const SizedBox(width: kSmallPadding),
                        const Icon(
                          Icons.share,
                          size: 18,
                          color: kGoogleChromeMediumGrey,
                        ),
                        const SizedBox(width: kSmallPadding),
                        const Icon(
                          Icons.more_vert,
                          size: 18,
                          color: kGoogleChromeMediumGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (imageUrl != null && imageUrl.isNotEmpty) ...[
                const SizedBox(width: kSmallPadding),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
