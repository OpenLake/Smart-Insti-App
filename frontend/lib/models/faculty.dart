import 'course.dart';

class Faculty {
  Faculty({this.id, this.collegeId, required this.name, required this.facultyMail, required this.courses});

  final String? id;
  final String? collegeId;
  final String name;
  final String facultyMail;
  final List<Course> courses;
}