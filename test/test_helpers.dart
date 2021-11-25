// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserApi extends Mock implements UserApi {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUser extends Mock implements User {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements OAuthCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

const bookModel = BookModel(
  id: 'id',
  title: 'title',
  authors: ['authors'],
  pageCount: 0,
  coverImage: 'coverImage',
  currentPage: 0,
);

const searchBookModel = SearchBookModel(
  title: 'title',
  authors: ['authors'],
  pageCount: 0,
  coverImage: '',
);
