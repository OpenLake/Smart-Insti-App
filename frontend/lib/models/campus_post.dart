class CampusPost {
  final String id;
  final String content;
  final String backgroundColor; // e.g. "0xFFE0F7FA"
  final DateTime createdAt;
  final bool isLiked;
  final int likeCount;

  CampusPost({
    required this.id,
    required this.content,
    required this.backgroundColor,
    required this.createdAt,
    required this.isLiked,
    required this.likeCount,
  });

  factory CampusPost.fromJson(Map<String, dynamic> json) {
    return CampusPost(
      id: json['_id'],
      content: json['content'],
      backgroundColor: json['backgroundColor'] ?? '0xFFFFFFFF',
      createdAt: DateTime.parse(json['createdAt']),
      isLiked: json['isLiked'] ?? false,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}
