import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/screens/admin/add_courses.dart';
import 'package:smart_insti_app/screens/admin/add_students.dart';
import 'package:smart_insti_app/screens/admin/admin_home.dart';
import 'package:smart_insti_app/screens/admin/manage_rooms.dart';
import 'package:smart_insti_app/screens/admin/view_students.dart';
import '../screens/admin/add_faculty.dart';
import '../screens/admin/add_menu.dart';
import '../screens/admin/view_courses.dart';
import '../screens/admin/view_faculty.dart';
import '../screens/admin/view_menu.dart';
import '../screens/auth/admin_login.dart';
import '../screens/auth/user_login.dart';

final GoRouter routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: UserLogin()),
      routes: [
        GoRoute(
          path: 'admin_login',
          pageBuilder: (context, state) =>
              const MaterialPage(child: AdminLogin()),
        ),
        GoRoute(
          path: 'admin_home',
          pageBuilder: (context, state) =>
              const MaterialPage(child: AdminHome()),
          routes: [
            GoRoute(
              path: 'add_students',
              pageBuilder: (context, state) =>
                  MaterialPage(child: AddStudents()),
            ),
            GoRoute(
              path: 'add_faculty',
              pageBuilder: (context, state) =>
                  MaterialPage(child: AddFaculty()),
            ),
            GoRoute(
              path: 'add_courses',
              pageBuilder: (context, state) =>
                  MaterialPage(child: AddCourses()),
            ),
            GoRoute(
              path: 'view_students',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ViewStudents()),
            ),
            GoRoute(
              path: 'view_faculty',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ViewFaculty()),
            ),
            GoRoute(
              path: 'view_courses',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ViewCourses()),
            ),
            GoRoute(
              path: 'add_menu',
              pageBuilder: (context, state) =>
                  MaterialPage(child: AddMessMenu()),
            ),
            GoRoute(
              path: 'view_menu',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ViewMessMenu()),
            ),
            GoRoute(
              path: 'manage_rooms',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ManageRooms()),
            )
          ],
        ),
      ],
    ),
  ],
);
