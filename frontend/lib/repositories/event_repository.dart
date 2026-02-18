import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/event.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) => EventRepository());

class EventRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<Event>> getEvents(String token) async {
    // _client.options.headers['authorization'] = 'Bearer $token'; 
    try {
      final response = await _client.get('/events');
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> createEvent(Map<String, dynamic> data, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token'; 
    try {
      final response = await _client.post('/events', data: data);
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteEvent(String id, String token) async {
      _client.options.headers['authorization'] = 'Bearer $token';
      try {
          final response = await _client.delete('/events/$id');
          return response.data['status'] == true;
      } catch (e) {
          _logger.e(e);
          return false;
      }
  }
}
