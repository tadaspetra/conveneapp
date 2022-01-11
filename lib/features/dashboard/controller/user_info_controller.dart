import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInfoController = StreamProvider<UserInfo>((ref) {
  final UserApi userApi = ref.watch(userApiProvider);
  final String? uid = ref.watch(currentUserController).asData?.value.uid;
  if (uid != null) {
    return userApi.getUser(uid: uid);
  } else {
    return Stream.value(
      const UserInfo(uid: '', email: "error", name: "error", showTutorial: true),
    );
  }
});
