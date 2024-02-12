import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/screens/admin/add_courses.dart';
import 'package:smart_insti_app/screens/admin/add_students.dart';
import 'package:smart_insti_app/screens/admin/admin_home.dart';
import 'package:smart_insti_app/screens/admin/manage_rooms.dart';
import 'package:smart_insti_app/screens/admin/view_students.dart';
import 'package:smart_insti_app/screens/auth/user_login.dart';
import 'package:smart_insti_app/screens/lost_and_found.dart';
import '../screens/admin/add_faculty.dart';
import '../screens/admin/add_menu.dart';
import '../screens/admin/view_courses.dart';
import '../screens/admin/view_faculty.dart';
import '../screens/admin/view_menu.dart';
import '../screens/auth/admin_login.dart';

import '../screens/room_vacancy.dart';
import '../screens/user/user_home.dart';
import '../screens/user_profile.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: UserLogin()),
      routes: [
        GoRoute(
          path: 'user_home',
          pageBuilder: (context, state) => MaterialPage(child: UserHome()),
          routes: [
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
              path: 'view_menu',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ViewMessMenu()),
            ),
            GoRoute(
              path: 'classroom_vacancy',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: RoomVacancy()),
            ),
            GoRoute(
              path: 'lost_and_found',
              pageBuilder: (context, state) =>
                  MaterialPage(child: LostAndFound()),
            ),
            GoRoute(
              path: 'manage_rooms',
              pageBuilder: (context, state) =>
                  MaterialPage(child: ManageRooms()),
            ),
            GoRoute(
              path: 'user_profile',
              pageBuilder: (context, state) =>
                  MaterialPage(child: UserProfile()),
            ),
          ],
        ),
        GoRoute(
          path: 'admin_login',
          pageBuilder: (context, state) => MaterialPage(child: AdminLogin()),
          routes: [
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
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
