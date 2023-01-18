import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../model/post.dart';
import '../constants/text_styles.dart';

class PostView extends StatelessWidget{
  final Post post;
  const PostView({super.key, required this.post});

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: EdgeInsets.all(width*0.005),
        child: Markdown(data: post.content),
      ),
    );
  }
}
