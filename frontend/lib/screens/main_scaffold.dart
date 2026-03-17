import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/alumni.dart';
import 'package:smart_insti_app/screens/search/search_screen.dart';
import 'package:smart_insti_app/constants/route_constants.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final String location = GoRouterState.of(context).uri.toString();

    // Drawer User Details Logic
    final user = authState.currentUser;
    String name = "Guest";
    String email = "Welcome to Smart Insti";
    String? profilePicURI;

    if (user != null) {
      if (user is Student) {
        name = user.name;
        email = user.email;
        profilePicURI = user.profilePicURI;
      } else if (user is Faculty) {
        name = user.name;
        email = user.email;
        profilePicURI = user.profilePicURI;
      } else if (user is Admin) {
        name = "Administrator";
        email = user.email;
      } else if (user is Alumni) {
        name = user.name;
        email = user.email;
        profilePicURI = user.profilePicURI;
      }
    }

    // Dynamic Title Logic
    String title = "IIT Bhilai";
    String matchedRoute = RouteConstants.routeTitles.keys.firstWhere(
      (route) => location.startsWith(route),
      orElse: () => '/user_home',
    );

    if (matchedRoute != '/user_home') {
      title = RouteConstants.routeTitles[matchedRoute] ?? "IIT Bhilai";
    }

    if (location.contains('/campus-posts') ||
        location.contains('/polls') ||
        location.contains('/feed') ||
        location.contains('/news')) {
      title = "Feed";
      if (location.contains('/campus-posts')) title = "Campus Posts";
      if (location.contains('/polls')) title = "Campus Polls";
      if (location.contains('/news')) title = "Announcements";
    }

    String profileRoute = '/login';
    if (user != null) {
      if (user is Student) {
        profileRoute = '/user_home/student_profile';
      } else if (user is Faculty) {
        profileRoute = '/user_home/faculty_profile';
      } else if (user is Admin) {
        profileRoute = '/admin/profile';
      } else if (user is Alumni) {
        profileRoute = '/user_home/student_profile'; // Fallback for now
      }
    }

    return Scaffold(
      extendBody: false,
      drawer: _buildDrawer(
          context, ref, name, email, profilePicURI, user, profileRoute),
      appBar: AppBar(
        leadingWidth: 64,
        leading: Builder(
          builder: (context) {
            final bool canPop = Navigator.of(context).canPop();
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                    canPop
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.menu_rounded,
                    color: UltimateTheme.primary,
                    size: 18),
              ),
              onPressed: () {
                if (canPop) {
                  Navigator.of(context).pop();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            );
          },
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: UltimateTheme.textMain,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded,
                color: UltimateTheme.textSub.withValues(alpha: 0.7)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context, profileRoute),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, String name,
      String email, String? profilePicURI, dynamic user, String profileRoute) {
    return Drawer(
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: BoxDecoration(
              gradient: UltimateTheme.brandGradient,
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context).cardTheme.color,
                    backgroundImage: profilePicURI != null
                        ? NetworkImage(profilePicURI)
                        : null,
                    child: profilePicURI == null
                        ? Text(name.isNotEmpty ? name[0] : "G",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: UltimateTheme.primary))
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              children: [
                _buildDrawerItem(Icons.person_outline_rounded, "Profile", () {
                  Navigator.pop(context);
                  context.push(profileRoute);
                }),
                _buildDrawerItem(Icons.settings_outlined, "Settings", () {
                  Navigator.pop(context);
                  context.push('/user_home/settings');
                }),
                if (user is Admin)
                  _buildDrawerItem(Icons.analytics_outlined, "Analytics", () {
                    Navigator.pop(context);
                    context.push('/user_home/analytics');
                  }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),
                _buildDrawerItem(Icons.logout_rounded, "Logout", () async {
                  await ref.read(authServiceProvider).logout();
                  if (context.mounted) context.go('/login');
                }, isDestructive: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Smart Insti v2.0",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: UltimateTheme.textSub.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive ? Colors.redAccent : UltimateTheme.textSub),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDestructive ? Colors.redAccent : UltimateTheme.textMain,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, String profileRoute) {
    return Container(
      height: 84, // Increased height for the stuck look
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: UltimateTheme.primary.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, '/user_home', Icons.home_outlined,
                  Icons.home_rounded, "Home"),
              _buildNavItem(context, '/user_home/feed', Icons.favorite_outline,
                  Icons.favorite_rounded, "Feed"),
              _buildNavItem(
                  context,
                  '/user_home/marketplace',
                  Icons.shopping_bag_outlined,
                  Icons.shopping_bag_rounded,
                  "Market"),
              _buildNavItem(
                  context,
                  '/user_home/notifications',
                  Icons.notifications_none_rounded,
                  Icons.notifications_rounded,
                  "Alerts"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String route, IconData icon,
      IconData activeIcon, String label) {
    final String location = GoRouterState.of(context).uri.toString();

    bool isSelected = false;
    if (route == '/' || route == '/user_home') {
      bool isOtherTab = location.contains('/feed') ||
          location.contains('/news') ||
          location.contains('/campus-posts') ||
          location.contains('/polls') ||
          location.contains('/marketplace') ||
          location.contains('/notifications') ||
          location.contains('/student_profile') ||
          location.contains('/faculty_profile') ||
          location.contains('/admin/profile');
      isSelected = !isOtherTab;
    } else {
      isSelected = location == route ||
          (route != '/' && location.startsWith(route)) ||
          (route == '/user_home/feed' &&
              (location.contains('/campus-posts') ||
                  location.contains('/polls') ||
                  location.contains('/news')));
    }

    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? UltimateTheme.skeletonBrown
                  : UltimateTheme.textSub,
              size: 24,
            )
                .animate(target: isSelected ? 1 : 0)
                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: UltimateTheme.primary,
                  shape: BoxShape.circle,
                ),
              ).animate().fadeIn().scale(),
          ],
        ),
      ),
    );
  }
}
