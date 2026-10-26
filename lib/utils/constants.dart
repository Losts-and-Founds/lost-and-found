import 'package:flutter/material.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs
// Legacy backend removed in favor of Firebase Auth + Firestore + Cloudinary.
// The old REST base URL has intentionally been retired.

// Types of Push Notifications
enum NotificationType {
  item,
  newClaim,
  sentClaim,
  chat
}

enum ImagePick {
  user,
  insertItem,
  updateItem,
  nothing
}

// Global Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

// Images
const noUserImagePath = "assets/images/no-user.jpg";
const noItemImagePath = "assets/images/no-item.png";
