// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:smart_insti_app/constants/constants.dart';
// import 'package:smart_insti_app/constants/dummy_entries.dart';
// import '../models/student.dart';
// import 'dart:io';
//
// class StudentProvider extends ChangeNotifier {
//   final TextEditingController _studentNameController = TextEditingController();
//   final TextEditingController _studentEmailController = TextEditingController();
//   final TextEditingController _studentRollNoController = TextEditingController();
//   final TextEditingController _searchStudentController = TextEditingController();
//   String branch = Branches.branchList[0].value!;
//   String role = StudentRoles.studentRoleList[0].value!;
//
//   TextEditingController get studentNameController => _studentNameController;
//
//   TextEditingController get studentEmailController => _studentEmailController;
//
//   TextEditingController get studentRollNoController => _studentRollNoController;
//
//   TextEditingController get searchStudentController => _searchStudentController;
//
//   final List<Student> students = DummyStudents.students;
//   List<Student> filteredStudents = [];
//
//   final Logger _logger = Logger();
//
//   void pickSpreadsheet() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       bool isSpreadsheet = result.files.single.path!.endsWith(".xlsx") ||
//           result.files.single.path!.endsWith(".xls") ||
//           result.files.single.path!.endsWith(".csv");
//       if (isSpreadsheet) {
//         File file = File(result.files.single.path!);
//
//         // TODO : Add code to send the spreadsheet to the backend
//
//         _logger.i("Picked file ${file.path}");
//       } else {
//         _logger.e("Picked file is not a spreadsheet");
//       }
//     } else {
//       _logger.e("No file picked");
//     }
//   }
//
//   void searchStudents() {
//     String query = _searchStudentController.text;
//     _logger.i("Searching for student: $query");
//     filteredStudents =
//         students.where((student) => student.name.toLowerCase().contains(query.toLowerCase())).toList();
//     notifyListeners();
//   }
//
//   void addStudent() {
//     Student student = Student(
//       name: _studentNameController.text,
//       studentMail: _studentEmailController.text,
//       rollNumber: _studentRollNoController.text,
//       branch: branch,
//       role: role,
//     );
//     students.add(student);
//     _studentNameController.clear();
//     _studentEmailController.clear();
//     _studentRollNoController.clear();
//     _logger.i("Added student: ${student.name}");
//     notifyListeners();
//   }
//
//   void removeStudent(Student student) {
//     students.remove(student);
//     _logger.i("Removed student: ${student.name}");
//     String query = _searchStudentController.text;
//     filteredStudents =
//         students.where((student) => student.rollNumber.toLowerCase().contains(query.toLowerCase())).toList();
//     notifyListeners();
//   }
// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/constants/dummy_entries.dart';
import '../models/student.dart';
import 'dart:io';

class StudentState {
  final List<Student> students;
  final List<Student> filteredStudents;
  final TextEditingController studentNameController;
  final TextEditingController studentEmailController;
  final TextEditingController studentRollNoController;
  final TextEditingController searchStudentController;
  final String branch;
  final String role;

  StudentState({
    required this.students,
    required this.filteredStudents,
    required this.studentNameController,
    required this.studentEmailController,
    required this.studentRollNoController,
    required this.searchStudentController,
    required this.branch,
    required this.role,
  });

  StudentState copyWith({
    List<Student>? students,
    List<Student>? filteredStudents,
    TextEditingController? studentNameController,
    TextEditingController? studentEmailController,
    TextEditingController? studentRollNoController,
    TextEditingController? searchStudentController,
    String? branch,
    String? role,
  }) {
    return StudentState(
      students: students ?? this.students,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      studentNameController: studentNameController ?? this.studentNameController,
      studentEmailController: studentEmailController ?? this.studentEmailController,
      studentRollNoController: studentRollNoController ?? this.studentRollNoController,
      searchStudentController: searchStudentController ?? this.searchStudentController,
      branch: branch ?? this.branch,
      role: role ?? this.role,
    );
  }
}

final studentProvider = StateNotifierProvider<StudentProvider, StudentState>((ref) => StudentProvider());

class StudentProvider extends StateNotifier<StudentState> {
  StudentProvider()
      : super(StudentState(
          students: DummyStudents.students,
          filteredStudents: [],
          studentNameController: TextEditingController(),
          studentEmailController: TextEditingController(),
          studentRollNoController: TextEditingController(),
          searchStudentController: TextEditingController(),
          branch: Branches.branchList[0].value!,
          role: StudentRoles.studentRoleList[0].value!,
        ));

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

  get studentNameController => state.studentNameController;

  get studentEmailController => state.studentEmailController;

  get studentRollNoController => state.studentRollNoController;

  get searchStudentController => state.searchStudentController;

  void searchStudents() {
    String query = state.searchStudentController.text;
    _logger.i("Searching for student: $query");
    final newState = state.copyWith(
      filteredStudents:
          state.students.where((student) => student.name.toLowerCase().contains(query.toLowerCase())).toList(),
    );
    state = newState;
  }

  void updateBranch(String value) {
    final newState = state.copyWith(branch: value);
    state = newState;
  }

  void updateRole(String value) {
    final newState = state.copyWith(role: value);
    state = newState;
  }

  void addStudent() {
    final newState = state.copyWith(
      students: [
        Student(
          name: state.studentNameController.text,
          studentMail: state.studentEmailController.text,
          rollNumber: state.studentRollNoController.text,
          branch: state.branch,
          role: state.role,
        ),
        ...state.students,
      ],
      studentNameController: TextEditingController(),
      studentEmailController: TextEditingController(),
      studentRollNoController: TextEditingController(),
      branch: Branches.branchList[0].value!,
      role: StudentRoles.studentRoleList[0].value!,
    );
    state = newState;
  }

  void removeStudent(Student student) {
    final newStudents = state.students.where((s) => s != student).toList();
    final newFilteredStudents = state.filteredStudents.where((s) => s != student).toList();
    final newState = state.copyWith(
      students: newStudents,
      filteredStudents: newFilteredStudents,
    );
    state = newState;
    _logger.i("Removed student: ${student.name}");
  }
}
