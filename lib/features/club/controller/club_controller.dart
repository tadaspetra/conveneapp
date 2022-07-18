// list of clubs being currently read by the user
import 'dart:async';

import 'package:conveneapp/apis/firebase/club.dart';
import 'package:conveneapp/core/errors/failures.dart';
import 'package:conveneapp/features/club/model/club_book_model.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/features/club/model/personal_club_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'club_state.dart';

final currentClubsController = AutoDisposeStateNotifierProvider<CurrentClubList,
    AsyncValue<CurrentClubListState>>((ref) {
  return CurrentClubList(clubApi: ref.watch(clubApiProvider));
});

class CurrentClubList extends StateNotifier<AsyncValue<CurrentClubListState>> {
  CurrentClubList({required ClubApi clubApi})
      : _clubApi = clubApi,
        super(const AsyncLoading()) {
    _getClubs();
  }

  final ClubApi _clubApi;
  late StreamSubscription<List<PersonalClubModel>> _clubsSubscription;

  /// - initialises the stream to listen for changes in the  `currentClubs`
  void _getClubs() async {
    _clubsSubscription = _clubApi.getCurrentClubs().listen((event) {
      state = AsyncValue.data(CurrentClubListState(clubs: event));
    }, cancelOnError: false);
  }

  Future<void> addClub({required ClubModel club}) async {
    final result = await _clubApi.addClub(club);
    _emitConditionalState(result);
  }

  Future<ClubModel> getClub({required String clubId}) async {
    final result = await _clubApi.getClub(clubId);
    _emitConditionalState(result);
    if (result.isRight()) {
      return result.getOrElse(() => const ClubModel(
          name: "error", members: [])); //TODO: not the best error handling
    } else {
      return const ClubModel(name: "error", members: []);
    }
  }

  Future<void> addMember(
      {required ClubModel club, required String memberId}) async {
    final result = await _clubApi.addMember(club, memberId);
    _emitConditionalState(result);
  }

  Future<void> removeFromClub(
      {required ClubModel club, required String memberId}) async {
    final result = await _clubApi.removeFromClub(club, memberId);
    _emitConditionalState(result);
  }

  Future<void> addBook(
      {required ClubModel club, required ClubBookModel book}) async {
    final result = await _clubApi.addBook(club, book);
    _emitConditionalState(result);
  }
  // Future<void> updateBook({required BookModel book}) async {
  //   final result = await _clubApi.updateBook(book);
  //   _emitConditionalState(result);
  // }

  // Future<void> finishBook({required BookModel book}) async {
  //   final result = await _clubApi.finishBook(book);
  //   _emitConditionalState(result);
  // }

  // Future<void> deleteBook({required BookModel book}) async {
  //   final result = await _clubApi.deleteBook(book);
  //   _emitConditionalState(result);
  // }

  void _emitConditionalState(Either<Failure, void> result) {
    if (!mounted) return;
    result.fold((failure) {
      //@tadaspetra throwing AsyncError is not ideal since a different widget will be shown
      // instead show a snack bar
      state.maybeMap(
        data: (data) {
          state = AsyncValue.data(
              data.value.copyWith(failureMessage: failure.message));
        },
        orElse: () {
          state = AsyncValue.data(
              CurrentClubListState(failureMessage: failure.message));
        },
      );
    }, (_) {
      state.mapOrNull(
        data: (data) {
          state = AsyncValue.data(data.value.copyWith(failureMessage: null));
        },
      );
    });
  }

  @override
  void dispose() {
    unawaited(_clubsSubscription.cancel());
    super.dispose();
  }
}
