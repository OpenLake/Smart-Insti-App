import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../models/admin.dart';

final adminRepositoryProvider = Provider<AdminRepository>((_) => AdminRepository());

class AdminRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );


  Future<Admin?> getAdminById(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    final response = await _client.get('/admin/$id');
    return Admin.fromJson(response.data['data']);
  }
}
