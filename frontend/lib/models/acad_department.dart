class AcadDepartment {
  final String shortName;
  final String fullName;

  AcadDepartment({
    required this.shortName,
    required this.fullName,
  });

  factory AcadDepartment.fromJson(Map<String, dynamic> json) {
    return AcadDepartment(
      shortName: json['shortName'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}
