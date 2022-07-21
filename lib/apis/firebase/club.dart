import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/firebase_api_providers.dart';
import 'package:conveneapp/core/constants/constants.dart';
import 'package:conveneapp/core/errors/errors.dart';
import 'package:conveneapp/core/extensions/extensions.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';
import 'package:conveneapp/features/club/model/club_book_model.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/features/club/model/personal_club_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clubApiProvider = Provider<ClubApi>((ref) => ClubApiFirebase(
    firebaseFirestore: ref.watch(firebaseFirestoreProvider), firebaseAuth: ref.watch(firebaseAuthProvider)));

/// - all the transactions must be pointed to the current user's reference
abstract class ClubApi {
  // /// - finishes a book and adds it to the `finishedBooks` reference
  // FutureEitherVoid finishBook(BookModel book);

  /// - create a new book
  FutureEitherVoid addClub(ClubModel club);

  FutureEither<ClubModel> getClub(String clubId);

  // /// - used to update the currentPage
  // FutureEitherVoid updateBook(BookModel book);

  // /// - deletes a book
  // FutureEitherVoid deleteBook(BookModel book);

  /// - returns all the books for the current user
  StreamList<PersonalClubModel> getCurrentClubs();

  FutureEitherVoid addMember(ClubModel club, String memberId);

  FutureEitherVoid addBook(ClubModel club, ClubBookModel book);

  FutureEitherVoid removeFromClub(ClubModel club, String memberId);

  // /// - returns all the history books for the current user
  // Future<Either<Failure, List<BookModel>>> getHistoryBooks();
}

@visibleForTesting
class ClubApiFirebase implements ClubApi {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  ClubApiFirebase({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  /// 2 Club Databases:
  /// - `_clubsReference`: stores all the clubs in the app
  /// - `_currentUsersClubsReference`: stores the clubs the user is currently a member of
  /// the user one will be used to display any data that you need on the dashboard.
  /// the other will be used when user clicks in a club to see the details of the club.
  @override
  FutureEitherVoid addClub(ClubModel club) async {
    try {
      DocumentReference<Map<String, dynamic>> doc = await _clubsReference.add(club.toMap());
      await _currentUsersClubsReference.doc(doc.id).set({
        'name': club.name,
      });
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(ClubFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(ClubFailure());
    }
  }

  @override
  FutureEither<ClubModel> getClub(String clubId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _clubsReference.doc(clubId).get();
      return right(ClubModel.fromMap(doc.data()!).copyWith(id: doc.id));
    } on FirebaseException catch (e) {
      return left(ClubFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(ClubFailure());
    }
  }

  @override
  FutureEitherVoid addMember(ClubModel club, String memberId) async {
    try {
      //if member already exists, arrayUnion will not add it again
      await _clubsReference.doc(club.id).update({
        'members': FieldValue.arrayUnion([memberId]),
      });
      //if already in club, will just overwrite and not a problem
      await _currentUsersClubsReference.doc(club.id).set({
        'name': club.name,
      });
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(ClubFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(ClubFailure());
    }
  }

  @override
  FutureEitherVoid removeFromClub(ClubModel club, String memberId) async {
    try {
      //if member already exists, arrayUnion will not add it again
      await _clubsReference.doc(club.id).update({
        'members': FieldValue.arrayRemove([memberId]),
      });
      //if already in club, will just overwrite and not a problem
      await _currentUsersClubsReference.doc(club.id).delete();
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(ClubFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(ClubFailure());
    }
  }

  @override
  FutureEitherVoid addBook(ClubModel club, ClubBookModel book) async {
    try {
      //if member already exists, arrayUnion will not add it again
      await _clubsReference.doc(club.id).update({
        'currentBook': book.toMap(),
      });
      //TODO: add to everybodies indiviual reading
      return right(Future<void>.value());
    } on FirebaseException catch (e) {
      return left(ClubFailure.fromCode(e.code));
    } on Exception catch (_) {
      return left(ClubFailure());
    }
  }

  // @override
  // FutureEitherVoid deleteBook(BookModel book) async {
  //   try {
  //     return right(await _currentUsersBooksReference.doc(book.id).delete());
  //   } on FirebaseException catch (e) {
  //     return left(ClubFailure.fromCode(e.code));
  //   } on Exception catch (_) {
  //     return left(ClubFailure());
  //   }
  // }

  // @override
  // FutureEitherVoid finishBook(BookModel book) async {
  //   try {
  //     await deleteBook(book);
  //     await _currentUsersReference.collection(FirebaseConstants.finishedBooksCollection).add(
  //           book.copyWith(dateCompleted: DateTime.now(), currentPage: book.pageCount).toMap(),
  //         );
  //     return right(Future<void>.value());
  //   } on FirebaseException catch (e) {
  //     return left(ClubFailure.fromCode(e.code));
  //   } on Exception catch (_) {
  //     return left(ClubFailure());
  //   }
  // }

  // @override
  // FutureEitherVoid updateBook(BookModel book) async {
  //   try {
  //     return right(_currentUsersBooksReference.doc(book.id).update({'currentPage': book.currentPage}));
  //   } on FirebaseException catch (e) {
  //     return left(ClubFailure.fromCode(e.code));
  //   } on Exception catch (_) {
  //     return left(ClubFailure());
  //   }
  // }

  @override
  StreamList<PersonalClubModel> getCurrentClubs() {
    return _currentUsersClubsReference.orderBy('name').snapshots().map((event) {
      return event.docs.map((e) => PersonalClubModel.fromMap(e.data()).copyWith(id: e.id)).toList();
    });
  }

  // @override
  // Future<Either<Failure, List<BookModel>>> getHistoryBooks() async {
  //   try {
  //     final books = await _currentUsersReference
  //         .collection(FirebaseConstants.finishedBooksCollection)
  //         .orderBy('dateCompleted', descending: true)
  //         .get();

  //     return right(books.docs.map((e) => BookModel.fromMap(e.data()).copyWith(id: e.id)).toList());
  //   } catch (e) {
  //     return left(ClubFailure());
  //   }
  // }

  CollectionReference<Map<String, dynamic>> get _clubsReference {
    return _firebaseFirestore.collection(FirebaseConstants.clubsCollection);
  }

  CollectionReference<Map<String, dynamic>> get _currentUsersClubsReference {
    return _currentUsersReference.collection(FirebaseConstants.currentClubsCollection);
  }

  /// - return the current users document reference in firestore
  DocumentReference<Map<String, dynamic>> get _currentUsersReference {
    return _firebaseFirestore.collection(FirebaseConstants.usersCollection).doc(_firebaseAuth.currentUsersId);
  }
}
