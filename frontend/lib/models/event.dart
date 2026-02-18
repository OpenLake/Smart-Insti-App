class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String type;
  final String? organizerName;
  final bool isPublic;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.type,
    this.organizerName,
    required this.isPublic,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'] ?? '',
      type: json['type'] ?? 'Other',
      organizerName: json['organizer'] != null ? json['organizer']['name'] : null,
      isPublic: json['isPublic'] ?? true,
    );
  }
}
