class AcadTimetable {
  final String code;
  final String title;
  final String ltp;
  final double credits;
  final String discipline;
  final String program;
  final String lectureSlot;
  final String lectureVenue;
  final String tutorialSlot;
  final String tutorialVenue;
  final String labSlot;
  final String labVenue;
  final String instructor;

  AcadTimetable({
    required this.code,
    required this.title,
    required this.ltp,
    required this.credits,
    required this.discipline,
    required this.program,
    required this.lectureSlot,
    required this.lectureVenue,
    required this.tutorialSlot,
    required this.tutorialVenue,
    required this.labSlot,
    required this.labVenue,
    required this.instructor,
  });

  factory AcadTimetable.fromJson(Map<String, dynamic> json) {
    return AcadTimetable(
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      ltp: json['ltp'] ?? '',
      credits: (json['credits'] ?? 0).toDouble(),
      discipline: json['discipline'] ?? '',
      program: json['program'] ?? '',
      lectureSlot: json['lectureSlot'] ?? '',
      lectureVenue: json['lectureVenue'] ?? '',
      tutorialSlot: json['tutorialSlot'] ?? '',
      tutorialVenue: json['tutorialVenue'] ?? '',
      labSlot: json['labSlot'] ?? '',
      labVenue: json['labVenue'] ?? '',
      instructor: json['instructor'] ?? '',
    );
  }
}
