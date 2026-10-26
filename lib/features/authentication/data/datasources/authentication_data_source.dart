import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:lost_and_found/core/status/exceptions.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/registration_usecase.dart';
import '../models/session_model.dart';

abstract class AuthenticationDataSource {
  // Register the user with the given parameters
  Future<void> register(RegistrationParams params);

  // Login the user with the given credentials
  Future<SessionModel> login(LoginParams params);

  Future<SessionModel> loginCurrentUser();
}

class AuthenticationDataSourceImpl extends AuthenticationDataSource {
  @override
  Future<SessionModel> loginCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw RecordNotFoundException();
    }

    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw RecordNotFoundException();
    }
    if (!user.emailVerified) {
      throw UserNotAuthorizedException();
    }

    final email = user.email;
    if (email == null || email.isEmpty) {
      throw UserNotAuthorizedException();
    }

    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final userData = userSnapshot.data() ?? const <String, dynamic>{};
    final username = userData['username'] as String? ??
        user.displayName ??
        email.split('@').first;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'username': username,
      'usernameLower': username.toLowerCase(),
      'email': email,
      'firstName': username,
      'emailVerified': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return SessionModel(
      token: await user.getIdToken() ?? user.uid,
      user: user.uid.hashCode.abs(),
      expire:
          DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
      username: username,
      email: email,
    );
  }

  @override
  Future<void> register(RegistrationParams params) async {
    try {
      // 1. Check if username is already taken in Firestore
      var usernameCheck = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: params.username)
          .limit(1)
          .get();

      if (usernameCheck.docs.isEmpty) {
        usernameCheck = await FirebaseFirestore.instance
            .collection('users')
            .where('firstName', isEqualTo: params.username)
            .limit(1)
            .get();
      }

      if (usernameCheck.docs.isNotEmpty) {
        throw DuplicateRecordException('username');
      }

      // 2. Create the user in Firebase Authentication
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(params.username);
        await user.sendEmailVerification();

        // 3. Create user in Firebase Chat Core first
        try {
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: params.username,
              id: user.uid,
              lastName: "",
            ),
          );
        } catch (e) {
          log("FirebaseChatCore user creation notice: $e");
        }

        // 4. Store/merge full user record in Firestore (ensuring username & email are preserved)
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': params.username,
          'usernameLower': params.username.toLowerCase(),
          'email': params.email,
          'firstName': params.username,
          'lastName': '',
          'emailVerified': false,
          'fcmToken': params.token,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException on register: ${e.code} - ${e.message}");
      if (e.code == 'email-already-in-use') {
        throw DuplicateRecordException('email');
      } else if (e.code == 'weak-password') {
        throw ValidationException();
      } else if (e.code == 'invalid-email') {
        throw ValidationException();
      } else {
        throw InternalServerException();
      }
    } on DuplicateRecordException {
      rethrow;
    } catch (e) {
      log("Error during registration: $e");
      throw InternalServerException();
    }
  }

  @override
  Future<SessionModel> login(LoginParams params) async {
    try {
      String email = params.user.trim();
      String username = params.user.trim();

      // If user provided a username instead of an email, look up the email in Firestore
      if (!email.contains('@')) {
        final lower = username.toLowerCase();
        var query = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          query = await FirebaseFirestore.instance
              .collection('users')
              .where('usernameLower', isEqualTo: lower)
              .limit(1)
              .get();
        }

        if (query.docs.isEmpty) {
          query = await FirebaseFirestore.instance
              .collection('users')
              .where('firstName', isEqualTo: username)
              .limit(1)
              .get();
        }

        if (query.docs.isEmpty) {
          // Fallback scan across all users
          final allUsers =
              await FirebaseFirestore.instance.collection('users').get();
          for (final doc in allUsers.docs) {
            final data = doc.data();
            final u = (data['username'] as String?)?.toLowerCase();
            final f = (data['firstName'] as String?)?.toLowerCase();
            final ul = (data['usernameLower'] as String?)?.toLowerCase();
            if (u == lower || f == lower || ul == lower) {
              email = (data['email'] as String?) ?? '';
              break;
            }
          }
        } else {
          final data = query.docs.first.data();
          email = (data['email'] as String?) ?? '';
        }

        if (email.isEmpty) {
          throw RecordNotFoundException();
        }
      }

      // Sign in with Firebase Authentication
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: params.password,
      );

      final user = userCredential.user!;

      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        throw UserNotAuthorizedException();
      }

      final token = await user.getIdToken() ?? user.uid;

      // Ensure username is retrieved properly
      if (username.contains('@')) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            username = (data['username'] as String?) ??
                (data['firstName'] as String?) ??
                user.displayName ??
                email.split('@').first;
          } else {
            username = user.displayName ?? email.split('@').first;
          }
        } catch (_) {
          username = user.displayName ?? email.split('@').first;
        }
      }

      // Always ensure the Firestore user doc has both fields set
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'usernameLower': username.toLowerCase(),
          'email': user.email ?? email,
          'firstName': username,
          'lastName': '',
          'emailVerified': user.emailVerified,
          if (params.token != null) 'fcmToken': params.token,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}

      // Calculate session expiration (30 days from now in ms)
      final expire =
          DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;

      return SessionModel(
        token: token,
        user: user.uid.hashCode.abs(),
        expire: expire,
        username: username,
        email: user.email ?? email,
      );
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException on login: ${e.code} - ${e.message}");
      if (e.code == 'user-not-found') {
        throw RecordNotFoundException();
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw PasswordMismatchException();
      } else if (e.code == 'user-disabled') {
        throw UserAccessForbiddenException();
      } else {
        throw UserNotAuthorizedException();
      }
    } on RecordNotFoundException {
      rethrow;
    } on UserNotAuthorizedException {
      rethrow;
    } catch (e) {
      log("Error during login: $e");
      throw InternalServerException();
    }
  }
}
