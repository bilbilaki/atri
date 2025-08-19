import 'package:flutter/material.dart';

// Colors
const Color kGoogleChromeBlue = Color(0xFF4285F4);
const Color kGoogleChromeGrey = Color(0xFFF1F3F4);
const Color kGoogleChromeDarkGrey = Color(0xFF202124);
const Color kGoogleChromeMediumGrey = Color(0xFF5F6368); // For text like "1d"
const Color kGoogleChromeLightGrey = Color(0xFFDADCE0); // Border color

// Padding and Spacing
const EdgeInsets kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);
const double kSmallPadding = 8.0;
const double kMediumPadding = 16.0;
const double kLargePadding = 24.0;

const double kCardElevation = 0.5;
const BorderRadius kCardBorderRadius = BorderRadius.all(Radius.circular(12.0));

// Text Styles
const TextStyle kUrlTextStyle = TextStyle(color: Color(0xFF006400), fontSize: 13.0); // Dark Green for URLs
const TextStyle kTitleTextStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
const TextStyle kDescriptionTextStyle = TextStyle(fontSize: 14.0, color: Color(0xFF5F6368));
const TextStyle kSmallDescriptionTextStyle = TextStyle(fontSize: 12.0, color: Color(0xFF5F6368));
const TextStyle kBoldWhiteTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const TextStyle kSettingsTitleStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
const TextStyle kSettingsSubtitleStyle = TextStyle(fontSize: 14.0, color: kGoogleChromeMediumGrey);

// Icons
// Placeholder for custom icons not readily available in Material Icons
const IconData kHomeIcon = Icons.home_outlined;
const IconData kPlusIcon = Icons.add;
const IconData kStarIcon = Icons.star_outline;
const IconData kDownloadIcon = Icons.download_outlined;
const IconData kInfoIcon = Icons.info_outline;
const IconData kRefreshIcon = Icons.refresh;
const IconData kSearchIcon = Icons.search;
const IconData kMicIcon = Icons.mic_none;
const IconData kShareIcon = Icons.share;
const IconData kTranslateIcon = Icons.translate_outlined;
const IconData kAddHomeScreenIcon = Icons.add_to_home_screen;
const IconData kHistoryIcon = Icons.history;
const IconData kDeleteIcon = Icons.delete_outline;
const IconData kRecentTabsIcon = Icons.tab;
const IconData kZoomIcon = Icons.zoom_out_map;
const IconData kFindInPageIcon = Icons.find_in_page_outlined;
const IconData kNewTabIcon = Icons.add_box_outlined;
final IconData kIncognitoIcon = Icons.adobe_sharp;
const IconData kNewGroupIcon = Icons.grid_on_outlined; // Or Icons.group_add