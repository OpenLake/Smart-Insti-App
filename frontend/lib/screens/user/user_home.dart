import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/event_provider.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/components/featured_hero_card.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/alumni.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/acad_timetable.dart';
import 'package:smart_insti_app/utils/timetable_utils.dart';
import 'package:smart_insti_app/provider/user_bundle_provider.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  int _currentSubTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(eventProvider.notifier).loadEvents();
      ref.read(acadmapProvider.notifier).fetchCourses();
      ref.read(acadmapProvider.notifier).fetchTimetable();
      await ref.read(authProvider.notifier).getCurrentUser(context);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).currentUser;
    final bundleState = ref.watch(userBundleProvider);
    final eventState = ref.watch(eventProvider);
    final acadmapState = ref.watch(acadmapProvider);

    String firstName = "Guest";
    List<String> wishlist = [];
    if (user != null) {
      if (user is Student) {
        firstName = user.name.split(' ').first;
        wishlist = user.wishlist;
      } else if (user is Faculty) {
        firstName = user.name.split(' ').first;
      } else if (user is Alumni) {
        firstName = user.name.split(' ').first;
      } else if (user is Admin) {
        firstName = "Admin";
      }
    } else {
      bundleState.whenData((bundle) {
        final bundleName = bundle?.identity.name;
        if (bundleName != null && bundleName.isNotEmpty) {
          firstName = bundleName.split(' ').first;
        }
      });
    }

    final quickActionItems = [
      {
        "title": "Mess",
        "subtitle": "Weekly Menu",
        "icon": Icons.restaurant_menu_rounded,
        "route": "/user_home/mess_menu",
        "color": const Color(0xFFF1655E)
      },
      {
        "title": "Rooms",
        "subtitle": "Check Vacancy",
        "icon": Icons.meeting_room_rounded,
        "route": "/user_home/room_vacancy",
        "color": const Color(0xFF504EC6)
      },
      {
        "title": "Events",
        "subtitle": "Happenings",
        "icon": Icons.event_rounded,
        "route": "/user_home/events",
        "color": const Color(0xFFC48154)
      },
      {
        "title": "Academics",
        "subtitle": "Courses",
        "icon": Icons.school_rounded,
        "route": "/user_home/academics",
        "color": const Color(0xFFFFC107)
      },
      {
        "title": "Feedback",
        "subtitle": "Report Issues",
        "icon": Icons.feedback_rounded,
        "route": "/user_home/complaints",
        "color": const Color(0xFFE91E63)
      },
      {
        "title": "Lost & Found",
        "subtitle": "Find Items",
        "icon": Icons.search_rounded,
        "route": "/user_home/lost_and_found",
        "color": const Color(0xFF2196F3)
      },
    ];

    return Scaffold(
      backgroundColor: UltimateTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Dark Top Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: const BoxDecoration(
                color: UltimateTheme.accent, // Use design system accent
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Welcome, $firstName!",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: UltimateTheme.skeletonBrown,
                        child: Icon(Icons.person_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Search Bar
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: Colors.white70, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            "Search for courses, events...",
                            style: GoogleFonts.inter(
                              color: Colors.white30,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  // 2. Featured Card
                  if (eventState.events.isNotEmpty)
                    FeaturedHeroCard(
                      event: eventState.events.first,
                      onTap: () => context.push('/user_home/events'),
                    )
                  else
                    const FeaturedHeroCard(),

                  const SizedBox(height: 32),

                  // 3. Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildTabItem(0, "Quick Actions"),
                        const SizedBox(width: 12),
                        _buildTabItem(1, "Schedule"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Content Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              UltimateTheme.skeletonRed.withValues(alpha: 0.1),
                          border: Border.all(
                              color: UltimateTheme.skeletonRed, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentSubTab == 0
                              ? "EXPLORE MODULES"
                              : "TODAY'S SCHEDULE",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.skeletonRed,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. Grid/List Content
                  _currentSubTab == 0
                      ? _buildGridView(quickActionItems)
                      : _buildListView(acadmapState.timetable, wishlist),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool isActive = _currentSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? UltimateTheme.accent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isActive)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isActive ? Colors.white : UltimateTheme.accent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final Color itemColor = item['color'] as Color;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return GestureDetector(
            onTap: () => context.push(item['route']),
            child: Container(
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: isDark ? 0.15 : 0.06),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: itemColor.withValues(alpha: isDark ? 0.3 : 0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: itemColor.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    // Decorative Background Icon
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: Icon(
                        item['icon'] as IconData,
                        size: 90,
                        color: itemColor.withValues(alpha: 0.05),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: itemColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              size: 20,
                              color: itemColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.textMain,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  UltimateTheme.textSub.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<AcadTimetable> timetable, List<String> wishlist) {
    final todayClasses = TimetableUtils.getTodaysClasses(timetable, wishlist);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (todayClasses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: UltimateTheme.primary.withValues(alpha: isDark ? 0.1 : 0.04),
            borderRadius: BorderRadius.circular(28),
            border:
                Border.all(color: UltimateTheme.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              const Icon(Icons.wb_sunny_rounded,
                  size: 40, color: Colors.orangeAccent),
              const SizedBox(height: 16),
              Text(
                "No classes today!",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: UltimateTheme.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Check back tomorrow or explore modules",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: UltimateTheme.textMain.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todayClasses.length,
        itemBuilder: (context, index) {
          final entry = todayClasses[index];
          final AcadTimetable t = entry['timetable'] as AcadTimetable;
          final TimeOfDay startTime = entry['startTime'] as TimeOfDay;
          final accentColor = UltimateTheme.primary;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        startTime.format(context).split(' ')[0],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        startTime.format(context).split(' ')[1],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: accentColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: UltimateTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 12,
                              color: UltimateTheme.textMain
                                  .withValues(alpha: 0.3)),
                          const SizedBox(width: 4),
                          Text(
                            "${entry['type']} • ${entry['venue']}",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: UltimateTheme.textMain
                                  .withValues(alpha: 0.45),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: accentColor.withValues(alpha: 0.3)),
              ],
            ),
          );
        },
      ),
    );
  }
}
