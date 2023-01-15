import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String id;
  final String title;
  final String postedBy;
  final Timestamp postedOn;
  final String content;
  List<String> likedBy;

  Post({
    this.id = '',
    required this.title,
    required this.postedBy,
    required this.postedOn,
    required this.content,
    List<String>? likedBy
  })
      : likedBy = (likedBy == null) ? <String>[] : likedBy;

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
