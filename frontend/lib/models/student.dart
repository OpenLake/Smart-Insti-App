import 'package:smart_insti_app/models/achievement.dart';
import 'package:smart_insti_app/models/skills.dart';

class Student {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String? about;
  final String? profilePicURI;
  final String? branch;
  final int? graduationYear;
  final List<Skill>? skills;
  final List<Achievement>? achievements;
  final List<String>? roles;
  final List<String> wishlist;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    this.about,
    this.profilePicURI,
    this.branch,
    this.graduationYear,
    this.skills,
    this.achievements,
    this.roles,
    this.wishlist = const [],
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    final academicInfo = json['academicInfo'] as Map<String, dynamic>?;
    return Student(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Smart Insti User',
      email: json['email'] ?? '',
      rollNumber: json['rollNumber'] ?? json['student_id'] ?? academicInfo?['studentId'] ?? '',
      about: json['about'],
      profilePicURI: json['profilePicURI'] ?? json['profile_pic_url'],
      branch: json['branch'] ?? json['department'] ?? academicInfo?['department'],
      graduationYear: json['graduationYear'] ?? json['batch'] ?? academicInfo?['batch'],
      skills: json['skills'] != null
          ? (json['skills'] as List<dynamic>)
              .map((item) =>
                  item is Map<String, dynamic> ? Skill.fromJson(item) : null)
              .whereType<Skill>()
              .toList()
          : [],
      achievements: json['achievements'] != null
          ? (json['achievements'] as List<dynamic>)
              .map((item) => item is Map<String, dynamic>
                  ? Achievement.fromJson(item)
                  : null)
              .whereType<Achievement>()
              .toList()
          : null,
      roles: json['roles'] != null
          ? (json['roles'] as List?)?.map((item) => item as String).toList()
          : json['role'] != null ? [json['role'] as String] : [],
      wishlist: json['wishlist'] != null
          ? (json['wishlist'] as List?)
                  ?.map(
                      (item) => item is String ? item : item['_id'].toString())
                  .toList() ??
              []
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'about': about,
      'profilePicURI': profilePicURI,
      'branch': branch,
      'graduationYear': graduationYear,
      'skills':
          skills != null ? skills!.map((skill) => skill.toJson()).toList() : [],
      'achievements': achievements != null
          ? achievements!.map((achievement) => achievement.toJson()).toList()
          : [],
      'roles': roles,
      'wishlist': wishlist,
    };
  }
}
