import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'dart:io';
import '../constants/constants.dart';
import '../models/course.dart';

class CoursesProvider extends ChangeNotifier {
  final List<String> _branches = [];
  final Logger _logger = Logger();

  final List<Course> _courses = DummyCourses.courses;
  List<Course> filteredCourses = [];

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _searchCourseController = TextEditingController();

  String branch = Branches.branchList[0].value!;

  TextEditingController get courseCodeController => _courseCodeController;

  TextEditingController get courseNameController => _courseNameController;

  TextEditingController get searchCourseController => _searchCourseController;

  get branches => _branches;
  get courses => _courses;

  void pickSpreadsheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx") ||
          result.files.single.path!.endsWith(".xls") ||
          result.files.single.path!.endsWith(".csv");
      if (isSpreadsheet) {
        File file = File(result.files.single.path!);

        // TODO : Add code to send the spreadsheet to the backend

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
        _courses.where((course) => course.courseName.toLowerCase().contains(query.toLowerCase())).toList();
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
        branch: branch));
    _courseCodeController.clear();
    _courseNameController.clear();
    notifyListeners();
  }
}
