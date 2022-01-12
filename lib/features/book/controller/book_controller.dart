// list of books being currently read by the user
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
part 'book_state.dart';

final currentBooksController =
    AutoDisposeStateNotifierProvider<CurrentBookList, AsyncValue<CurrentBookListState>>((ref) {
  return CurrentBookList(bookApi: ref.watch(bookApiProvider));
});

class CurrentBookList extends StateNotifier<AsyncValue<CurrentBookListState>> {
  CurrentBookList({required BookApi bookApi})
      : _bookApi = bookApi,
        super(const AsyncLoading()) {
    _getBooks();
  }

  final BookApi _bookApi;
  late StreamSubscription<List<BookModel>> _booksSubscription;

  /// - initialises the stream to listen for changes in the  `currentBooks`
  void _getBooks() async {
    _booksSubscription = _bookApi.getCurrentBooks().listen((event) {
      state = AsyncValue.data(CurrentBookListState(books: event));
    }, cancelOnError: false);
  }

  Future<void> addBook({required SearchBookModel book}) async {
    final result = await _bookApi.addBook(book);
    _emitConditionalState(result);
  }

  Future<void> updateBook({required BookModel book}) async {
    final result = await _bookApi.updateBook(book);
    _emitConditionalState(result);
  }

  Future<void> finishBook({required BookModel book}) async {
    final result = await _bookApi.finishBook(book);
    _emitConditionalState(result);
  }

  Future<void> deleteBook({required BookModel book}) async {
    final result = await _bookApi.deleteBook(book);
    _emitConditionalState(result);
  }

  void _emitConditionalState(Either<Failure, void> result) {
    result.fold((failure) {
      //@tadaspetra throwing AsyncError is not ideal since a different widget will be shown
      // instead show a snack bar
      state.maybeMap(
        data: (data) {
          state = AsyncValue.data(data.value.copyWith(failureMessage: failure.message));
        },
        orElse: () {
          state = AsyncValue.data(CurrentBookListState(failureMessage: failure.message));
        },
      );
    }, (_) {
      state.mapOrNull(
        data: (data) {
          state = AsyncValue.data(data.value.copyWith(failureMessage: null));
        },
      );
    });
  }

  @override
  void dispose() {
    unawaited(_booksSubscription.cancel());
    super.dispose();
  }
}
