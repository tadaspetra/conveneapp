import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';

final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

class BookApi {
  Future<List<BookModel>> getCurrentBooks({required String uid}) async {
    final List<BookModel> _books = [];
    final books =
        await users.doc(uid).collection("currentBooks").orderBy("title").get();

    for (final book in books.docs) {
      _books.add(
        BookModel(
          id: book.id,
          authors: List<String>.from(book["authors"]),
          coverImage: book["coverImage"],
          currentPage: book.data()['currentPage'] ?? 0,
          pageCount: book["pageCount"],
          title: book["title"],
        ),
      );
    }

    // TODO: why does this not work?
    // try {
    //   books.docs.map((e) {
    //     _books.add(BookModel.fromMap(e.data()));
    //   });
    // } catch (e) {
    //   print(e);
    // }
    // print(_books);

    return _books;
  }

  Future<void> finishBook(
      {required BookModel book, required String uid}) async {
    await users.doc(uid).collection("currentBooks").doc(book.id).delete();
    await users.doc(uid).collection("finishedBooks").add(book
        .copyWith(dateCompleted: DateTime.now(), currentPage: book.pageCount)
        .toMap());
  }

  Future<void> addBook(
      {required SearchBookModel book, required String uid}) async {
    await users.doc(uid).collection("currentBooks").add(book.toMap());
  }

  Future<void> updateBook(
      {required BookModel book, required String uid}) async {
    return users
        .doc(uid)
        .collection("currentBooks")
        .doc(book.id)
        .update(<String, dynamic>{
      'currentPage': book.currentPage,
    });
  }

  Future<void> deleteBook(
      {required BookModel book, required String uid}) async {
    return users.doc(uid).collection("currentBooks").doc(book.id).delete();
  }
}
