import 'package:atri/utils/app_constants.dart';
import 'package:atri/utils/app_router.dart';
import 'package:atri/widgets/app_bars.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kMediumPadding, kLargePadding, kMediumPadding, kSmallPadding),
      child: Text(
        title,
        style: kDescriptionTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsListItem({
    required BuildContext context,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding, vertical: kSmallPadding),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: kMediumPadding),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) Text(title, style: kSettingsTitleStyle),
                  if (subtitle != null) Text(subtitle, style: kSettingsSubtitleStyle),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: ListView(
        children: [
          _buildSettingsSectionTitle('You and Google'),
          _buildSettingsListItem(
            context: context,
            leading: const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile_avatar.png'), // Placeholder
              backgroundColor: Colors.grey,
              child: Text('D', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            title: 'Daniel Saghapoor (INoSuKe)',
            subtitle: 'd.saghapoor@gmail.com',
            onTap: () {
              print('Profile tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Google Account');
            },
          ),
          _buildSettingsListItem(
            context: context,
            leading: const Icon(Icons.search, color: kGoogleChromeDarkGrey),
            title: 'Google services',
            onTap: () {
              print('Google services tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Google Services');
            },
          ),
          _buildSettingsSectionTitle('Basics'),
          _buildSettingsListItem(
            context: context,
            title: 'Search engine',
            subtitle: 'Google',
            onTap: () {
              print('Search engine tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Search Engine');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Address bar',
            subtitle: 'Top',
            onTap: () {
              print('Address bar tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Address Bar');
            },
          ),
          _buildSettingsSectionTitle('Privacy and security'),
          _buildSettingsListItem(
            context: context,
            title: 'Safety check',
            onTap: () {
              print('Safety check tapped');
              // This could navigate to the Safety Check card content or a dedicated page
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Safety Check');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Passwords and Autofill',
            onTap: () {
              print('Passwords and Autofill tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Passwords & Autofill');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Google Password Manager',
            onTap: () {
              print('Google Password Manager tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Google Password Manager');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Payment methods',
            onTap: () {
              print('Payment methods tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Payment Methods');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Addresses and more',
            onTap: () {
              print('Addresses and more tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Addresses');
            },
          ),
          _buildSettingsListItem(
            context: context,
            title: 'Autofill services',
            onTap: () {
              print('Autofill services tapped');
              AppRouter.navigateTo(context, AppRouter.placeholderRoute, arguments: 'Autofill Services');
            },
          ),
          _buildSettingsSectionTitle('Web & Privacy'),
 _buildSettingsListItem(
 context: context,
 title: 'User agent',
 subtitle: 'Control how websites see your browser',
 onTap: () => AppRouter.navigateTo(context, AppRouter.userAgentRoute),
 ),
 _buildSettingsListItem(
 context: context,
 title: 'Cookies',
 subtitle: 'View and clear cookies',
 onTap: () => AppRouter.navigateTo(context, AppRouter.cookiesManagerRoute),
 ),
 const SizedBox(height: kLargePadding),
 ],
 ),
 );
 }
          // Add more settings categories/items as needed
    
}
