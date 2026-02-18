
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import 'auth/auth_service.dart';
import '../../provider/auth_provider.dart';

final pollServiceProvider = Provider<PollService>((ref) {
  return PollService(ref);
});

class PollService {
  final Ref _ref;
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  PollService(this._ref);

  Future<Map<String, dynamic>> createPoll({
    required String question,
    required List<String> options,
    int? expiryHours,
    String? target
  }) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.post('/polls/create', data: {
        'question': question,
        'options': options,
        'expiryHours': expiryHours,
        'target': target
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

  Future<List<dynamic>> getActivePolls() async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.get('/polls/active');

      if (response.data['status'] == true) {
          return response.data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> vote(String pollId, int optionIndex) async {
    try {
      final token = _ref.read(authProvider).token;
      _client.options.headers['authorization'] = 'Bearer $token';

      final response = await _client.post('/polls/$pollId/vote', data: {
        'optionIndex': optionIndex
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
}
