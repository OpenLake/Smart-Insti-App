import 'package:flutter/material.dart';

import '../view/user_info_posts_view.dart';
import '../view/user_info_achievements_view.dart';
import '../view/user_info_skills_view.dart';
import '../view/user_info_pors_view.dart';
import '../model/user_data.dart';
import '../model/post.dart';

class UserInfoView extends StatefulWidget {
  final UserData profile; 
  final List<Post> posts;
  const UserInfoView({ super.key, required this.profile, required this.posts});
  @override
  State<UserInfoView> createState() => UserInfoViewState();
}

class UserInfoViewState extends State<UserInfoView> 
  with SingleTickerProviderStateMixin 
{
  static const List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.grid_on)),
    Tab(icon: Icon(Icons.emoji_events)),
    Tab(icon: Icon(Icons.star)),
    Tab(icon: Icon(Icons.badge)),
  ];

  late TabController _tabController;
  late int _selectedTabBar;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _selectedTabBar = 0;
  }

 @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          onTap: (index){
            setState((){
              _selectedTabBar = index;
            });
          },
          tabs: myTabs,
          labelColor: Colors.black,
        ),

        const Divider(),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: 
              (_selectedTabBar == 0) ? 
                UserInfoPostsView(widget.posts)
              :(_selectedTabBar == 1) ? 
                UserInfoAchievementsView(widget.profile.achievements)
              :(_selectedTabBar == 2) ? 
                UserInfoSkillsView(widget.profile.skills)
                :UserInfoPorsView(widget.profile.pors),
        ),
      ],
    );
  }
}
