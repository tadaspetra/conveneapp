import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/features/authentication/model/auth_state.dart';
import 'package:conveneapp/features/authentication/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String nullUid = "nouser";
const String nullEmail = "nouser";
final authApiProvider = Provider<AuthApi>((ref) => AuthApiImpl());

final currentUserController = StreamProvider<LocalUser>((ref) {
  final AuthApi authApi = ref.watch(authApiProvider);
  return authApi.currentUser().map((user) => LocalUser(
        uid: user?.uid ?? nullUid,
        email: user?.email ?? nullEmail,
        name: user?.displayName,
      ));
});

final authStateController = Provider<AuthState>((ref) {
  final user = ref.watch(currentUserController);
  return user.when(
    data: (user) {
      if (user.uid == nullUid) {
        return AuthState.notAuthenticated;
      } else {
        return AuthState.authenticated;
      }
    },
    loading: (user) {
      return AuthState.unknown;
    },
    error: (err, stack, user) {
      return AuthState.notAuthenticated;
    },
  );
});
