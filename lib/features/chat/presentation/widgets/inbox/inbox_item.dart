import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/widgets/circular_image_avatar.dart';
import 'package:lost_and_found/utils/constants.dart';

import '../../../../../core/presentation/widgets/custom_circular_progress.dart';
import '../../../../../utils/colors/custom_color.dart';

class InboxItem extends StatelessWidget {
  final int otherUserId;
  final String token;
  final String roomName;
  final String lastMessage;
  final bool opened;
  final int itemId;
  final String itemTitle;
  final VoidCallback onTap;

  const InboxItem({
    super.key,
    required this.otherUserId,
    required this.token,
    required this.roomName,
    required this.lastMessage,
    required this.opened,
    required this.onTap,
    required this.itemId,
    required this.itemTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: !opened
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).extension<CustomColors>()!.background2,
      child: InkWell(
        onTap: onTap,
        splashColor: !opened
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context)
                .extension<CustomColors>()!
                .splashGreyColor!
                .withOpacity(0.4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            _buildUserAvatar(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      roomName,
                                      style: const TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      lastMessage,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .extension<CustomColors>()!
                                              .secondaryTextColor),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildItemThumbnail(),
                          ),
                        ),
                        Text(
                          itemTitle,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .extension<CustomColors>()!
                                  .secondaryTextColor,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId.toString())
          .get(),
      builder: (context, snapshot) {
        final userData = snapshot.data?.data();
        final imageUrl = (userData?['photoUrl'] as String? ??
                userData?['imageUrl'] as String?) ??
            '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress(size: 25);
        }

        return CircularImage(
          token: token,
          imageUrl: imageUrl,
          radius: 25,
          errorImage: noUserImagePath,
        );
      },
    );
  }

  Widget _buildItemThumbnail() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('items')
          .doc(itemId.toString())
          .get(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data?.data()?['imageUrl'] as String? ?? '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress(size: 25);
        }

        if (!snapshot.hasData || snapshot.hasError || imageUrl.isEmpty) {
          return Image.asset(noItemImagePath, fit: BoxFit.cover);
        }

        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CustomCircularProgress(size: 25);
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(
            noItemImagePath,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
