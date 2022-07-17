class UserInfo {
  final String uid;
  final String email;
  final String? name;
  final bool showTutorial;

  const UserInfo({required this.uid, required this.email, this.name, required this.showTutorial});

  UserInfo copyWith({
    String? uid,
    String? email,
    String? name,
    bool? showTutorial,
  }) {
    return UserInfo(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      showTutorial: showTutorial ?? this.showTutorial,
    );
  }
}
