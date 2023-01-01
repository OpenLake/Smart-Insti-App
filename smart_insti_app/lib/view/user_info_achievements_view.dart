import 'package:flutter/material.dart';

import 'achievement_view.dart';
import '../model/achievement.dart';

class UserInfoAchievementsView extends StatelessWidget{
  final List<Achievement> achievements;
  const UserInfoAchievementsView(this.achievements, {super.key});

  @override
  Widget build(BuildContext context){
    return ListView(
      children: achievements.isNotEmpty ? 
        achievements.map((achievement){
          return AchievementView(achievement: achievement);
        }).toList()
      : <Widget>[],
    );
  }
}
