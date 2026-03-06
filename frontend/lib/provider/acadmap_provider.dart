import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../repositories/acadmap_repository.dart';
import '../models/acad_course.dart';
import '../models/acad_timetable.dart';
import '../models/acad_curriculum.dart';
import '../models/acad_department.dart';

final acadmapProvider = StateNotifierProvider<AcadmapProvider, AcadmapState>(
    (ref) => AcadmapProvider(ref));

class AcadmapState {
  final List<AcadCourse> courses;
  final List<AcadCourse> filteredCourses;
  final List<AcadTimetable> timetable;
  final List<AcadTimetable> filteredTimetable;
  final List<AcadCurriculum> curriculum;
  final List<AcadDepartment> departments;
  final bool isLoading;
  final String? error;

  final TextEditingController courseSearchController;
  final TextEditingController timetableSearchController;

  AcadmapState({
    required this.courses,
    required this.filteredCourses,
    required this.timetable,
    required this.filteredTimetable,
    required this.curriculum,
    required this.departments,
    required this.isLoading,
    this.error,
    required this.courseSearchController,
    required this.timetableSearchController,
  });

  AcadmapState copyWith({
    List<AcadCourse>? courses,
    List<AcadCourse>? filteredCourses,
    List<AcadTimetable>? timetable,
    List<AcadTimetable>? filteredTimetable,
    List<AcadCurriculum>? curriculum,
    List<AcadDepartment>? departments,
    bool? isLoading,
    String? error,
  }) {
    return AcadmapState(
      courses: courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      timetable: timetable ?? this.timetable,
      filteredTimetable: filteredTimetable ?? this.filteredTimetable,
      curriculum: curriculum ?? this.curriculum,
      departments: departments ?? this.departments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      courseSearchController: courseSearchController,
      timetableSearchController: timetableSearchController,
    );
  }
}

class AcadmapProvider extends StateNotifier<AcadmapState> {
  final Ref ref;
  final Logger _logger = Logger();

  AcadmapProvider(this.ref)
      : super(AcadmapState(
          courses: [],
          filteredCourses: [],
          timetable: [],
          filteredTimetable: [],
          curriculum: [],
          departments: [],
          isLoading: false,
          courseSearchController: TextEditingController(),
          timetableSearchController: TextEditingController(),
        ));

  AcadmapRepository get _api => ref.read(acadmapRepositoryProvider);

  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final courses = await _api.getCourses();
      state = state.copyWith(
          courses: courses, filteredCourses: courses, isLoading: false);
    } catch (e) {
      _logger.e("Failed to fetch courses: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredCourses: state.courses);
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered = state.courses.where((c) {
        return c.title.toLowerCase().contains(lowerQuery) ||
            c.code.toLowerCase().contains(lowerQuery);
      }).toList();
      state = state.copyWith(filteredCourses: filtered);
    }
  }

  Future<void> fetchTimetable() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final t = await _api.getTimetable();
      state =
          state.copyWith(timetable: t, filteredTimetable: t, isLoading: false);
    } catch (e) {
      _logger.e("Failed to fetch timetable: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void searchTimetable(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredTimetable: state.timetable);
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered = state.timetable.where((t) {
        return t.title.toLowerCase().contains(lowerQuery) ||
            t.code.toLowerCase().contains(lowerQuery) ||
            t.instructor.toLowerCase().contains(lowerQuery);
      }).toList();
      state = state.copyWith(filteredTimetable: filtered);
    }
  }

  Future<void> fetchCurriculum() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final c = await _api.getCurriculum();
      state = state.copyWith(curriculum: c, isLoading: false);
    } catch (e) {
      _logger.e("Failed to fetch curriculum: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchDepartments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final d = await _api.getDepartments();
      state = state.copyWith(departments: d, isLoading: false);
    } catch (e) {
      _logger.e("Failed to fetch departments: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
