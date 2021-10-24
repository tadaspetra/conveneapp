import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';

const _error = 'error';
const _authExceptionMessage = 'We have trouble in connection you to the app!. Please try again.';
void main() {
  late MockUserApi userApi;
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockUser user;
  late AuthApiImpl authApiImpl;
  late MockGoogleAuthApi googleAuthApi;
  late MockGoogleSignInAuthentication authentication;
  late MockUserCredential userCredential;
  late MockAuthCredential authCredential;

  setUp(() {
    userApi = MockUserApi();
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    user = MockUser();
    googleAuthApi = MockGoogleAuthApi();
    authentication = MockGoogleSignInAuthentication();
    userCredential = MockUserCredential();
    authCredential = MockAuthCredential();
    authApiImpl = AuthApiImpl(
        firebaseAuth: firebaseAuth, userApi: userApi, googleSignIn: googleSignIn, googleAuthApi: googleAuthApi);
  });
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
      expect(authApiImpl.currentUser(), emitsInOrder([user]));
    });
    test('should return [null] when there is no user logged in', () {
      mockCurrentUser(null);
      expect(authApiImpl.currentUser(), emitsInOrder([null]));
    });
    test('should return stream of errors when an error is emitted', () {
      when(() => authApiImpl.currentUser()).thenAnswer((invocation) => Stream.error(_error));
      expect(authApiImpl.currentUser(), emitsError(_error));
    });
  });
  group('signIn', () {
    const email = 'email';
    const uid = 'uid';
    const name = 'name';
    const abortedMessage = 'Sign in aborted by user';
    test(
      '''should return [right(unit)] when the user has be created/signed in and the 
      user document is created''',
      () async {
        when(() => googleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => authCredential);
        when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer((invocation) async => userCredential);
        when(() => userCredential.user).thenReturn(user);
        when(() => user.email).thenReturn(email);
        when(() => user.uid).thenReturn(uid);
        when(() => user.displayName).thenReturn(name);
        when(() => userApi.addUser(uid: uid, email: email, name: name)).thenAnswer((invocation) async {});
        expect(await authApiImpl.signIn(), equals(right(unit)));
      },
    );
    test('''should return left(AuthFailure(We have trouble in 
    connection you to the app!. Please try again.))''', () async {
      when(() => googleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => authCredential);
      when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer((invocation) async => userCredential);
      expect(await authApiImpl.signIn(), equals(left(_getAuthFailure(_authExceptionMessage))));
    });
    test('should retrun left(AuthFailure(Sign in aborted by user) when the user cancels the flow))', () async {
      when(() => googleAuthApi.signInWithGoogle()).thenAnswer((invocation) async => null);
      expect(await authApiImpl.signIn(), equals(left(_getAuthFailure(abortedMessage))));
    });
  });
}
