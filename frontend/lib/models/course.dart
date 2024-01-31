class Course {
  final String id;
  final String courseCode;
  final String courseName;
  final List<String> branches;

  Course({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.branches,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      courseCode: json['courseCode'],
      courseName: json['name'],
      branches:
          (json['branches'] as List).map((item) => item as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseCode': courseCode,
      'name': courseName,
      'branches': branches,
    };
  }
}
