import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';

import '../../constants/constants.dart';

class FacultyProfile extends ConsumerWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    final Faculty currentFaculty = ref.read(authProvider).currentUser as Faculty;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text('Name: ${currentFaculty.name}', style: TextStyle(fontSize: 16)),
          Text('Email: ${currentFaculty.email}', style: TextStyle(fontSize: 16)),
          Text('Department: ${currentFaculty.department}', style: TextStyle(fontSize: 16)),
          Text('Cabin Number: ${currentFaculty.cabin}', style: TextStyle(fontSize: 16)),
        ],
      ),
    ));
  }
}
