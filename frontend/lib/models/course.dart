class Course {
  final String? id;
  final String courseCode;
  final String courseName;
  final int credits;
  final List<String>? branches;
  final String? primaryRoom;

  Course({
    this.id,
    required this.courseName,
    required this.courseCode,
    required this.credits,
    this.branches,
    this.primaryRoom,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      courseCode: json['courseCode'],
      courseName: json['name'],
      credits: json['credits'],
      branches:
          (json['branches'] as List).map((item) => item as String).toList(),
      primaryRoom: json['primaryRoom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'name': courseName,
      'credits': credits,
      'branches': branches,
      'primaryRoom': primaryRoom,
    };
  }
}
