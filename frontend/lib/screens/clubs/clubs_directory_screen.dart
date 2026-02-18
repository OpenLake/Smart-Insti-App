import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/club_provider.dart';
import '../../models/club.dart';

class ClubsDirectoryScreen extends ConsumerStatefulWidget {
  const ClubsDirectoryScreen({super.key});

  @override
  ConsumerState<ClubsDirectoryScreen> createState() => _ClubsDirectoryScreenState();
}

class _ClubsDirectoryScreenState extends ConsumerState<ClubsDirectoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clubProvider.notifier).loadClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubState = ref.watch(clubProvider);
    
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Student Bodies", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        bottom: TabBar(
            controller: _tabController,
            labelColor: UltimateTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: UltimateTheme.primaryColor,
            isScrollable: true,
            tabs: const [
                Tab(text: "All"),
                Tab(text: "Technical"),
                Tab(text: "Cultural"),
                Tab(text: "Sports"),
            ],
        ),
      ),
      body: clubState.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
                _buildClubGrid(clubState.clubs),
                _buildClubGrid(clubState.clubs.where((c) => c.domain == 'Technical').toList()),
                _buildClubGrid(clubState.clubs.where((c) => c.domain == 'Cultural').toList()),
                _buildClubGrid(clubState.clubs.where((c) => c.domain == 'Sports').toList()),
            ],
        ),
    );
  }

  Widget _buildClubGrid(List<Club> clubs) {
    if (clubs.isEmpty) {
        return Center(child: Text("No clubs found", style: GoogleFonts.outfit(color: Colors.grey)));
    }

    return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
        ),
        itemCount: clubs.length,
        itemBuilder: (context, index) {
            final club = clubs[index];
            return GestureDetector(
                onTap: () => context.push('/user_home/clubs/detail/${club.id}'),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundColor: UltimateTheme.primaryColor.withOpacity(0.1),
                                backgroundImage: club.logo != null ? NetworkImage(club.logo!) : null,
                                child: club.logo == null ? Text(club.name[0], style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)) : null,
                            ),
                            const SizedBox(height: 12),
                            Text(club.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(club.type, style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[800])),
                            ),
                        ],
                    ),
                ),
            );
        },
    );
  }
}
