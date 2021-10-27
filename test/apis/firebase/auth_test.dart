import 'dart:typed_data';

import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/constants/constants.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../test_helpers.dart';

class MockGoogleAuthApi extends Mock implements GoogleAuthApi {}

class MockAppleAuthApi extends Mock implements AppleAuthApi {}

class MockAuthorizationResult extends Mock implements AuthorizationResult {}

class MockAppleIdCredential extends Mock implements AppleIdCredential {}

class MockPersonNameComponents extends Mock implements PersonNameComponents {}

class MockNsError extends Mock implements NsError {}

const _error = 'error';
const _firebaseExceptionCode = 'firebase-error';

void main() {
  late MockUserApi userApi;
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockUser user;
  late AuthApiFirebase authApiFirebase;
  late MockGoogleAuthApi googleAuthApi;

  late MockUserCredential userCredential;
  late MockAuthCredential authCredential;
  late MockAppleAuthApi appleAuthApi;
  late MockAuthorizationResult authorizationResult;
  late MockAppleIdCredential appleIdCredential;
  late MockPersonNameComponents personNameComponents;
  late MockNsError nsError;

  setUp(() {
    userApi = MockUserApi();
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    user = MockUser();
    googleAuthApi = MockGoogleAuthApi();
    userCredential = MockUserCredential();
    authCredential = MockAuthCredential();
    appleAuthApi = MockAppleAuthApi();
    authorizationResult = MockAuthorizationResult();
    appleIdCredential = MockAppleIdCredential();
    personNameComponents = MockPersonNameComponents();
    nsError = MockNsError();

    authApiFirebase = AuthApiFirebase(
        firebaseAuth: firebaseAuth,
        userApi: userApi,
        googleSignIn: googleSignIn,
        googleAuthApi: googleAuthApi,
        appleAuthApi: appleAuthApi);
  });

  const email = 'email';
  const uid = 'uid';
  const name = 'name';

  AuthFailure _getAuthFailure(String message) {
    return AuthFailure(message);
  }

  group('currentUser', () {
    void mockCurrentUser(MockUser? user) {
      when(() => firebaseAuth.authStateChanges()).thenAnswer(
        (invocation) => Stream.fromIterable([
          user,
        ]),
      );
    }

    test('should return [User] when a user has logged in', () {
      mockCurrentUser(user);

      expect(authApiFirebase.currentUser(), emitsInOrder([user]));
    });

    test('should return [null] when there is no user logged in', () {
      mockCurrentUser(null);

      expect(authApiFirebase.currentUser(), emitsInOrder([null]));
    });

    test('should return stream of errors when an error is emitted', () {
      when(() => authApiFirebase.currentUser()).thenAnswer((invocation) => Stream.error(_error));

      expect(authApiFirebase.currentUser(), emitsError(_error));
    });
  });

  group('signIn', () {
    const abortedMessage = 'Sign in aborted by user';
    void mockSignGoogle() {
      when(() => googleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => authCredential);
    }

    test(
      '''should return [right(void)] when the user has be created/signed in and the 
      user document is created''',
      () async {
        mockSignGoogle();
        when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer((invocation) async => userCredential);
        when(() => userCredential.user).thenReturn(user);
        when(() => user.email).thenReturn(email);
        when(() => user.uid).thenReturn(uid);
        when(() => user.displayName).thenReturn(name);
        when(() => userApi.addUser(uid: uid, email: email, name: name)).thenAnswer((invocation) async {});

        expect(await authApiFirebase.signIn(), equals(right(null)));
      },
    );

    test('''should return left(AuthFailure(We have trouble in 
    connecting you to the app!. Please try again.))''', () async {
      mockSignGoogle();
      when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer((invocation) async => userCredential);

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test('should retrun left(AuthFailure(Sign in aborted by user) when the user cancels the flow))', () async {
      when(() => googleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => null);

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(abortedMessage))));
    });

    test('''should return [left(AuthFailure(AuthFailure(error))] 
    when [FirebaseAuthException] is thrown and [e.message] is not null''', () async {
      mockSignGoogle();
      when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer(
        (invocation) async => throw FirebaseAuthException(
          code: _firebaseExceptionCode,
          message: _error,
        ),
      );

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(_error))));
    });

    test('''should return [left(AuthFailure(AuthFailure(We have trouble in 
    connecting you to the app!. Please try again.)))] 
    when [FirebaseAuthException] is thrown and [e.message] is [null]
    ''', () async {
      mockSignGoogle();
      when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer(
        (invocation) async => throw FirebaseAuthException(
          code: _firebaseExceptionCode,
        ),
      );

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test('''should return [left(AuthFailure(AuthFailure(We have trouble in 
        connecting you to the app!. Please try again.)))] when [Exception] is throw''', () async {
      mockSignGoogle();
      when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer(
        (invocation) async => throw Exception(),
      );

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });
  });

  group('authApiProvider', () {
    test('should return typeOf [AuthApi] when provider is called', () {
      final container = ProviderContainer(overrides: [
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        googleSignInProvider.overrideWithValue(googleSignIn),
        userApiProvider.overrideWithValue(userApi),
        googleAuthApiProvider.overrideWithValue(googleAuthApi),
        appleAuthApiProvider.overrideWithValue(appleAuthApi)
      ]);
      expect(container.read(authApiProvider), isA<AuthApi>());
    });
  });

  group('signOut', () {
    test('should return [right(null)] when the user has been signed out', () async {
      when(() => googleSignIn.signOut()).thenAnswer((invocation) async {});
      when(() => firebaseAuth.signOut()).thenAnswer((invocation) async {});

      expect(await authApiFirebase.signOut(), equals(right(null)));
    });

    test('''should return left(AuthFailure(Unknown error occured
     when trying to sign out you from the app))
         when an exception is thrown''', () async {
      when(() => googleSignIn.signOut()).thenAnswer((invocation) async => throw Exception());

      expect(await authApiFirebase.signOut(), equals(left(_getAuthFailure(signOutExceptionMessage))));
    });
  });

  group('signInWithApple', () {
    void mockAutorizationResult() {
      when(() => appleAuthApi.signInWithApple()).thenAnswer((invocation) async => authorizationResult);
    }

    group('AuthorizationStatus.authorized', () {
      setUp(() {
        registerFallbackValue(authCredential);
      });
      test('should return [right(null)] when user is signedIn and', () async {
        mockAutorizationResult();
        when(() => authorizationResult.status).thenReturn(AuthorizationStatus.authorized);
        when(() => authorizationResult.credential).thenReturn(appleIdCredential);
        when(() => appleIdCredential.identityToken).thenReturn(Uint8List.fromList([]));
        when(() => appleIdCredential.authorizationCode).thenReturn(Uint8List.fromList([]));
        when(() => appleIdCredential.fullName).thenReturn(personNameComponents);

        when(() => firebaseAuth.signInWithCredential(any())).thenAnswer((invocation) async => userCredential);
        when(() => personNameComponents.givenName).thenReturn(name);
        when(() => personNameComponents.familyName).thenReturn(name);
        when(() => userCredential.user).thenReturn(user);
        when(() => user.uid).thenReturn(uid);
        when(() => user.email).thenReturn(email);
        when(() => user.updateDisplayName(any<String>())).thenAnswer((invocation) async {});
        when(() => userApi.addUser(
            uid: any<String>(named: 'uid'),
            email: any<String>(named: 'email'),
            name: any<String>(named: 'name'))).thenAnswer((invocation) async {});

        expect(await authApiFirebase.signInWithApple(), equals(right(null)));
      });
    });

    group('AuthorizationStatus.error', () {
      test('should return [left(error)] when [Ns.localizedFailureReason] is null', () async {
        mockAutorizationResult();
        when(() => authorizationResult.status).thenReturn(AuthorizationStatus.error);
        when(() => authorizationResult.error).thenReturn(nsError);
        when(() => nsError.localizedFailureReason).thenReturn(_error);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(_error))));
      });
      test('''should return [left(We have trouble in connecting you to the app!. Please try again.)] 
      when [Ns.localizedFailureReason] is not null''', () async {
        mockAutorizationResult();
        when(() => authorizationResult.status).thenReturn(AuthorizationStatus.error);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
      });
    });

    group('AuthorizationStatus.cancelled', () {
      test('should return [left(Sign in aborted by user)] when user cancels the flow', () async {
        mockAutorizationResult();
        when(() => authorizationResult.status).thenReturn(AuthorizationStatus.cancelled);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure('Sign in aborted by user'))));
      });
    });

    test(
        'should return [left(AuthFailure(error))] when [FirebaseException] is thrown with [FirebaseAuthException.message] is not null',
        () async {
      when(() => appleAuthApi.signInWithApple())
          .thenAnswer((invocation) async => throw FirebaseAuthException(code: _firebaseExceptionCode, message: _error));

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(_error))));
    });

    test(
        'should reuturn left(AuthFailure(We have trouble in connecting you to the app!. Please try again.)) when [FirebaseAuthException] is thrown with [FirebaseAuthException.message] is null',
        () async {
      when(() => appleAuthApi.signInWithApple())
          .thenAnswer((invocation) async => throw FirebaseAuthException(code: _firebaseExceptionCode));

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test(
        'should reuturn left(AuthFailure(We have trouble in connecting you to the app!. Please try again.)) when [Exception] is thrown',
        () async {
      when(() => appleAuthApi.signInWithApple()).thenAnswer((invocation) async => throw Exception());

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
    });
  });
}
