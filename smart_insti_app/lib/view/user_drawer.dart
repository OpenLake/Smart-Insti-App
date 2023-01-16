import 'package:flutter/material.dart';

import '../model/user_data.dart';
import '../model/user_data_model.dart';
import '../adapter/user_profile.dart';
import '../constants/text_styles.dart';
import '../adapter/new_post.dart';
import '../adapter/feed.dart';
import '../adapter/edit_user_profile.dart';

class UserDrawer extends StatefulWidget{
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => UserDrawerState();
}

class UserDrawerState extends State<UserDrawer>{
  // This id can be obtained from auth
  final ldapId = 'user_id';
  late Future<UserData> userProfileRef;
  UserData profile = UserDataModel.profile;

  @override
  initState(){
    super.initState();
    userProfileRef = UserDataModel.fetch(ldapId);
  }

  Future<void> getData() async {
    final newProfile  = await userProfileRef;
    setState(() {
      profile = newProfile;
    });
  }

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;
    getData();

    return Drawer(
       child: ListView(
         padding: EdgeInsets.zero,
         children: <Widget>[
           DrawerHeader(
             decoration: const BoxDecoration(
               color: Colors.blue,
             ),
             child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:(context) =>
                         UserProfile(
                          ldapId: ldapId,
                          viewerLdapId: ldapId,
                        ),
                      )
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: width*0.01,
                      horizontal: width*0.01
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Expanded(
                          child: ClipOval(
                            child:
                            (profile.profilePhotoURL != '') ?
                            Image(
                              image: NetworkImage(profile.profilePhotoURL),
                            )
                            : const Image(
                              image: NetworkImage("https://logodix.com/logo/1070509.png"),
                            ),
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: width*0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.username,
                                  style: TextStyles.titleLight,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "@${profile.userID}",
                                  style: TextStyles.subtitleLight,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                  )
                ),
                const Divider(),
              ],
            ),
          ),

          // New Post button
          TextButton(
            child: const ListTile(
              leading: Icon(Icons.add),
              title: Text("New Post"),
            ),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) =>
                   NewPost(profile),
                )
              );
            },
          ),

          const Divider(),

          // Feed Button
          TextButton(
            child: const ListTile(
              leading: Icon(Icons.chat),
              title: Text("Feed"),
            ),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) =>
                   const Feed(),
                )
              );
            },
          ),

          const Divider(),

          // Edit Profile
          TextButton(
            child: const ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Profile"),
            ),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) =>
                    UserProfileEdit(profile: profile),
                )
              );
            },
          ),

          const Divider(),
        ],
      ),
    );
  }
}
