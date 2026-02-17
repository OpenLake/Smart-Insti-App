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

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(bottomNavIndexProvider);
    final authState = ref.watch(authProvider);

    final List<Widget> pages = [
      const UserHome(),
      const NewsPage(),
      const EventsPage(),
      const LinksPage(),
      // Profile Tab: Show Profile if logged in, else Login Screen (embedded or redirected)
      // For now, let's show LoginGeneral if not logged in.
       authState.token != null ? const Center(child: Text("Profile Placeholder")) : GeneralLogin(),
    ];
    
    // If logged in, maybe show profile page properly. 
    // But for now "Profile Placeholder" or specific profile page based on role.
    
    Widget getProfilePage() {
       if (authState.token != null) {
          // You might want a dedicated ProfileWrapper or similar.
          // For now, let's just use a placeholder text or redirect logic.
           return Scaffold(
             appBar: AppBar(title: const Text("Profile")),
             body: Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Logged in as ${authState.currentUserRole}"),
                   ElevatedButton(
                     onPressed: () {
                         ref.read(authServiceProvider).clearCredentials();
                         ref.read(authProvider.notifier).clearCurrentUser();
                         // The state change will trigger rebuild and show Login
                     },
                     child: const Text("Logout"),
                   )
                 ],
               ),
             ),
           );
       }
       return GeneralLogin();
    }
    
    // Update pages list with dynamic profile 
    final List<Widget> actualPages = [
      const UserHome(),
      const NewsPage(),
      const EventsPage(),
      const LinksPage(),
      getProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {},
        ),
        title: const Text("IIT Bhilai"),
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
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const UserHome(),
          const NewsPage(),
          const EventsPage(),
          const LinksPage(),
          getProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bottomNavIndexProvider.notifier).state = 4;
        },
        backgroundColor: UltimateTheme.primary,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        padding: EdgeInsets.zero,
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCustomNavItem(0, Icons.home_outlined, Icons.home_rounded, "Home", selectedIndex == 0, ref),
            _buildCustomNavItem(1, Icons.explore_outlined, Icons.explore_rounded, "Feed", selectedIndex == 1, ref),
            const SizedBox(width: 48), // Space for FAB
            _buildCustomNavItem(2, Icons.calendar_today_outlined, Icons.calendar_today_rounded, "Events", selectedIndex == 2, ref),
            _buildCustomNavItem(3, Icons.widgets_outlined, Icons.widgets_rounded, "Links", selectedIndex == 3, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavItem(int index, IconData icon, IconData activeIcon, String label, bool isSelected, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? UltimateTheme.primary : UltimateTheme.textSub,
            size: 24,
          ),
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
    ).animate().scale(begin: isSelected ? const Offset(1.1, 1.1) : const Offset(1, 1), duration: 200.ms);
  }
}
