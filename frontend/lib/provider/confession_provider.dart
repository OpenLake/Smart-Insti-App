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
  final bool isLoading; // For initial load
  final bool isLoadingMore; // For pagination
  final int page;
  final bool hasMore;

  ConfessionState({
    this.confessions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.page = 1,
    this.hasMore = true,
  });

  ConfessionState copyWith({
    List<Confession>? confessions,
    bool? isLoading,
    bool? isLoadingMore,
    int? page,
    bool? hasMore,
  }) {
    return ConfessionState(
      confessions: confessions ?? this.confessions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
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

  Future<void> loadConfessions({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, hasMore: true, confessions: []);
    }

    // specific check for already loading or no more data (only if not refreshing)
    if (!refresh && (state.isLoading || state.isLoadingMore || !state.hasMore)) return;

    if (!refresh) {
      state = state.copyWith(isLoadingMore: true);
    }
    
    try {
        final token = _ref.read(authProvider).token;
        if (token != null) {
          final newConfessions = await _repository.getConfessions(token, page: state.page);
          
          if (refresh) {
             state = state.copyWith(
               confessions: newConfessions, 
               isLoading: false, 
               page: state.page + 1,
               hasMore: newConfessions.isNotEmpty
             );
          } else {
             state = state.copyWith(
               confessions: [...state.confessions, ...newConfessions],
               isLoadingMore: false,
               page: state.page + 1,
               hasMore: newConfessions.isNotEmpty
             );
          }
        } else {
          state = state.copyWith(isLoading: false, isLoadingMore: false);
        }
    } catch (e) {
        state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<bool> createConfession(String content, String backgroundColor) async {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      final success = await _repository.createConfession(content, backgroundColor, token);
      if (success) {
        loadConfessions(refresh: true);
        return true;
      }
    }
    return false;
  }

  Future<void> likeConfession(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          await _repository.likeConfession(id, token);
          // ideally separate like state update without full reload
          // for simplicity just reloading current view logic or better, optimistic update in state
          final updatedConfessions = state.confessions.map((c) {
             if (c.id == id) {
                final isLiked = !c.isLiked;
                final count = isLiked ? c.likeCount + 1 : c.likeCount - 1;
                return Confession(
                    id: c.id, 
                    content: c.content, 
                    backgroundColor: c.backgroundColor, 
                    createdAt: c.createdAt, 
                    isLiked: isLiked, 
                    likeCount: count
                );
             }
             return c;
          }).toList();
          state = state.copyWith(confessions: updatedConfessions);
      }
  }

  Future<void> reportConfession(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          await _repository.reportConfession(id, token);
      }
  }
}
