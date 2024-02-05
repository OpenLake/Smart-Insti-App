import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/models/student.dart';
import '../constants/dummy_entries.dart';

final studentRepositoryProvider =
    Provider<StudentRepository>((_) => StudentRepository());

class StudentRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<dynamic>> Students() async {
    try {
      final response = await _client.get('/students');
      return response.data.map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return DummyStudents.students;
    }
  }
}
