import 'package:flutter/foundation.dart';

@immutable
class LocalUser {
  final String uid;
  final String email;
  final String? name;

  const LocalUser({required this.uid, required this.email, this.name});

  LocalUser copyWith({
    String? uid,
    String? email,
    String? name,
  }) {
    return LocalUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
