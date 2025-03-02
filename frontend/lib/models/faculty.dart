class Faculty {
  final String? id;
  final String name;
  final String email;
  final String? cabin;
  final String? department;
  final List<String>? courses;

  Faculty({
    this.id,
    required this.name,
    required this.email,
    this.cabin,
    this.department,
    this.courses,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['_id'],
      name: json['name'] ?? 'Smart Insti User',
      email: json['email'],
      cabin: json['cabin'],
      department: json['department'],
      courses: json['courses'] != null ? (json['courses'] as List).map((course) => course.toString()).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cabin': cabin,
      'department': department,
      'courses': courses != null ? courses!.toList() : [],
    };
  }
}
