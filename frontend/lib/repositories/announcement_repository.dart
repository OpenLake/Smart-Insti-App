import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/announcement.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) => AnnouncementRepository());

class AnnouncementRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  final Logger _logger = Logger();

  Future<List<Announcement>> getAnnouncements(String token, {String? type}) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final Map<String, dynamic> queryParams = {};
      if (type != null && type != 'All') queryParams['type'] = type;

      final response = await _client.get('/announcements', queryParameters: queryParams);
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Announcement.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> createAnnouncement(Announcement announcement, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/announcements', data: announcement.toJson());
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteAnnouncement(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.delete('/announcements/$id');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
