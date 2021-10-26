import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserApi extends Mock implements UserApi {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUser extends Mock implements User {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockGoogleAuthApi extends Mock implements GoogleAuthApi {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements OAuthCredential {}
