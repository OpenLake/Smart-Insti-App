import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/provider/home_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/alumni.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/event.dart'; // Added import
import 'package:smart_insti_app/provider/event_provider.dart'; // Added import
import '../search/search_screen.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).buildMenuTiles(context);
      ref.read(eventProvider.notifier).loadEvents(); // Load events
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final eventState = ref.watch(eventProvider); // Watch event provider
    final user = ref.watch(authProvider).currentUser;
    String name = "Guest";
    String email = "";
    String? profilePicURI;

    if (user != null) {
      if (user is Student) {
        name = user.name.split(' ').first;
        email = user.email;
        profilePicURI = user.profilePicURI;
      } else if (user is Faculty) {
        name = user.name.split(' ').first;
        email = user.email;
        profilePicURI = user.profilePicURI;
      } else if (user is Admin) {
        name = "Admin";
        email = user.email;
      } else if (user is Alumni) {
        name = user.name.split(' ').first;
        email = user.email;
        profilePicURI = user.profilePicURI;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // 1. Welcome Section with Search
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, $name",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: UltimateTheme.textMain,
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                      },
                      decoration: InputDecoration(
                        hintText: "What are you looking for?",
                        hintStyle: GoogleFonts.inter(color: UltimateTheme.textSub, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: UltimateTheme.primary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Courses Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Courses",
                    style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
                  ),
                  TextButton(
                    onPressed: () => context.push('/user_home/timetables'), // Assuming timetables is the schedule view
                    child: Text(
                      "View Schedule ->",
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: UltimateTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140, // Height for course cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCourseCard("CS301", "Operating Systems", "Mon, Wed 10:00 AM", UltimateTheme.accent),
                  _buildCourseCard("CS302", "Database Systems", "Tue, Thu 11:30 AM", UltimateTheme.primary),
                  _buildCourseCard("CS303", "Computer Networks", "Fri 09:00 AM", UltimateTheme.navy),
                ],
              ),
            ),
          ),

          // 3. Announcement Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              height: 60,
              decoration: BoxDecoration(
                color: UltimateTheme.navy.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: UltimateTheme.navy.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.campaign_rounded, color: UltimateTheme.navy),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Campus Alert: Career Fair starts at 10 AM",
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: UltimateTheme.navy),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: UltimateTheme.navy),
                  const SizedBox(width: 12),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),

          // 4. Quick Actions Grid (4x2)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16, // Increased spacing
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final items = [
                    {"title": "Mess", "icon": Icons.restaurant_menu_rounded, "color": UltimateTheme.primary, "route": "/user_home/mess_menu"},
                    {"title": "Rooms", "icon": Icons.meeting_room_rounded, "color": UltimateTheme.accent, "route": "/user_home/room_vacancy"},
                    {"title": "Emergency", "icon": Icons.health_and_safety_rounded, "color": UltimateTheme.navy, "route": "/user_home/links"},
                    {"title": "Events", "icon": Icons.event_rounded, "color": Colors.orange, "route": "/user_home/events"},
                    {"title": "News", "icon": Icons.article_rounded, "color": UltimateTheme.accent, "route": "/user_home/news"},
                    {"title": "Complaints", "icon": Icons.report_problem_rounded, "color": UltimateTheme.primary, "route": "/user_home/complaints"},
                    {"title": "Lost & Found", "icon": Icons.search_rounded, "color": UltimateTheme.accent, "route": "/user_home/lost_and_found"},
                    {"title": "Study Groups", "icon": Icons.groups_rounded, "color": UltimateTheme.navy, "route": "/user_home/chat_list"},
                    {"title": "Broadcast", "icon": Icons.campaign_rounded, "color": UltimateTheme.primary, "route": "/user_home/broadcast"},
                    {"title": "Buy & Sell", "icon": Icons.storefront_rounded, "color": UltimateTheme.accent, "route": "/user_home/marketplace"},
                    {"title": "Resources", "icon": Icons.folder_copy_outlined, "color": Colors.teal, "route": "/user_home/resources"},
                    {"title": "Clubs", "icon": Icons.groups_outlined, "color": Colors.indigo, "route": "/user_home/clubs"},
                    {"title": "Polls", "icon": Icons.poll_outlined, "color": Colors.purple, "route": "/user_home/polls"},
                    {"title": "Confessions", "icon": Icons.favorite_outline, "color": Colors.pinkAccent, "route": "/user_home/confessions"},
                    {"title": "Calendar", "icon": Icons.calendar_today_outlined, "color": Colors.orange, "route": ""},
                    {"title": "Attendance", "icon": Icons.qr_code, "color": Colors.green, "route": "/user_home/attendance"},
                    {"title": "Alumni", "icon": Icons.school, "color": Colors.blue, "route": "/user_home/alumni"},
                    {"title": "Bus", "icon": Icons.directions_bus, "color": Colors.redAccent, "route": "/user_home/transport"},
                    {"title": "Leaderboard", "icon": Icons.emoji_events, "color": Colors.amber, "route": "/user_home/leaderboard"},
                  ];

                  final item = items[index];
                  final color = item['color'] as Color;

                  return InkWell(
                    onTap: () => context.push(item['route'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
                          ),
                          child: Icon(item['icon'] as IconData, color: color, size: 26),
                        ).animate(delay: (50 * index).ms).scale(curve: Curves.easeOutBack),
                        const Spacer(),
                        Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: UltimateTheme.textSub),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
                childCount: 9,
              ),
            ),
          ),

          // 5. Upcoming Events
// ... (omitting Quick Actions replacement as it was done in previous step, but providing context to match)

          // 5. Upcoming Events
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 100), // Added bottom padding
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upcoming Events",
                    style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
                  ),
                  const SizedBox(height: 16),
                  if (eventState.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (eventState.events.isEmpty)
                    Center(child: Text("No upcoming events", style: GoogleFonts.inter(color: UltimateTheme.textSub)))
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: eventState.events.length, // Use real count
                        itemBuilder: (context, index) => _buildFeaturedEventCard(eventState.events[index]), // Pass event
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String code, String name, String time, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.inter(fontSize: 10, color: UltimateTheme.textSub),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeaturedEventCard(Event event) {
    // Determine icon/emoji based on event type or title (simple mapping)
    String emoji = "📅";
    if (event.type.toLowerCase().contains('gala') || event.title.toLowerCase().contains('party')) {
      emoji = "🎉";
    } else if (event.type.toLowerCase().contains('workshop') || event.title.toLowerCase().contains('workshop')) {
      emoji = "🛠️";
    } else if (event.type.toLowerCase().contains('hackathon')) {
      emoji = "💻";
    } else if (event.category.toLowerCase() == 'sports') {
      emoji = "🏆";
    } else if (event.category.toLowerCase() == 'cultural') {
      emoji = "🎭";
    }

    return GestureDetector(
      onTap: () => context.push('/user_home/events'), // Navigate to events page on tap
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 40))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd').format(event.startTime),
                    style: GoogleFonts.inter(fontSize: 11, color: UltimateTheme.textSub),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
