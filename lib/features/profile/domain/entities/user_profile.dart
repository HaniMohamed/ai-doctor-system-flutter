class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String organizationId;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.organizationId,
  });
}


