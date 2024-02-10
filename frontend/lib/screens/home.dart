import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../provider/student_provider.dart';

class Home extends ConsumerWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.read(studentProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConstants.appName,
          ),
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.push('/user_profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                context.push('/admin_home');
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Tap the icon to view your profile.'),
            ],
          ),
        ),
      ),
    );
  }
}
