import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
import '../constants/constants.dart';
import '../models/resource.dart';

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) => ResourceRepository());

class ResourceRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      validateStatus: (status) => status! < 500,
    ),
  );
  final Logger _logger = Logger();

  Future<List<Resource>> getResources(String token, {String? department, int? semester, String? subject}) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final Map<String, dynamic> queryParams = {};
      if (department != null) queryParams['department'] = department;
      if (semester != null) queryParams['semester'] = semester;
      if (subject != null) queryParams['subject'] = subject;

      final response = await _client.get('/resources', queryParameters: queryParams);
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => Resource.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<bool> uploadResource(String token, File file, Map<String, dynamic> data) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      String fileName = file.path.split('/').last;
      
      // Determine content type based on extension
      MediaType? contentType;
      if (fileName.endsWith('.pdf')) {
        contentType = MediaType('application', 'pdf');
      } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        contentType = MediaType('image', 'jpeg');
      } else if (fileName.endsWith('.png')) {
        contentType = MediaType('image', 'png');
      } else {
         contentType = MediaType('application', 'octet-stream');
      }

      FormData formData = FormData.fromMap({
        ...data,
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: contentType,
        ),
      });

      final response = await _client.post('/resources', data: formData);
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteResource(String id, String token) async {
    _client.options.headers['authorization'] = 'Bearer $token';
    try {
      final response = await _client.delete('/resources/$id');
      return response.data['status'] == true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
