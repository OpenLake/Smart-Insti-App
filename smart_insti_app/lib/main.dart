import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'adapter/user_profile.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Insti App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('user_id'),
          leading: const Icon(Icons.expand_more),
        ),
        body: const UserProfile(
          viewerLdapId: "viewer_id",
          ldapId: "viewer_id"
        ),
      ),
    );
  }
}
