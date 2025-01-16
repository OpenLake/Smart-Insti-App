import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../models/student.dart';

final studentRepositoryProvider =
    Provider<StudentRepository>((ref) => StudentRepository());

class StudentRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  final Logger _logger = Logger();

  Future<Student?> getStudentById(String id, String token) async {
    _client.options.headers['authorization'] = token;
    try {
      final response = await _client.get('/student/$id');
      return Student.fromJson(response.data);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  Future<bool> addStudent(Student student) async {
    try {
      _logger.i(student.toJson());
      final response = await _client.post(
        '/students',
        data: student.toJson(),
      );
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      final response = await _client.get('/students');
      _logger.i(response.data);
      return (response.data as List).map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      return DummyStudents.students;
    }
  }

  Future<Student> updateStudent(state) async {
    try {
      final response = await _client.put('/students/${state.student.id}',
          data: state.student.toJson());
      return Student.fromJson(response.data['user']);
    } catch (e) {
      return DummyStudents.students[0];
    }
  }

  Future<bool> deleteStudent(String id) async {
    try {
      await _client.delete('/student/$id');
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
