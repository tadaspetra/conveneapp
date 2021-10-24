import 'package:conveneapp/core/loading.dart';
import 'package:conveneapp/dashboard.dart';

import 'package:conveneapp/features/authentication/view/auth_page.dart';

import 'package:conveneapp/top_level_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNavigator extends ConsumerWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateNotifierProvider).userStream.when(data: (user) {
      if (user != null) return Dashboard(user: user);
      return AuthPage(appleSignInAvailable: ref.read(authStateNotifierProvider).isAppleSignIn);
    }, error: (e, es, previousData) {
      return Text(e.toString());
    }, loading: (_) {
      return const LoadingPage();
    });
  }
}
