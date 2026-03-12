import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/campus_post.dart';
import '../repositories/campus_post_repository.dart';
import 'auth_provider.dart';

final campusPostProvider =
    StateNotifierProvider<CampusPostNotifier, CampusPostState>((ref) {
  return CampusPostNotifier(ref);
});

class CampusPostState {
  final List<CampusPost> posts;
  final bool isLoading; // For initial load
  final bool isLoadingMore; // For pagination
  final int page;
  final bool hasMore;

  CampusPostState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.page = 1,
    this.hasMore = true,
  });

  CampusPostState copyWith({
    List<CampusPost>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    int? page,
    bool? hasMore,
  }) {
    return CampusPostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CampusPostNotifier extends StateNotifier<CampusPostState> {
  final Ref _ref;
  final CampusPostRepository _repository;
  final Logger _logger = Logger();

  CampusPostNotifier(this._ref)
      : _repository = _ref.read(campusPostRepositoryProvider),
        super(CampusPostState());

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      state = state
          .copyWith(isLoading: true, page: 1, hasMore: true, posts: []);
    }

    // specific check for already loading or no more data (only if not refreshing)
    if (!refresh && (state.isLoading || state.isLoadingMore || !state.hasMore))
      return;

    if (!refresh) {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final newPosts =
            await _repository.getCampusPosts(token, page: state.page);

        if (refresh) {
          state = state.copyWith(
              posts: newPosts,
              isLoading: false,
              page: state.page + 1,
              hasMore: newPosts.isNotEmpty);
        } else {
          state = state.copyWith(
              posts: [...state.posts, ...newPosts],
              isLoadingMore: false,
              page: state.page + 1,
              hasMore: newPosts.isNotEmpty);
        }
      } else {
        state = state.copyWith(isLoading: false, isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<bool> createPost(String content, String backgroundColor) async {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      final success =
          await _repository.createCampusPost(content, backgroundColor, token);
      if (success) {
        loadPosts(refresh: true);
        return true;
      }
    }
    return false;
  }

  Future<void> likePost(String id) async {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      await _repository.likeCampusPost(id, token);
      // optimistic update in state
      final updatedPosts = state.posts.map((p) {
        if (p.id == id) {
          final isLiked = !p.isLiked;
          final count = isLiked ? p.likeCount + 1 : p.likeCount - 1;
          return CampusPost(
              id: p.id,
              content: p.content,
              backgroundColor: p.backgroundColor,
              createdAt: p.createdAt,
              isLiked: isLiked,
              likeCount: count);
        }
        return p;
      }).toList();
      state = state.copyWith(posts: updatedPosts);
    }
  }

  Future<void> reportPost(String id) async {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      await _repository.reportCampusPost(id, token);
    }
  }
}
