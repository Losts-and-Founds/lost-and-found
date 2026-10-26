import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class PersonalizedLargeGreenButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isActive;
  final Widget text;

  const PersonalizedLargeGreenButton({
    super.key,
    required this.onPressed,
    this.isActive = true,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? mintColor : (customColors.secondaryTextColor ?? Colors.grey),
                elevation: 0,
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
