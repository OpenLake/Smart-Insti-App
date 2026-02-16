import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/collapsing_app_bar.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/provider/home_provider.dart';
import '../../constants/constants.dart';
import '../../models/faculty.dart';
import '../../models/student.dart';
import 'package:smart_insti_app/models/alumni.dart';
import '../../models/admin.dart'; // Add Admin import
import '../../services/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart'; // Add Google Fonts import

class UserHome extends ConsumerWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).buildMenuTiles(context);
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
         // Only verify if we think we have a session (e.g. not explicitly guest). 
         // For now, verifyAuthTokenExistence redirects to / if invalid.
         // We should probably modify verifyAuthTokenExistence or just skip it if we are in "MainScaffold" which handles guests.
         // Let's rely on AuthState. If token is null, we are guest.
      }
    });

    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(builder: (_, ref, __) {
                          final user = ref.watch(authProvider).currentUser;
                          final role = ref.watch(authProvider).currentUserRole;
                          String name = "Guest";
                          if (user != null) {
                             if (user is Student) name = user.name.split(' ').first;
                             else if (user is Faculty) name = user.name.split(' ').first;
                             else if (user is Admin) name = "Admin";
                             else if (user is Alumni) name = user.name.split(' ').first;
                          }
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good Morning,",
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                name,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.notifications_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: ref.read(homeProvider.notifier).searchController,
                        onChanged: (value) => ref.read(homeProvider.notifier).buildMenuTiles(context),
                        decoration: InputDecoration(
                          hintText: "Search features...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quick Actions",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Grid of Menu Tiles
                      Consumer(
                        builder: (_, ref, ___) {
                          final tiles = ref.watch(homeProvider).menuTiles;
                          if (tiles.isEmpty) return const Center(child: Text("No features found"));
                          
                          // Convert existing tiles (which are likely containers/cards) to a clean grid
                          // For now, we reuse the provider's list but lay it out differently if possible
                          // or just wrap them.
                          // Actually, homeProvider builds specific widgets. Let's use GridView inside the column.
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: tiles,
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      Text(
                        "Recent Updates",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Placeholder for horizontal news scroll (could integrate PostProvider here later)
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                             _buildPromoCard(context, "Tech Fest 2024", "Register now!", Colors.purple.shade50),
                             _buildPromoCard(context, "Exam Schedule", "View timetable", Colors.orange.shade50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, String title, String subtitle, Color color) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
           Text(subtitle, style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}

