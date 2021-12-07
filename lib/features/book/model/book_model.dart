import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  /// - dont include id in the json converters
  final String id;
  final String title;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;
  final int currentPage;
  final DateTime? dateCompleted;

  const BookModel({
    this.id = '',
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.currentPage,
    this.coverImage,
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
      'title': title,
      'authors': authors,
      'pageCount': pageCount,
      'coverImage': coverImage,
      'currentPage': currentPage,
      'dateCompleted': dateCompleted?.millisecondsSinceEpoch,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'],
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'],
      coverImage: map['coverImage'] as String?,
      currentPage: map['currentPage'],
      dateCompleted: map['dateCompleted'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateCompleted']) : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      title,
      authors,
      pageCount,
      coverImage,
      currentPage,
      dateCompleted,
    ];
  }
}
