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
  late MockUserApi mockUserApi;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUser mockUser;
  late AuthApiFirebase authApiFirebase;
  late MockGoogleAuthApi mockGoogleAuthApi;

  late MockUserCredential mockUserCredential;
  late MockAuthCredential mockAuthCredential;
  late MockAppleAuthApi mockAppleAuthApi;
  late MockAuthorizationResult mockAuthorizationResult;
  late MockAppleIdCredential mockAppleIdCredential;
  late MockPersonNameComponents mockPersonNameComponents;
  late MockNsError mockNsError;

  setUp(() {
    mockUserApi = MockUserApi();
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUser = MockUser();
    mockGoogleAuthApi = MockGoogleAuthApi();
    mockUserCredential = MockUserCredential();
    mockAuthCredential = MockAuthCredential();
    mockAppleAuthApi = MockAppleAuthApi();
    mockAuthorizationResult = MockAuthorizationResult();
    mockAppleIdCredential = MockAppleIdCredential();
    mockPersonNameComponents = MockPersonNameComponents();
    mockNsError = MockNsError();

    authApiFirebase = AuthApiFirebase(
        firebaseAuth: mockFirebaseAuth,
        userApi: mockUserApi,
        googleSignIn: mockGoogleSignIn,
        googleAuthApi: mockGoogleAuthApi,
        appleAuthApi: mockAppleAuthApi);
  });

  const email = 'email';
  const uid = 'uid';
  const name = 'name';

  AuthFailure _getAuthFailure(String message) {
    return AuthFailure(message);
  }

  group('currentUser', () {
    void mockCurrentUser(MockUser? user) {
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer(
        (invocation) => Stream.fromIterable([
          user,
        ]),
      );
    }

    test('should return [User] when a user has logged in', () {
      mockCurrentUser(mockUser);

      expect(authApiFirebase.currentUser(), emitsInOrder([mockUser]));
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
      when(() => mockGoogleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => mockAuthCredential);
    }

    test(
      '''should return [right(void)] when the user has be created/signed in and the 
      user document is created''',
      () async {
        mockSignGoogle();
        when(() => mockFirebaseAuth.signInWithCredential(mockAuthCredential))
            .thenAnswer((invocation) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.email).thenReturn(email);
        when(() => mockUser.uid).thenReturn(uid);
        when(() => mockUser.displayName).thenReturn(name);
        when(() => mockUserApi.addUser(uid: uid, email: email, name: name)).thenAnswer((invocation) async {});

        expect(await authApiFirebase.signIn(), equals(right(null)));
      },
    );

    test('''should return left(AuthFailure(We have trouble in 
    connecting you to the app!. Please try again.)) when [UserCredential.user] is null''', () async {
      mockSignGoogle();
      when(() => mockFirebaseAuth.signInWithCredential(mockAuthCredential))
          .thenAnswer((invocation) async => mockUserCredential);

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test('should retrun left(AuthFailure(Sign in aborted by user) when the user cancels the flow))', () async {
      when(() => mockGoogleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => null);

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(abortedMessage))));
    });

    test('''should return [left(AuthFailure(AuthFailure(error))] 
    when [FirebaseAuthException] is thrown and [e.message] is not null''', () async {
      mockSignGoogle();
      when(() => mockFirebaseAuth.signInWithCredential(mockAuthCredential)).thenAnswer(
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
      when(() => mockFirebaseAuth.signInWithCredential(mockAuthCredential)).thenAnswer(
        (invocation) async => throw FirebaseAuthException(
          code: _firebaseExceptionCode,
        ),
      );

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test('''should return [left(AuthFailure(AuthFailure(We have trouble in 
        connecting you to the app!. Please try again.)))] when [Exception] is thrown''', () async {
      mockSignGoogle();
      when(() => mockFirebaseAuth.signInWithCredential(mockAuthCredential)).thenAnswer(
        (invocation) async => throw Exception(),
      );

      expect(await authApiFirebase.signIn(), equals(left(_getAuthFailure(authExceptionMessage))));
    });
  });

  group('authApiProvider', () {
    test('should return typeOf [AuthApi] when provider is called', () {
      final container = ProviderContainer(overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        googleSignInProvider.overrideWithValue(mockGoogleSignIn),
        userApiProvider.overrideWithValue(mockUserApi),
        googleAuthApiProvider.overrideWithValue(mockGoogleAuthApi),
        appleAuthApiProvider.overrideWithValue(mockAppleAuthApi)
      ]);
      expect(container.read(authApiProvider), isA<AuthApi>());
    });
  });

  group('signOut', () {
    test('should return [right(null)] when the user has been signed out', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((invocation) async {});
      when(() => mockFirebaseAuth.signOut()).thenAnswer((invocation) async {});

      expect(await authApiFirebase.signOut(), equals(right(null)));
    });

    test('''should return left(AuthFailure(Unknown error occured
     when trying to sign out you from the app))
         when an exception is thrown''', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((invocation) async => throw Exception());

      expect(await authApiFirebase.signOut(), equals(left(_getAuthFailure(signOutExceptionMessage))));
    });
  });

  group('signInWithApple', () {
    void mockAutorizationResult() {
      when(() => mockAppleAuthApi.signInWithApple()).thenAnswer((invocation) async => mockAuthorizationResult);
    }

    group('AuthorizationStatus.authorized', () {
      setUp(() {
        registerFallbackValue(mockAuthCredential);
      });

      test('should return [right(null)] when user is signedIn and', () async {
        mockAutorizationResult();
        when(() => mockAuthorizationResult.status).thenReturn(AuthorizationStatus.authorized);
        when(() => mockAuthorizationResult.credential).thenReturn(mockAppleIdCredential);
        when(() => mockAppleIdCredential.identityToken).thenReturn(Uint8List.fromList([]));
        when(() => mockAppleIdCredential.authorizationCode).thenReturn(Uint8List.fromList([]));
        when(() => mockAppleIdCredential.fullName).thenReturn(mockPersonNameComponents);

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer((invocation) async => mockUserCredential);
        when(() => mockPersonNameComponents.givenName).thenReturn(name);
        when(() => mockPersonNameComponents.familyName).thenReturn(name);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(uid);
        when(() => mockUser.email).thenReturn(email);
        when(() => mockUser.updateDisplayName(any<String>())).thenAnswer((invocation) async {});
        when(() => mockUserApi.addUser(
            uid: any<String>(named: 'uid'),
            email: any<String>(named: 'email'),
            name: any<String>(named: 'name'))).thenAnswer((invocation) async {});

        expect(await authApiFirebase.signInWithApple(), equals(right(null)));
      });
    });

    group('AuthorizationStatus.error', () {
      test('should return [left(error)] when [Ns.localizedFailureReason] is null', () async {
        mockAutorizationResult();
        when(() => mockAuthorizationResult.status).thenReturn(AuthorizationStatus.error);
        when(() => mockAuthorizationResult.error).thenReturn(mockNsError);
        when(() => mockNsError.localizedFailureReason).thenReturn(_error);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(_error))));
      });

      test('''should return [left(We have trouble in connecting you to the app!. Please try again.)] 
      when [Ns.localizedFailureReason] is not null''', () async {
        mockAutorizationResult();
        when(() => mockAuthorizationResult.status).thenReturn(AuthorizationStatus.error);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
      });
    });

    group('AuthorizationStatus.cancelled', () {
      test('should return [left(Sign in aborted by user)] when user cancels the flow', () async {
        mockAutorizationResult();
        when(() => mockAuthorizationResult.status).thenReturn(AuthorizationStatus.cancelled);

        expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure('Sign in aborted by user'))));
      });
    });

    test(
        'should return [left(AuthFailure(error))] when [FirebaseException] is thrown with [FirebaseAuthException.message] is not null',
        () async {
      when(() => mockAppleAuthApi.signInWithApple())
          .thenAnswer((invocation) async => throw FirebaseAuthException(code: _firebaseExceptionCode, message: _error));

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(_error))));
    });

    test(
        'should reuturn left(AuthFailure(We have trouble in connecting you to the app!. Please try again.)) when [FirebaseAuthException] is thrown with [FirebaseAuthException.message] is null',
        () async {
      when(() => mockAppleAuthApi.signInWithApple())
          .thenAnswer((invocation) async => throw FirebaseAuthException(code: _firebaseExceptionCode));

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
    });

    test(
        'should reuturn left(AuthFailure(We have trouble in connecting you to the app!. Please try again.)) when [Exception] is thrown',
        () async {
      when(() => mockAppleAuthApi.signInWithApple()).thenAnswer((invocation) async => throw Exception());

      expect(await authApiFirebase.signInWithApple(), equals(left(_getAuthFailure(authExceptionMessage))));
    });
  });
}
