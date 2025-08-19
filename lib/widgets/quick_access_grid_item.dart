
import 'package:atri/utils/app_constants.dart';
import 'package:flutter/material.dart';

class QuickAccessGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const QuickAccessGridItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: backgroundColor ?? Colors.grey[200],
            child: Icon(icon, color: iconColor ?? kGoogleChromeDarkGrey, size: 28),
          ),
          const SizedBox(height: kSmallPadding / 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: kGoogleChromeMediumGrey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}