class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String type;
  final String? organizerName;
  final String category;
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
    required this.category,
    required this.isPublic,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final schedule = json['schedule'] ?? {};
    final organizer = json['organizing_unit_id'];

    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.tryParse(schedule['start']?.toString() ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(schedule['end']?.toString() ?? '') ?? DateTime.now(),
      location: schedule['venue'] ?? 'Unknown Location',
      type: json['type'] ?? 'Other',
      organizerName: organizer is Map<String, dynamic> ? organizer['name'] : (organizer is String ? organizer : null),
      category: json['category'] ?? 'Other',
      isPublic: json['isPublic'] ?? true, // Default to true if missing
    );
  }
}
