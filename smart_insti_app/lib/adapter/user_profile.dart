import 'package:flutter/material.dart';

import '../view/user_profile_view.dart';
import '../view/user_info_view.dart';
import '../model/user_data.dart';
import '../model/user_data_model.dart';
import '../adapter/edit_user_profile.dart';

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
  late Future<UserData> profileRef;
  late Future<UserData> myProfileRef;
  var type = "unknown";

  @override
  void initState(){
    super.initState;
    profileRef = UserDataModel.fetch(widget.ldapId);
    myProfileRef = UserDataModel.fetch(widget.viewerLdapId);
  }

  Future<void> getProfile() async {
    final newProfile  = await profileRef;
    final myProfile = await myProfileRef;
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
    });
  }

  Future<void> reloadProfile() async {
    setState((){
      profileRef = UserDataModel.fetch(widget.ldapId);
      myProfileRef = UserDataModel.fetch(widget.viewerLdapId);
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

  @override
  Widget build(BuildContext context){
    getProfile();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        UserProfileView(
          profile: profile,
          type: type,
          follow: follow,
          unfollow: unfollow,
          edit: edit,
        ),
        UserInfoView(profile: profile),
      ],
    );
  }
}
