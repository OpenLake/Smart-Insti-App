class Broadcast {
  final String title;
  final String body;
  final DateTime time;

  Broadcast({
    required this.title,
    required this.body,
    required this.time,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time']),
    );
  }
}
