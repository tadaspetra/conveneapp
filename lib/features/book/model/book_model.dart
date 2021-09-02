class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final int pageCount;
  final String coverImage;

  const BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.coverImage,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverImage,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
    );
  }
}
