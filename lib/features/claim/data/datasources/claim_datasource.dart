import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';
import 'package:lost_and_found/features/claim/data/models/claim_received/claim_received_dto.dart';
import 'package:lost_and_found/features/claim/data/models/claim_received/item_dto.dart'
    as received;
import 'package:lost_and_found/features/claim/data/models/claim_received/user_dto.dart'
    as received;
import 'package:lost_and_found/features/claim/data/models/claim_sent/claim_sent_dto.dart';
import 'package:lost_and_found/features/claim/data/models/claim_sent/item_dto.dart'
    as sent;
import 'package:lost_and_found/features/claim/domain/usecases/create_claim_usecase.dart';
import 'package:lost_and_found/features/claim/domain/usecases/manage_claim_usecase.dart';
import 'package:lost_and_found/features/item/data/models/item/category_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/claim_received_dto.dart'
    as item_claim;
import 'package:lost_and_found/features/item/data/models/item/claim_sent_dto.dart'
    as item_claim;
import 'package:lost_and_found/features/item/data/models/item/item_dto.dart'
    as item;
import 'package:lost_and_found/features/item/data/models/item/position_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/user_dto.dart'
    as item_user;

abstract class ClaimDataSource {
  Future<List<ClaimReceivedDto>> getReceivedClaims(NoParams params);
  Future<List<ClaimSentDto>> getSentClaims(NoParams params);
  Future<item.ItemDto> createClaim(CreateClaimParams params);
  Future<item.ItemDto> manageClaim(ManageClaimParams params);
}

class ClaimDataSourceImpl implements ClaimDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ClaimDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<List<ClaimReceivedDto>> getReceivedClaims(NoParams params) async {
    final user = _requireUser();
    final snapshot = await _firestore
        .collection('claims')
        .where('itemOwnerId', isEqualTo: user.uid)
        .get();
    final claims = <ClaimReceivedDto>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final itemId = data['itemId'] as int;
      final claimantId = data['claimantId'] as String;
      final itemDoc =
          await _firestore.collection('items').doc(itemId.toString()).get();
      final claimantDoc =
          await _firestore.collection('users').doc(claimantId).get();
      final itemData = itemDoc.data();
      final claimantData = claimantDoc.data();
      if (!itemDoc.exists || itemData == null || claimantData == null) {
        throw StateError('Claim ${doc.id} has a missing item or claimant.');
      }

      claims.add(ClaimReceivedDto(
        id: data['id'] as int,
        item: received.ItemDto(
          id: itemId,
          title: itemData['title'] as String? ?? '',
        ),
        user: received.UserDto(
          id: _numericUserId(claimantId),
          username: _username(claimantData),
          image: _imageUrl(claimantData) != null,
          uid: claimantId,
        ),
        status: _legacyStatus(data['status'] as String?),
        date: _date(data['createdAt']),
        answer: data['message'] as String?,
      ));
    }
    return claims;
  }

  @override
  Future<List<ClaimSentDto>> getSentClaims(NoParams params) async {
    final user = _requireUser();
    final snapshot = await _firestore
        .collection('claims')
        .where('claimantId', isEqualTo: user.uid)
        .get();
    final claims = <ClaimSentDto>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final itemId = data['itemId'] as int;
      final itemDoc =
          await _firestore.collection('items').doc(itemId.toString()).get();
      final itemData = itemDoc.data();
      if (!itemDoc.exists || itemData == null) {
        throw StateError('Claim ${doc.id} references a missing item.');
      }

      claims.add(ClaimSentDto(
        id: data['id'] as int,
        status: _legacyStatus(data['status'] as String?),
        item: sent.ItemDto(
          id: itemId,
          title: itemData['title'] as String? ?? '',
          image: _imageUrl(itemData) != null,
        ),
        answer: data['message'] as String?,
        date: _date(data['createdAt']),
      ));
    }
    return claims;
  }

  @override
  Future<item.ItemDto> createClaim(CreateClaimParams params) async {
    final user = _requireUser();
    final itemRef =
        _firestore.collection('items').doc(params.itemId.toString());
    final itemSnapshot = await itemRef.get();
    final itemData = itemSnapshot.data();
    if (!itemSnapshot.exists || itemData == null) {
      throw StateError('Cannot claim an item that does not exist.');
    }

    final ownerId = itemData['ownerId'] as String?;
    if (ownerId == null || ownerId == user.uid) {
      throw StateError('You cannot claim an item that you own.');
    }

    final existingClaim = await _firestore
        .collection('claims')
        .where('itemId', isEqualTo: params.itemId)
        .where('claimantId', isEqualTo: user.uid)
        .limit(1)
        .get();
    if (existingClaim.docs.isNotEmpty) {
      throw StateError('You have already submitted a claim for this item.');
    }

    final counterRef = _firestore.collection('counters').doc('claims');
    await _firestore.runTransaction<void>((transaction) async {
      final counterSnapshot = await transaction.get(counterRef);
      final claimId = (counterSnapshot.data()?['value'] as int? ?? 0) + 1;
      final claimRef = _firestore.collection('claims').doc(claimId.toString());
      final notificationRef =
          _firestore.collection('notifications').doc('claim_$claimId');
      final claimantSnapshot =
          await transaction.get(_firestore.collection('users').doc(user.uid));
      final claimant = claimantSnapshot.data() ?? const <String, dynamic>{};
      final claimantName = _username(claimant);

      transaction.set(counterRef, {'value': claimId});
      transaction.set(claimRef, {
        'id': claimId,
        'itemId': params.itemId,
        'itemOwnerId': ownerId,
        'claimantId': user.uid,
        'message': params.answer,
        'proofImageUrls': <String>[],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'decisionAt': null,
      });
      transaction.set(notificationRef, {
        'recipientId': ownerId,
        'type': 'new_claim',
        'title': '$claimantName submitted an ownership claim',
        'body': params.answer,
        'senderId': user.uid,
        'senderName': claimantName,
        'itemId': params.itemId,
        'claimId': claimId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
    return _loadItem(params.itemId);
  }

  @override
  Future<item.ItemDto> manageClaim(ManageClaimParams params) async {
    final user = _requireUser();
    final itemRef =
        _firestore.collection('items').doc(params.itemId.toString());
    final itemSnapshot = await itemRef.get();
    final itemData = itemSnapshot.data();
    if (!itemSnapshot.exists || itemData == null) {
      throw StateError('Cannot manage a claim for a missing item.');
    }
    if (itemData['ownerId'] != user.uid) {
      throw StateError('Only the item owner can decide a claim.');
    }

    final claimRef =
        _firestore.collection('claims').doc(params.claimId.toString());
    final claimSnapshot = await claimRef.get();
    final claimData = claimSnapshot.data();
    if (!claimSnapshot.exists ||
        claimData == null ||
        claimData['itemId'] != params.itemId) {
      throw StateError('The claim does not belong to this item.');
    }

    final status =
        params.status.name == 'approved' ? 'accepted' : params.status.name;
    final claimantId = claimData['claimantId'] as String?;
    if (claimantId == null) {
      throw StateError('The claim has no claimant ID.');
    }

    final ownerSnapshot =
        await _firestore.collection('users').doc(user.uid).get();
    final itemTitle = itemData['title'] as String? ?? 'your item';
    final notificationRef = _firestore
        .collection('notifications')
        .doc('claim_${params.claimId}_decision');
    final batch = _firestore.batch();
    batch.update(claimRef, {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'decisionAt': FieldValue.serverTimestamp(),
    });
    if (status == 'accepted') {
      batch.update(itemRef, {
        'status': 'claimed',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    batch.set(notificationRef, {
      'recipientId': claimantId,
      'type': 'claim_update',
      'title':
          'Your claim was ${status == 'accepted' ? 'approved' : 'rejected'}',
      'body': 'The owner reviewed your claim for "$itemTitle".',
      'senderId': user.uid,
      'senderName': _username(ownerSnapshot.data() ?? const {}),
      'itemId': params.itemId,
      'claimId': params.claimId,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
    return _loadItem(params.itemId);
  }

  Future<item.ItemDto> _loadItem(int itemId) async {
    final user = _requireUser();
    final itemSnapshot =
        await _firestore.collection('items').doc(itemId.toString()).get();
    final data = itemSnapshot.data();
    if (!itemSnapshot.exists || data == null) {
      throw StateError('Item $itemId does not exist.');
    }

    final ownerId = data['ownerId'] as String?;
    if (ownerId == null) {
      throw StateError('Item $itemId has no owner.');
    }
    final ownerSnapshot =
        await _firestore.collection('users').doc(ownerId).get();
    final owner = ownerSnapshot.data();
    if (owner == null) {
      throw StateError('Item $itemId has no owner profile.');
    }
    final location = data['location'] as Map<String, dynamic>? ?? const {};
    final position = PositionDto(
      X: (location['latitude'] as num?)?.toDouble() ?? 0,
      Y: (location['longitude'] as num?)?.toDouble() ?? 0,
    );

    final claimSnapshot = await _firestore
        .collection('claims')
        .where('itemId', isEqualTo: itemId)
        .get();
    final receivedClaims = <item_claim.ClaimReceivedDto>[];
    item_claim.ClaimSentDto? userClaim;
    for (final doc in claimSnapshot.docs) {
      final claim = doc.data();
      final claimantId = claim['claimantId'] as String;
      final claimantSnapshot =
          await _firestore.collection('users').doc(claimantId).get();
      final claimant = claimantSnapshot.data();
      if (claimant == null) {
        throw StateError('Claim ${doc.id} has no claimant profile.');
      }
      final claimId = claim['id'] as int;
      final claimStatus = _legacyStatus(claim['status'] as String?);
      final answer = claim['message'] as String? ?? '';
      final date = _date(claim['createdAt']);
      receivedClaims.add(item_claim.ClaimReceivedDto(
        id: claimId,
        user: received.UserDto(
          id: _numericUserId(claimantId),
          username: _username(claimant),
          image: _imageUrl(claimant) != null,
          uid: claimantId,
        ),
        status: claimStatus,
        answer: answer,
        date: date,
      ));
      if (claimantId == user.uid) {
        userClaim = item_claim.ClaimSentDto(
          id: claimId,
          status: claimStatus,
          answer: answer,
          date: date,
        );
      }
    }

    final categoryId = (data['categoryId'] as num?)?.toInt() ?? 0;
    final category = _category(categoryId);
    final createdAt =
        _date(data['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
    return item.ItemDto(
      id: itemId,
      resolved: data['status'] == 'resolved',
      title: data['title'] as String? ?? '',
      type: data['status'] as String? ?? 'found',
      address: location['label'] as String? ?? '',
      image: _imageUrl(data) != null,
      date: createdAt,
      user: item_user.UserDto(
        id: _numericUserId(ownerId),
        username: _username(owner),
        image: _imageUrl(owner) != null,
      ),
      category: category,
      question: data['question'] as String?,
      position: position,
      claims: receivedClaims,
      userClaim: userClaim,
    );
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required for claims.');
    }
    return user;
  }

  static int _numericUserId(String uid) => uid.hashCode.abs();

  static String _username(Map<String, dynamic> data) =>
      data['username'] as String? ??
      data['displayName'] as String? ??
      data['firstName'] as String? ??
      data['email'] as String? ??
      'User';

  static String? _imageUrl(Map<String, dynamic> data) =>
      data['photoUrl'] as String? ?? data['imageUrl'] as String?;

  static DateTime? _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static String _legacyStatus(String? value) {
    switch (value) {
      case 'accepted':
        return 'approved';
      case 'rejected':
        return 'rejected';
      default:
        return 'pending';
    }
  }

  static CategoryDto _category(int id) {
    const categories = {
      1: CategoryDto(
          id: 1,
          name: 'Electronics',
          description: 'Phones, Laptops, Gadgets',
          icon: 57790),
      2: CategoryDto(
          id: 2,
          name: 'Documents',
          description: 'IDs, Passports, Cards',
          icon: 57747),
      3: CategoryDto(
          id: 3,
          name: 'Keys',
          description: 'House, Car, Locker keys',
          icon: 62426),
      4: CategoryDto(
          id: 4,
          name: 'Clothing',
          description: 'Jackets, Hats, Scarves',
          icon: 58943),
      5: CategoryDto(
          id: 5,
          name: 'Bags',
          description: 'Backpacks, Wallets, Purses',
          icon: 57544),
      6: CategoryDto(
          id: 6,
          name: 'Other',
          description: 'Miscellaneous items',
          icon: 58826),
    };
    return categories[id] ??
        CategoryDto(
            id: id,
            name: 'Other',
            description: 'Miscellaneous items',
            icon: 58826);
  }
}
