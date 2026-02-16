class Post {
  final String id;
  final String title;
  final String content;
  final String author;
  final String type;
  final String? imageURI;
  final List<String> likes;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.type,
    this.imageURI,
    required this.likes,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      type: json['type'],
      imageURI: json['imageURI'],
      likes: (json['likes'] as List).map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'type': type,
      'imageURI': imageURI,
      'likes': likes,
    };
  }
}
