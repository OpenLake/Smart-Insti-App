import 'package:flutter/material.dart';
import '../model/user_data.dart';
import '../constants/text_styles.dart';

class UserProfileView extends StatelessWidget {
  final UserData profile;
  final String type;
  final VoidCallback follow;
  final VoidCallback unfollow;

  const UserProfileView({
    super.key, 
    required this.profile, 
    required this.type, 
    required this.follow, 
    required this.unfollow
  });

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Avatar
                ClipOval(
                  child: 
                  (profile.profilePhotoURL != '') ? 
                  Image(
                    image: NetworkImage(profile.profilePhotoURL),
                    height: 60,
                  )
                  : const Image(
                    image: NetworkImage("https://logodix.com/logo/1070509.png"),
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
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
                ),
              ],
            ),
          ),

          // about
          Padding(
            padding: const EdgeInsets.all(16.0),
            // replace this column with a list
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: descriptionList,
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              onPressed: unfollow, 
              child: const Text("Edit Profile"),
            )
            : OutlinedButton(
              onPressed: unfollow, 
              child: const Text("Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
