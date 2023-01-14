import 'package:flutter/material.dart';

import 'post_view.dart';
import '../model/post.dart';
import '../model/user_data.dart';

class NewPostView extends StatefulWidget{
  final Function addPost;
  final UserData profile;
  const NewPostView(this.addPost, this.profile, {super.key});

  @override
  State<NewPostView> createState() => NewPostViewState();
}

class NewPostViewState extends State<NewPostView>{
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late Function addPost;

  @override
  void initState() {
    super.initState();
    addPost = widget.addPost;
  }
  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width*0.025),
      child: Column(
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "Title",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                borderSide: BorderSide(color: Colors.grey, width: width*0.001),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
              ),
            ),
          ),

          SizedBox(height: width*0.015),

          TextField(
            controller: contentController,
            maxLines: 15,
            decoration: InputDecoration(
              labelText: "Post",
              hintText: "Write post content here(markdown is supported)...",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                borderSide: BorderSide(color: Colors.grey, width: width*0.001),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  child: const Text('Preview'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:(context) =>
                         PostView(
                          post: Post(
                            title: titleController.text,
                            postedBy: widget.profile.userID,
                            content: contentController.text,
                          ),
                        ),
                      )
                    );
                  },
                )
              ),

              SizedBox(width: width*0.015),

              Expanded(
                child: ElevatedButton(
                  child: const Text('Post'),
                  onPressed: () {
                    addPost(
                      Post(
                        title: titleController.text,
                        postedBy: widget.profile.userID,
                        content: contentController.text,
                      )
                    );
                  },
                )
              ),
            ]
          ),
        ],
      )
    );
  }
}
