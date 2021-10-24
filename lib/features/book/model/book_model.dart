import 'dart:convert';

class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;
  final int currentPage;
  final DateTime? dateCompleted;

  static const idKey = 'id';
  static const titleKey = 'title';
  static const authorsKey = 'authors';
  static const pageCountKey = 'pageCount';
  static const coverImageKey = 'coverImage';
  static const currentPageKey = 'currentPage';
  static const dateCompletedKey = 'dateCompleted';

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
      idKey: id,
      titleKey: title,
      authorsKey: authors,
      pageCountKey: pageCount,
      coverImageKey: coverImage,
      currentPageKey: currentPage,
      dateCompletedKey: dateCompleted,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map[idKey] ?? "",
      title: map[titleKey],
      authors: List<String>.from(map[authorsKey]),
      pageCount: map[pageCountKey] ?? 0,
      coverImage: map[coverImageKey],
      currentPage: map[currentPageKey] ?? 0,
      dateCompleted: map[dateCompletedKey] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[dateCompletedKey])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source));
}
