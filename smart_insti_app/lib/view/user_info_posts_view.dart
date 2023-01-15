import 'package:flutter/material.dart';

import '../model/post.dart';
import 'post_brief_view.dart';

class UserInfoPostsView extends StatelessWidget{
  final List<Post> posts;
  const UserInfoPostsView(this.posts, {super.key});

  @override
  Widget build(BuildContext context){
    return ListView(
      children: posts.isNotEmpty ?
        posts.map((post){
          return PostBriefView(post: post);
        }).toList()
      : <Widget>[],
    );
  }
}
