import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../models/acad_course.dart';
import '../models/acad_timetable.dart';
import '../models/acad_curriculum.dart';
import '../models/acad_department.dart';

final acadmapRepositoryProvider =
    Provider<AcadmapRepository>((ref) => AcadmapRepository());

class AcadmapRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.hubApiBaseUrl,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  final Logger _logger = Logger();

  Future<List<AcadCourse>> getCourses() async {
    try {
      final response = await _client.get('/academics/courses');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is List) {
          return data.map((e) => AcadCourse.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<List<AcadTimetable>> getTimetable() async {
    try {
      final response = await _client.get('/academics/timetable');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is List) {
          return data.map((e) => AcadTimetable.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<List<AcadCurriculum>> getCurriculum() async {
    try {
      final response = await _client.get('/academics/curriculum');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is List) {
          return data.map((e) => AcadCurriculum.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  Future<AcadCurriculum?> getBranchCurriculum(String branch) async {
    try {
      final response = await _client.get('/academics/curriculum/$branch');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is List && data.isNotEmpty) {
          return AcadCurriculum.fromJson(data.first);
        } else if (data is Map<String, dynamic>) {
          return AcadCurriculum.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  Future<List<AcadDepartment>> getDepartments() async {
    try {
      final response = await _client.get('/academics/departments');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        if (data is List) {
          return data.map((e) => AcadDepartment.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }
}
