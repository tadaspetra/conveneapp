import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

final CollectionReference users = FirebaseFirestore.instance.collection('users');

class UserApi {
  Stream<UserInfo> getUser({required String uid}) {
    Stream<DocumentSnapshot> docSnapshot = users.doc(uid).snapshots();
    return docSnapshot.map<UserInfo>(
      (user) => UserInfo(
        uid: user.id,
        email: user["email"],
        name: user["name"],
        showTutorial: user['showTutorial'],
      ),
    );
  }

  Future<void> addUser({required String uid, String? email, String? name}) async {
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();

    if (documentSnapshot.exists) return;
    await users.doc(uid).set({
      'email': email ?? FieldValue.delete(),
      'name': name ?? FieldValue.delete(),
      'showTutorial': true,
    }, SetOptions(merge: true));
  }

  Future<void> removeTutorial({required String uid}) async {
    await users.doc(uid).update({
      'showTutorial': false,
    });
  }
}
