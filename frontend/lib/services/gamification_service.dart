
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService(ref);
});

class GamificationService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  GamificationService(this._ref);

  Future<List<dynamic>> getLeaderboard() async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/leaderboard');

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
