import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/create_room_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/delete_rooms_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/get_room_messages_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/read_chat_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/registration_chat_usecase.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lost_and_found/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/update_item_title_room_usecase.dart';

abstract class ChatDataSource {
  Future<void> register(RegistrationChatParams params);

  Future<void> login(String email, String password);

  Stream<List<Room>> getUserRooms();

  Future<Room> createRoom(CreateRoomParams params);

  Future<Pair<Room, Stream<List<Message>>>> getRoomMessages(
      GetRoomMessagesParams params);

  Future<void> sendMessage(SendMessageParams params);

  Future<void> readChat(ReadChatParams params);

  Future<void> deleteRooms(DeleteRoomsParams params);

  Future<void> updateItemTitleRoom(UpdateItemTitleRoomParams params);

  Future<void> logout(NoParams params);
}

class ChatDataSourceImpl implements ChatDataSource {
  ChatDataSourceImpl();

  @override
  Future<void> register(RegistrationChatParams params) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError(
          'A signed-in Firebase user is required to register chat.');
    }

    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection('users')
        .doc(uid)
        .set({
      'uid': uid,
      'username': params.username,
      'email': params.email,
      'firstName': params.username,
      'lastName': '',
    }, SetOptions(merge: true));
  }

  @override
  Future<void> login(String email, String password) async {
    if (FirebaseAuth.instance.currentUser == null ||
        FirebaseAuth.instance.currentUser?.email != email) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  @override
  Future<void> logout(NoParams params) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Stream<List<Room>> getUserRooms() {
    return FirebaseChatCore.instance.rooms();
  }

  @override
  Future<Room> createRoom(CreateRoomParams params) async {
    if (FirebaseAuth.instance.currentUser?.uid != params.userUid1 ||
        params.userUid2.isEmpty) {
      throw StateError(
          'Both chat participants must have valid Firebase user IDs.');
    }

    final firestore = FirebaseChatCore.instance.getFirebaseFirestore();
    final userRooms = await firestore
        .collection('rooms')
        .where('userIds', arrayContains: params.userUid1)
        .get();

    for (final doc in userRooms.docs) {
      final data = doc.data();
      final metadata = data['metadata'] as Map<String, dynamic>?;
      final userIds =
          (data['userIds'] as List<dynamic>? ?? const []).whereType<String>();
      if (metadata?['item'] == params.itemId &&
          userIds.contains(params.userUid2)) {
        return await FirebaseChatCore.instance.room(doc.id).first;
      }
    }

    return await FirebaseChatCore.instance.createGroupRoom(
      name: params.itemName,
      users: [
        types.User(id: params.userUid2, firstName: params.username2),
      ],
      metadata: {
        "id1": params.id1,
        "id2": params.id2,
        "uid1": params.userUid1,
        "uid2": params.userUid2,
        "username1": params.username1,
        "username2": params.username2,
        "item": params.itemId,
        "title": params.itemName,
        "active": false,
        "lastMessage": null,
        "lastMessageId": null,
        "last-${params.userUid1}": null,
        "last-${params.userUid2}": null,
        "unread-${params.userUid1}": 0,
        "unread-${params.userUid2}": 0,
      },
    );
  }

  @override
  Future<Pair<Room, Stream<List<Message>>>> getRoomMessages(
      GetRoomMessagesParams params) async {
    final room = await FirebaseChatCore.instance.room(params.roomId).first;
    return Pair(room, FirebaseChatCore.instance.messages(room));
  }

  @override
  Future<void> sendMessage(SendMessageParams params) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != params.senderId) {
      throw StateError(
          'The sender must be the currently signed-in Firebase user.');
    }

    final firestore = FirebaseChatCore.instance.getFirebaseFirestore();
    final roomRef = firestore.collection('rooms').doc(params.roomId);
    final roomSnapshot = await roomRef.get();
    final roomData = roomSnapshot.data();
    if (roomData == null) {
      throw StateError('The conversation no longer exists.');
    }
    final participantIds =
        (roomData['userIds'] as List<dynamic>? ?? const []).whereType<String>();
    if (!participantIds.contains(currentUser.uid)) {
      throw StateError(
          'The signed-in user is not a participant in this conversation.');
    }

    final messageRef = roomRef.collection('messages').doc();
    final message = types.TextMessage.fromPartial(
      author: types.User(id: currentUser.uid),
      id: messageRef.id,
      partialText: params.message,
    );
    final messageData = message.toJson()
      ..remove('author')
      ..remove('id')
      ..['authorId'] = currentUser.uid
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();

    final batch = firestore.batch();
    batch.set(messageRef, messageData);
    final metadata = roomData['metadata'] as Map<String, dynamic>? ?? const {};
    final itemId = metadata['item'];
    final recipients =
        participantIds.where((id) => id != currentUser.uid).toList();
    final roomUpdate = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
      'metadata.active': true,
      'metadata.lastMessage': params.message.text,
      'metadata.lastMessageId': messageRef.id,
      'metadata.last-${currentUser.uid}': messageRef.id,
      for (final recipientId in recipients)
        'metadata.unread-$recipientId': FieldValue.increment(1),
    };
    batch.update(roomRef, roomUpdate);
    final senderSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    final senderData = senderSnapshot.data() ?? const <String, dynamic>{};
    final senderName = senderData['username'] as String? ??
        senderData['displayName'] as String? ??
        currentUser.displayName ??
        'Someone';
    for (final recipientId in recipients) {
      final notificationRef = firestore.collection('notifications').doc(
            '${params.roomId}_${messageRef.id}_$recipientId',
          );
      batch.set(notificationRef, {
        'recipientId': recipientId,
        'type': 'message',
        'title': 'New message from $senderName',
        'body': params.message.text,
        'senderId': currentUser.uid,
        'senderName': senderName,
        'roomId': params.roomId,
        'itemId': itemId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  @override
  Future<void> readChat(ReadChatParams params) async {
    final messages = (await FirebaseChatCore.instance
            .getFirebaseFirestore()
            .collection("rooms/${params.roomId}/messages")
            .orderBy("createdAt", descending: true)
            .limit(1)
            .get())
        .docs;

    final firestore = FirebaseChatCore.instance.getFirebaseFirestore();
    final batch = firestore.batch();
    final roomUpdate = <String, dynamic>{
      'metadata.unread-${params.currentId}': 0,
    };
    if (messages.isNotEmpty) {
      roomUpdate['metadata.last-${params.currentId}'] = messages.first.id;
    }
    batch.update(firestore.collection('rooms').doc(params.roomId), roomUpdate);
    final unreadNotifications = await firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: params.currentId)
        .where('roomId', isEqualTo: params.roomId)
        .where('read', isEqualTo: false)
        .get();
    for (final notification in unreadNotifications.docs) {
      batch.update(notification.reference, {
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  @override
  Future<void> deleteRooms(DeleteRoomsParams params) async {
    final roomsToDelete = (await FirebaseChatCore.instance
            .getFirebaseFirestore()
            .collection("rooms")
            .where("metadata.item", isEqualTo: params.itemId)
            .get())
        .docs;

    for (var element in roomsToDelete) {
      await element.reference.delete();
    }
  }

  @override
  Future<void> updateItemTitleRoom(UpdateItemTitleRoomParams params) async {
    final roomsToUpdate = (await FirebaseChatCore.instance
            .getFirebaseFirestore()
            .collection("rooms")
            .where("metadata.item", isEqualTo: params.itemId)
            .get())
        .docs;

    for (var element in roomsToUpdate) {
      await element.reference.update({"metadata.title": params.newItemName});
    }
  }
}
