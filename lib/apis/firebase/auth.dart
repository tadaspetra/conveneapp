import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/constants/exception_messages.dart';
import 'package:conveneapp/core/constants/firebase_constants.dart';
import 'package:conveneapp/core/errors/errors.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'firebase_api_providers.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApiFirebase(
      appleAuthApi: ref.watch(appleAuthApiProvider),
      firebaseAuth: ref.watch(firebaseAuthProvider),
      googleAuthApi: ref.watch(googleAuthApiProvider),
      googleSignIn: ref.watch(googleSignInProvider),
      userApi: ref.watch(userApiProvider)),
);

///{@template auth_api}
///- Must Not be accessed outside `auth.dart`
/// - These classes are used by `authApiProvider`
///{@endtemplate}
@visibleForTesting
final appleAuthApiProvider = Provider((ref) => AppleAuthApi());

///{@macro auth_api}
@visibleForTesting
final googleAuthApiProvider = Provider((ref) => GoogleAuthApi(googleSignIn: ref.watch(googleSignInProvider)));

abstract class AuthApi {
  Stream<User?> currentUser();

  /// - signIn with google
  FutureEitherVoid signIn();

  /// - SignIn with apple
  FutureEitherVoid signInWithApple();
  FutureEitherVoid signOut();
}

/// - Implementations for `AuthApi`
class AuthApiFirebase implements AuthApi {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserApi _userApi;
  final GoogleAuthApi _googleAuthApi;
  final AppleAuthApi _appleAuthApi;
  AuthApiFirebase(
      {required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn,
      required UserApi userApi,
      required GoogleAuthApi googleAuthApi,
      required AppleAuthApi appleAuthApi})
      : _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth,
        _userApi = userApi,
        _appleAuthApi = appleAuthApi,
        _googleAuthApi = googleAuthApi;

  @override
  Stream<User?> currentUser() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  FutureEitherVoid signIn() async {
    // Trigger the authentication flow
    try {
      final googleUser = await _googleAuthApi.signInWithGoogle();
      if (googleUser != null) {
        // Create a new credential
        final userCredential = await _firebaseAuth.signInWithCredential(googleUser);
        final user = userCredential.user;
        if (user != null) {
          await _userApi.addUser(uid: user.uid, email: user.email, name: user.displayName);
          return right(null);
        } else {
          throw AuthException(authExceptionMessage);
        }
      } else {
        throw AuthException('Sign in aborted by user');
      }
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(e.message ?? authExceptionMessage));
    } on BaseException catch (e) {
      return left(AuthFailure(e.message));
    } on Exception catch (_) {
      return left(AuthFailure(authExceptionMessage));
    }
  }

  // - catching one exception is allowed since there wont be any exceptions
  //thrown from the platform when this is invoked
  @override
  FutureEitherVoid signOut() async {
    try {
      // Will signout the user's google account if logged in via google
      await _googleSignIn.signOut();

      // Once signed in, return the UserCredential
      await _firebaseAuth.signOut();
      return right(null);
    } on Exception catch (_) {
      return left(AuthFailure(signOutExceptionMessage));
    }
  }

  @override
  FutureEitherVoid signInWithApple() async {
    try {
      const scopes = FirebaseConstants.appleSignInScopes;
      // 1. perform the sign-in request
      final AuthorizationResult result = await _appleAuthApi.signInWithApple();
      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );
          final userCredential = await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;
          if (scopes.contains(Scope.fullName)) {
            final fullName = appleIdCredential.fullName;
            if (fullName != null && fullName.givenName != null && fullName.familyName != null) {
              final displayName = '${fullName.givenName} ${fullName.familyName}';
              await firebaseUser.updateDisplayName(displayName);
            }
          }

          /// - Adds the user's document directly after the account creating
          await _userApi.addUser(uid: firebaseUser.uid, email: firebaseUser.email, name: firebaseUser.displayName);
          return right(null);
        case AuthorizationStatus.error:
          throw AuthException(result.error?.localizedFailureReason ?? authExceptionMessage);

        case AuthorizationStatus.cancelled:
          throw AuthException('Sign in aborted by user');
      }
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(e.message ?? authExceptionMessage));
    } on BaseException catch (e) {
      return left(AuthFailure(e.message));
    } on Exception catch (_) {
      return left(AuthFailure(authExceptionMessage));
    }
  }
}

/// - should only be accessed in testing
/// - this extraction is needed in order to test the functionality of the other parts
/// - below are non-mockable function
@visibleForTesting
class GoogleAuthApi {
  final GoogleSignIn _googleSignIn;
  GoogleAuthApi({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;
  Future<OAuthCredential?> signInWithGoogle() async {
    final result = await _googleSignIn.signIn();
    if (result == null) {
      return null;
    }
    final authentication = await result.authentication;
    return GoogleAuthProvider.credential(accessToken: authentication.accessToken, idToken: authentication.idToken);
  }
}

/// - must be accessed only within tests, since this function is only used internally by the test
@visibleForTesting
class AppleAuthApi {
  Future<AuthorizationResult> signInWithApple() async {
    const scopes = FirebaseConstants.appleSignInScopes;
    return TheAppleSignIn.performRequests(const [AppleIdRequest(requestedScopes: scopes)]);
  }
}
