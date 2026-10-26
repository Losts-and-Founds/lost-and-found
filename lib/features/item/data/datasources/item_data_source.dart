import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lost_and_found/core/data/datasources/cloudinary_image_service.dart';
import 'package:lost_and_found/features/item/data/models/insert_item/item_response_dto.dart';
import 'package:lost_and_found/features/item/data/models/user_item/user_item_dto.dart';
import 'package:lost_and_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/get_item_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/get_user_items_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/upload_item_image_usecase.dart';
import 'package:lost_and_found/features/claim/data/models/claim_received/user_dto.dart'
    as claim_user;

import '../../../../core/domain/usecases/usecase.dart';
import '../../domain/usecases/delete_item_image_usecase.dart';
import '../../domain/usecases/search_items_usecase.dart';
import '../../domain/usecases/solve_item_usecase.dart';
import '../models/item/category_dto.dart';
import '../models/item/claim_received_dto.dart' as item_claim;
import '../models/item/item_dto.dart';
import '../models/item/position_dto.dart';
import '../models/item/user_dto.dart';
import '../models/news/news_dto.dart';
import '../models/search_item/search_item_dto.dart';
import '../models/search_item/user_dto.dart' as search_user;

abstract class ItemDataSource {
  Future<List<UserItemDto>> getUserItems(GetUserItemsParams params);
  Future<List<NewsDto>> getUserNotifications(NoParams params);
  Future<List<SearchItemDto>> searchItems(SearchItemsParams params);
  Future<ItemDto> getItem(GetItemParams params);
  Future<ItemResponseDto> createItem(CreateItemParams params);
  Future<void> uploadItemImage(UploadItemImageParams params);
  Future<void> solveItem(SolveItemParams params);
  Future<void> deleteItem(DeleteItemParams params);
  Future<void> updateItem(UpdateItemParams params);
  Future<void> deleteItemImage(DeleteItemImageParams params);
}

class ItemDataSourceImpl implements ItemDataSource {
  final CloudinaryImageService _imageService;

  ItemDataSourceImpl({CloudinaryImageService? imageService})
      : _imageService = imageService ?? CloudinaryImageService();

  @override
  Future<List<UserItemDto>> getUserItems(GetUserItemsParams params) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('status', isEqualTo: params.type.name)
        .get();

    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      final location = data['location'] as Map<String, dynamic>?;
      final timestamp = data['createdAt'];
      return UserItemDto(
        id: int.tryParse(doc.id) ?? 0,
        title: data['title'] as String? ?? '',
        claims: 0,
        approvedClaims: 0,
        image: (data['imageUrl'] as String?)?.isNotEmpty == true,
        imageUrl: data['imageUrl'] as String?,
        location: location?['label'] as String?,
        categoryId: _asInt(data['categoryId']),
        createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
      );
    }).toList();

    items.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return items;
  }

  @override
  Future<List<NewsDto>> getUserNotifications(NoParams params) async {
    return const [];
  }

  @override
  Future<List<SearchItemDto>> searchItems(SearchItemsParams params) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('status', isEqualTo: params.type.name)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return SearchItemDto(
        id: int.tryParse(doc.id) ?? 0,
        title: data['title'] as String? ?? '',
        type: params.type.name,
        image: (data['imageUrl'] as String?)?.isNotEmpty == true,
        user: search_user.UserDto(id: 0, username: ''),
        date: DateTime.now(),
        distance: 0,
      );
    }).toList();
  }

  @override
  Future<ItemDto> getItem(GetItemParams params) async {
    final doc = await FirebaseFirestore.instance
        .collection('items')
        .doc(params.id.toString())
        .get();
    final data = doc.data();
    if (data == null) {
      throw StateError('Item not found.');
    }

    final location = data['location'] as Map<String, dynamic>?;
    var latitude = _asDouble(location?['latitude']);
    var longitude = _asDouble(location?['longitude']);
    final storedLocation = location?['label'] as String?;
    final coordinateParts = _coordinateParts(storedLocation);
    if (coordinateParts != null) {
      // Older item creation stored longitude/latitude in the opposite fields.
      longitude = coordinateParts[0];
      latitude = coordinateParts[1];
    }
    final categoryId = _asInt(data['categoryId']);
    final ownerId = data['ownerId'] as String?;
    final ownerSnapshot = ownerId == null
        ? null
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(ownerId)
            .get();
    final ownerData = ownerSnapshot?.data() ?? const <String, dynamic>{};
    final claims = <item_claim.ClaimReceivedDto>[];
    if (ownerId != null && ownerId == FirebaseAuth.instance.currentUser?.uid) {
      final claimsSnapshot = await FirebaseFirestore.instance
          .collection('claims')
          .where('itemId', isEqualTo: params.id)
          .get();

      for (final claimDoc in claimsSnapshot.docs) {
        final claim = claimDoc.data();
        final claimantId = claim['claimantId'] as String?;
        if (claimantId == null) {
          throw StateError('Claim ${claimDoc.id} has no claimant ID.');
        }

        final claimantSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(claimantId)
            .get();
        final claimant = claimantSnapshot.data();
        if (claimant == null) {
          throw StateError('Claim ${claimDoc.id} has no claimant profile.');
        }

        final imageUrl =
            claimant['photoUrl'] as String? ?? claimant['imageUrl'] as String?;
        final status = claim['status'] as String?;
        claims.add(item_claim.ClaimReceivedDto(
          id: _asInt(claim['id']) ?? 0,
          user: claim_user.UserDto(
            id: claimantId.hashCode.abs(),
            username: claimant['username'] as String? ??
                claimant['displayName'] as String? ??
                claimant['firstName'] as String? ??
                claimant['email'] as String? ??
                'User',
            image: imageUrl != null,
            uid: claimantId,
          ),
          status: status == 'accepted'
              ? 'approved'
              : status == 'rejected'
                  ? 'rejected'
                  : 'pending',
          answer: claim['message'] as String? ?? '',
          date: claim['createdAt'] is Timestamp
              ? (claim['createdAt'] as Timestamp).toDate()
              : null,
        ));
      }
    }
    final username = ownerData['username'] as String? ??
        ownerData['displayName'] as String? ??
        'Unknown user';
    final profileImageUrl =
        ownerData['photoUrl'] as String? ?? ownerData['imageUrl'] as String?;
    final address = await _resolveLocationLabel(
      storedLocation,
      latitude: latitude,
      longitude: longitude,
    );
    List<ItemMatchDto>? matches;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final itemStatus = data['status'] as String?;
    if (ownerId != null &&
        ownerId == currentUserId &&
        (itemStatus == 'lost' || itemStatus == 'found')) {
      final matchingStatus = itemStatus == 'lost' ? 'found' : 'lost';
      final candidateSnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('status', isEqualTo: matchingStatus)
          .limit(50)
          .get();
      matches = _rankMatchingItems(
        candidates: candidateSnapshot.docs,
        itemId: params.id,
        ownerId: ownerId,
        title: data['title'] as String? ?? '',
        categoryId: categoryId,
      );
    }

    return ItemDto(
      id: params.id,
      resolved: (data['status'] as String?) == 'resolved',
      title: data['title'] as String? ?? '',
      type: data['status'] as String? ?? 'lost',
      address: address,
      image: (data['imageUrl'] as String?)?.isNotEmpty == true,
      date: _timestampToDateTime(data['createdAt']),
      user: UserDto(
        id: _asInt(ownerData['id']) ?? 0,
        uid: ownerId,
        username: username,
        imageUrl: profileImageUrl,
      ),
      category: _categoryFor(categoryId),
      question: data['question'] as String?,
      position: PositionDto(
        X: latitude,
        Y: longitude,
      ),
      claims: claims,
      news: matches,
    );
  }

  List<ItemMatchDto> _rankMatchingItems({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> candidates,
    required int itemId,
    required String ownerId,
    required String title,
    required int? categoryId,
  }) {
    final sourceTerms = _titleTerms(title);
    final ranked = <_RankedItemMatch>[];
    for (final document in candidates) {
      final candidate = document.data();
      final candidateId = int.tryParse(document.id) ?? _asInt(candidate['id']);
      final candidateOwner = candidate['ownerId'] as String?;
      if (candidateId == null ||
          candidateId == itemId ||
          candidateOwner == ownerId) {
        continue;
      }

      final candidateTitle = candidate['title'] as String? ?? '';
      final sharedTerms =
          sourceTerms.intersection(_titleTerms(candidateTitle)).length;
      final hasSameCategory =
          categoryId != null && _asInt(candidate['categoryId']) == categoryId;
      final score = sharedTerms + (hasSameCategory ? 3 : 0);
      if (score == 0) continue;

      final timestamp = candidate['createdAt'];
      ranked.add(_RankedItemMatch(
        score: score,
        createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
        item: ItemMatchDto(
          id: candidateId,
          title: candidateTitle,
          imageUrl: candidate['imageUrl'] as String?,
        ),
      ));
    }

    ranked.sort((a, b) {
      final scoreOrder = b.score.compareTo(a.score);
      if (scoreOrder != 0) return scoreOrder;
      return (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
    });
    return ranked.take(10).map((entry) => entry.item).toList();
  }

  Set<String> _titleTerms(String title) => title
      .toLowerCase()
      .split(RegExp(r'[^a-z0-9]+'))
      .where((term) => term.length > 2)
      .toSet();

  @override
  Future<ItemResponseDto> createItem(CreateItemParams params) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required to create an item.');
    }

    final firestore = FirebaseFirestore.instance;
    final counterRef = firestore.collection('counters').doc('items');
    final itemId = await firestore.runTransaction<int>((transaction) async {
      final counter = await transaction.get(counterRef);
      final nextId = (counter.data()?['value'] as int? ?? 0) + 1;
      final itemRef = firestore.collection('items').doc(nextId.toString());

      transaction.set(counterRef, {'value': nextId});
      transaction.set(itemRef, {
        'ownerId': user.uid,
        'title': params.title,
        'description': '',
        'categoryId': params.category,
        'status': params.type.name,
        'imageUrl': null,
        'location': {
          'label': _usableLocationLabel(params.locationLabel),
          'latitude': params.position.X,
          'longitude': params.position.Y,
        },
        'question': params.question,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'resolvedAt': null,
      });

      return nextId;
    });

    return ItemResponseDto(id: itemId);
  }

  @override
  Future<void> uploadItemImage(UploadItemImageParams params) async {
    final imageUrl = await _imageService.upload(params.image);
    await FirebaseFirestore.instance
        .collection('items')
        .doc(params.itemId.toString())
        .update({
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> solveItem(SolveItemParams params) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(params.itemId.toString())
        .update({
      'status': 'resolved',
      'resolvedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteItem(DeleteItemParams params) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(params.itemId.toString())
        .delete();
  }

  @override
  Future<void> updateItem(UpdateItemParams params) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(params.itemId.toString())
        .update({
      'title': params.title,
      'categoryId': params.category,
      'question': params.question,
      'location': {
        'label': _usableLocationLabel(params.locationLabel),
        'latitude': params.position.X,
        'longitude': params.position.Y,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteItemImage(DeleteItemImageParams params) async {
    await FirebaseFirestore.instance
        .collection('items')
        .doc(params.itemId.toString())
        .update({
      'imageUrl': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  CategoryDto _categoryFor(int? categoryId) {
    const categories = {
      1: ('Wallets & Purses', 'Wallets and purses', 57544),
      2: ('Electronics & Gadgets', 'Phones and electronics', 57790),
      3: ('Keys & Access Cards', 'Keys and access cards', 62426),
      4: ('Bags & Backpacks', 'Bags and backpacks', 57544),
      5: ('Clothing & Accessories', 'Clothing and accessories', 58943),
      6: ('Documents & IDs', 'Documents and identification', 57747),
      7: ('Other Valuables', 'Other items', 58826),
    };
    final category = categories[categoryId];
    if (category == null) {
      return CategoryDto(
        id: categoryId ?? 0,
        name: 'Other',
        description: '',
        icon: 58826,
      );
    }
    return CategoryDto(
      id: categoryId!,
      name: category.$1,
      description: category.$2,
      icon: category.$3,
    );
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  Future<String> _resolveLocationLabel(
    String? storedLabel, {
    required double latitude,
    required double longitude,
  }) async {
    final label = storedLabel?.trim() ?? '';
    if (label.isNotEmpty && !_looksLikeCoordinates(label)) {
      return label;
    }
    if (latitude == 0 && longitude == 0) {
      return 'Location unavailable';
    }

    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'format': 'jsonv2',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'zoom': '16',
        'addressdetails': '1',
      },
    );
    try {
      final response = await http.get(uri, headers: {
        'User-Agent': 'LostAndFoundApp/1.0'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        return 'Location unavailable';
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final displayName = data['display_name'] as String?;
      if (displayName == null || displayName.isEmpty) {
        return 'Location unavailable';
      }

      final addressData = data['address'] as Map<String, dynamic>?;
      final road = addressData?['road'] ??
          addressData?['pedestrian'] ??
          addressData?['path'];
      final area = addressData?['city'] ??
          addressData?['town'] ??
          addressData?['village'] ??
          addressData?['suburb'] ??
          addressData?['county'];
      if (road != null && area != null) {
        return '$road, $area';
      }
      return displayName;
    } on TimeoutException {
      return 'Location unavailable';
    } on SocketException {
      return 'Location unavailable';
    } on http.ClientException {
      return 'Location unavailable';
    } on FormatException {
      return 'Location unavailable';
    }
  }

  bool _looksLikeCoordinates(String value) {
    return _coordinateParts(value) != null;
  }

  String _usableLocationLabel(String? value) {
    final label = value?.trim() ?? '';
    return label.isNotEmpty && !_looksLikeCoordinates(label) ? label : '';
  }

  List<double>? _coordinateParts(String? value) {
    if (value == null) return null;
    final parts = value.split(',');
    if (parts.length != 2) return null;
    final first = double.tryParse(parts[0].trim());
    final second = double.tryParse(parts[1].trim());
    if (first == null || second == null) return null;
    return [first, second];
  }
}

class _RankedItemMatch {
  final int score;
  final DateTime? createdAt;
  final ItemMatchDto item;

  const _RankedItemMatch({
    required this.score,
    required this.createdAt,
    required this.item,
  });
}
