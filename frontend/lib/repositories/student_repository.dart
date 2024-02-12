import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/student.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) => StudentRepository());

class StudentRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
    ),
  );

  final Logger _logger = Logger();

  Future<Student?> getStudentById(String id) async {
    try {
      final response = await _client.get('/student/$id');
      return Student.fromJson(response.data);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }
}
