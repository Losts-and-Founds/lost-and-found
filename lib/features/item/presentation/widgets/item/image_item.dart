import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/constants.dart';

class ImageItem extends StatelessWidget {
  final int itemId;
  final String token;

  const ImageItem({Key? key, required this.itemId, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('items')
          .doc(itemId.toString())
          .get(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data?.data()?['imageUrl'] as String?;
        final backgroundColor =
            Theme.of(context).extension<CustomColors>()!.background2;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: backgroundColor,
            width: width,
            height: 300,
            child: const CustomCircularProgress(size: 150),
          );
        }

        if (!snapshot.hasData ||
            snapshot.hasError ||
            imageUrl == null ||
            imageUrl.isEmpty) {
          return Image.asset(
            noItemImagePath,
            fit: BoxFit.cover,
            width: width,
            height: 300,
          );
        }

        return InkWell(
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          child: Container(
            color: backgroundColor,
            width: width,
            height: 300,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CustomCircularProgress(size: 150);
              },
              errorBuilder: (context, error, stackTrace) => Image.asset(
                noItemImagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
