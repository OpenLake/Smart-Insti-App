import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../confessions/confession_wall_screen.dart';
import '../polls/polls_screen.dart';

class AskYourCampusScreen extends ConsumerStatefulWidget {
  const AskYourCampusScreen({super.key});

  @override
  ConsumerState<AskYourCampusScreen> createState() => _AskYourCampusScreenState();
}

class _AskYourCampusScreenState extends ConsumerState<AskYourCampusScreen> with SingleTickerProviderStateMixin {
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
      backgroundColor: UltimateTheme.backgroundColor,
      body: Column(
        children: [
          Container(
            color: UltimateTheme.surfaceColor,
            child: TabBar(
              controller: _tabController,
              labelColor: UltimateTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: UltimateTheme.primaryColor,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Anonymous Posts"),
                Tab(text: "Polls"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ConfessionListWidget(),
                PollListWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/user_home/confessions/add'),
              backgroundColor: UltimateTheme.primaryColor,
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text("Post anonymously", style: GoogleFonts.outfit(color: Colors.white)),
            )
          : FloatingActionButton.extended(
              onPressed: () => context.push('/user_home/polls/create'),
              backgroundColor: UltimateTheme.primaryColor,
              icon: const Icon(Icons.poll, color: Colors.white),
              label: Text("Create Poll", style: GoogleFonts.outfit(color: Colors.white)),
            ),
    );
  }
}
