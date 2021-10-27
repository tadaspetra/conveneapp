import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/features/authentication/model/user.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final authStateChangesProvider = StreamProvider<LocalUser?>(
  (ref) => ref.watch(authApiProvider).currentUser().map((user) {
    if (user == null) return null;
    return LocalUser(
      uid: user.uid,
      email: user.email ?? 'no email is set',
      name: user.displayName,
    );
  }),
);

final authStateNotifierProvider = StateNotifierProvider<AuthStateControllerNotifier, AuthState>((ref) {
  final firebaseAuthChanges = ref.watch(authStateChangesProvider);
  return AuthStateControllerNotifier(AuthState(userStream: firebaseAuthChanges, isAppleSignIn: false));
});

class AuthStateControllerNotifier extends StateNotifier<AuthState> {
  AuthStateControllerNotifier(AuthState state) : super(state) {
    _initilize();
  }

  Future<void> _initilize() async {
    final isApple = await TheAppleSignIn.isAvailable();
    state = state.copyWith(isAppleSignIn: isApple);
  }
}

@immutable
class AuthState {
  final AsyncValue<LocalUser?> userStream;
  final bool isAppleSignIn;
  const AuthState({
    required this.userStream,
    required this.isAppleSignIn,
  });

  AuthState copyWith({
    AsyncValue<LocalUser?>? userStream,
    bool? isAppleSignIn,
  }) {
    return AuthState(
      userStream: userStream ?? this.userStream,
      isAppleSignIn: isAppleSignIn ?? this.isAppleSignIn,
    );
  }

  @override
  String toString() => 'AuthState(userStream: $userStream, isAppleSignIn: $isAppleSignIn)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState && other.userStream == userStream && other.isAppleSignIn == isAppleSignIn;
  }

  @override
  int get hashCode => userStream.hashCode ^ isAppleSignIn.hashCode;
}
