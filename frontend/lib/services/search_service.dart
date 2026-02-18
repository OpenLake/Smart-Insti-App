
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(ref);
});

class SearchService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  SearchService(this._ref);

  Future<Map<String, dynamic>> search(String query) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/search', queryParameters: {'q': query});

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
