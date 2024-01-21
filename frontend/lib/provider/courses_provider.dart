import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import '../models/course.dart';

class CoursesProvider extends ChangeNotifier {
  final List<String> _branches = [];
  final Logger _logger = Logger();

  final List<Course> _courses = [];
  List<Course> filteredCourses = [];

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseBranchController = TextEditingController();
  final TextEditingController _searchCourseController = TextEditingController();

  TextEditingController get courseCodeController => _courseCodeController;

  TextEditingController get courseNameController => _courseNameController;

  TextEditingController get courseBranchController => _courseBranchController;

  TextEditingController get searchCourseController => _searchCourseController;

  List<String> getBranches() {
    return _branches;
  }

  List<Course> getCourses() {
    return _courses;
  }

  void pickSpreadsheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx");
      if (isSpreadsheet) {
        File file = File(result.files.single.path!);
        _logger.i("Picked file ${file.path}");
      } else {
        _logger.e("Picked file is not a spreadsheet");
      }
    } else {
      _logger.e("No file picked");
    }
  }

  void searchCourses() {
    String query = _searchCourseController.text;
    _logger.i("Searching for courses with query $query");
    filteredCourses =
        _courses.where((course) => course.courseCode.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void removeCourse(Course course) {
    _logger.i("Removing course ${course.courseCode}");
    _courses.remove(course);
    String query = _searchCourseController.text;
    filteredCourses =
        _courses.where((course) => course.courseCode.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void addCourse() {
    _logger.i("Adding course ${_courseCodeController.text}");
    _courses.add(Course(
        courseCode: _courseCodeController.text,
        courseName: _courseNameController.text,
        branch: _courseBranchController.text));
    _courseCodeController.clear();
    _courseNameController.clear();
    _courseBranchController.clear();
    notifyListeners();
  }
}
