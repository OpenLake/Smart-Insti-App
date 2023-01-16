import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/comment.dart';
import '../constants/text_styles.dart';

class CommentView extends StatelessWidget{
  final Comment comment;
  const CommentView({super.key, required this.comment});

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width*0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(data: comment.content),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "- @${comment.commentBy}      ",
              style: TextStyles.boldCount
            )
          ),
          const Divider(),
        ],
      ),
    );
  }
}
