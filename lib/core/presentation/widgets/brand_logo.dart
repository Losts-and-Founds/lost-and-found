import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

/// Circular pin icon inside a mint-green ring matching the high-fidelity design specification
class BrandPinIcon extends StatelessWidget {
  final double size;
  final double ringPadding;

  const BrandPinIcon({
    super.key,
    this.size = 64,
    this.ringPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: mintColor,
          width: size >= 64 ? 2.8 : 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: mintColor.withOpacity(0.2),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(ringPadding),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mintColor.withOpacity(0.12),
        ),
        child: Center(
          child: Icon(
            Icons.location_on_rounded,
            color: mintColor,
            size: size * 0.52,
          ),
        ),
      ),
    );
  }
}

/// Brand logo containing the circular pin and serif "Lost&Found" text
class BrandLogo extends StatelessWidget {
  final bool vertical;
  final double iconSize;
  final double fontSize;
  final bool showSubtitle;
  final String? subtitle;

  const BrandLogo({
    super.key,
    this.vertical = true,
    this.iconSize = 68,
    this.fontSize = 32,
    this.showSubtitle = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BrandPinIcon(size: iconSize),
          const SizedBox(height: 16),
          Text(
            "Lost&Found",
            style: AppTypography.serifTitle(
              context,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showSubtitle) ...[
            const SizedBox(height: 8),
            Text(
              subtitle ?? "Every lost thing has a way back home.",
              textAlign: TextAlign.center,
              style: AppTypography.sansSecondary(
                context,
                fontSize: 14,
              ),
            ),
          ],
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BrandPinIcon(size: iconSize),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Lost&Found",
                style: AppTypography.serifTitle(
                  context,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (showSubtitle) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle ?? "Every lost thing has a way back home.",
                  style: AppTypography.sansSecondary(
                    context,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    }
  }
}
