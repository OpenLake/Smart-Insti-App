import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/screens/main_scaffold.dart';
import 'package:smart_insti_app/screens/auth/login_general.dart';
import '../screens/auth/admin_login.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/user/user_home.dart';

import 'admin_routes.dart';
import 'user_routes.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/user_home',
  redirect: (context, state) {
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/user_home',
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OnboardingScreen()),
    ),
    GoRoute(
      path: '/verify-otp',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OTPVerificationScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => MaterialPage(child: GeneralLogin()),
      routes: [
        GoRoute(
          path: 'admin_login',
          pageBuilder: (context, state) => MaterialPage(child: AdminLogin()),
        ),
      ],
    ),
    adminRoute,
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/user_home',
          pageBuilder: (context, state) =>
              const MaterialPage(child: UserHome()),
          routes: userRoutes,
        ),
      ],
    ),
  ],
);
