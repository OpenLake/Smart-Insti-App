class Room {
  Room({this.occupantId, this.id, required this.name, this.vacant});

  final String? id;
  final String name;
  final bool? vacant;
  final String? occupantId;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      vacant: json['vacant'],
      occupantId: json['occupantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vacant': vacant,
      'occupantId': occupantId,
    };
  }
}
