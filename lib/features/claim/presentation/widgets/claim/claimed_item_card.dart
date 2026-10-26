import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/utils/utility.dart';
import 'package:lost_and_found/features/claim/domain/entities/claim_received.dart';
import 'package:lost_and_found/features/item/domain/entities/item.dart' as item;
import 'package:lost_and_found/features/claim/presentation/bloc/claim/claim_bloc.dart';
import 'package:lost_and_found/features/claim/presentation/pages/answer_claim_screen.dart';

import '../../../../../core/domain/entities/claim_status.dart';
import '../../../../../core/presentation/widgets/custom_circular_progress.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/colors/custom_color.dart';
import '../../../../../utils/constants.dart';
import '../../../../../core/status/failures.dart';

class ClaimedItemCard extends StatelessWidget {
  final bool isItemResolved;
  final String token;
  final ClaimReceived claim;

  const ClaimedItemCard({
    super.key,
    required this.isItemResolved,
    required this.token,
    required this.claim,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClaimBloc, ClaimState>(
      builder: (ctx, state) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: claim.opened
              ? Theme.of(context).extension<CustomColors>()!.openedColor
              : Theme.of(context).extension<CustomColors>()!.notOpenedColor,
          child: InkWell(
            splashColor: !claim.opened
                ? Theme.of(context).extension<CustomColors>()!.splashGreenColor
                : Theme.of(context).extension<CustomColors>()!.splashGreyColor,
            onTap: () async {
              if (!isItemResolved) {
                ctx.read<ClaimBloc>().add(ClaimEvent.claimRead(claim.id));
                try {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  final notification = await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc('claim_${claim.id}')
                      .get();
                  if (uid != null &&
                      notification.exists &&
                      notification.data()?['recipientId'] == uid &&
                      notification.data()?['read'] != true) {
                    await notification.reference.update({
                      'read': true,
                      'readAt': FieldValue.serverTimestamp(),
                    });
                  }
                } on FirebaseException {
                  if (ctx.mounted) {
                    showBasicErrorSnackbar(ctx, const Failure.genericFailure());
                  }
                }
                if (!ctx.mounted) return;

                final updatedItem = await Navigator.push<item.Item?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnswerClaimScreen(
                      itemId: claim.item.id,
                      claimId: claim.id,
                      isClaimAlreadyManaged:
                          claim.status != ClaimStatus.pending,
                    ),
                  ),
                );

                if (updatedItem != null && context.mounted) {
                  context
                      .read<ClaimBloc>()
                      .add(ClaimEvent.receivedClaimsRefreshed(updatedItem));
                }
              } else {
                showBasicInfoSnackbar(context,
                    AppLocalizations.of(context)!.itemAlreadySolvedToast);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.3,
                  color: claim.opened
                      ? Theme.of(context)
                          .extension<CustomColors>()!
                          .borderColorOpened!
                      : Theme.of(context)
                          .extension<CustomColors>()!
                          .borderColorNotOpened!,
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              claim.item.title,
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .claimedBy(claim.user.username),
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .extension<CustomColors>()!
                                    .secondaryTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: claim.status == ClaimStatus.approved
                                    ? Theme.of(context)
                                        .extension<CustomColors>()!
                                        .claimAcceptedStatusColor
                                    : (claim.status == ClaimStatus.rejected
                                        ? Theme.of(context)
                                            .extension<CustomColors>()!
                                            .claimDeniedStatusColor
                                        : Theme.of(context)
                                            .extension<CustomColors>()!
                                            .claimWaitingStatusColor),
                              ),
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .claimStatusSpaced,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                    TextSpan(
                                      text: claim.status
                                          .getTranslatedName(context)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
      ),
    );
  }

  Widget _buildUserAvatar() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(claim.user.id.toString())
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
