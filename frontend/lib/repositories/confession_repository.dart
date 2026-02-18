import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/confession.dart';

final confessionRepositoryProvider = Provider<ConfessionRepository>((ref) => ConfessionRepository());

class ConfessionRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<Confession>> getConfessions(String token, {int page = 1}) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.get('/confessions', queryParameters: {'page': page});
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Confession.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> createConfession(String content, String backgroundColor, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/confessions', data: {
        'content': content,
        'backgroundColor': backgroundColor
      });
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> likeConfession(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
        final response = await _client.put('/confessions/$id/like');
        return response.data['status'] == true;
    } catch (e) {
        _logger.e(e);
        return false;
    }
  }

  Future<bool> reportConfession(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
        final response = await _client.post('/confessions/$id/report');
        return response.data['status'] == true;
    } catch (e) {
        _logger.e(e);
        return false;
    }
  }
}
