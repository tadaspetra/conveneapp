import 'package:equatable/equatable.dart';

class ClubModel extends Equatable {
  /// - dont include id in the json converters
  final String id;
  final String name;
  final List<String> members;

  const ClubModel({
    this.id = '',
    required this.name,
    required this.members,
  });

  ClubModel copyWith({
    String? id,
    String? name,
    List<String>? members,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      name: map['name'],
      members: List<String>.from(map['members']),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      members,
    ];
  }
}
