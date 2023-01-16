import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/post.dart';
import '../model/post_model.dart';
import '../model/comment.dart';
import '../constants/text_styles.dart';
import 'comment_view.dart';

class PostView extends StatelessWidget{
  final Post post;
  PostView({super.key, required this.post});
  final TextEditingController contentController = TextEditingController();

  // get this id from auth
  final String ldapId = 'user_id';

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    List<Widget> children = <Widget>[
      MarkdownBody(data: post.content),
      const Divider(),
      Text(
        "Comments",
        style: TextStyles.title,
      ),
      TextField(
        controller: contentController,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: "Comment",
          hintText: "Write comment content here(markdown is supported)...",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
            borderSide: BorderSide(color: Colors.grey, width: width*0.001),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
          ),
        ),
      ),
      OutlinedButton(
        child: const Text("Add Comment"),
        onPressed: (){
          PostModel.addComment(
            post.id,
            Comment(commentBy: ldapId,
              content: contentController.text,
              commentOn: Timestamp.fromDate(DateTime.now())
            )
          );
          post.comments.add(
            Comment(
              commentBy: ldapId,
              content: contentController.text,
              commentOn: Timestamp.fromDate(DateTime.now())
            )
          );
          contentController.text = '';
        },
      ),
    ];
    children.addAll(
      (post.comments.isNotEmpty) ?
        post.comments.map((comment){
          return CommentView(comment: comment);
        }).toList()
        : <Widget>[],
      );
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: EdgeInsets.all(width*0.005),
        child: ListView(
          children: children,
        ),
      )
    );
  }
}
