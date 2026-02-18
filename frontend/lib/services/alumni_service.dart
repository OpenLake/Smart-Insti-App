
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final alumniServiceProvider = Provider<AlumniService>((ref) {
  return AlumniService(ref);
});

class AlumniService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  AlumniService(this._ref);

  Future<List<dynamic>> getAlumni({String? branch, String? year, String? search}) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/alumni', queryParameters: {
          if (branch != null) 'branch': branch,
          if (year != null) 'graduationYear': year,
          if (search != null) 'search': search,
      });

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getFilters() async {
      try {
        final token = _ref.read(authProvider).token;
        _client.options.headers['authorization'] = 'Bearer $token';

        final response = await _client.get('/alumni/filters');

        if (response.data['status'] == true) {
            return response.data['data'];
        }
        return {'branches': [], 'years': []};
      } catch (e) {
        return {'branches': [], 'years': []};
      }
  }
}
