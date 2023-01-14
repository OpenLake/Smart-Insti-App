import 'package:flutter/material.dart';

import '../view/new_post_view.dart';

class NewPost extends StatefulWidget{
  const NewPost({super.key});

  @override
  State<NewPost> createState()=>NewPostState();
}

class NewPostState extends State<NewPost>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: NewPostView(),
    );
  }
}
