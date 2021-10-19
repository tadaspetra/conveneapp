import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('users');

class BookApi {
  Future<List<BookModel>> getCurrentBooks({required String uid}) async {
    try {
      final books = await users.doc(uid).collection("currentBooks").orderBy("title").get();
      List<BookModel> _books = books.docs.map((e) => BookModel.fromMap(e.data()).copyWith(id: e.id)).toList();
      return _books;
    } catch (e) {
      log(e.toString());
      throw (e);
    }
  }

  Future<void> finishBook({required BookModel book, required String uid}) async {
    await users.doc(uid).collection("currentBooks").doc(book.id).delete();
    await users
        .doc(uid)
        .collection("finishedBooks")
        .add(book.copyWith(dateCompleted: DateTime.now(), currentPage: book.pageCount).toMap());
  }

  Future<void> addBook({required SearchBookModel book, required String uid}) async {
    await users.doc(uid).collection("currentBooks").add(book.toMap());
  }

  Future<void> updateBook({required BookModel book, required String uid}) async {
    return users.doc(uid).collection("currentBooks").doc(book.id).update(<String, dynamic>{
      'currentPage': book.currentPage,
    });
  }

  Future<void> deleteBook({required BookModel book, required String uid}) async {
    return users.doc(uid).collection("currentBooks").doc(book.id).delete();
  }
}
