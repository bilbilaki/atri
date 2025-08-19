
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? screenName = ModalRoute.of(context)?.settings.arguments as String?;
    final String title = screenName?.replaceAll('_', ' ').capitalizeFirst ?? 'Placeholder';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kGoogleChromeDarkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: kGoogleChromeDarkGrey, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 60, color: kGoogleChromeMediumGrey),
            const SizedBox(height: kMediumPadding),
            Text(
              'This is the "$title" screen.',
              style: kTitleTextStyle.copyWith(color: kGoogleChromeMediumGrey),
            ),
            Text(
              'UI Not Implemented in this clone.',
              style: kDescriptionTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}