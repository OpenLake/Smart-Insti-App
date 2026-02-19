import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../models/student.dart';

final studentRepositoryProvider =
    Provider<StudentRepository>((ref) => StudentRepository());

class StudentRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );


  Future<Student?> getStudentById(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    final response = await _client.get('/student/$id');
    return Student.fromJson(response.data['data']);
  }

  Future<Student> addStudent(String email) async {
    try {
      final response = await _client.post(
        '/students',
        data: {
          'email': email,
        },
      );

      return Student.fromJson(response.data['data']);
    } catch (e) {
      return DummyStudents.students[0];
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      final response = await _client.get('/students');
      return (response.data['data'] as List).map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      return DummyStudents.students;
    }
  }

  Future<Student> updateStudent(state) async {
    try {
      final response = await _client.put('/students/${state.student.id}',
          data: state.student.toJson());
      return Student.fromJson(response.data['data']);
    } catch (e) {
      return DummyStudents.students[0];
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _client.delete('/students/$id');
    } catch (e) {
      return;
    }
  }
}
