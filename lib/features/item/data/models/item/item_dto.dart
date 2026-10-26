import 'package:lost_and_found/features/item/data/models/item/category_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/claim_received_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/claim_sent_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/position_dto.dart';
import 'package:lost_and_found/features/item/data/models/item/user_dto.dart';

class ItemDto {
  final int id;
  final bool resolved;
  final String title;
  final String type;
  final String address;
  final bool? image;
  final DateTime date;
  final UserDto user;
  final CategoryDto category;
  final String? question;
  final PositionDto position;
  final List<ClaimReceivedDto>? claims;
  final ClaimSentDto? userClaim;
  final List<ItemMatchDto>? news;

  const ItemDto({
    required this.id,
    required this.resolved,
    required this.title,
    required this.type,
    required this.address,
    this.image,
    required this.date,
    required this.user,
    required this.category,
    required this.question,
    required this.position,
    this.claims,
    this.userClaim,
    this.news,
  });
}

class ItemMatchDto {
  final int id;
  final String title;
  final String? imageUrl;

  const ItemMatchDto({
    required this.id,
    required this.title,
    this.imageUrl,
  });
}
