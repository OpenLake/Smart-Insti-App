import 'package:flutter/material.dart';

import '../view/user_profile_view.dart';
import '../view/user_info_view.dart';
import '../model/user_data.dart';
import '../model/user_data_model.dart';
import '../model/post.dart';
import '../model/post_model.dart';
import '../adapter/edit_user_profile.dart';
import '../adapter/new_post.dart';

class UserProfile extends StatefulWidget{
  final String ldapId;
  final String viewerLdapId;
  const UserProfile({
    super.key,
    required this.ldapId,
    required this.viewerLdapId
  });
  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile>{
  var profile = UserDataModel.profile;
  var posts = <Post>[];
  late Future<UserData> profileRef;
  late Future<UserData> myProfileRef;
  late Future<List<Post>> postsRef;
  var type = "unknown";

  @override
  void initState(){
    super.initState;
    profileRef = UserDataModel.fetch(widget.ldapId);
    myProfileRef = UserDataModel.fetch(widget.viewerLdapId);
    postsRef = PostModel.getPosts([widget.ldapId]);
  }

  Future<void> getProfile() async {
    final newProfile  = await profileRef;
    final myProfile = await myProfileRef;
    final newPosts = await postsRef;
    setState(() {
      if(myProfile.userID == newProfile.userID){
        type = "self";
      }
      else{
         type = myProfile.following.contains(newProfile.userID) ?
             "following"
             : "not following";
      }
      profile = newProfile;
      posts = newPosts;
    });
  }

  Future<void> reloadProfile() async {
    setState((){
      profileRef = UserDataModel.fetch(widget.ldapId);
      myProfileRef = UserDataModel.fetch(widget.viewerLdapId);
      postsRef = PostModel.getPosts([widget.ldapId]);
    });
    await getProfile();
  }

  follow() async {
    await UserDataModel.follow(widget.viewerLdapId, widget.ldapId);
    await reloadProfile();
    setState((){
      type = "following";
    });
  }

  unfollow() async {
    await UserDataModel.unfollow(widget.viewerLdapId, widget.ldapId);
    await reloadProfile();
    setState((){
      type = "not following";
    });
  }
  edit(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) =>
         UserProfileEdit(profile: profile),
      )
    );
  }
  addPost(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) =>
         NewPost(profile),
      )
    );
  }

  @override
  Widget build(BuildContext context){
    getProfile();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ldapId),
        leading: const Icon(Icons.expand_more),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserProfileView(
            profile: profile,
            type: type,
            follow: follow,
            unfollow: unfollow,
            edit: edit,
            addPost: addPost,
          ),
          UserInfoView(profile: profile, posts: posts),
        ],
      )
    );
  }
}
