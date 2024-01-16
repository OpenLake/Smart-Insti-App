import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home.dart';

final GoRouter routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: Home()),
    )
  ],
);
