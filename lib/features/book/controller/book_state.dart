part of 'book_controller.dart';

class CurrentBookListState extends Equatable {
  /// - defaults to empty
  final List<BookModel> books;

  /// - used to show a snackbar when an error occurs
  final String? failureMessage;
  const CurrentBookListState({this.books = const [], this.failureMessage});

  @override
  List<Object?> get props => [books, failureMessage];

  CurrentBookListState copyWith({
    List<BookModel>? books,
    String? failureMessage,
  }) {
    return CurrentBookListState(
      books: books ?? this.books,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }
}
