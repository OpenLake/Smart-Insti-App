class UserBundle {
  final Identity identity;
  final AcadmapBundleData? academics;
  final Map<String, dynamic>? community;
  final Map<String, dynamic>? institute;
  final List<String> warnings;

  UserBundle({
    required this.identity,
    this.academics,
    this.community,
    this.institute,
    required this.warnings,
  });

  factory UserBundle.fromJson(Map<String, dynamic> json) {
    return UserBundle(
      identity: Identity.fromJson(json['identity'] ?? {}),
      academics: json['academics'] != null
          ? AcadmapBundleData.fromJson(json['academics'])
          : null,
      community: json['community'],
      institute: json['institute'],
      warnings: List<String>.from(json['warnings'] ?? []),
    );
  }
}

class Identity {
  final String email;
  final String? name;
  final String? role;

  Identity({required this.email, this.name, this.role});

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      email: json['email'] ?? '',
      name: json['name'],
      role: json['role'],
    );
  }
}

class AcadmapBundleData {
  final String provider;
  final AcadmapProfile? acadmap;

  AcadmapBundleData({required this.provider, this.acadmap});

  factory AcadmapBundleData.fromJson(Map<String, dynamic> json) {
    return AcadmapBundleData(
      provider: json['provider'] ?? '',
      acadmap:
          json['acadmap'] != null ? AcadmapProfile.fromJson(json['acadmap']) : null,
    );
  }
}

class AcadmapProfile {
  final List<String> selectedCourses;
  final List<String> completedCourses;
  final String? batch;
  final String? department;
  final String? program;
  final String? profileImage;

  AcadmapProfile({
    required this.selectedCourses,
    required this.completedCourses,
    this.batch,
    this.department,
    this.program,
    this.profileImage,
  });

  factory AcadmapProfile.fromJson(Map<String, dynamic> json) {
    return AcadmapProfile(
      selectedCourses: List<String>.from(json['selected_courses'] ?? []),
      completedCourses: List<String>.from(json['completed_courses'] ?? []),
      batch: json['batch'],
      department: json['department'],
      program: json['program'],
      profileImage: json['profile_image'],
    );
  }
}

