
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService(ref);
});

class AttendanceService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  AttendanceService(this._ref);

  Future<Map<String, dynamic>> markAttendance(String courseId, String sessionId, {Map<String, double>? location}) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.post('/attendance/mark', data: {
        'courseId': courseId,
        'sessionId': sessionId,
        'location': location
      });

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
          return e.response!.data;
      }
      return {'status': false, 'message': e.message};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  Future<List<dynamic>> getAttendanceHistory({String? courseId}) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/attendance/my-attendance', queryParameters: 
        courseId != null ? {'courseId': courseId} : null
      );

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getAttendanceStats() async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/attendance/stats');

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
