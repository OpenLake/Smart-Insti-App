
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final transportServiceProvider = Provider<TransportService>((ref) {
  return TransportService(ref);
});

class TransportService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  TransportService(this._ref);

  Future<List<dynamic>> getBusRoutes() async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/transport');

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
