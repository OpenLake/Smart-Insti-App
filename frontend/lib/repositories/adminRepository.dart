import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/admin.dart';

final adminRepositoryProvider = Provider<AdminRepository>((_) => AdminRepository());

class AdminRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  final Logger _logger = Logger();

  Future<Admin?> getAdminById(String id) async {
    try {
      final response = await _client.get('/admin/$id');
      return Admin.fromJson(response.data);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }
}
