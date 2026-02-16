import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final studentDbRepositoryProvider = Provider<StudentDbRepository>((ref) => StudentDbRepository());

class StudentDbRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['STUDENT_DB_API_URL'] ?? 'http://localhost:8000',
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  // Announcements
  Future<List<dynamic>> getAnnouncements() async {
    try {
      final response = await _client.get('/api/announcements');
      if (response.statusCode == 200) {
        return response.data['announcements'];
      }
      return [];
    } catch (e) {
      _logger.e("Error fetching announcements: $e");
      return [];
    }
  }

  // Events
  Future<List<dynamic>> getEvents() async {
    try {
      final response = await _client.get('/api/events/events');
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      _logger.e("Error fetching events: $e");
      return [];
    }
  }

  // PORs (Council)
  Future<Map<String, dynamic>> getCurrentPORs() async {
    try {
      final response = await _client.get('/api/por/current');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      _logger.e("Error fetching PORs: $e");
      return {};
    }
  }
}
