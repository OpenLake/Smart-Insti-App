import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final authServiceProvider = Provider<AuthService>((_) => AuthService());

class AuthService {
  late final Dio _client;
  final _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  AuthService() {
    _client = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BACKEND_DOMAIN']!,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    _client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.read(key: 'refreshToken');
            if (refreshToken != null) {
              try {
                // Use a separate Dio instance to avoid infinite loops
                final refreshDio = Dio(BaseOptions(baseUrl: dotenv.env['BACKEND_DOMAIN']!));
                final response = await refreshDio.post(
                  '/general-auth/refresh-token',
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200 && response.data['status'] == true) {
                  final newAccessToken = response.data['accessToken'];
                  final newRefreshToken = response.data['refreshToken'];
                  
                  await _secureStorage.write(key: 'token', value: newAccessToken);
                  if (newRefreshToken != null) {
                    await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
                  }

                  // Retry the original request with new token
                  final opts = error.requestOptions;
                  opts.headers['Authorization'] = 'Bearer $newAccessToken';
                  
                  final clonedRequest = await _client.request(
                    opts.path,
                    options: Options(
                      method: opts.method,
                      headers: opts.headers,
                    ),
                    data: opts.data,
                    queryParameters: opts.queryParameters,
                  );
                  return handler.resolve(clonedRequest);
                }
              } catch (e) {
                // Refresh failed
                _logger.e("Token refresh failed: $e");
                await clearCredentials();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

   Future<void> saveCredentials(Map response) async {
    try {
      final data = response.containsKey('data') ? response['data'] : response;
      // Handle both flat and nested responses if needed, but usually it's in 'data'
      
      final credentials = {
        'token': data['token'] ?? '',
        'refreshToken': data['refreshToken'] ?? '', // Store refresh token
        '_id': data['_id'] ?? '',
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'role': data['role'] ?? '',
      };

      await _secureStorage.write(key: 'token', value: credentials['token']);
      await _secureStorage.write(key: 'refreshToken', value: credentials['refreshToken']);
      await _secureStorage.write(key: '_id', value: credentials['_id']);
      await _secureStorage.write(key: 'name', value: credentials['name']);
      await _secureStorage.write(key: 'email', value: credentials['email']);
      await _secureStorage.write(key: 'role', value: credentials['role']);
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<Map<String, String>> checkCredentials() async {
    Map<String, String> credentials = {};
    try {
      credentials = {
        'token': await _secureStorage.read(key: 'token') ?? '',
        'refreshToken': await _secureStorage.read(key: 'refreshToken') ?? '',
        '_id': await _secureStorage.read(key: '_id') ?? '',
        'name': await _secureStorage.read(key: 'name') ?? '',
        'email': await _secureStorage.read(key: 'email') ?? '',
        'role': await _secureStorage.read(key: 'role') ?? '',
      };
      return credentials;
    } catch (e) {
      _logger.e(e);
      return credentials;
    }
  }

  Future<bool> clearCredentials() async {
    try {
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'refreshToken');
      await _secureStorage.delete(key: '_id');
      await _secureStorage.delete(key: 'name');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'role');
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<void> logout() async {
    await clearCredentials();
  }

  Future<({int statusCode, String message})> sendOtp(
      String email, String loginForRole) async {
    try {
      final response = await _client.post(
        '/otp/send-otp',
        data: {
          'email': email,
          'loginForRole': loginForRole,
        },
      );
      _logger.i(response.data);
      return (
        statusCode: response.statusCode!,
        message: response.data['message'] as String
      );
    } catch (e) {
      _logger.e(e);
      if (e is DioException && e.response != null) {
        return (
          statusCode: e.response!.statusCode ?? 500,
          message: e.response!.data['message']?.toString() ?? 'Error'
        );
      }
      return (statusCode: 500, message: 'Internal Server Error');
    }
  }

  Future<({int statusCode, String message})> verifyOtp(
      String email, String otp) async {
    try {
      final response = await _client.post(
        '/otp/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      _logger.i(response.data);
      return (
        statusCode: response.statusCode!,
        message: response.data['message']?.toString() ?? '',
      );
    } catch (e) {
      _logger.e(e);
      if (e is DioException && e.response != null) {
        return (
          statusCode: e.response!.statusCode ?? 500,
          message: e.response!.data['message']?.toString() ?? 'Error'
        );
      }
      return (statusCode: 500, message: 'Internal Server Error');
    }
  }

  Future<Map<String, dynamic>> loginAdmin(String email, String password) async {
    try {
      final response = await _client.post(
        '/admin-auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      _logger.e(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> loginFacultyOrStudent(
      String email, String loginForRole) async {
    try {
      final response = await _client.post(
        '/general-auth/login',
        data: {
          'email': email,
          'loginForRole': loginForRole,
        },
      );
      return response.data;
    } catch (e) {
      _logger.e(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> registerStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await _client.post(
        '/general-auth/register',
        data: studentData,
      );
      return response.data;
    } catch (e) {
      _logger.e(e);
      return {};
    }
  }
}
