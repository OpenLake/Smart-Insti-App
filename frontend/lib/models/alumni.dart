class Alumni {
  final String id;
  final String name;
  final String email;
  final int? graduationYear;
  final String? degree;
  final String? department;
  final String? currentOrganization;
  final String? designation;
  final String? linkedInProfile;

  Alumni({
    required this.id,
    required this.name,
    required this.email,
    this.graduationYear,
    this.degree,
    this.department,
    this.currentOrganization,
    this.designation,
    this.linkedInProfile,
  });

  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      graduationYear: json['graduationYear'],
      degree: json['degree'],
      department: json['department'],
      currentOrganization: json['currentOrganization'],
      designation: json['designation'],
      linkedInProfile: json['linkedInProfile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'graduationYear': graduationYear,
      'degree': degree,
      'department': department,
      'currentOrganization': currentOrganization,
      'designation': designation,
      'linkedInProfile': linkedInProfile,
    };
  }
}
