class Announcement {
  final String id;
  final String title;
  final String content;
  final Map<String, dynamic> author;
  final String type;
  final dynamic target; // Can be Map or String ID
  final String? targetModel;
  final bool isPinned;
  final DateTime? expiryDate;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.type,
    this.target,
    this.targetModel,
    this.isPinned = false,
    this.expiryDate,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      author: json['author'] is Map ? json['author'] : {'name': 'Unknown'},
      type: json['type'],
      target: json['target'],
      targetModel: json['targetModel'],
      isPinned: json['isPinned'] ?? false,
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'target': target,
      'targetModel': targetModel,
      'isPinned': isPinned,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}
