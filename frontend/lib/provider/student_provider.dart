import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentEmailController = TextEditingController();
  final TextEditingController _studentRollNoController = TextEditingController();
  final TextEditingController _searchStudentController = TextEditingController();
  String branch = Branches.branchList[0].value!;
  String role = StudentRoles.studentRoleList[0].value!;

  TextEditingController get studentNameController => _studentNameController;

  TextEditingController get studentEmailController => _studentEmailController;

  TextEditingController get studentRollNoController => _studentRollNoController;

  TextEditingController get searchStudentController => _searchStudentController;

  final List<Student> students = [];
  List<Student> filteredStudents = [];

  final Logger _logger = Logger();

  void searchStudents() {
    String query = _searchStudentController.text;
    _logger.i("Searching for student: $query");
    filteredStudents =
        students.where((student) => student.rollNumber.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void addStudent() {
    Student student = Student(
      name: _studentNameController.text,
      studentMail: _studentEmailController.text,
      rollNumber: _studentRollNoController.text,
      branch: branch,
      role: role,
    );
    students.add(student);
    _studentNameController.clear();
    _studentEmailController.clear();
    _studentRollNoController.clear();
    _logger.i("Added student: ${student.name}");
    notifyListeners();
  }

  void removeStudent(Student student) {
    students.remove(student);
    _logger.i("Removed student: ${student.name}");
    String query = _searchStudentController.text;
    filteredStudents =
        students.where((student) => student.rollNumber.toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }
}
