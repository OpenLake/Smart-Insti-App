import 'package:flutter/material.dart';

import '../model/user_data_model.dart';
import '../model/user_data.dart';
import '../view/edit_user_profile_view.dart';


class UserProfileEdit extends StatefulWidget{
  final UserData profile;
  const UserProfileEdit({
    super.key,
    required this.profile,
  });
  @override
  State<UserProfileEdit> createState() => UserProfileEditState();
}

class UserProfileEditState extends State<UserProfileEdit>{
  late UserData profile = widget.profile;
  late Future<UserData> profileRef;
  late Future<UserData> myProfileRef;
  var type = "unknown";

  @override
  void initState(){
    super.initState;
    profile = widget.profile;
  }

  update(updatedProfile) async {
    await UserDataModel.updateProfile(updatedProfile.userID, updatedProfile);
    // await reloadProfile();
    inform();
    setState((){
      profile = updatedProfile;
      // type = "following";
    });
  }

  inform(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated"),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        leading: const Icon(Icons.expand_more),
      ),
      body: EditUserProfileView(profile, update),
    );
  }
}
