import 'package:equatable/equatable.dart';

class ClubBookModel extends Equatable {
  /// - dont include id in the json converters
  final String id;
  final String title;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;
  final DateTime? dueDate;

  const ClubBookModel({
    this.id = '',
    required this.title,
    required this.authors,
    required this.pageCount,
    this.coverImage,
    required this.dueDate,
  });

  ClubBookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverImage,
    DateTime? dueDate,
  }) {
    return ClubBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors,
      'pageCount': pageCount,
      'coverImage': coverImage,
      'dueDate': dueDate?.millisecondsSinceEpoch,
    };
  }

  factory ClubBookModel.fromMap(Map<String, dynamic> map) {
    return ClubBookModel(
      title: map['title'],
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'] ?? 0,
      coverImage: map['coverImage'] as String?,
      dueDate: map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : null,
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
      dueDate,
    ];
  }
}
