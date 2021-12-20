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
  final double? rating;
  final String? review;

  const BookModel({
    this.id = '',
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.currentPage,
    this.coverImage,
    this.dateCompleted,
    this.rating,
    this.review,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverImage,
    int? currentPage,
    DateTime? dateCompleted,
    double? rating,
    String? review,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
      currentPage: currentPage ?? this.currentPage,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      rating: rating ?? this.rating,
      review: review ?? this.review,
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
      'rating': rating,
      'review': review,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'],
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'] ?? 0,
      coverImage: map['coverImage'] as String?,
      currentPage: map['currentPage'],
      dateCompleted: map['dateCompleted'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateCompleted']) : null,
      rating: map['rating'],
      review: map['review'],
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
      rating,
      review,
    ];
  }
}
