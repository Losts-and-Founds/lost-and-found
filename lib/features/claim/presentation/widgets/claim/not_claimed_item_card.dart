import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/utils/utility.dart';

import '../../../../../core/presentation/widgets/custom_circular_progress.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/colors/custom_color.dart';
import '../../../../../utils/constants.dart';

class NotClaimedItemCard extends StatelessWidget {
  final bool isItemSolved;
  final int itemId;
  final String itemName;
  final String token;

  const NotClaimedItemCard({
    required this.isItemSolved,
    required this.itemId,
    required this.itemName,
    required this.token,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Theme.of(context).extension<CustomColors>()!.openedColor,
        child: InkWell(
          splashColor:
              Theme.of(context).extension<CustomColors>()!.splashGreyColor,
          onTap: () {
            if (!isItemSolved) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemScreen(itemId: itemId),
                ),
              );
            } else {
              showBasicInfoSnackbar(
                context,
                AppLocalizations.of(context)!.itemAlreadySolvedToast,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context)
                    .extension<CustomColors>()!
                    .borderColorOpened!,
                width: 0.3,
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
                    child: _ItemImage(itemId: itemId),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              itemName,
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final int itemId;

  const _ItemImage({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('items')
          .doc(itemId.toString())
          .get(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data?.data()?['imageUrl'] as String?;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress(size: 35);
        }
        if (!snapshot.hasData ||
            snapshot.hasError ||
            imageUrl == null ||
            imageUrl.isEmpty) {
          return Image.asset(noItemImagePath, fit: BoxFit.cover);
        }
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(noItemImagePath, fit: BoxFit.cover),
        );
      },
    );
  }
}
