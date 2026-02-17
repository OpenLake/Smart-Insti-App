import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/collapsing_app_bar.dart';
import 'package:smart_insti_app/provider/admin_provider.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import '../../constants/constants.dart';
import '../../models/admin.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminProvider);
    final user = ref.watch(authProvider).currentUser;
    String name = "Administrator";
    if (user != null && user is Admin) {
      name = user.name.split(' ').first;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Admin Hero Block
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              height: 220,
              decoration: UltimateTheme.brandCardDecoration,
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Opacity(
                      opacity: 0.1,
                      child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 240),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Restricted Access",
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        Text(
                          "Welcome back,\n$name",
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildAdminStatBadge("System Active", Icons.check_circle_rounded),
                            const SizedBox(width: 12),
                            _buildAdminStatBadge("All Nodes Up", Icons.lan_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
          ),

          // 2. Search & Tools Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: UltimateTheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: ref.read(adminProvider).searchController,
                        onChanged: (value) => ref.read(adminProvider.notifier).buildMenuTiles(context),
                        decoration: InputDecoration(
                          hintText: "Search controls...",
                          hintStyle: GoogleFonts.inter(color: UltimateTheme.textSub, fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: UltimateTheme.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildAdminActionIcon(Icons.logout_rounded, () {
                    ref.read(authServiceProvider).clearCredentials();
                    ref.read(authProvider.notifier).clearCurrentUser();
                    context.go('/');
                  }),
                ],
              ),
            ),
          ),

          // 3. Management Bento Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ref.watch(adminProvider).menuTiles[index];
                },
                childCount: ref.watch(adminProvider).menuTiles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStatBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: Icon(icon, color: UltimateTheme.textMain, size: 24),
      ),
    );
  }
}
