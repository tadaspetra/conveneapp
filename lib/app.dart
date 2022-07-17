import 'package:conveneapp/core/loading.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/authentication/model/auth_state.dart';
import 'package:conveneapp/features/authentication/view/auth_page.dart';
import 'package:conveneapp/features/dashboard/view/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<AppNavigator> {
  late Future<FirebaseApp> _initialization;
  late Future<bool> _appleSignInAvailable;

  @override
  void initState() {
    _initialization = Firebase.initializeApp();
    _appleSignInAvailable = TheAppleSignIn.isAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw ("WE HAVE PROBLEMS");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
          AuthState currentAuthState = ref.watch(authStateController);
          switch (currentAuthState) {
            case AuthState.unknown:
              return const LoadingPage();
            case AuthState.notAuthenticated:
              return FutureBuilder(
                future: _appleSignInAvailable,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasError) {
                    throw ("WE HAVE PROBLEMS");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AuthPage(
                      appleSignInAvailable: snapshot.data ?? false,
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  }
                  throw ("WE STILL HAVE PROBLEMS");
                },
              );
            case AuthState.authenticated:
              return const Dashboard();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        throw ("WE STILL HAVE PROBLEMS");
      },
    );
  }
}
