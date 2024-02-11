import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/dummy_entries.dart';
import '../models/faculty.dart';

final facultyRepositoryProvider =
    Provider<FacultyRepository>((_) => FacultyRepository());
final storage = FlutterSecureStorage();

class FacultyRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<Faculty>> faculties() async {
    try {
      final response = await _client.get('/faculties');
      return (response.data as List).map((e) => Faculty.fromJson(e)).toList();
    } catch (e) {
      return DummyFaculties.faculties;
    }
  }

  Future<Faculty> getFaculty(String email) async {
    try {
      final id = await storage.read(key: email);
      final response = await _client.get('/faculties/$id');
      return Faculty.fromJson(response.data);
    } catch (e) {
      return DummyFaculties.faculties[0];
    }
  }

  Future<Faculty> addFaculty(String email) async {
    try {
      final response = await _client.post(
        '/faculties',
        data: {
          'email': email,
        },
      );

      storage.write(
          key: response.data['user']['email'], value: response.data['_id']);

      return Faculty.fromJson(response.data['user']);
    } catch (e) {
      return DummyFaculties.faculties[0];
    }
  }

  Future<Faculty> updateFaculty(Faculty faculty) async {
    try {
      final response =
          await _client.put('/faculties/${faculty.id}', data: faculty.toJson());
      return Faculty.fromJson(response.data['user']);
    } catch (e) {
      return DummyFaculties.faculties[0];
    }
  }

  Future<void> deleteFaculty(String id) async {
    try {
      await _client.delete('/faculties/$id');
    } catch (e) {
      return;
    }
  }
}
