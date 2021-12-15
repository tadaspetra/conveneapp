import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:conveneapp/core/constants/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:conveneapp/core/errors/errors.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookApiProvider = Provider<BookApi>((ref) => BookApiFirebase(
    firebaseFirestore: ref.watch(firebaseFirestoreProvider), firebaseAuth: ref.watch(firebaseAuthProvider)));

/// - all the transactions must be pointed to the current user's reference
abstract class BookApi {
  /// - finishes a book and adds it to the `finishedBooks` reference
  FutureEitherVoid finishBook(BookModel book);

  /// - create a new book
  FutureEitherVoid addBook(SearchBookModel book);

  /// - used to update the currentPage
  FutureEitherVoid updateBook(BookModel book);

  /// - deletes a book
  FutureEitherVoid deleteBook(BookModel book);

  /// - returns all the books for the current user
  StreamList<BookModel> getCurrentBooks();

  /// - returns all the books for the current user
  Future<List<BookModel>> getHistoryBooks();
}

@visibleForTesting
class BookApiFirebase implements BookApi {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  BookApiFirebase({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  @override
  FutureEitherVoid addBook(SearchBookModel book) async {
    try {
      await _currentUsersBooksReference.add(book.toMap());
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(BookFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(BookFailure());
    }
  }

  @override
  FutureEitherVoid deleteBook(BookModel book) async {
    try {
      return right(await _currentUsersBooksReference.doc(book.id).delete());
    } on FirebaseException catch (e) {
      return left(BookFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(BookFailure());
    }
  }

  @override
  FutureEitherVoid finishBook(BookModel book) async {
    try {
      await deleteBook(book);
      await _currentUsersReference.collection(FirebaseConstants.finishedBooksCollection).add(
            book.copyWith(dateCompleted: DateTime.now(), currentPage: book.pageCount).toMap(),
          );
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(BookFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(BookFailure());
    }
  }

  @override
  FutureEitherVoid updateBook(BookModel book) async {
    try {
      return right(_currentUsersBooksReference.doc(book.id).update({'currentPage': book.currentPage}));
    } on FirebaseException catch (e) {
      return left(BookFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(BookFailure());
    }
  }

  @override
  StreamList<BookModel> getCurrentBooks() {
    return _currentUsersBooksReference.orderBy('title').snapshots().map((event) {
      return event.docs.map((e) => BookModel.fromMap(e.data()).copyWith(id: e.id)).toList();
    });
  }

  @override
  Future<List<BookModel>> getHistoryBooks() async {
    final books = await _currentUsersReference
        .collection(FirebaseConstants.finishedBooksCollection)
        .orderBy('dateCompleted', descending: true)
        .get();

    return books.docs.map((e) => BookModel.fromMap(e.data()).copyWith(id: e.id)).toList();
  }

  CollectionReference<Map<String, dynamic>> get _currentUsersBooksReference {
    return _currentUsersReference.collection(FirebaseConstants.currentBooksCollection);
  }

  /// - return the current users document reference in firestore
  DocumentReference<Map<String, dynamic>> get _currentUsersReference {
    return _firebaseFirestore.collection(FirebaseConstants.usersCollection).doc(_firebaseAuth.currentUsersId);
  }
}
