import 'package:flutter/material.dart';
import '../model/user_data.dart';
import '../constants/text_styles.dart';

class UserProfileView extends StatelessWidget {
  final UserData profile;
  final String type;
  final VoidCallback follow;
  final VoidCallback unfollow;
  final VoidCallback edit;

  const UserProfileView({
    super.key, 
    required this.profile, 
    required this.type, 
    required this.follow, 
    required this.unfollow,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    var descriptionList = <Widget>[];
    for(int i = 0; i < profile.description.length; i++){
      descriptionList.add(Text(profile.description[i]));
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header
          Padding(
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
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.username,
                          style: TextStyles.title,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          profile.userID,
                          style: TextStyles.subtitle,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),

          // about
          Padding(
            padding: EdgeInsets.all(width*0.016),
            // replace this column with a list
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: descriptionList,
            ),
          ),

          // Button
          Padding(
            padding: EdgeInsets.all(width*0.008),
            child: type == "following" ? OutlinedButton(
              onPressed: unfollow,
              child: const Text("Following"),
            ) :
            type == "not following" ?
            ElevatedButton(
              onPressed: follow,
              child: const Text("Follow"),
            )
            : type == "self" ? OutlinedButton(
              onPressed: edit,
              child: const Text("Edit Profile"),
            )
            : OutlinedButton(
              onPressed: (){
              }, 
              child: const Text("Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
