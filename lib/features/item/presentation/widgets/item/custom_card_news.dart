import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/constants.dart';

import '../../pages/item_page.dart';

class CustomCardNews extends StatelessWidget {
  final int id;
  final String title;
  final String token;
  final String? imageUrl;

  const CustomCardNews({
    super.key,
    required this.id,
    required this.title,
    required this.token,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 145,
      child: Stack(
        children: [
          Card(
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            color: Theme.of(context).colorScheme.surface,
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
                      child: imageUrl == null || imageUrl!.isEmpty
                          ? Image.asset(
                              noItemImagePath,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                noItemImagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
