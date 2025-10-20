class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String organizationId;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.organizationId,
  });
}
