import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../campus_posts/campus_post_wall_screen.dart';
import '../polls/polls_screen.dart';
import 'news_page.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const FeedScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserRole = ref.watch(authProvider).currentUserRole;

    return Scaffold(
      backgroundColor: UltimateTheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: UltimateTheme.primary,
              unselectedLabelColor:
                  UltimateTheme.textSub.withValues(alpha: 0.5),
              indicatorColor: UltimateTheme.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              labelStyle: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(text: "Announcements"),
                Tab(text: "Posts"),
                Tab(text: "Polls"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AnnouncementListWidget(),
                CampusPostListWidget(),
                PollListWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: _buildFAB(currentUserRole, ref),
      ),
    );
  }

  Widget? _buildFAB(String? role, WidgetRef ref) {
    if (_tabController.index == 0) {
      if (role == 'admin' || role == 'faculty') {
        return FloatingActionButton.extended(
          heroTag: 'announcement_fab',
          onPressed: () => showAddAnnouncementDialog(context, ref),
          backgroundColor: UltimateTheme.primary,
          elevation: 4,
          icon: const Icon(Icons.campaign_rounded, color: Colors.white),
          label: Text("Broadcast",
              style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ).animate().scale(curve: Curves.easeOutBack);
      }
      return null;
    } else if (_tabController.index == 1) {
      return FloatingActionButton.extended(
        heroTag: 'post_fab',
        onPressed: () => context.push('/user_home/campus-posts/add'),
        backgroundColor: UltimateTheme.primary,
        elevation: 4,
        icon: const Icon(Icons.favorite_rounded, color: Colors.white),
        label: Text("Post Anonymously",
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(curve: Curves.easeOutBack);
    } else {
      return FloatingActionButton.extended(
        heroTag: 'poll_fab',
        onPressed: () => context.push('/user_home/polls/create'),
        backgroundColor: UltimateTheme.primary,
        elevation: 4,
        icon: const Icon(Icons.poll_rounded, color: Colors.white),
        label: Text("Create Poll",
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(curve: Curves.easeOutBack);
    }
  }
}
