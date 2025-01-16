import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/provider/courses_provider.dart';
import 'package:smart_insti_app/repositories/faculty_repository.dart';
import 'dart:io';
import '../models/faculty.dart';

final facultyProvider = StateNotifierProvider<FacultyStateNotifier, FacultyState>((ref) => FacultyStateNotifier(ref));

class FacultyState {
  final List<Faculty> faculties;
  final List<Faculty> filteredFaculties;
  final List<int> selectedCourses;
  final TextEditingController facultyNameController;
  final TextEditingController facultyEmailController;
  final TextEditingController facultyDepartmentController;
  final TextEditingController facultyCabinController;
  final TextEditingController searchFacultyController;

  FacultyState({
    required this.faculties,
    required this.filteredFaculties,
    required this.selectedCourses,
    required this.facultyNameController,
    required this.facultyEmailController,
    required this.searchFacultyController,
    required this.facultyDepartmentController,
    required this.facultyCabinController,
  });

  FacultyState copyWith({
    List<Faculty>? faculties,
    List<Faculty>? filteredFaculties,
    List<int>? selectedCourses,
    TextEditingController? facultyNameController,
    TextEditingController? facultyEmailController,
    TextEditingController? searchFacultyController,
    TextEditingController? facultyDepartmentController,
    TextEditingController? facultyCabinController,
  }) {
    return FacultyState(
      faculties: faculties ?? this.faculties,
      filteredFaculties: filteredFaculties ?? this.filteredFaculties,
      selectedCourses: selectedCourses ?? this.selectedCourses,
      facultyNameController: facultyNameController ?? this.facultyNameController,
      facultyEmailController: facultyEmailController ?? this.facultyEmailController,
      facultyCabinController: facultyCabinController ?? this.facultyCabinController,
      facultyDepartmentController: facultyDepartmentController ?? this.facultyDepartmentController,
      searchFacultyController: searchFacultyController ?? this.searchFacultyController,
    );
  }
}

class FacultyStateNotifier extends StateNotifier<FacultyState> {
  FacultyStateNotifier(Ref ref)
      : _coursesState = ref.read(coursesProvider.notifier),
        _api = ref.read(facultyRepositoryProvider),
        super(FacultyState(
          faculties: [],
          filteredFaculties: [],
          selectedCourses: [],
          facultyNameController: TextEditingController(),
          facultyEmailController: TextEditingController(),
          facultyCabinController: TextEditingController(),
          facultyDepartmentController: TextEditingController(),
          searchFacultyController: TextEditingController(),
        )) {
    loadFaculties();
  }

  final Logger _logger = Logger();
  final FacultyRepository _api;
  final CoursesNotifier _coursesState;

  void loadFaculties() async {
    final faculties = await _api.getFaculties();
    _coursesState.loadCourses();
    state = state.copyWith(
      faculties: faculties,
      filteredFaculties: faculties,
    );
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

  Future<void> addFaculty() async {
    _logger.i(_coursesState.state.courses.length);
    if (await _api.addFaculty(
      Faculty(
        name: state.facultyNameController.text,
        email: state.facultyEmailController.text,
        department: state.facultyDepartmentController.text,
        cabin: state.facultyCabinController.text,
        courses: state.selectedCourses.map((courseIndex) => _coursesState.state.courses[courseIndex].id!).toList(),
      ),
    )) {
      clearControllers();
      loadFaculties();
    }
  }

  void updateSelectedCourses(List<int> courses) {
    state = state.copyWith(
      selectedCourses: courses,
    );
  }

  void searchFaculties() {
    String query = state.searchFacultyController.text;
    _logger.i("Searching for faculty: $query");
    state = state.copyWith(
      filteredFaculties:
          state.faculties.where((faculty) => faculty.name.toLowerCase().contains(query.toLowerCase())).toList(),
    );
  }

  Future<void> removeFaculty(Faculty faculty) async {
    if (await _api.deleteFaculty(faculty.id!)) {
      loadFaculties();
    }
  }

  void clearControllers() {
    state.facultyNameController.clear();
    state.facultyEmailController.clear();
    state.facultyCabinController.clear();
    state.facultyDepartmentController.clear();
    state.searchFacultyController.clear();
    state = state.copyWith(
      selectedCourses: [],
    );
  }
}
