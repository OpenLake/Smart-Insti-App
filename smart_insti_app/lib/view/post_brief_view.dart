import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/post.dart';
import 'post_view.dart';

class PostBriefView extends StatelessWidget{
  final Post post;
  const PostBriefView({super.key, required this.post});

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;
    final String content =
        (post.content.length > 360) ?
          "${post.content.substring(0, 260)} **Read more...**"
          : post.content;

    return TextButton(
      child: Padding(
        padding: EdgeInsets.all(width*0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              MarkdownBody(data: content),
              const Divider(),
          ],
        ),
      ),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:(context) =>
             PostView(
              post: post,
            ),
          )
        );
      },
    );
  }
}
