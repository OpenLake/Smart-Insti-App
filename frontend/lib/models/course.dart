class Course {
  Course({this.id, this.collegeId, required this.courseCode, required this.courseName, required this.branch});

  final String? id;
  final String? collegeId;
  final String courseCode;
  final String courseName;
  final String branch;
}