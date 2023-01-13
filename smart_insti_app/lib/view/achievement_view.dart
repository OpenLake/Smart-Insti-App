import 'package:flutter/material.dart';
import '../model/achievement.dart';
import '../constants/text_styles.dart';

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
            style: TextStyles.title,
          ),
          Text(achievement.description),
          const Divider(),
        ],
      ),
    );
  }
}
