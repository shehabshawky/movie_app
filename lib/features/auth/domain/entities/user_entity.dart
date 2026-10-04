class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatar;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatar,
  });
}
