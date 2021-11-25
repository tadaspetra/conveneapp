import 'package:firebase_auth/firebase_auth.dart';

extension XFirebaseAuth on FirebaseAuth {
  /// - use this only when you are sure about if the current user is logged in
  /// - if the user is logged in this will return the `uid` defaults to empty
  String get currentUsersId => currentUser?.uid ?? '';
}
