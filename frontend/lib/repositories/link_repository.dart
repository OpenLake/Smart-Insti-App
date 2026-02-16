import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/link.dart';

final linkRepositoryProvider = Provider<LinkRepository>((ref) => LinkRepository());

class LinkRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  final Logger _logger = Logger();

  Future<List<Link>> getLinks(String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.get('/links');
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Link.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> addLink(Link link, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/links', data: link.toJson());
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteLink(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.delete('/links/$id');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
