import 'package:smart_insti_app/models/course.dart';

class Faculty {
  final String id;
  final String name;
  final String email;
  final String? cabinNumber;
  final String? department;
  final List<Course>? courses;
  final String? profilePicURI;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
    this.cabinNumber,
    this.department,
    this.courses,
    this.profilePicURI,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    final academicInfo = json['academicInfo'] as Map<String, dynamic>?;
    String? extractedCabin = json['cabinNumber'];
    if (extractedCabin == null && json['about'] != null) {
      final aboutStr = json['about'] as String;
      if (aboutStr.contains('Cabin: ')) {
        final match = RegExp(r'Cabin: (.+)').firstMatch(aboutStr);
        extractedCabin = match?.group(1);
      }
    }
    return Faculty(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Smart Insti User',
      email: json['email'] ?? '',
      cabinNumber: extractedCabin,
      department: json['department'] ?? academicInfo?['department'],
      profilePicURI: json['profilePicURI'] ?? json['profile_pic_url'],
      courses: json['courses'] != null
          ? (json['courses'] as List)
              .map((item) =>
                  item is Map<String, dynamic> ? Course.fromJson(item) : null)
              .whereType<Course>()
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'cabinNumber': cabinNumber,
      'department': department,
      'courses': courses != null
          ? courses!.map((course) => course.toJson()).toList()
          : [],
    };
  }
}
