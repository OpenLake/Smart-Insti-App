import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../../models/student.dart';
import 'dart:io';
import '../models/achievement.dart';
import '../models/skills.dart';
import '../repositories/student_repository.dart';

final studentProvider = StateNotifierProvider<StudentProvider, StudentState>((ref) => StudentProvider(ref));

class StudentState {
  final List<Student> students;
  final List<Student> filteredStudents;
  final TextEditingController studentNameController;
  final TextEditingController studentEmailController;
  final TextEditingController studentRollNoController;
  final TextEditingController searchStudentController;
  final String branch;
  final List<int> roles;
  final List<DropdownMenuItem<String>> selectableRoles;
  final List<DropdownMenuItem<String>> selectableBranches;
  final int graduationYear;
  final String? profilePicURI;
  final String? about;
  final List<Skill>? skills;
  final List<Achievement>? achievements;

  StudentState({
    required this.students,
    required this.filteredStudents,
    required this.studentNameController,
    required this.studentEmailController,
    required this.studentRollNoController,
    required this.searchStudentController,
    required this.branch,
    required this.roles,
    required this.selectableRoles,
    required this.selectableBranches,
    required this.graduationYear,
    this.profilePicURI,
    this.about,
    this.achievements,
    this.skills,
  });

  StudentState copyWith({
    List<Student>? students,
    List<Student>? filteredStudents,
    TextEditingController? studentNameController,
    TextEditingController? studentEmailController,
    TextEditingController? studentRollNoController,
    TextEditingController? searchStudentController,
    String? branch,
    List<int>? roles,
    List<DropdownMenuItem<String>>? selectableRoles,
    List<DropdownMenuItem<String>>? selectableBranches,
    int? graduationYear,
    String? about,
    String? profilePicURI,
    List<Skill>? skills,
    List<Achievement>? achievements,
  }) {
    return StudentState(
      students: students ?? this.students,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      studentNameController: studentNameController ?? this.studentNameController,
      studentEmailController: studentEmailController ?? this.studentEmailController,
      studentRollNoController: studentRollNoController ?? this.studentRollNoController,
      searchStudentController: searchStudentController ?? this.searchStudentController,
      branch: branch ?? this.branch,
      profilePicURI: profilePicURI ?? this.profilePicURI,
      about: about ?? this.about,
      graduationYear: graduationYear ?? this.graduationYear,
      skills: skills ?? this.skills,
      achievements: achievements ?? this.achievements,
      roles: roles ?? this.roles,
      selectableRoles: selectableRoles ?? this.selectableRoles,
      selectableBranches: selectableBranches ?? this.selectableBranches,
    );
  }
}

class StudentProvider extends StateNotifier<StudentState> {
  StudentProvider(Ref ref)
      : _api = ref.read(studentRepositoryProvider),
        super(StudentState(
          students: DummyStudents.students,
          filteredStudents: [],
          studentNameController: TextEditingController(),
          studentEmailController: TextEditingController(),
          studentRollNoController: TextEditingController(),
          searchStudentController: TextEditingController(),
          branch: Branches.branchList[0].value!,
          roles: [],
          selectableRoles: StudentRoles.studentRoleList,
          selectableBranches: Branches.branchList,
          graduationYear: DateTime.now().year,
        )) {
    loadStudents();
  }

  final Logger _logger = Logger();
  final StudentRepository _api;

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

  void loadStudents() async {
    final students = await _api.getStudents();
    final newState = state.copyWith(students: students, filteredStudents: students);
    state = newState;
  }

  void searchStudents() {
    String query = state.searchStudentController.text;
    _logger.i("Searching for student: $query");
    final newState = state.copyWith(
      filteredStudents:
          state.students.where((student) => student.name.toLowerCase().contains(query.toLowerCase())).toList(),
    );
    state = newState;
  }

  void updateRoles(List<int> rolesIndex) {
    state = state.copyWith(roles: rolesIndex);
  }

  void updateBranch(String value) {
    final newState = state.copyWith(branch: value);
    state = newState;
  }

  void updateRole(List<int> rolesIndex) {
    _logger.i("Updating roles: $rolesIndex");
    state = state.copyWith(roles: rolesIndex);
  }

  void updateGraduationYear(DateTime time) {
    final newState = state.copyWith(graduationYear: time.year);
    state = newState;
  }

  void editAbout(String newAbout) {
    final newState = state.copyWith(about: newAbout);
    state = newState;
  }

  void editSkills(List<Skill> newSkills) {
    final newState = state.copyWith(skills: newSkills);
    state = newState;
  }

  void editAchievements(List<Achievement> newAchievements) {
    final newState = state.copyWith(achievements: newAchievements);
    state = newState;
  }

  void addSelectableRole(String item) {
    _logger.i("Adding item: $item");
    final newState = state.copyWith(
      selectableRoles: [
        ...state.selectableRoles,
        DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ),
      ],
    );
    state = newState;
  }

  void addSelectableBranch(String item) {
    _logger.i("Adding item: $item");
    final newState = state.copyWith(
      selectableBranches: [
        ...state.selectableBranches,
        DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ),
      ],
    );
    state = newState;
  }

  Future<void> addStudent() async {
    final newStudent = Student(
      name: state.studentNameController.text,
      email: state.studentEmailController.text,
      rollNumber: state.studentRollNoController.text,
      branch: state.branch,
      graduationYear: state.graduationYear,
      roles: state.roles.map((index) => StudentRoles.studentRoleList[index].value!).toList(),
    );
    if (await _api.addStudent(newStudent)) {
      clearControllers();
      loadStudents();
    }
  }

  Future<void> removeStudent(Student student) async {
    if (await _api.deleteStudent(student.id!)) {
      loadStudents();
    }
  }

  void clearControllers() {
    state.studentNameController.clear();
    state.studentEmailController.clear();
    state.studentRollNoController.clear();
    final newState = state.copyWith(
      branch: Branches.branchList[0].value!,
      graduationYear: DateTime.now().year,
      roles: [],
    );
    state = newState;
  }
}
