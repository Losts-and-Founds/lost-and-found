class UserItemDto {
  final int id;
  final String title;
  final int claims;
  final int approvedClaims;
  final bool? image;
  final String? imageUrl;
  final String? location;
  final int? categoryId;
  final DateTime? createdAt;

  const UserItemDto({
    required this.id,
    required this.title,
    required this.claims,
    required this.approvedClaims,
    this.image,
    this.imageUrl,
    this.location,
    this.categoryId,
    this.createdAt,
  });
}
