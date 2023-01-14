import 'package:flutter/material.dart';
import 'skill_view.dart';
import '../model/skill.dart';

class UserInfoSkillsView extends StatelessWidget{
  final List<Skill> skills;
  const UserInfoSkillsView(this.skills, {super.key});

  @override
  Widget build(BuildContext context){
    return ListView(
      children: skills.isNotEmpty ? 
        skills.map((skill){
          return SkillView(skill: skill);
        }).toList()
      : <Widget>[],
    );
  }
}
