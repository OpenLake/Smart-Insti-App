import 'package:flutter/material.dart';

import '../model/user_data_model.dart';
import '../model/user_data.dart';
import '../model/post.dart';
import '../model/post_model.dart';
import '../view/post_feed_view.dart';

class Feed extends StatefulWidget{
  const Feed({super.key});

  @override
  State<Feed> createState() => FeedState();
}

class FeedState extends State<Feed>{
  // This id can be obtained from auth
  final ldapId = 'user_id';
  late Future<UserData> userProfileRef;
  UserData profile = UserDataModel.profile;
  Map<String, UserData> userProfiles = {};
  List<Post> posts = <Post>[];

  @override
  initState(){
    super.initState();
    userProfileRef = UserDataModel.fetch(ldapId);
  }

  Future<void> getData() async {
    final newProfile  = await userProfileRef;
    final newPosts = await PostModel.getPosts(newProfile.following);
    final Map<String, UserData> newUserProfiles = {};
    for(Post post in newPosts){
      if(!newUserProfiles.containsKey(post.postedBy)){
        newUserProfiles[post.postedBy] = await UserDataModel.fetch(post.postedBy);
      }
    }
    setState(() {
      profile = newProfile;
      posts = newPosts;
      userProfiles = newUserProfiles;
    });
  }
  Future<void> reloadData() async {
    setState((){
      userProfileRef = UserDataModel.fetch(ldapId);
    });
    await getData();
  }

  like(post) async {
    await PostModel.like(post, ldapId);
    await reloadData();
  }

  unlike(post) async {
    await PostModel.unlike(post, ldapId);
    await reloadData();
  }

  @override
  Widget build(BuildContext context){
    getData();
    return Scaffold(
       appBar: AppBar(
         title: const Text("Feed"),
         leading: const Icon(Icons.expand_more),
       ),
       body: ListView(
        children: posts.isNotEmpty ?
        posts.map((post){
          return PostFeedView(
            post: post,
            profile: userProfiles[post.postedBy]!,
            like: like,
            unlike: unlike
          );
        }).toList()
      : <Widget>[],
    ),
    );
  }
}
