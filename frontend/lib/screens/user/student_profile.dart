import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/provider/user_provider.dart';

class StudentProfile extends ConsumerWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(userProvider);
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name: ${currentStudent.student.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Email: ${currentStudent.student.email}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Branch: ${currentStudent.student.branch}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Graduation Year: ${currentStudent.student.graduationYear}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'About: ${currentStudent.student.about}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Roles: ${currentStudent.student.roles!.join(', ')}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Column(
            children: currentStudent.student.skills!.map((skill) {
              return Column(children: [
                Text('Achievement: ${skill.name}'),
                Text('Year: ${skill.level}'),
              ]);
            }).toList(),
          ),
          SizedBox(height: 10),
          Column(
            children: currentStudent.student!.achievements!.map((achievement) {
              return Column(children: [
                Text('Achievement: ${achievement.name}'),
                Text('Year: ${achievement.date}'),
                Text('Description: ${achievement.description}'),
              ]);
            }).toList(),
          ),
        ],
      ),
    ));
  }
}
