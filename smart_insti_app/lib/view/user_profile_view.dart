import 'package:flutter/material.dart';
import '../model/user_data.dart';

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
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        profile.userID,
                        style: const TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w400, 
                          color: Color.fromARGB(200, 00, 00, 00)
                        ),
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
