import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String token;
  final String imageUrl;
  final double radius;
  final String errorImage;

  const CircularImage({
    super.key,
    required this.token,
    required this.imageUrl,
    required this.errorImage,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('data:image') ||
          (imageUrl.length > 200 && !imageUrl.startsWith('http') && !imageUrl.startsWith('/'))) {
        try {
          final clean = imageUrl.contains(',') ? imageUrl.split(',').last : imageUrl;
          imageProvider = MemoryImage(base64Decode(clean));
        } catch (_) {}
      } else if (!imageUrl.startsWith('http')) {
        try {
          final file = File(imageUrl);
          if (file.existsSync()) {
            imageProvider = FileImage(file);
          }
        } catch (_) {}
      } else if (imageUrl.startsWith('http') && !imageUrl.contains('13.53.123.54')) {
        imageProvider = NetworkImage(
          imageUrl,
          headers: token.isNotEmpty ? {"Authorization": "Bearer $token"} : null,
        );
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(errorImage),
      foregroundImage: imageProvider,
      onForegroundImageError: imageProvider != null ? (_, __) {} : null,
    );
  }
}
