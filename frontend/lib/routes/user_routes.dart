import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/user/student_profile.dart';
import '../screens/user/news_page.dart';
import '../screens/user/events_page.dart';
import '../screens/user/links_page.dart';
import '../screens/user/faculty_profile.dart';
import '../screens/user/room_vacancy.dart';
import '../screens/user/lost_and_found.dart';
import '../screens/user/timetables.dart';
import '../screens/user/timetable_editor.dart';
import '../screens/clubs/clubs_directory_screen.dart';
import '../screens/clubs/club_profile_screen.dart';
import '../screens/marketplace/wishlist_screen.dart';
import '../screens/user/ask_campus_screen.dart';
import '../screens/campus_posts/add_campus_post_screen.dart';
import '../screens/polls/create_poll_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/user/broadcast.dart';
import '../screens/user/chat_room.dart';
import '../screens/user/user_mess_menu.dart';
import '../screens/feedback/feedback_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/private_chat_screen.dart';
import '../screens/alumni/alumni_directory_screen.dart';
import '../screens/transport/transport_screen.dart';
import '../screens/gamification/leaderboard_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/admin/admin_analytics_screen.dart';
import '../screens/resources/resources_screen.dart';
import '../screens/resources/add_resource_screen.dart';
import '../screens/attendance/attendance_history_screen.dart';
import '../screens/attendance/qr_scanner_screen.dart';

import 'academics_routes.dart';
import 'marketplace_routes.dart';

final List<RouteBase> userRoutes = [
  GoRoute(
    path: 'profile',
    pageBuilder: (context, state) =>
        const MaterialPage(child: StudentProfile()),
  ),
  GoRoute(
    path: 'news',
    pageBuilder: (context, state) => const MaterialPage(child: NewsPage()),
  ),
  GoRoute(
    path: 'events',
    pageBuilder: (context, state) => const MaterialPage(child: EventsPage()),
  ),
  GoRoute(
    path: 'links',
    pageBuilder: (context, state) => const MaterialPage(child: LinksPage()),
  ),
  GoRoute(
    path: 'faculty_profile',
    pageBuilder: (context, state) =>
        const MaterialPage(child: FacultyProfile()),
  ),
  GoRoute(
    path: 'student_profile',
    pageBuilder: (context, state) =>
        const MaterialPage(child: StudentProfile()),
  ),
  GoRoute(
    path: 'room_vacancy',
    pageBuilder: (context, state) => const MaterialPage(child: RoomVacancy()),
  ),
  GoRoute(
    path: 'lost_and_found',
    pageBuilder: (context, state) => MaterialPage(child: LostAndFound()),
  ),
  GoRoute(
    path: 'timetables',
    pageBuilder: (context, state) => MaterialPage(child: Timetables()),
    routes: [
      GoRoute(
        path: 'editor',
        pageBuilder: (context, state) =>
            const MaterialPage(child: TimetableEditor()),
      ),
    ],
  ),
  GoRoute(
      path: 'clubs',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ClubsDirectoryScreen()),
      routes: [
        GoRoute(
          path: 'detail/:id',
          pageBuilder: (context, state) => MaterialPage(
              child: ClubProfileScreen(clubId: state.pathParameters['id']!)),
        ),
      ]),
  GoRoute(
    path: 'favorites',
    pageBuilder: (context, state) =>
        const MaterialPage(child: WishlistScreen()),
  ),
  GoRoute(
      path: 'campus-posts',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AskYourCampusScreen()),
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) =>
              const MaterialPage(child: AddCampusPostScreen()),
        ),
      ]),
  GoRoute(
      path: 'polls',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AskYourCampusScreen()),
      routes: [
        GoRoute(
          path: 'create',
          pageBuilder: (context, state) =>
              const MaterialPage(child: CreatePollScreen()),
        ),
      ]),
  GoRoute(
    path: 'calendar',
    pageBuilder: (context, state) =>
        const MaterialPage(child: CalendarScreen()),
  ),
  GoRoute(
    path: 'broadcast',
    pageBuilder: (context, state) => MaterialPage(child: BroadcastPage()),
  ),
  GoRoute(
    path: 'chat_room',
    pageBuilder: (context, state) => MaterialPage(child: ChatRoom()),
  ),
  GoRoute(
      path: 'mess_menu',
      pageBuilder: (context, state) => MaterialPage(child: UserMessMenu())),
  GoRoute(
    path: 'complaints',
    pageBuilder: (context, state) =>
        const MaterialPage(child: FeedbackScreen()),
  ),
  GoRoute(
    path: 'chat_list',
    pageBuilder: (context, state) =>
        const MaterialPage(child: ChatListScreen()),
    routes: [
      GoRoute(
        path: 'chat/:cid/:uid/:name',
        pageBuilder: (context, state) => MaterialPage(
          child: PrivateChatScreen(
            conversationId: state.pathParameters['cid']!,
            targetUserId: state.pathParameters['uid']!,
            targetUserName: state.pathParameters['name']!,
          ),
        ),
      ),
    ],
  ),
  marketplaceRoute,
  GoRoute(
    path: 'alumni',
    pageBuilder: (context, state) =>
        const MaterialPage(child: AlumniDirectoryScreen()),
  ),
  GoRoute(
    path: 'transport',
    pageBuilder: (context, state) =>
        const MaterialPage(child: TransportScreen()),
  ),
  GoRoute(
    path: 'leaderboard',
    pageBuilder: (context, state) =>
        const MaterialPage(child: LeaderboardScreen()),
  ),
  GoRoute(
    path: 'settings',
    pageBuilder: (context, state) =>
        const MaterialPage(child: SettingsScreen()),
  ),
  GoRoute(
    path: 'analytics',
    pageBuilder: (context, state) =>
        const MaterialPage(child: AdminAnalyticsScreen()),
  ),
  GoRoute(
    path: 'resources',
    pageBuilder: (context, state) =>
        const MaterialPage(child: ResourcesScreen()),
    routes: [
      GoRoute(
        path: 'add',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AddResourceScreen()),
      ),
    ],
  ),
  GoRoute(
    path: 'attendance',
    pageBuilder: (context, state) =>
        const MaterialPage(child: AttendanceHistoryScreen()),
    routes: [
      GoRoute(
        path: 'scan',
        pageBuilder: (context, state) =>
            const MaterialPage(child: QRScannerScreen()),
      ),
    ],
  ),
  academicsRoute,
];
