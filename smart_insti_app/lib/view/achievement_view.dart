import 'package:flutter/material.dart';
import '../model/achievement.dart';

class AchievementView extends StatelessWidget{
  final Achievement achievement;
  const AchievementView({super.key, required this.achievement});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            achievement.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(achievement.description),
          const Divider(),
        ],
      ),
    );
  }
}
