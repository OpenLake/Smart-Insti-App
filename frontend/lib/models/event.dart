class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? imageURI;
  final String organizedBy;
  final String createdBy;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.imageURI,
    required this.organizedBy,
    required this.createdBy,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      imageURI: json['imageURI'],
      organizedBy: json['organizedBy'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageURI': imageURI,
      'organizedBy': organizedBy,
    };
  }
}
