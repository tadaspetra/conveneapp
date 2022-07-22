part of 'club_controller.dart';

class CurrentClubListState extends Equatable {
  /// - defaults to empty
  final List<PersonalClubModel> clubs;

  /// - used to show a snackbar when an error occurs
  final String? failureMessage;
  const CurrentClubListState({this.clubs = const [], this.failureMessage});

  @override
  List<Object?> get props => [clubs, failureMessage];

  CurrentClubListState copyWith({
    List<PersonalClubModel>? clubs,
    String? failureMessage,
  }) {
    return CurrentClubListState(
      clubs: clubs ?? this.clubs,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }
}
