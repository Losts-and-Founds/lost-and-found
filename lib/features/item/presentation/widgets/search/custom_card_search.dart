import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/constants.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../pages/item_page.dart';

class CustomCardSearch extends StatelessWidget {
  final int id;
  final String text;
  final String owner;
  final String type;
  final String token;
  final DateTime date;
  final double distance;

  const CustomCardSearch({
    super.key,
    required this.id,
    required this.text,
    required this.type,
    required this.owner,
    required this.date,
    required this.distance,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Stack(
        children: [
          Card(
            surfaceTintColor:
                Theme.of(context).extension<CustomColors>()!.background2,
            color: Theme.of(context).extension<CustomColors>()!.background2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: _SearchItemImage(itemId: id),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 18,
                    bottom: 5,
                    right: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .secondaryTextColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .metersAway(distance.toInt()),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 4,
            top: 25,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${type[0].toUpperCase()}${type.substring(1)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: -1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
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
          ),
        ],
      ),
    );
  }
}

class _SearchItemImage extends StatelessWidget {
  final int itemId;

  const _SearchItemImage({required this.itemId});

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
          return const CustomCircularProgress(size: 75);
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
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CustomCircularProgress(size: 75);
          },
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(noItemImagePath, fit: BoxFit.cover),
        );
      },
    );
  }
}
