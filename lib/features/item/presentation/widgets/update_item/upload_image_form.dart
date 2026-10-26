import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/custom_circular_progress.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/colors/custom_color.dart';
import '../../../../../utils/constants.dart';

class UploadImageForm extends StatelessWidget {
  final int itemId;
  final String token;
  final VoidCallback onSelectUploadMethod;
  final VoidCallback onDeletePhoto;
  final String? imagePath;
  final bool hasDeletedOriginalImage;

  const UploadImageForm({
    super.key,
    required this.itemId,
    required this.token,
    required this.onSelectUploadMethod,
    required this.onDeletePhoto,
    required this.imagePath,
    required this.hasDeletedOriginalImage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>()!;
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            color: colors.background2,
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: imagePath != null
                ? Image.file(File(imagePath!), fit: BoxFit.cover)
                : hasDeletedOriginalImage
                    ? _buildUploadButton(context)
                    : _buildOriginalImage(),
          ),
          if (imagePath != null || !hasDeletedOriginalImage)
            Positioned(
              right: 16,
              bottom: 10,
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: onDeletePhoto,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOriginalImage() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('items')
          .doc(itemId.toString())
          .get(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data?.data()?['imageUrl'] as String?;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress(size: 150);
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
            return const CustomCircularProgress(size: 150);
          },
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(noItemImagePath, fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onSelectUploadMethod,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          backgroundColor:
              Theme.of(context).extension<CustomColors>()!.background2,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(20),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 0.4,
          ),
          elevation: 0,
        ),
        child: Text(
          AppLocalizations.of(context)!.uploadImageButton,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
