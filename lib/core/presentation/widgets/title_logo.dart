import 'package:flutter/material.dart';
import 'package:lost_and_found/core/presentation/widgets/brand_logo.dart';

Widget titleLogoVertical() {
  return const BrandLogo(
    vertical: true,
    iconSize: 72,
    fontSize: 34,
    showSubtitle: false,
  );
}

Widget titleLogoHorizontal(BuildContext context) {
  return const BrandLogo(
    vertical: false,
    iconSize: 52,
    fontSize: 28,
    showSubtitle: false,
  );
}
