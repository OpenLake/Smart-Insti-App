import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../models/user_bundle.dart';

final hubRepositoryProvider = Provider<HubRepository>((ref) => HubRepository());

class HubRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.hubApiBaseUrl,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  final Logger _logger = Logger();

  Future<UserBundle?> getUserBundle(String token) async {
    try {
      final response = await _client.get(
        '/user/bundle',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var body = response.data;
        if (body is String) {
          body = jsonDecode(body);
        }
        
        final bundleData = body['data'];
        if (bundleData != null) {
          return UserBundle.fromJson(bundleData);
        }
        return null;
      } else {
        _logger.e('Failed to fetch user bundle: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error fetching user bundle: $e');
      return null;
    }
  }
}
