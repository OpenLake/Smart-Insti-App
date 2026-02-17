import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alumni.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final alumniRepositoryProvider = Provider<AlumniRepository>((ref) => AlumniRepository());

class AlumniRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  Future<Alumni?> getAlumniById(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    final response = await _client.get('/alumni/$id');
    return Alumni.fromJson(response.data['data']);
  }
}
