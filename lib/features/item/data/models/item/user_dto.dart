class UserDto {
  final int id;
  final String username;
  final bool? image;
  final String? uid;
  final String? imageUrl;

  const UserDto({
    required this.id,
    required this.username,
    this.image,
    this.uid,
    this.imageUrl,
  });
}
