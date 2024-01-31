class Student {
  Student({
    required this.id,
    required this.name,
    required this.studentMail,
    required this.rollNumber,
    this.about,
    this.profilePicURI,
    this.graduationYear,
    required this.branch,
    this.roles,
    this.skills,
    this.achievements,
  });

  final String id;
  final String name;
  final String studentMail;
  final String rollNumber;
  String? about;
  final String? profilePicURI;
  final String? graduationYear;
  final String branch;
  final List<String>? roles;
  List<String>? skills;
  List<Achievement>? achievements;
}

class Skills {
  final String text;
  final double proficiency;

  Skills({
    required this.text,
    required this.proficiency,
  });
}

class Achievement {
  final String title;
  final String description;

  Achievement({
    required this.title,
    required this.description,
  });
}
