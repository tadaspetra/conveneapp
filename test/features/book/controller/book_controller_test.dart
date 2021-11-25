import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

class MockBookApi extends Mock implements BookApi {}

class FakeSearchBookModel extends Fake implements SearchBookModel {}

class FakeBookModel extends Fake implements BookModel {}

void main() {
  late MockBookApi mockBookApi;
  late CurrentBookList currentBookList;

  void mockEmptyCurrentBooks([List<BookModel>? value]) {
    when(() => mockBookApi.getCurrentBooks())
        .thenAnswer((_) => value != null ? Stream.value(value) : const Stream.empty());
  }

  setUp(() {
    mockBookApi = MockBookApi();
    registerFallbackValue(FakeSearchBookModel());
    registerFallbackValue(FakeBookModel());
  });

  const expectedBookState = AsyncData(CurrentBookListState(books: [bookModel]));

  void setUpNotifiers() {
    currentBookList = CurrentBookList(bookApi: mockBookApi);
  }

  final bookFailure = BookFailure('error');
  group('getBooks', () {
    test('should [set] the state when data is received', () {
      when(() => mockBookApi.getCurrentBooks()).thenAnswer((_) => Stream.value([bookModel]));
      setUpNotifiers();

      expect(currentBookList.stream, emitsInOrder([expectedBookState]));
    });
  });

  group('addBook', () {
    test('should [add] new book when called and set failure message to null', () async {
      mockEmptyCurrentBooks([]);
      setUpNotifiers();

      when(() => mockBookApi.addBook(any())).thenAnswer((_) async => right(Future<void>.value()));

      // ordering is important
      expectLater(
          currentBookList.stream,
          emitsInOrder(const [
            AsyncValue.data(
              CurrentBookListState(
                books: [],
                failureMessage: null,
              ),
            ),
          ]));

      await currentBookList.addBook(book: searchBookModel);
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [adding] a new book and current state is not AsyncData
    ''', () async {
      mockEmptyCurrentBooks();
      setUpNotifiers();
      when(() => mockBookApi.addBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(currentBookList.stream,
          emitsInOrder([AsyncValue.data(CurrentBookListState(failureMessage: bookFailure.message))]));

      await currentBookList.addBook(book: searchBookModel);

      verify(() => mockBookApi.addBook(any()));
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [adding] a new book and current state is  AsyncData
    ''', () async {
      mockEmptyCurrentBooks([bookModel]);
      setUpNotifiers();
      when(() => mockBookApi.addBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(
          currentBookList.stream,
          emitsInOrder([
            const AsyncValue.data(
              CurrentBookListState(
                failureMessage: null,
                books: [bookModel],
              ),
            ),
            AsyncValue.data(
              CurrentBookListState(
                failureMessage: bookFailure.message,
                books: const [bookModel],
              ),
            )
          ]));

      await currentBookList.addBook(book: searchBookModel);

      verify(() => mockBookApi.addBook(any()));
    });
  });

  group('update', () {
    test('should  [update] book when called and set failure message to null', () async {
      mockEmptyCurrentBooks([]);
      setUpNotifiers();

      when(() => mockBookApi.updateBook(any())).thenAnswer((_) async => right(Future<void>.value()));

      // ordering is important
      expectLater(
          currentBookList.stream,
          emitsInOrder(const [
            AsyncValue.data(
              CurrentBookListState(
                books: [],
                failureMessage: null,
              ),
            ),
          ]));

      await currentBookList.updateBook(book: bookModel);
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [updating] and current state is not AsyncData
    ''', () async {
      mockEmptyCurrentBooks();
      setUpNotifiers();
      when(() => mockBookApi.updateBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(currentBookList.stream,
          emitsInOrder([AsyncValue.data(CurrentBookListState(failureMessage: bookFailure.message))]));

      await currentBookList.updateBook(book: bookModel);

      verify(() => mockBookApi.updateBook(any()));
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [updating] and current state is  AsyncData
    ''', () async {
      mockEmptyCurrentBooks([bookModel]);
      setUpNotifiers();
      when(() => mockBookApi.updateBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(
          currentBookList.stream,
          emitsInOrder([
            const AsyncValue.data(
              CurrentBookListState(
                failureMessage: null,
                books: [bookModel],
              ),
            ),
            AsyncValue.data(
              CurrentBookListState(
                failureMessage: bookFailure.message,
                books: const [bookModel],
              ),
            )
          ]));

      await currentBookList.updateBook(book: bookModel);

      verify(() => mockBookApi.updateBook(any()));
    });
  });

  group('finishBook', () {
    test('should [finish]  book when called and set failure message to null', () async {
      mockEmptyCurrentBooks([]);
      setUpNotifiers();

      when(() => mockBookApi.finishBook(any())).thenAnswer((_) async => right(Future<void>.value()));

      // ordering is important
      expectLater(
          currentBookList.stream,
          emitsInOrder(const [
            AsyncValue.data(
              CurrentBookListState(
                books: [],
                failureMessage: null,
              ),
            ),
          ]));

      await currentBookList.finishBook(book: bookModel);
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [finishing] a book and current state is not AsyncData
    ''', () async {
      mockEmptyCurrentBooks();
      setUpNotifiers();
      when(() => mockBookApi.finishBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(currentBookList.stream,
          emitsInOrder([AsyncValue.data(CurrentBookListState(failureMessage: bookFailure.message))]));

      await currentBookList.finishBook(book: bookModel);

      verify(() => mockBookApi.finishBook(any()));
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [finishing] a book and current state is  AsyncData
    ''', () async {
      mockEmptyCurrentBooks([bookModel]);
      setUpNotifiers();
      when(() => mockBookApi.finishBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(
          currentBookList.stream,
          emitsInOrder([
            const AsyncValue.data(
              CurrentBookListState(
                failureMessage: null,
                books: [bookModel],
              ),
            ),
            AsyncValue.data(
              CurrentBookListState(
                failureMessage: bookFailure.message,
                books: const [bookModel],
              ),
            )
          ]));

      await currentBookList.finishBook(book: bookModel);

      verify(() => mockBookApi.finishBook(any()));
    });
  });

  group('delete', () {
    test('should [delete]  book when called and set failure message to null', () async {
      mockEmptyCurrentBooks([]);
      setUpNotifiers();

      when(() => mockBookApi.deleteBook(any())).thenAnswer((_) async => right(Future<void>.value()));

      // ordering is important
      expectLater(
          currentBookList.stream,
          emitsInOrder(const [
            AsyncValue.data(
              CurrentBookListState(
                books: [],
                failureMessage: null,
              ),
            ),
          ]));

      await currentBookList.deleteBook(book: bookModel);
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [deleting] a book and current state is not AsyncData
    ''', () async {
      mockEmptyCurrentBooks();
      setUpNotifiers();
      when(() => mockBookApi.deleteBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(currentBookList.stream,
          emitsInOrder([AsyncValue.data(CurrentBookListState(failureMessage: bookFailure.message))]));

      await currentBookList.deleteBook(book: bookModel);

      verify(() => mockBookApi.deleteBook(any()));
    });

    test('''
    should emit [AsyncValue.data(CurrentBookListState(failureMessage: error))]
    when a failure occurs when [deleting] a book and current state is  AsyncData
    ''', () async {
      mockEmptyCurrentBooks([bookModel]);
      setUpNotifiers();
      when(() => mockBookApi.deleteBook(any())).thenAnswer((_) async => left(bookFailure));

      expectLater(
          currentBookList.stream,
          emitsInOrder([
            const AsyncValue.data(
              CurrentBookListState(
                failureMessage: null,
                books: [bookModel],
              ),
            ),
            AsyncValue.data(
              CurrentBookListState(
                failureMessage: bookFailure.message,
                books: const [bookModel],
              ),
            )
          ]));

      await currentBookList.deleteBook(book: bookModel);

      verify(() => mockBookApi.deleteBook(any()));
    });
  });

  group('dispose', () {
    test('should unsubscribe from the [currentBooks] stream when controller is disposed', () {
      mockEmptyCurrentBooks();
      setUpNotifiers();

      currentBookList.dispose();

      expect(currentBookList.mounted, isFalse);
    });
  });

  group('currentBooksController', () {
    test('should return an instance of CurrentBookList', () {
      mockEmptyCurrentBooks();
      final container = ProviderContainer(overrides: [
        bookApiProvider.overrideWithValue(mockBookApi),
      ]);

      expect(container.read(currentBooksController.notifier), isA<CurrentBookList>());
    });
  });
}
