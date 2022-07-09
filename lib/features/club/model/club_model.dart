import 'package:conveneapp/features/club/model/club_book_model.dart';
import 'package:equatable/equatable.dart';

class ClubModel extends Equatable {
  /// - dont include id in the json converters
  final String id;
  final String name;
  final List<String> members;
  final ClubBookModel? currentBook;

  const ClubModel({
    this.id = '',
    required this.name,
    required this.members,
    this.currentBook,
  });

  ClubModel copyWith({
    String? id,
    String? name,
    List<String>? members,
    ClubBookModel? currentBook,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      currentBook: currentBook ?? this.currentBook,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
      'currentBook': currentBook?.toMap(),
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      name: map['name'],
      members: List<String>.from(map['members']),
      currentBook: map['currentBook'] != null
          ? ClubBookModel.fromMap(map['currentBook'])
          : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      members,
      currentBook,
    ];
  }
}
