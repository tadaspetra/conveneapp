import 'package:books_finder/books_finder.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';

class BooksFinderApi {
  Future<List<SearchBookModel>> searchBooks(String name) async {
    final List<SearchBookModel> _books = [];
    final books = await queryBooks(name,
        maxResults: 20, //TODO: How many books do we want to display
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
        reschemeImageLinks: true);

    for (final Book book in books) {
      _books.add(
        SearchBookModel(
          title: book.info.title,
          authors: book.info.authors,
          pageCount: book.info.pageCount,
          coverImage: book.info.imageLinks.isEmpty ? null : book.info.imageLinks["thumbnail"].toString(),
        ),
      );
    }

    return _books;
  }
}
