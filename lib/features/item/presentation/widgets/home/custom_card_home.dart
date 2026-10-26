import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/utils/constants.dart';
import 'package:lost_and_found/utils/screen_size.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/colors/custom_color.dart';

class CustomCardHome extends StatelessWidget {
  final int id;
  final String text;
  final int claims;
  final int approvedClaims;
  final String token;
  final bool hasAdditionalInfo;

  const CustomCardHome({
    super.key,
    required this.id,
    required this.text,
    required this.claims,
    required this.token,
    required this.approvedClaims,
    required this.hasAdditionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = ScreenSize.isBigSmartphoneDevice(context)
        ? 150.0
        : ScreenSize.isMediumSmartphoneDevice(context)
            ? 130.0
            : 100.0;
    final colors = Theme.of(context).extension<CustomColors>()!;

    return SizedBox(
      width: ScreenSize.isBigSmartphoneDevice(context)
          ? 165
          : ScreenSize.isMediumSmartphoneDevice(context)
              ? 150
              : 130,
      child: Stack(
        children: [
          Card(
            surfaceTintColor: colors.background2,
            color: colors.background2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: imageSize,
                        width: imageSize,
                        child: FutureBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection('items')
                              .doc(id.toString())
                              .get(),
                          builder: (context, snapshot) {
                            final imageUrl =
                                snapshot.data?.data()?['imageUrl'] as String?;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CustomCircularProgress(size: 75);
                            }
                            if (!snapshot.hasData ||
                                snapshot.hasError ||
                                imageUrl == null ||
                                imageUrl.isEmpty) {
                              return Image.asset(
                                noItemImagePath,
                                fit: BoxFit.cover,
                              );
                            }
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const CustomCircularProgress(size: 75);
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                noItemImagePath,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          fontSize: ScreenSize.isBigSmartphoneDevice(context)
                              ? 18
                              : ScreenSize.isMediumSmartphoneDevice(context)
                                  ? 16
                                  : 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      if (claims > 0)
                        _ClaimBadge(
                          color: colors.nClaimsColor!,
                          label:
                              AppLocalizations.of(context)!.openClaims(claims),
                        )
                      else if (approvedClaims > 0)
                        _ClaimBadge(
                          color: colors.claimAcceptedStatusColor!,
                          label: AppLocalizations.of(context)!.resolved,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: colors.splashGreyColor!.withValues(alpha: 0.3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemScreen(itemId: id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _ClaimBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.connect_without_contact, size: 14),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    label,
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
