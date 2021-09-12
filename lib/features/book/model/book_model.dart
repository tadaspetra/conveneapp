import 'dart:convert';

class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;
  final int currentPage;
  final DateTime? dateCompleted;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.coverImage,
    required this.currentPage,
    this.dateCompleted,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverImage,
    int? currentPage,
    DateTime? dateCompleted,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
      currentPage: currentPage ?? this.currentPage,
      dateCompleted: dateCompleted ?? this.dateCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'pageCount': pageCount,
      'coverImage': coverImage,
      'currentPage': currentPage,
      'dateCompleted': dateCompleted,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'] ?? 0,
      coverImage: map['coverImage'],
      currentPage: map['currentPage'],
      dateCompleted: DateTime.fromMillisecondsSinceEpoch(map['dateCompleted']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) => BookModel.fromMap(json.decode(source));
}
