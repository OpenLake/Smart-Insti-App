import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      body: IndexedStack(
        index: selectedIndex,
        children: actualPages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.link_outlined),
            selectedIcon: Icon(Icons.link),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
