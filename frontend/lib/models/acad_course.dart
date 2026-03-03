class AcadCourse {
  final String id;
  final String code;
  final String title;
  final String department;
  final double credits;
  final String? prerequisites;
  final List<String> syllabus;
  final Map<String, String>? schedule;

  AcadCourse({
    required this.id,
    required this.code,
    required this.title,
    required this.department,
    required this.credits,
    this.prerequisites,
    required this.syllabus,
    this.schedule,
  });

  factory AcadCourse.fromJson(Map<String, dynamic> json) {
    return AcadCourse(
      id: json['id'] ?? json['_id'] ?? '',
      code: json['code'] ?? json['course_code'] ?? '',
      title: json['title'] ?? json['course_name'] ?? '',
      department: json['department'] ?? json['Department'] ?? '',
      credits: (json['credits'] ?? 0).toDouble(),
      prerequisites: json['prerequisites'],
      syllabus: () {
        final rawSyllabus = json['syllabus'];
        if (rawSyllabus is List) {
          return rawSyllabus.map((e) => e.toString()).toList();
        } else if (rawSyllabus is String) {
          return [rawSyllabus];
        }
        return <String>[];
      }(),
      schedule: json['schedule'] != null
          ? Map<String, String>.from(json['schedule'])
          : null,
    );
  }
}
