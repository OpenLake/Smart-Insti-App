import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import '../../constants/constants.dart';
import '../../models/student.dart';

class StudentProfile extends ConsumerWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    final Student currentStudent = ref.read(authProvider).currentUser as Student;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name: ${currentStudent.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Email: ${currentStudent.email}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Branch: ${currentStudent.branch}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Graduation Year: ${currentStudent.graduationYear}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'About: ${currentStudent.about}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Roles: ${currentStudent.roles!.join(', ')}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Column(
            children: currentStudent.skills!.map((skill) {
              return Column(children: [
                Text('Achievement: ${skill.name}'),
                Text('Year: ${skill.level}'),
              ]);
            }).toList(),
          ),
          SizedBox(height: 10),
          Column(
            children: currentStudent.achievements!.map((achievement) {
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
