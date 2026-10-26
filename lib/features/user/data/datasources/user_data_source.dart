import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found/core/data/datasources/cloudinary_image_service.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';
import 'package:lost_and_found/features/user/data/datasources/user_client.dart';
import 'package:lost_and_found/features/user/domain/usecases/update_locale_usecase.dart';
import 'package:lost_and_found/features/user/domain/usecases/update_password_usecase.dart';
import 'package:lost_and_found/features/user/domain/usecases/upload_user_image_usecase.dart';

import '../models/get_user/user_dto.dart';

abstract class UserDataSource {
  Future<UserDto> getUserInfo(NoParams params, int userId);
  Future<void> uploadUserImage(UploadUserImageParams params);
  Future<void> updatePassword(UpdatePasswordParams params);
  Future<void> updateLocale(UpdateLocaleParams params);
}

class UserDataSourceImpl implements UserDataSource {
  final CloudinaryImageService _imageService;

  UserDataSourceImpl({CloudinaryImageService? imageService})
      : _imageService = imageService ?? CloudinaryImageService();

  @override
  Future<UserDto> getUserInfo(NoParams params, int userId) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) {
      throw StateError('A signed-in user is required to load the profile.');
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(current.uid).get();
    final data = doc.data() ?? const <String, dynamic>{};
    final username = data['username'] as String? ??
        data['displayName'] as String? ??
        current.displayName ??
        current.email?.split('@').first ??
        'User';
    final imageUrl = data['photoUrl'] as String? ?? data['imageUrl'] as String?;

    return UserDto(
      id: userId,
      username: username,
      image: imageUrl != null && imageUrl.isNotEmpty,
    );
  }

  @override
  Future<void> uploadUserImage(UploadUserImageParams params) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) {
      throw StateError('A signed-in user is required to upload a profile image.');
    }

    final imageUrl = await _imageService.upload(params.image);
    await FirebaseFirestore.instance.collection('users').doc(current.uid).set({
      'photoUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updatePassword(UpdatePasswordParams params) async {
    final current = FirebaseAuth.instance.currentUser;
    final email = current?.email;
    if (current == null || email == null) {
      throw StateError('A signed-in email user is required to change the password.');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: params.oldPassword,
    );
    await current.reauthenticateWithCredential(credential);
    await current.updatePassword(params.newPassword);
  }

  @override
  Future<void> updateLocale(UpdateLocaleParams params) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) {
      throw StateError('A signed-in user is required to update the locale.');
    }

    await FirebaseFirestore.instance.collection('users').doc(current.uid).set({
      'locale': params.locale,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
