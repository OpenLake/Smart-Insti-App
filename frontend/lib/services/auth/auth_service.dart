import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final authServiceProvider = Provider<AuthService>((_) => AuthService());

class AuthService {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
    ),
  );

  final _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  void loginStudent() async {
    try {
      final response = await _client.post('/login/student');
      _logger.i(response.data);
    } catch (e) {
      _logger.e(e);
    }
  }
}
