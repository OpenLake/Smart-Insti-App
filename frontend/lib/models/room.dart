class Room {
  Room({this.occupantId, this.id, required this.name, this.vacant = true});

  final String? id;
  final String name;
  final bool vacant;
  final String? occupantId;
}
