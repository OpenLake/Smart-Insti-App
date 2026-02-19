import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/feedback.dart';

class FeedbackRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.hubApiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<Feedback>> getFeedbacks(String token) async {
    _client.options.headers['authorization'] = 'Bearer $token'; 
    try {
      final response = await _client.get('/feedback');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => Feedback.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> createFeedback(Map<String, dynamic> data, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token'; 
    try {
      final response = await _client.post('/feedback', data: data);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
