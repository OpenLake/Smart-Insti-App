import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'post.dart';

class PostModel{
  static Future<void> addPost(Post post) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    if(post.title != '' || post.content != ''){
      await db.collection('posts')
          .withConverter(
            fromFirestore: Post.fromFirestore,
            toFirestore: (Post data, _) => data.toFirestore()
          )
          .doc()
          .set(post);
    }
  }
  static Future<List<Post>> getPosts(List<String> by) async{
    WidgetsFlutterBinding.ensureInitialized();
    final db = FirebaseFirestore.instance;
    List<Post> posts = <Post>[];
    final querySnap = await db.collection('posts')
        .where('postedBy', whereIn: by)
        .orderBy('postedOn', descending: true)
        .withConverter(
            fromFirestore: Post.fromFirestore,
            toFirestore: (Post data, _) => data.toFirestore()
          )
        .get();
    for(var docSnap in querySnap.docs){
      posts.add(docSnap.data());
    }
    return posts;
  }
}
