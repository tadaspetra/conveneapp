import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockCollectionReference mockCollectionReference;
  late BookApiFirebase bookApiFirebase;
  late MockDocumentReference mockDocumentReference;
  late MockUser mockUser;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockUser = MockUser();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

    bookApiFirebase = BookApiFirebase(firebaseFirestore: mockFirebaseFirestore, firebaseAuth: mockFirebaseAuth);
  });
  const uid = 'uid';

  void mockCurrentUser() {
    when(() => mockFirebaseFirestore.collection(any())).thenAnswer((_) => mockCollectionReference);
    when(() => mockCollectionReference.doc(any())).thenAnswer((_) => mockDocumentReference);
    when(() => mockFirebaseAuth.currentUser).thenAnswer((_) => mockUser);
    when(() => mockUser.uid).thenAnswer((_) => uid);
  }

  void mockCurrentUsersBookReference() {
    when(() => mockDocumentReference.collection(any())).thenAnswer((_) => mockCollectionReference);
    when(() => mockCollectionReference.doc(any())).thenAnswer((_) => mockDocumentReference);
  }

  group('addBook', () {
    test('should add a new book when called', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) async => mockDocumentReference);

      final result = await bookApiFirebase.addBook(searchBookModel);

      expect(result, isA<Right<Failure, void>>());
    });

    test('should return [BookFailure()] when Firebase exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) => throw FirebaseException(
            plugin: 'io/exception',
          ));

      final result = await bookApiFirebase.addBook(searchBookModel);

      expect(result, left(BookFailure()));
    });

    test('should return [BookFailure()] when  Exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) => throw Exception());

      final result = await bookApiFirebase.addBook(searchBookModel);

      expect(result, left(BookFailure()));
    });
  });
  void mockDeleteBook() {
    mockCurrentUser();
    mockCurrentUsersBookReference();

    when(() => mockDocumentReference.delete()).thenAnswer((_) async {});
  }

  group('deleteBook', () {
    test('should delete book when called', () async {
      mockDeleteBook();

      final result = await bookApiFirebase.deleteBook(bookModel);

      expect(result, isA<Right<Failure, void>>());
    });

    test('should return [BookFailure()] when Firebase exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockDocumentReference.delete()).thenAnswer((_) => throw FirebaseException(
            plugin: 'io/exception',
          ));

      final result = await bookApiFirebase.deleteBook(bookModel);

      expect(result, left(BookFailure()));
    });

    test('should return [BookFailure()] when  Exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockDocumentReference.delete()).thenAnswer((_) => throw Exception());

      final result = await bookApiFirebase.deleteBook(bookModel);

      expect(result, left(BookFailure()));
    });
  });

  group('finishBook', () {
    test('should finish book when called', () async {
      mockDeleteBook();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) async => mockDocumentReference);

      final result = await bookApiFirebase.finishBook(bookModel);

      expect(result, isA<Right<Failure, void>>());
    });

    test('should return [BookFailure()] when Firebase exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      mockDeleteBook();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) => throw FirebaseException(plugin: 'io/exception'));

      final result = await bookApiFirebase.finishBook(bookModel);

      expect(result, left(BookFailure()));
    });

    test('should return [BookFailure()] when  Exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      mockDeleteBook();
      when(() => mockCollectionReference.add(any())).thenAnswer((_) => throw Exception());

      final result = await bookApiFirebase.finishBook(bookModel);

      expect(result, left(BookFailure()));
    });
  });

  group('updateBook', () {
    test('should update book when called', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockDocumentReference.update(any())).thenAnswer((_) async {});

      final result = await bookApiFirebase.updateBook(bookModel);

      expect(result, isA<Right<Failure, void>>());
    });

    test('should return [BookFailure()] when Firebase exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockDocumentReference.update(any())).thenAnswer((_) => throw FirebaseException(
            plugin: 'io/exception',
          ));

      final result = await bookApiFirebase.updateBook(bookModel);

      expect(result, left(BookFailure()));
    });

    test('should return [BookFailure()] when  Exception is thrown ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockDocumentReference.update(any())).thenAnswer((_) => throw Exception());

      final result = await bookApiFirebase.updateBook(bookModel);

      expect(result, left(BookFailure()));
    });
  });

  group('getCurrentBooks', () {
    test('should return Books from the current users current books collection ', () {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockCollectionReference.orderBy(any())).thenAnswer((_) => mockQuery);
      when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.fromIterable([mockQuerySnapshot]));
      when(() => mockQuerySnapshot.docs).thenAnswer((_) => [mockQueryDocumentSnapshot]);
      when(() => mockQueryDocumentSnapshot.data()).thenAnswer((_) => bookModel.toMap());
      when(() => mockQueryDocumentSnapshot.id).thenAnswer((_) => bookModel.id);

      expect(
          bookApiFirebase.getCurrentBooks(),
          emitsInOrder([
            [bookModel]
          ]));
    });
  });

  group('getHistoryBooks', () {
    test('should return Books from the current users finished books collection ', () async {
      mockCurrentUser();
      mockCurrentUsersBookReference();
      when(() => mockCollectionReference.orderBy('dateCompleted', descending: true)).thenAnswer((_) => mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenAnswer((_) => [mockQueryDocumentSnapshot]);
      when(() => mockQueryDocumentSnapshot.data()).thenAnswer((_) => bookModel.toMap());
      when(() => mockQueryDocumentSnapshot.id).thenAnswer((_) => bookModel.id);

      expect(await bookApiFirebase.getHistoryBooks(), isA<Right<Failure, List<BookModel>>>());
    });
  });

  group('bookApiProvider', () {
    test('should return an instance of BookApi', () {
      final container = ProviderContainer(overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        firebaseFirestoreProvider.overrideWithValue(mockFirebaseFirestore)
      ]);

      expect(container.read(bookApiProvider), isA<BookApi>());
    });
  });
}
