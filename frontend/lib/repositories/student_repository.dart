import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/dummy_entries.dart';
import '../models/student.dart';
import '../provider/user_provider.dart';

final studentRepositoryProvider =
    Provider<StudentRepository>((_) => StudentRepository());
final storage = FlutterSecureStorage();

class StudentRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<Student>> students() async {
    try {
      final response = await _client.get('/students');
      return (response.data as List).map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      return DummyStudents.students;
    }
  }

  Future<Student> getStudent(String email) async {
    try {
      final id = await storage.read(key: email);
      final response = await _client.get('/students/$id');
      return Student.fromJson(response.data);
    } catch (e) {
      return DummyStudents.students[0];
    }
  }

  Future<Student> addStudent(String email) async {
    try {
      final response = await _client.post(
        '/students',
        data: {
          'email': email,
        },
      );

      storage.write(
          key: response.data['user']['email'], value: response.data['_id']);

      return Student.fromJson(response.data['user']);
    } catch (e) {
      return DummyStudents.students[0];
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

  Future<void> deleteStudent(String id) async {
    try {
      await _client.delete('/students/$id');
    } catch (e) {
      return;
    }
  }
}
