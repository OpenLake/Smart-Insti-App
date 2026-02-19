import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import 'package:smart_insti_app/screens/user/complaint_page.dart';
import 'package:smart_insti_app/screens/user/events_page.dart';
import 'package:smart_insti_app/screens/user/links_page.dart';
import 'package:smart_insti_app/screens/user/news_page.dart';
import 'package:smart_insti_app/screens/user/user_home.dart';
import 'package:smart_insti_app/screens/auth/login_general.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/alumni.dart';

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

    // Dynamic Title Logic
    String title = "IIT Bhilai";
    if (location.contains('/news')) title = "Feed";
    else if (location.contains('/confessions') || location.contains('/polls')) title = "Ask Your Campus";
    else if (location.contains('/events')) title = "Explore";
    else if (location.contains('/student_profile') || location.contains('/profile')) title = "Profile";
    else if (location == '/user_home') title = "IIT Bhilai";
    // Add more conditions as needed for other sub-pages if they need specific titles over the default

    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: UltimateTheme.primary),
                accountName: Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                accountEmail: Text(email, style: GoogleFonts.outfit()),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: profilePicURI != null ? NetworkImage(profilePicURI) : null,
                    child: profilePicURI == null ? Text(name.isNotEmpty ? name[0] : "G", style: const TextStyle(fontSize: 24, color: UltimateTheme.primary)) : null,
                ),
             ),
             ListTile(
                leading: const Icon(Icons.person),
                title: Text("Profile", style: GoogleFonts.outfit()),
                onTap: () {
                    Navigator.pop(context);
                    context.push('/user_home/student_profile'); 
                },
             ),
             ListTile(
                leading: const Icon(Icons.settings),
                title: Text("Settings", style: GoogleFonts.outfit()),
                onTap: () {
                    Navigator.pop(context);
                    context.push('/user_home/settings');
                },
             ),
             if (user is Admin)
               ListTile(
                  leading: const Icon(Icons.analytics, color: Colors.blue),
                  title: Text("Analytics", style: GoogleFonts.outfit()),
                  onTap: () {
                      Navigator.pop(context);
                      context.push('/user_home/analytics');
                  },
               ),
             const Divider(),
             ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text("Logout", style: GoogleFonts.outfit(color: Colors.red)),
                onTap: () async {
                    await ref.read(authServiceProvider).logout();
                    if (context.mounted) context.go('/login');
                },
             ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        padding: EdgeInsets.zero,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCustomNavItem(context, '/user_home/news', Icons.explore_outlined, Icons.explore_rounded, "Feed"),
            _buildCustomNavItem(context, '/user_home/confessions', Icons.favorite_outline, Icons.favorite_rounded, "Campus"),
            _buildCustomNavItem(context, '/user_home', Icons.home_outlined, Icons.home_rounded, "Home"),
            _buildCustomNavItem(context, '/user_home/events', Icons.search_outlined, Icons.search_rounded, "Explore"),
            _buildCustomNavItem(context, '/user_home/student_profile', Icons.person_outline, Icons.person_rounded, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavItem(BuildContext context, String route, IconData icon, IconData activeIcon, String label) {
    final String location = GoRouterState.of(context).uri.toString();
    
    bool isSelected = false;
    // Specific check for Home to avoid matching prefixes of other routes if they share structure, though here we have distinct paths mostly.
    // However, logic:
    // Feed: /user_home/news
    // Confession: /user_home/confessions
    // Home: /user_home
    // Explore: /user_home/events
    // Profile: /user_home/student_profile

    if (route == '/user_home') {
       // Only selected if strictly /user_home OR a subroute that isn't one of the other main tabs
       // Identifying other tabs:
       bool isOtherTab = location.contains('/news') || location.contains('/confessions') || location.contains('/events') || location.contains('/student_profile');
       isSelected = !isOtherTab; 
    } else {
       isSelected = location.contains(route.split('/').last); // e.g. contains 'news', 'confessions'
    }

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? UltimateTheme.primary : UltimateTheme.textSub,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? UltimateTheme.primary : UltimateTheme.textSub,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(begin: isSelected ? const Offset(1.1, 1.1) : const Offset(1, 1), duration: 200.ms);
  }
}
