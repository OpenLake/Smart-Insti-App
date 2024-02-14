import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/timtable.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) => TimetableRepository());

class TimetableRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  final Logger _logger = Logger();

  Future<List<Timetable>> getTimetables(String token) async {
    _client.options.headers['authorization'] = token;
    try {
      final response = await _client.get('/timetable');
      return (response.data as List).map((e) => Timetable.fromJson(e)).toList();
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<Timetable?> getTimetableById(String id, String token) async {
    _client.options.headers['authorization'] = token;
    try {
      final response = await _client.get('/timetable/$id');
      return Timetable.fromJson(response.data);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }
}
