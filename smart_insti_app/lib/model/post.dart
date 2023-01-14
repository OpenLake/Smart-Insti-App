class Post{
  final String title;
  final String postedBy;
  final String content;
  Post({required this.title, required this.postedBy, required this.content});

  Map<String,dynamic> toJson() => {
    "title": title,
    "postedBy": postedBy,
    "content": content
  };
}
