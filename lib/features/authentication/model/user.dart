class User {
  final String uid;
  final String email;

  const User(this.uid, this.email);

  User copyWith({
    String? uid,
    String? email,
  }) {
    return User(
      uid ?? this.uid,
      email ?? this.email,
    );
  }
}
