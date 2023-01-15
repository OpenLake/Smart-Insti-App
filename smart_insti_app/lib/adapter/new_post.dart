import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../model/user_data.dart';
import '../model/post.dart';
import '../view/new_post_view.dart';

class NewPost extends StatefulWidget{
  final UserData profile;
  const NewPost(this.profile, {super.key});

  @override
  State<NewPost> createState()=>NewPostState();
}

class NewPostState extends State<NewPost>{

  addPost(Post post) async{
    await PostModel.addPost(post);
    inform();
  }
  inform(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Added New Post"),
      ),
    );
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: NewPostView(addPost, widget.profile),
    );
  }
}
