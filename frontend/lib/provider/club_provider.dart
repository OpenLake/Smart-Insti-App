import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/club.dart';
import '../repositories/club_repository.dart';
import 'auth_provider.dart';

final clubProvider = StateNotifierProvider<ClubNotifier, ClubState>((ref) {
  return ClubNotifier(ref);
});

class ClubState {
  final List<Club> clubs;
  final bool isLoading;
  final Club? selectedClub;

  ClubState({
    this.clubs = const [],
    this.isLoading = false,
    this.selectedClub,
  });

  ClubState copyWith({
    List<Club>? clubs,
    bool? isLoading,
    Club? selectedClub,
  }) {
    return ClubState(
      clubs: clubs ?? this.clubs,
      isLoading: isLoading ?? this.isLoading,
      selectedClub: selectedClub ?? this.selectedClub,
    );
  }
}

class ClubNotifier extends StateNotifier<ClubState> {
  final Ref _ref;
  final ClubRepository _repository;

  ClubNotifier(this._ref)
      : _repository = _ref.read(clubRepositoryProvider),
        super(ClubState());

  Future<void> loadClubs() async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token;
    if (token != null) {
        final clubs = await _repository.getClubs(token);
        state = state.copyWith(clubs: clubs, isLoading: false);
    } else {
        state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadClubDetails(String id) async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token;
    if (token != null) {
        final club = await _repository.getClubDetails(id, token);
        state = state.copyWith(selectedClub: club, isLoading: false);
    } else {
        state = state.copyWith(isLoading: false);
    }
  }
}
