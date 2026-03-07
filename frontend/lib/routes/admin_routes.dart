import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/admin/admin_home.dart';
import '../screens/admin/admin_profile.dart';
import '../screens/admin/add_students.dart';
import '../screens/admin/add_faculty.dart';
import '../screens/admin/add_courses.dart';
import '../screens/admin/view_students.dart';
import '../screens/admin/view_faculty.dart';
import '../screens/admin/view_courses.dart';
import '../screens/admin/add_menu.dart';
import '../screens/admin/view_menu.dart';
import '../screens/admin/manage_rooms.dart';
import '../screens/admin/admin_complaints.dart';

final GoRoute adminRoute = GoRoute(
  path: '/admin',
  pageBuilder: (context, state) => const MaterialPage(child: AdminHome()),
  routes: [
    GoRoute(
      path: 'profile',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AdminProfile()),
    ),
    GoRoute(
      path: 'add_students',
      pageBuilder: (context, state) => MaterialPage(child: AddStudents()),
    ),
    GoRoute(
      path: 'add_faculty',
      pageBuilder: (context, state) => MaterialPage(child: AddFaculty()),
    ),
    GoRoute(
      path: 'add_courses',
      pageBuilder: (context, state) => MaterialPage(child: AddCourses()),
    ),
    GoRoute(
      path: 'view_students',
      pageBuilder: (context, state) => MaterialPage(child: ViewStudents()),
    ),
    GoRoute(
      path: 'view_faculty',
      pageBuilder: (context, state) => MaterialPage(child: ViewFaculty()),
    ),
    GoRoute(
      path: 'view_courses',
      pageBuilder: (context, state) => MaterialPage(child: ViewCourses()),
    ),
    GoRoute(
      path: 'add_menu',
      pageBuilder: (context, state) => MaterialPage(child: AddMessMenu()),
    ),
    GoRoute(
      path: 'view_menu',
      pageBuilder: (context, state) => MaterialPage(child: ViewMessMenu()),
    ),
    GoRoute(
      path: 'manage_rooms',
      pageBuilder: (context, state) => MaterialPage(child: ManageRooms()),
    ),
    GoRoute(
      path: 'manage_complaints',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AdminComplaintScreen()),
    )
  ],
);
