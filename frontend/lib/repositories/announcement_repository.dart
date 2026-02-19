import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/announcement.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) => AnnouncementRepository());

class AnnouncementRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.hubApiBaseUrl,
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
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => Announcement.fromJson(e)).toList();
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
  Future<Announcement?> getAnnouncementById(String id, String token) async {
      _client.options.headers['authorization'] = 'Bearer $token';
      try {
          final response = await _client.get('/announcements/$id');
          if (response.statusCode == 200) {
              return Announcement.fromJson(response.data);
          }
          return null;
      } catch (e) {
          _logger.e(e);
          return null;
      }
  }

  Future<bool> updateAnnouncement(String id, Announcement announcement, String token) async {
      _client.options.headers['authorization'] = 'Bearer $token';
      try {
          final response = await _client.put('/announcements/$id', data: announcement.toJson());
          return response.data['status'] == true;
      } catch (e) {
          _logger.e(e);
          return false;
      }
  }
}
