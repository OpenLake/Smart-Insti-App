import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../repositories/student_db_repository.dart';
import 'auth_provider.dart';

final postProvider = StateNotifierProvider<PostProvider, PostState>((ref) {
  return PostProvider(ref);
});

class PostState {
  final List<Post> posts;
  final bool isLoading;

  PostState({
    this.posts = const [],
    this.isLoading = false,
  });

  PostState copyWith({
    List<Post>? posts,
    bool? isLoading,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PostProvider extends StateNotifier<PostState> {
  final Ref _ref;
  final PostRepository _repository;
  final StudentDbRepository _studentDbRepository;
  final Logger _logger = Logger();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  PostProvider(this._ref)
      : _repository = _ref.read(postRepositoryProvider),
        _studentDbRepository = _ref.read(studentDbRepositoryProvider), // Fixed ref -> _ref
        super(PostState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _ref.read(authProvider).token ?? ""; // Optional token for GET?
      final posts = await _repository.getPosts(token);
      
      // Fetch announcements from Student DB
      final announcements = await _studentDbRepository.getAnnouncements();
      final announcementPosts = announcements.map((a) => Post(
        id: a['_id'],
        title: a['title'],
        content: a['content'],
        author: a['author']['personal_info']['name'] ?? "Admin",
        type: "Announcement",
        likes: [],
        createdAt: DateTime.parse(a['createdAt']),
      )).toList();

      state = state.copyWith(posts: [...posts, ...announcementPosts], isLoading: false);
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addPost() async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final newPost = Post(
          id: '',
          title: titleController.text,
          content: contentController.text,
          author: authorController.text,
          type: "News", // Default for now
          likes: [],
          createdAt: DateTime.now(),
        );
        final success = await _repository.addPost(newPost, token);
        if (success) {
          await loadPosts();
          clearControllers();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> likePost(String id) async {
    try {
      final token = _ref.read(authProvider).token;
      if (token != null) {
        final success = await _repository.likePost(id, token);
        if (success) {
          await loadPosts();
        }
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  void clearControllers() {
    titleController.clear();
    contentController.clear();
    authorController.clear();
  }
}
