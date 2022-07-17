class AuthUser {
  final String uid;
  final String email;
  final String? name;

  const AuthUser({required this.uid, required this.email, this.name});

  AuthUser copyWith({
    String? uid,
    String? email,
    String? name,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
