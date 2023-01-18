import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String commentBy;
  final String content;
  final Timestamp commentOn;
  Comment({
    required this.commentBy,
    required this.content,
    required this.commentOn
  });
  Map<String, dynamic> toJson() => {
    'commentBy': commentBy,
    'content': content,
    'commentOn': commentOn
  };
  Comment.fromJson(Map<String, dynamic> hashMap)
  : commentBy = hashMap['commentBy'],
  content = hashMap['content'],
  commentOn = hashMap['commentOn'];
}
