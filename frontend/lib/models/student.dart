class Student {
  Student(
      {required this.name,
      required this.studentMail,
      required this.rollNumber,
      required this.branch,
      required this.role,
      this.id,
      this.collegeId});

  final String? id;
  final String? collegeId;
  final String name;
  final String studentMail;
  final String rollNumber;
  final String branch;
  final String role;
}
