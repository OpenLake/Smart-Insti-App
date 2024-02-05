import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/models/Faculty.dart';
import '../constants/dummy_entries.dart';

final facultyRepositoryProvider =
    Provider<FacultyRepository>((_) => FacultyRepository());

class FacultyRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  Future<List<dynamic>> Faculties() async {
    try {
      final response = await _client.get('/faculties');
      return response.data.map((e) => Faculty.fromJson(e)).toList();
    } catch (e) {
      return DummyFaculties.faculties;
    }
  }
}
