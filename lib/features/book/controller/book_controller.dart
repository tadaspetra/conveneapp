// list of books being currently read by the user
import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentBooksController = StateNotifierProvider.family<CurrentBookList,
    AsyncValue<List<BookModel>>, String>((ref, uid) {
  return CurrentBookList(ref.read, uid);
});

class CurrentBookList extends StateNotifier<AsyncValue<List<BookModel>>> {
  final String uid;
  CurrentBookList(this.read, this.uid) : super(const AsyncLoading()) {
    _getBooks();
  }

  final Reader read;

  Future<void> _getBooks() async {
    try {
      final List<BookModel> books = await BookApi().getCurrentBooks(uid: uid);
      state = AsyncData(books);
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }

  Future<void> addBook({required SearchBookModel book}) async {
    try {
      await BookApi().addBook(book: book, uid: uid);
      final List<BookModel> books = await BookApi().getCurrentBooks(uid: uid);
      state = AsyncData(books);
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }

  Future<void> updateBook({required BookModel book}) async {
    try {
      await BookApi().updateBook(book: book, uid: uid);
      final List<BookModel> books = await BookApi().getCurrentBooks(uid: uid);
      state = AsyncData(books);
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }

  Future<void> finishBook({required BookModel book}) async {
    try {
      await BookApi().finishBook(book: book, uid: uid);
      final List<BookModel> books = await BookApi().getCurrentBooks(uid: uid);
      state = AsyncData(books);
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }

  Future<void> deleteBook({required BookModel book}) async {
    try {
      await BookApi().deleteBook(book: book, uid: uid);
      final List<BookModel> books = await BookApi().getCurrentBooks(uid: uid);
      state = AsyncData(books);
    } catch (e, st) {
      throw AsyncError<Exception>(e, st);
    }
  }
}
