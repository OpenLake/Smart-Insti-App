import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/provider/user_provider.dart';

class FacultyProfile extends ConsumerWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFaculty = ref.watch(userProvider);
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text('Name: ${currentFaculty.faculty.name}',
              style: TextStyle(fontSize: 16)),
          Text('Email: ${currentFaculty.faculty.email}',
              style: TextStyle(fontSize: 16)),
          Text('Department: ${currentFaculty.faculty.department}',
              style: TextStyle(fontSize: 16)),
          Text('Cabin Number: ${currentFaculty.faculty.cabinNumber}',
              style: TextStyle(fontSize: 16)),
          ...currentFaculty.faculty.courses!.map((course) {
            return Column(
              children: <Widget>[
                Text('Course Code: ${course.courseCode}',
                    style: TextStyle(fontSize: 16)),
                Text('Course Name: ${course.courseName}',
                    style: TextStyle(fontSize: 16)),
                Text('Credits: ${course.credits}',
                    style: TextStyle(fontSize: 16)),
                ...course.branches!.map((branch) {
                  return Text('Branch: $branch',
                      style: TextStyle(fontSize: 16));
                }).toList(),
                Text('Primary Room: ${course.primaryRoom}',
                    style: TextStyle(fontSize: 16)),
              ],
            );
          }).toList(),
        ],
      ),
    ));
  }
}
