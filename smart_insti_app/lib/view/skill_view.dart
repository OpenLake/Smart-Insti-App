import 'package:flutter/material.dart';

import '../model/skill.dart';
import '../constants/text_styles.dart';

class SkillView extends StatelessWidget{
  final Skill skill;
  const SkillView({super.key, required this.skill});

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width*0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                skill.title,
                style: 
                  TextStyles.title,
              ),
              const Expanded(child: Text("")),
              Profeciency(skill.profeciency)
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class Profeciency extends StatelessWidget{
  final int rating; 
  const Profeciency(this.rating, {super.key});

  @override
  Widget build(BuildContext context){
    var stars = <Widget>[];
    for(int i = 1; i <= 5; i++){
      stars.add(rating < i ? const Icon(Icons.star_border) : const Icon(Icons.star));
    }
    return Row(
      children: stars,
    );
  }
}
