class Room {
  Room({this.occupantId, this.id, required this.name, this.vacant});

  final String? id;
  final String name;
  final bool? vacant;
  final String? occupantId;
}
