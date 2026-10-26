import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class ItemFeedCardData {
  final int id;
  final bool isLost;
  final String title;
  final String location;
  final String date;
  final DateTime? createdAt;
  final String? imageUrl;
  final String? category;

  const ItemFeedCardData({
    required this.id,
    required this.isLost,
    required this.title,
    required this.location,
    required this.date,
    this.createdAt,
    this.imageUrl,
    this.category,
  });
}

class ItemFeedCard extends StatelessWidget {
  final ItemFeedCardData item;
  final VoidCallback? onTap;

  const ItemFeedCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardFill = colors.cardFill ??
        (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = colors.cardBorderColor ??
        (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));
    final secondaryTextColor =
        colors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final textPrimary =
        colors.textPrimary ?? (isDark ? Colors.white : const Color(0xFF1E232A));
    final foundColor = colors.primaryAccent ?? const Color(0xFF52C46A);
    final badgeColor = item.isLost
        ? (isDark ? const Color(0xFFA61C32) : const Color(0xFF1E232A))
        : foundColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap ??
              () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemScreen(itemId: item.id),
                    ),
                  ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: colors.containerSoft ??
                            (isDark
                                ? const Color(0xFF192238)
                                : const Color(0xFFF3EFEA)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: item.imageUrl?.startsWith('http') == true
                          ? CachedNetworkImage(
                              imageUrl: _thumbnailUrl(item.imageUrl!),
                              fit: BoxFit.cover,
                              memCacheWidth: 320,
                              memCacheHeight: 320,
                              maxWidthDiskCache: 320,
                              maxHeightDiskCache: 320,
                              placeholder: (_, __) =>
                                  _buildPlaceholder(context),
                              errorWidget: (_, __, ___) =>
                                  _buildPlaceholder(context),
                            )
                          : _buildPlaceholder(context),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(AppRadius.badge),
                        ),
                        child: Text(
                          item.isLost ? 'LOST' : 'FOUND',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item.date,
                          style: AppTypography.sansSecondary(
                            context,
                            fontSize: 11,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.sansBold(
                          context,
                          fontSize: 17,
                          color: textPrimary,
                        ),
                      ),
                      if (item.category != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.category!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.sansSecondary(
                            context,
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.sansSecondary(
                                context,
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _thumbnailUrl(String imageUrl) {
    const uploadPath = '/image/upload/';
    if (!imageUrl.contains('res.cloudinary.com') ||
        !imageUrl.contains(uploadPath)) {
      return imageUrl;
    }
    return imageUrl.replaceFirst(
      uploadPath,
      '${uploadPath}f_auto,q_auto,w_320,h_320,c_fill/',
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        item.isLost
            ? Icons.search_off_rounded
            : Icons.check_circle_outline_rounded,
        size: 36,
        color: Theme.of(context)
                .extension<CustomColors>()
                ?.secondaryTextColor
                ?.withOpacity(0.5) ??
            const Color(0xFF8F99A8),
      ),
    );
  }
}
