import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/screens/main_scaffold.dart';
import 'package:smart_insti_app/screens/admin/add_courses.dart';
import 'package:smart_insti_app/screens/admin/add_students.dart';
import 'package:smart_insti_app/screens/admin/admin_home.dart';
import 'package:smart_insti_app/screens/admin/manage_rooms.dart';
import 'package:smart_insti_app/screens/admin/view_students.dart';
import 'package:smart_insti_app/screens/auth/login_general.dart';
import 'package:smart_insti_app/screens/loading_page.dart';
import 'package:smart_insti_app/screens/user/lost_and_found.dart';
import 'package:smart_insti_app/screens/user/user_mess_menu.dart';
import 'package:smart_insti_app/screens/user/timetable_editor.dart';
import 'package:smart_insti_app/screens/user/events_page.dart';
import 'package:smart_insti_app/screens/user/news_page.dart';
import 'package:smart_insti_app/screens/feedback/feedback_screen.dart'; // Mapped to Complaints
import 'package:smart_insti_app/screens/user/links_page.dart';
import '../screens/admin/add_faculty.dart';
import '../screens/admin/add_menu.dart';
import '../screens/admin/admin_profile.dart';
import '../screens/admin/view_courses.dart';
import '../screens/admin/view_faculty.dart';
import '../screens/admin/view_menu.dart';
import '../screens/auth/admin_login.dart';
import '../screens/user/chat_room.dart';
import '../screens/user/room_vacancy.dart';
import '../screens/user/timetables.dart';
import '../screens/user/student_profile.dart';
import '../screens/user/user_home.dart';
import '../screens/user/faculty_profile.dart';
import '../screens/user/broadcast.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/private_chat_screen.dart';

// Actually imports are at line 34.
import '../screens/marketplace/marketplace_screen.dart';
import '../screens/marketplace/add_listing_screen.dart';
import '../screens/marketplace/listing_detail.dart';
import '../screens/marketplace/wishlist_screen.dart';
import '../screens/admin/admin_complaints.dart';
import '../screens/attendance/attendance_history_screen.dart';
import '../screens/attendance/qr_scanner_screen.dart';
import '../screens/resources/resources_screen.dart';
import '../screens/resources/add_resource_screen.dart';
import '../screens/clubs/clubs_directory_screen.dart';
import '../screens/clubs/club_profile_screen.dart';
import 'package:smart_insti_app/screens/user/ask_campus_screen.dart';
import 'package:smart_insti_app/screens/polls/create_poll_screen.dart';
import '../screens/confessions/add_confession_screen.dart';
import '../screens/polls/polls_screen.dart';
import '../screens/polls/create_poll_screen.dart';
import '../screens/alumni/alumni_directory_screen.dart';
import '../screens/transport/transport_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/admin/admin_analytics_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/gamification/leaderboard_screen.dart';


final GoRouter routes = GoRouter(
  initialLocation: '/user_home',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/user_home',
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
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) => const MaterialPage(child: AdminHome()),
      routes: [
        GoRoute(
          path: 'profile',
          pageBuilder: (context, state) => const MaterialPage(child: AdminProfile()),
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
          pageBuilder: (context, state) => const MaterialPage(child: AdminComplaintScreen()),
        )
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/user_home',
          pageBuilder: (context, state) => const MaterialPage(child: UserHome()),
          routes: [
            GoRoute(
              path: 'profile',
              // Placeholder logic for profile: requires auth check usually done in redirection or the page itself
              pageBuilder: (context, state) => const MaterialPage(child: StudentProfile()), 
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
              pageBuilder: (context, state) => const MaterialPage(child: FacultyProfile()),
            ),
            GoRoute(
              path: 'student_profile',
              pageBuilder: (context, state) => const MaterialPage(child: StudentProfile()),
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
                  pageBuilder: (context, state) => const MaterialPage(child: TimetableEditor()),
                ),
              ],
            ),
            GoRoute(
              path: 'clubs',
              pageBuilder: (context, state) => const MaterialPage(child: ClubsDirectoryScreen()),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  pageBuilder: (context, state) => MaterialPage(child: ClubProfileScreen(clubId: state.pathParameters['id']!)),
                ),
              ]
            ),
            GoRoute(
              path: 'favorites',
              pageBuilder: (context, state) => const MaterialPage(child: WishlistScreen()),
            ),
            GoRoute(
              path: 'confessions',
              pageBuilder: (context, state) => const MaterialPage(child: AskYourCampusScreen()),
              routes: [
                 GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) => const MaterialPage(child: AddConfessionScreen()),
                ),
              ]
            ),
            GoRoute(
              path: 'polls', // Add polls route group
              pageBuilder: (context, state) => const MaterialPage(child: AskYourCampusScreen()), // Reuse main screen if traversed directly
              routes: [
                 GoRoute(
                  path: 'create',
                  pageBuilder: (context, state) => const MaterialPage(child: CreatePollScreen()),
                 ),
              ]
            ),
            GoRoute(
              path: 'calendar',
              pageBuilder: (context, state) => const MaterialPage(child: CalendarScreen()),
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
              pageBuilder: (context, state) => MaterialPage(child: UserMessMenu()) 
            ),
            GoRoute(
              path: 'complaints',
              pageBuilder: (context, state) => const MaterialPage(child: FeedbackScreen()),
            ),
            GoRoute(
              path: 'chat_list',
              pageBuilder: (context, state) => const MaterialPage(child: ChatListScreen()),
            ),
            GoRoute(
              path: 'marketplace',
              pageBuilder: (context, state) => const MaterialPage(child: MarketplaceScreen()),
              routes: [
                GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) => const MaterialPage(child: AddListingScreen()),
                ),
                GoRoute(
                  path: 'detail/:id',
                  pageBuilder: (context, state) => MaterialPage(child: ListingDetailScreen(listingId: state.pathParameters['id']!)),
                ),
                GoRoute(
                  path: 'wishlist',
                  pageBuilder: (context, state) => const MaterialPage(child: WishlistScreen()),
                ),
              ],
            ),
            GoRoute(
              path: 'alumni',
              pageBuilder: (context, state) => const MaterialPage(child: AlumniDirectoryScreen()),
            ),
            GoRoute(
              path: 'transport',
              pageBuilder: (context, state) => const MaterialPage(child: TransportScreen()),
            ),
            GoRoute(
              path: 'leaderboard',
              pageBuilder: (context, state) => const MaterialPage(child: LeaderboardScreen()),
            ),
            GoRoute(
              path: 'settings',
              pageBuilder: (context, state) => const MaterialPage(child: SettingsScreen()),
            ),
            GoRoute(
              path: 'analytics',
              pageBuilder: (context, state) => const MaterialPage(child: AdminAnalyticsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
