import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../constants/constants.dart';
import '../models/complaint.dart';

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) => ComplaintRepository());

class ComplaintRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  final Logger _logger = Logger();

  Future<List<Complaint>> getComplaints(String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.get('/complaints');
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Complaint.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> addComplaint(Complaint complaint, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.post('/complaints', data: complaint.toJson());
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> upvoteComplaint(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.put('/complaints/$id/upvote');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
