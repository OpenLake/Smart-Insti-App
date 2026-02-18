import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/confession.dart';
import '../repositories/confession_repository.dart';
import 'auth_provider.dart';

final confessionProvider = StateNotifierProvider<ConfessionNotifier, ConfessionState>((ref) {
  return ConfessionNotifier(ref);
});

class ConfessionState {
  final List<Confession> confessions;
  final bool isLoading;

  ConfessionState({
    this.confessions = const [],
    this.isLoading = false,
  });

  ConfessionState copyWith({
    List<Confession>? confessions,
    bool? isLoading,
  }) {
    return ConfessionState(
      confessions: confessions ?? this.confessions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConfessionNotifier extends StateNotifier<ConfessionState> {
  final Ref _ref;
  final ConfessionRepository _repository;
  final Logger _logger = Logger();

  ConfessionNotifier(this._ref)
      : _repository = _ref.read(confessionRepositoryProvider),
        super(ConfessionState());

  Future<void> loadConfessions() async {
    state = state.copyWith(isLoading: true);
    final token = _ref.read(authProvider).token;
    if (token != null) {
      final confessions = await _repository.getConfessions(token);
      state = state.copyWith(confessions: confessions, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> createConfession(String content, String backgroundColor) async {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      final success = await _repository.createConfession(content, backgroundColor, token);
      if (success) {
        loadConfessions();
        return true;
      }
    }
    return false;
  }

  Future<void> likeConfession(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          // Optimistic update? For now just reload
          await _repository.likeConfession(id, token);
          loadConfessions();
      }
  }

  Future<void> reportConfession(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          await _repository.reportConfession(id, token);
          // Don't need to reload, maybe show a snackbar in UI
      }
  }
}
