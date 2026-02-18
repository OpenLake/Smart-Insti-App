import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/club.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) => ClubRepository());

class ClubRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<Club>> getClubs(String token) async {
    // _client.options.headers['authorization'] = 'Bearer $token'; 
    // Public endpoint for now, but token can be sent if needed
    try {
      final response = await _client.get('/clubs');
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Club.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<Club?> getClubDetails(String id, String token) async {
    try {
      final response = await _client.get('/clubs/$id');
      if (response.data['status'] == true) {
        return Club.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }
}
