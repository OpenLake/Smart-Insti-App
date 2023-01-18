import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class Post{
  final String id;
  final String title;
  final String postedBy;
  final Timestamp postedOn;
  final String content;
  List<String> likedBy;
  List<Comment> comments;

  Post({
    this.id = '',
    required this.title,
    required this.postedBy,
    required this.postedOn,
    required this.content,
    List<String>? likedBy,
    List<Comment>? comments
  })
      : likedBy = (likedBy == null) ? <String>[] : likedBy,
      comments = (comments == null) ? <Comment>[] : comments;

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data();

    return Post(
      id: snapshot.id,
      title: data?['title'],
      postedBy: data?['postedBy'],
      postedOn: data?['postedOn'],
      content: data?['content'],
      likedBy: data?['likedBy'].cast<String>(),
      comments:
        data?['comments'] is Iterable ?
          List.from(data?['comments']).map((hashMap)=> Comment.fromJson(hashMap)).toList()
          : <Comment>[]
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'title': title,
      'postedBy': postedBy,
      'postedOn': postedOn,
      'content': content,
      'likedBy': likedBy,
    };
  }
}
