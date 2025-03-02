import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/course.dart';

final courseRepositoryProvider =
    Provider<CourseRepository>((_) => CourseRepository());

class CourseRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
    ),
  );

  final Logger _logger = Logger();

  Future<List<Course>> getCourses() async {
    try {
      final response = await _client.get('/courses');
      List<Course> courses = [];
      for (var course in response.data) {
        courses.add(Course.fromJson(course));
      }
      return courses;
    } catch (e) {
      return [];
    }
  }

  Future<bool> addCourse(Course course) async {
    try {
      final response = await _client.post('/courses', data: course.toJson());
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<Course> updateCourse(Course course) async {
    try {
      final response =
          await _client.put('/courses/${course.id}', data: course.toJson());
      return Course.fromJson(response.data);
    } catch (e) {
      return course;
    }
  }

  Future<bool> deleteCourse(Course course) async {
    try {
      final response = await _client.delete('/course/${course.id}');
      _logger.i(response.data);
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<Course> getCourse(Course course) async {
    try {
      final response = await _client.get('/courses/$course.id');
      return Course.fromJson(response.data);
    } catch (e) {
      return course;
    }
  }
}
