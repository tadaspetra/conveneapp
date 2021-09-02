class SearchBookModel {
  final String title;
  final List<String> authors;
  final int pageCount;
  final String coverImage;

  const SearchBookModel({
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.coverImage,
  });

  SearchBookModel copyWith({
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverImage,
  }) {
    return SearchBookModel(
      title: title ?? this.title,
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
    );
  }
}
