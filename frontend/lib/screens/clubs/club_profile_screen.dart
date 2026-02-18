import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/club_provider.dart';
import '../../models/club.dart';

class ClubProfileScreen extends ConsumerStatefulWidget {
  final String clubId;
  const ClubProfileScreen({super.key, required this.clubId});

  @override
  ConsumerState<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends ConsumerState<ClubProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clubProvider.notifier).loadClubDetails(widget.clubId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubState = ref.watch(clubProvider);
    final club = clubState.selectedClub;

    if (clubState.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (club == null) {
        return const Scaffold(body: Center(child: Text("Club not found")));
    }

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(club.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                background: Stack(
                    children: [
                        Container(color: UltimateTheme.primaryColor),
                        if (club.banner != null) Image.network(club.banner!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                        Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                ),
                            ),
                        ),
                    ],
                ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // Description
                        Text("About", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(club.description.isNotEmpty ? club.description : "No description available.", style: GoogleFonts.outfit(color: Colors.grey[800], height: 1.5)),
                        const SizedBox(height: 24),

                        // Core Team
                        Text("Core Team", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildMemberSection(club.members ?? []),
                        
                        const SizedBox(height: 24),
                        // Contact
                        Text("Contact", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                         const SizedBox(height: 8),
                         if (club.email != null) 
                            ListTile(
                                leading: const Icon(Icons.email_outlined),
                                title: Text(club.email!, style: GoogleFonts.outfit()),
                                contentPadding: EdgeInsets.zero,
                            ),
                         // Add social links here if needed
                    ],
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberSection(List<ClubMember> members) {
      if (members.isEmpty) return const Text("No members listed.");

      return SizedBox(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              itemBuilder: (context, index) {
                  final member = members[index];
                  return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                          children: [
                              CircleAvatar(
                                  radius: 30,
                                  backgroundImage: member.profilePicURI != null ? NetworkImage(member.profilePicURI!) : null,
                                  child: member.profilePicURI == null ? const Icon(Icons.person) : null,
                              ),
                              const SizedBox(height: 8),
                              Text(member.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(member.role, style: GoogleFonts.outfit(color: UltimateTheme.primaryColor, fontSize: 10), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                      ),
                  );
              },
          ),
      );
  }
}
