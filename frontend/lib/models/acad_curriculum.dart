class AcadCourseRef {
  final String code;
  final String name;
  final double credits;
  final String? category;

  AcadCourseRef({
    required this.code,
    required this.name,
    required this.credits,
    this.category,
  });

  factory AcadCourseRef.fromJson(Map<String, dynamic> json) {
    return AcadCourseRef(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      credits: (json['credits'] ?? 0).toDouble(),
      category: json['category'],
    );
  }
}

class AcadSemester {
  final int semester;
  final double totalCredits;
  final List<AcadCourseRef> courses;

  AcadSemester({
    required this.semester,
    required this.totalCredits,
    required this.courses,
  });

  factory AcadSemester.fromJson(Map<String, dynamic> json) {
    return AcadSemester(
      semester: json['semester'] ?? 0,
      totalCredits: (json['totalCredits'] ?? 0).toDouble(),
      courses: (json['courses'] as List?)
              ?.map((c) => AcadCourseRef.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class AcadCurriculum {
  final String branch;
  final String degree;
  final List<AcadSemester> semesters;

  AcadCurriculum({
    required this.branch,
    required this.degree,
    required this.semesters,
  });

  factory AcadCurriculum.fromJson(Map<String, dynamic> json) {
    return AcadCurriculum(
      branch: json['branch'] ?? '',
      degree: json['degree'] ?? '',
      semesters: (json['semesters'] as List?)
              ?.map((s) => AcadSemester.fromJson(s))
              .toList() ??
          [],
    );
  }
}
