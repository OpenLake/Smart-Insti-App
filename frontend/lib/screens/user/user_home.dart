import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/alumni.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/event.dart';
import 'package:smart_insti_app/provider/event_provider.dart';
import '../search/search_screen.dart';
import 'package:smart_insti_app/provider/user_bundle_provider.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/models/acad_course.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(eventProvider.notifier).loadEvents();
      ref.read(acadmapProvider.notifier).fetchCourses();
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
    final eventState = ref.watch(eventProvider);
    final user = ref.watch(authProvider).currentUser;
    final bundleState = ref.watch(userBundleProvider);
    final acadmapState = ref.watch(acadmapProvider);
    
    String firstName = "Guest";

    if (user != null) {
      if (user is Student) {
        firstName = user.name.split(' ').first;
      } else if (user is Faculty) {
        firstName = user.name.split(' ').first;
      } else if (user is Admin) {
        firstName = "Admin";
      } else if (user is Alumni) {
        firstName = user.name.split(' ').first;
      }
    } else {
      // Fallback to Hub bundle name
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
        "icon": Icons.restaurant_menu_rounded,
        "color": UltimateTheme.primary,
        "route": "/user_home/mess_menu"
      },
      {
        "title": "Rooms",
        "icon": Icons.meeting_room_rounded,
        "color": UltimateTheme.secondary,
        "route": "/user_home/room_vacancy"
      },
      {
        "title": "Events",
        "icon": Icons.event_rounded,
        "color": UltimateTheme.accent,
        "route": "/user_home/events"
      },
      {
        "title": "Academics",
        "icon": Icons.school_rounded,
        "color": UltimateTheme.primary,
        "route": "/user_home/academics"
      },
      {
        "title": "News",
        "icon": Icons.article_rounded,
        "color": UltimateTheme.secondary,
        "route": "/user_home/news"
      },
      {
        "title": "Feedback",
        "icon": Icons.feedback_rounded,
        "color": UltimateTheme.accent,
        "route": "/user_home/complaints"
      },
      {
        "title": "Lost & Found",
        "icon": Icons.search_rounded,
        "color": UltimateTheme.primary,
        "route": "/user_home/lost_and_found"
      },
      {
        "title": "Clubs",
        "icon": Icons.groups_outlined,
        "color": UltimateTheme.secondary,
        "route": "/user_home/clubs"
      },
      {
        "title": "Polls",
        "icon": Icons.poll_outlined,
        "color": UltimateTheme.accent,
        "route": "/user_home/polls"
      },
      {
        "title": "Confessions",
        "icon": Icons.favorite_outline,
        "color": Colors.pinkAccent,
        "route": "/user_home/confessions"
      },
      {
        "title": "Attendance",
        "icon": Icons.qr_code,
        "color": UltimateTheme.primary,
        "route": "/user_home/attendance"
      },
      {
        "title": "Bus",
        "icon": Icons.directions_bus,
        "color": UltimateTheme.secondary,
        "route": "/user_home/transport"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                              fontSize: 16,
                              color: UltimateTheme.textSub,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            firstName,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.textMain,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideX(begin: -0.2),
                      GestureDetector(
                        onTap: () {
                          if (user is Student) {
                            context.push('/user_home/student_profile');
                          } else if (user is Faculty) {
                            context.push('/user_home/faculty_profile');
                          } else if (user is Alumni) {
                            context.push('/user_home/student_profile');
                          } else {
                            context.go('/login');
                          }
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              UltimateTheme.primary.withValues(alpha: 0.1),
                          backgroundImage: () {
                            // 1. Check local profile image
                            if (user != null &&
                                (user is Student ||
                                    user is Faculty ||
                                    user is Alumni) &&
                                (user as dynamic).profilePicURI != null) {
                              return NetworkImage((user as dynamic).profilePicURI!);
                            }
                            // 2. Fallback to Hub/Acadmap profile image
                            final hubImage = bundleState.value?.academics?.acadmap?.profileImage;
                            if (hubImage != null && hubImage.isNotEmpty) {
                              return NetworkImage(hubImage);
                            }
                            return null;
                          }(),
                          child: (user == null ||
                                  (user is Student ||
                                          user is Faculty ||
                                          user is Alumni) &&
                                      (user as dynamic).profilePicURI == null &&
                                      (bundleState.value?.academics?.acadmap?.profileImage == null))
                              ? const Icon(Icons.person_outline_rounded,
                                  color: UltimateTheme.primary)
                              : null,
                        ),
                      ).animate().fadeIn().scale(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchScreen())),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                            color:
                                UltimateTheme.textSub.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: UltimateTheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            "Search for modules, courses...",
                            style: GoogleFonts.inter(
                                color: UltimateTheme.textSub, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),

          // 2. Courses Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Courses",
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textMain),
                  ),
                  TextButton(
                    onPressed: () => context.push('/user_home/timetables'),
                    child: Text(
                      "Full Schedule",
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: UltimateTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: bundleState.when(
                data: (bundle) {
                  if (bundle == null) {
                    return Center(
                      child: Text(
                        "Please log in to see your courses",
                        style: GoogleFonts.inter(color: UltimateTheme.textSub),
                      ),
                    );
                  }

                  final selectedCodes = bundle.academics?.acadmap?.selectedCourses ?? [];
                  
                  if (selectedCodes.isEmpty) {
                    return Center(
                      child: Text(
                        "No courses selected in Acadmap",
                        style: GoogleFonts.inter(color: UltimateTheme.textSub),
                      ),
                    );
                  }

                  final List<AcadCourse> myCourses = [];
                  for (final code in selectedCodes) {
                    final match = acadmapState.courses.firstWhere(
                      (c) {
                        final catalogCodes = c.code.toLowerCase().split('/').map((s) => s.trim());
                        final bundleCodes = code.toLowerCase().split('/').map((s) => s.trim());
                        return catalogCodes.any((cc) => bundleCodes.contains(cc));
                      },
                      orElse: () => AcadCourse(id: '', code: code, title: 'Details Pending...', department: '', credits: 0, syllabus: []),
                    );
                    myCourses.add(match);
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: myCourses.length,
                    itemBuilder: (context, index) {
                      final course = myCourses[index];
                      // Choose a color based on index
                      final colors = [UltimateTheme.primary, UltimateTheme.secondary, UltimateTheme.accent];
                      final color = colors[index % colors.length];
                      
                      return _buildCourseCard(
                        course.code,
                        course.title,
                        course.department.isEmpty ? "Ecosystem Core" : course.department,
                        color,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text("Fetching Bundle...", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                error: (e, __) => Center(
                  child: Text(
                    "Hub Error: ${e.toString().split('\n').first}",
                    style: const TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              ),
            ),
          ),


          // 3. Quick Actions Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Quick Actions",
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: UltimateTheme.textMain),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = quickActionItems[index];
                  final color = item['color'] as Color;

                  return GestureDetector(
                    onTap: () => context.push(item['route'] as String),
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: color.withValues(alpha: 0.15),
                                width: 1.5),
                          ),
                          child: Icon(item['icon'] as IconData,
                              color: color, size: 28),
                        )
                            .animate(delay: (40 * index).ms)
                            .scale(curve: Curves.easeOutBack),
                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: UltimateTheme.textMain),
                        ),
                      ],
                    ),
                  );
                },
                childCount: quickActionItems.length,
              ),
            ),
          ),

          // 4. Upcoming Events
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.textMain),
                      ),
                      TextButton(
                        onPressed: () => context.push('/user_home/events'),
                        child: Text(
                          "Explore All",
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (eventState.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (eventState.events.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: UltimateTheme.bentoDecoration(context),
                      child: Center(
                        child: Text("No upcoming events",
                            style: GoogleFonts.inter(
                                color: UltimateTheme.textSub)),
                      ),
                    )
                  else
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: eventState.events.length,
                        itemBuilder: (context, index) =>
                            _buildFeaturedEventCard(eventState.events[index]),
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

  Widget _buildCourseCard(
      String code, String name, String details, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  code,
                  style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.bold, color: color),
                ),
              ),
              Icon(Icons.more_vert_rounded,
                  size: 18,
                  color: UltimateTheme.textSub.withValues(alpha: 0.5)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: UltimateTheme.textMain),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 12, color: UltimateTheme.textSub),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      details,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: UltimateTheme.textSub,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildFeaturedEventCard(Event event) {
    String emoji = "📅";
    if (event.type.toLowerCase().contains('gala') ||
        event.title.toLowerCase().contains('party')) {
      emoji = "🎉";
    } else if (event.type.toLowerCase().contains('workshop') ||
        event.title.toLowerCase().contains('workshop')) {
      emoji = "🛠️";
    } else if (event.type.toLowerCase().contains('hackathon')) {
      emoji = "💻";
    } else if (event.category.toLowerCase() == 'sports') {
      emoji = "🏆";
    } else if (event.category.toLowerCase() == 'cultural') {
      emoji = "🎭";
    }

    return GestureDetector(
      onTap: () => context.push('/user_home/events'),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: UltimateTheme.primary.withValues(alpha: 0.05),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 48))),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textMain),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 12, color: UltimateTheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.startTime),
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: UltimateTheme.textSub,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
