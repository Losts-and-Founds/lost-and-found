import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/utils/constants.dart';

import '../../../../../core/domain/entities/claim_status.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/colors/custom_color.dart';

class ClaimedItemCard extends StatelessWidget {
  final int userId;
  final String username;
  final bool opened;
  final String token;
  final ClaimStatus status;
  final VoidCallback onTap;

  const ClaimedItemCard({
    super.key,
    required this.userId,
    required this.username,
    required this.opened,
    required this.token,
    required this.onTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: opened
            ? Theme.of(context).extension<CustomColors>()!.openedColor
            : Theme.of(context).extension<CustomColors>()!.notOpenedColor,
        child: InkWell(
          splashColor: opened
              ? Theme.of(context).extension<CustomColors>()!.splashGreyColor
              : Theme.of(context).extension<CustomColors>()!.splashGreenColor,
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0.3,
                color: opened
                    ? Theme.of(context).extension<CustomColors>()!.borderColorOpened!
                    : Theme.of(context).extension<CustomColors>()!.borderColorNotOpened!,
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildUserAvatar(),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.claimedBy(username),
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: status == ClaimStatus.approved
                                  ? Theme.of(context).extension<CustomColors>()!.claimAcceptedStatusColor
                                  : (status == ClaimStatus.rejected
                                      ? Theme.of(context).extension<CustomColors>()!.claimDeniedStatusColor
                                      : Theme.of(context).extension<CustomColors>()!.claimWaitingStatusColor),
                            ),
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.claimStatusSpaced,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: status.getTranslatedName(context).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId.toString())
          .get(),
      builder: (context, snapshot) {
        final imageUrl = (snapshot.data?.data()?['photoUrl'] as String? ??
                snapshot.data?.data()?['imageUrl'] as String?) ??
            '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress(size: 35);
        }

        if (!snapshot.hasData || snapshot.hasError || imageUrl.isEmpty) {
          return Image.asset(noUserImagePath, fit: BoxFit.cover);
        }

        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CustomCircularProgress(size: 35);
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(
            noUserImagePath,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
