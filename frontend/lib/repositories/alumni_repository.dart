import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../models/alumni.dart';

final alumniRepositoryProvider = Provider<AlumniRepository>((ref) => AlumniRepository());

class AlumniRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  Future<Alumni?> getAlumniById(String id, String token) async {
    try {
      final response = await _client.get(
        '/alumni/$id',
        options: Options(
          headers: {'authorization': 'Bearer $token'},
        ),
      );
      if (response.data['status'] == true) {
        return Alumni.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
