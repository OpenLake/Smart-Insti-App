import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/campus_post.dart';

final campusPostRepositoryProvider =
    Provider<CampusPostRepository>((ref) => CampusPostRepository());

class CampusPostRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<CampusPost>> getCampusPosts(String token, {int page = 1}) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response =
          await _client.get('/campus-posts', queryParameters: {'page': page});
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => CampusPost.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> createCampusPost(
      String content, String backgroundColor, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/campus-posts',
          data: {'content': content, 'backgroundColor': backgroundColor});
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> likeCampusPost(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.put('/campus-posts/$id/like');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> reportCampusPost(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/campus-posts/$id/report');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
