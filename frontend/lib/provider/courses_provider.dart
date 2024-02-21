import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/repositories/course_repository.dart';
import 'dart:io';
import '../constants/constants.dart';
import '../models/course.dart';

final coursesProvider = StateNotifierProvider<CoursesNotifier, CoursesState>((ref) => CoursesNotifier(ref));

class CoursesState {
  final List<Course> courses;
  final List<Course> filteredCourses;
  final TextEditingController courseCodeController;
  final TextEditingController courseNameController;
  final TextEditingController courseCreditController;
  final TextEditingController searchCourseController;
  final List<int> branches;
  final String? primaryRoom;
  final List<DropdownMenuItem<String>> selectableBranches;

  CoursesState({
    required this.courses,
    required this.filteredCourses,
    required this.courseCodeController,
    required this.courseNameController,
    required this.courseCreditController,
    required this.searchCourseController,
    required this.branches,
    required this.primaryRoom,
    required this.selectableBranches,
  });

  CoursesState copyWith({
    List<Course>? courses,
    List<Course>? filteredCourses,
    List<int>? branches,
    TextEditingController? courseCodeController,
    TextEditingController? courseNameController,
    TextEditingController? courseCreditController,
    TextEditingController? searchCourseController,
    String? primaryRoom,
    List<DropdownMenuItem<String>>? selectableBranches,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      courseCodeController: courseCodeController ?? this.courseCodeController,
      courseNameController: courseNameController ?? this.courseNameController,
      courseCreditController: courseCreditController ?? this.courseCreditController,
      searchCourseController: searchCourseController ?? this.searchCourseController,
      branches: branches ?? this.branches,
      primaryRoom: primaryRoom ?? this.primaryRoom,
      selectableBranches: selectableBranches ?? this.selectableBranches,
    );
  }
}

class CoursesNotifier extends StateNotifier<CoursesState> {
  CoursesNotifier(Ref ref)
      : _api = ref.read(courseRepositoryProvider),
        super(
          CoursesState(
            courses: [],
            filteredCourses: [],
            courseCodeController: TextEditingController(),
            courseNameController: TextEditingController(),
            courseCreditController: TextEditingController(),
            searchCourseController: TextEditingController(),
            branches: [],
            primaryRoom: null,
            selectableBranches: Branches.branchList,
          ),
        ) {
    loadCourses();
  }

  final Logger _logger = Logger();
  final CourseRepository _api;

  void loadCourses() async {
    final courses = await _api.getCourses();
    state = state.copyWith(courses: courses, filteredCourses: courses);
  }

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

  Future<void> addCourse() async {
    if (await _api.addCourse(
      Course(
        courseCode: state.courseCodeController.text,
        courseName: state.courseNameController.text,
        credits: int.parse(state.courseCreditController.text),
        branches: state.branches.map((index) => Branches.branchList[index].value!).toList(),
        primaryRoom: state.primaryRoom,
      ),
    )) {
      clearControllers();
      loadCourses();
    }
  }

  void addSelectableBranch(String branch) {
    state = state.copyWith(
      selectableBranches: [
        ...state.selectableBranches,
        DropdownMenuItem<String>(
          value: branch,
          child: Text(branch),
        ),
      ],
    );
  }

  void updateBranch(List<int> newBranches) {
    state = state.copyWith(branches: newBranches);
  }

  void updatePrimaryRoom(String room) {
    state = state.copyWith(primaryRoom: room);
  }

  Future<void> removeCourse(Course course) async {
    if (await _api.deleteCourse(course)) {
      loadCourses();
    }
  }

  void clearControllers() {
    state.courseCodeController.clear();
    state.courseNameController.clear();
    state.courseCreditController.clear();
    state = state.copyWith(
      branches: [],
      primaryRoom: null,
    );
  }
}
