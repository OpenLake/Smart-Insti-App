class Timetable {
  final String id;
  final String name;
  final int rows;
  final int columns;
  final List<List<String>> timetable;

  Timetable({
    required this.id,
    required this.name,
    required this.rows,
    required this.columns,
    required this.timetable,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['_id'],
      name: json['name'],
      rows: json['rows'],
      columns: json['columns'],
      timetable: List<List<String>>.from(json['timetable'].map((x) => List<String>.from(x.map((x) => x)))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rows': rows,
      'columns': columns,
      'timetable': List<dynamic>.from(timetable.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
  }
}
