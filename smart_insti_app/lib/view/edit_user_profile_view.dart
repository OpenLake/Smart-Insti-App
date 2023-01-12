import 'package:flutter/material.dart';

import '../model/user_data.dart';
import 'edit_achievement_view.dart';

class EditUserProfileView extends StatefulWidget{
  final UserData profile;
  final Function updateProfile;
  const EditUserProfileView(this.profile, this.updateProfile, {super.key});

  @override
  State<EditUserProfileView> createState() => EditUserProfileViewState();
}

class EditUserProfileViewState extends State<EditUserProfileView>{
  late UserData profile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  updateAchievements(achievements){
    profile.achievements = achievements;
  }

  @override
  void initState(){
    super.initState();
    profile = widget.profile;
    nameController = TextEditingController(text: profile.username);
    descriptionController = TextEditingController(
      text: profile.description.join("\n")
    );
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                      Text("Changing Profile Photo is not supported currently!"),
                  ),
                );
              },
               child: ClipOval(
                child:
                  (profile.profilePhotoURL != '') ?
                  Image(
                    image: NetworkImage(profile.profilePhotoURL),
                    height: 100,
                  )
                  : const Image(
                      image: NetworkImage("https://logodix.com/logo/1070509.png"
                    ),
                    height: 100,
                  ),
              ),
            ),
            // user name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),

            const SizedBox(height: 10),
            // description
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 10),

            // achievements
            OutlinedButton(
              child: const Text("Edit Achievements"),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditAchievementView(profile.achievements, updateAchievements),
                  ), 
                );
              }
            ),

            // skills
            OutlinedButton(
              child: const Text("Edit Skill"),
              onPressed: (){
              }
            ),

            // pors
            OutlinedButton(
              child: const Text("Edit PORs"),
              onPressed: (){
              }
            ),

            // Save button
            ElevatedButton(
              child: const Text("Update Profile"),
              onPressed: (){
                profile.username = nameController.text;
                profile.description = descriptionController.text.split('\n');
                widget.updateProfile(profile);
              }
            ),
          ],
        ),
      ),
    );
  }
}
