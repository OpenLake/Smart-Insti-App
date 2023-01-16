import 'package:flutter/material.dart';

import '../model/user_data_model.dart';
import '../adapter/user_profile.dart';

class SearchUserView extends StatefulWidget{
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => SearchUserViewState();
}

class SearchUserViewState extends State<SearchUserView>{
  final TextEditingController searchController = TextEditingController();

  search() async{
    bool exists = await UserDataModel.checkUser(searchController.text);
    if(exists){
      openProfile();
    }
    else{
      inform();
    }
  }

  openProfile(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) =>
         UserProfile(ldapId: searchController.text, viewerLdapId: 'user_id'),
      )
    );
  }
  inform(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User not found..."),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(width*0.05),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search User",
                hintText: "Search User",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(width*0.05)),
                  borderSide: BorderSide(color: Colors.grey, width: width*0.001),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(width*0.05)),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: search,
            child: const Text("Search")
          ),
        ]
      )
    );
  }
}
