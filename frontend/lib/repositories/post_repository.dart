import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/post.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => PostRepository());

class PostRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  final Logger _logger = Logger();

  Future<List<Post>> getPosts(String token) async {
    _client.options.headers['authorization'] = 'Bearer $token'; // Though GET /news is public? Wait, my backend implementation of GET /news didn't use `tokenRequired`.
    // Actually, `newsResource.get("/", async (req, res)...` did NOT use tokenRequired.
    // So token is optional? But if I pass it, it doesn't hurt.
    try {
      final response = await _client.get('/news');
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Post.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> addPost(Post post, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/news', data: post.toJson());
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> likePost(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.put('/news/$id/like');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
