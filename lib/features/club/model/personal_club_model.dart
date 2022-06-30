import 'package:equatable/equatable.dart';

class PersonalClubModel extends Equatable {
  /// - dont include id in the json converters
  final String id;
  final String name;

  const PersonalClubModel({
    this.id = '',
    required this.name,
  });

  PersonalClubModel copyWith({
    String? id,
    String? name,
  }) {
    return PersonalClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory PersonalClubModel.fromMap(Map<String, dynamic> map) {
    return PersonalClubModel(
      name: map['name'],
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
    ];
  }
}
