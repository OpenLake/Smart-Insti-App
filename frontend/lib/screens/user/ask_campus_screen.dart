import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../campus_posts/campus_post_wall_screen.dart';
import '../polls/polls_screen.dart';

class AskYourCampusScreen extends ConsumerStatefulWidget {
  const AskYourCampusScreen({super.key});

  @override
  ConsumerState<AskYourCampusScreen> createState() =>
      _AskYourCampusScreenState();
}

class _AskYourCampusScreenState extends ConsumerState<AskYourCampusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w600, fontSize: 15),
              tabs: const [
                Tab(text: "Campus Posts"),
                Tab(text: "Campus Polls"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                CampusPostListWidget(),
                PollListWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: _tabController.index == 0
            ? FloatingActionButton.extended(
                onPressed: () => context.push('/user_home/campus-posts/add'),
                backgroundColor: UltimateTheme.primary,
                elevation: 4,
                icon: const Icon(Icons.favorite_rounded, color: Colors.white),
                label: Text("Post Anonymously",
                    style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ).animate().scale(curve: Curves.easeOutBack)
            : FloatingActionButton.extended(
                onPressed: () => context.push('/user_home/polls/create'),
                backgroundColor: UltimateTheme.primary,
                elevation: 4,
                icon: const Icon(Icons.poll_rounded, color: Colors.white),
                label: Text("Create Poll",
                    style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ).animate().scale(curve: Curves.easeOutBack),
      ),
    );
  }
}
