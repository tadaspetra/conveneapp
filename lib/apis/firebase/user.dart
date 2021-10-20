import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/features/authentication/model/user.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('users');

class UserApi {

  Future<LocalUser> getUser({required String uid}) async {
    DocumentSnapshot docSnapshot = await users.doc(uid).get();
    return LocalUser(
      uid: docSnapshot.id,
      email: docSnapshot["email"],
      name: docSnapshot["name"],
    );
  }

  Future<void> addUser({required String uid, String? email, String? name}) async {
    await users.doc(uid).set({
      'email': email ?? FieldValue.delete(),
      'name': name ?? FieldValue.delete(),
    }, SetOptions(merge: true));
  }
}
