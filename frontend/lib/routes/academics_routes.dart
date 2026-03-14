import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/academics/academics_home.dart';
import '../screens/academics/acad_courses_screen.dart';
import '../screens/academics/acad_timetable_screen.dart';
import '../screens/academics/acad_curriculum_screen.dart';
import '../screens/academics/acad_departments_screen.dart';
import '../screens/academics/acad_personal_schedule_screen.dart';

final GoRoute academicsRoute = GoRoute(
  path: 'academics',
  pageBuilder: (context, state) => const MaterialPage(child: AcademicsHome()),
  routes: [
    GoRoute(
      path: 'courses',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AcadCoursesScreen()),
    ),
    GoRoute(
      path: 'timetable',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AcadTimetableScreen()),
    ),
    GoRoute(
      path: 'personal_schedule',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AcadPersonalScheduleScreen()),
    ),
    GoRoute(
      path: 'curriculum',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AcadCurriculumScreen()),
    ),
    GoRoute(
      path: 'departments',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AcadDepartmentsScreen()),
    ),
  ],
);
