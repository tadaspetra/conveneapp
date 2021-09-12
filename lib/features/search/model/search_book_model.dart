import 'dart:convert';

class SearchBookModel {
  final String title;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;

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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors,
      'pageCount': pageCount,
      'coverImage': coverImage,
    };
  }

  factory SearchBookModel.fromMap(Map<String, dynamic> map) {
    return SearchBookModel(
      title: map['title'],
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'],
      coverImage: map['coverImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchBookModel.fromJson(String source) => SearchBookModel.fromMap(json.decode(source));
}
