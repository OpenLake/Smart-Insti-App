import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/faculty.dart';

final facultyRepositoryProvider = Provider<FacultyRepository>((ref) => FacultyRepository());

class FacultyRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
    ),
  );

  final Logger _logger = Logger();

  Future<Faculty?> getFacultyById(String id, String token) async {
    _client.options.headers['authorization'] = token;
    try {
      final response = await _client.get('/faculty/$id');
      return Faculty.fromJson(response.data);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }
}
