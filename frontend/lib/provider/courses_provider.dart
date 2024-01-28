import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import 'dart:io';
import '../constants/constants.dart';
import '../models/course.dart';

final coursesProvider = StateNotifierProvider<CoursesNotifier, CoursesState>((ref) => CoursesNotifier());

class CoursesState {
  final List<Course> courses;
  final List<Course> filteredCourses;
  final TextEditingController courseCodeController;
  final TextEditingController courseNameController;
  final TextEditingController searchCourseController;
  final String branch;

  CoursesState({
    required this.courses,
    required this.filteredCourses,
    required this.courseCodeController,
    required this.courseNameController,
    required this.searchCourseController,
    required this.branch,
  });

  CoursesState copyWith({
    List<String>? branches,
    List<Course>? courses,
    List<Course>? filteredCourses,
    TextEditingController? courseCodeController,
    TextEditingController? courseNameController,
    TextEditingController? searchCourseController,
    String? branch,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      courseCodeController: courseCodeController ?? this.courseCodeController,
      courseNameController: courseNameController ?? this.courseNameController,
      searchCourseController: searchCourseController ?? this.searchCourseController,
      branch: branch ?? this.branch,
    );
  }
}

class CoursesNotifier extends StateNotifier<CoursesState> {
  CoursesNotifier() : super(_initialState());

  static CoursesState _initialState() {
    return CoursesState(
      courses: DummyCourses.courses,
      filteredCourses: [],
      courseCodeController: TextEditingController(),
      courseNameController: TextEditingController(),
      searchCourseController: TextEditingController(),
      branch: Branches.branchList[0].value!,
    );
  }

  get courseNameController => state.courseNameController;

  get courseCodeController => state.courseCodeController;

  get searchCourseController => state.searchCourseController;

  final Logger _logger = Logger();

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
    String query = state.searchCourseController.text;
    _logger.i("Searching for courses with query $query");
    state = state.copyWith(
        filteredCourses:
            state.courses.where((course) => course.courseName.toLowerCase().contains(query.toLowerCase())).toList());
  }

  void removeCourse(Course course) {
    _logger.i("Removing course ${course.courseCode}");
    state = state.copyWith(
      courses: state.courses..remove(course),
      filteredCourses: state.filteredCourses..remove(course),
    );
  }

  void addCourse() {
    _logger.i("Adding course ${state.courseCodeController.text}");
    final newCourse = Course(
      courseCode: state.courseCodeController.text,
      courseName: state.courseNameController.text,
      branch: state.branch,
    );
    state = state.copyWith(
      courses: [
        newCourse,
        ...state.courses,
      ],
      courseCodeController: TextEditingController(),
      courseNameController: TextEditingController(),
      branch: Branches.branchList[0].value!,
    );
  }

  void updateBranch(String newBranch) {
    state = state.copyWith(branch: newBranch);
  }
}
