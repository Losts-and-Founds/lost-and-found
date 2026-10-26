import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class PersonalizedLargeWhiteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget text;

  const PersonalizedLargeWhiteButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerFill = customColors.cardFill ?? (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ?? (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: containerFill,
                side: BorderSide(color: borderColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: text,
            ),
          ),
        )
      ],
    );
  }
}
