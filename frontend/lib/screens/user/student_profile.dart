import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/models/achievement.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'edit_profile.dart';

class StudentProfile extends ConsumerWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final Student currentStudent = authState.currentUser as Student;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // 1. Premium Header with SliverAppBar
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: UltimateTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
              background: Container(
                decoration: BoxDecoration(
                  gradient: UltimateTheme.brandGradient,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            backgroundImage: currentStudent.profilePicURI != null
                                ? NetworkImage(currentStudent.profilePicURI!)
                                : null,
                            child: currentStudent.profilePicURI == null
                                ? const Icon(Icons.person_rounded, size: 60, color: Colors.white)
                                : null,
                          ),
                        ).animate().fadeIn().scale(delay: 200.ms),
                        const SizedBox(height: 16),
                        Text(
                          currentStudent.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                        Text(
                          currentStudent.rollNumber,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen())),
              ),
            ],
          ),

          // 2. Profile Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Academic Info Card
                _buildSectionCard(
                  title: "Academic Profile",
                  icon: Icons.school_rounded,
                  children: [
                    _buildInfoRow("Email", currentStudent.email ?? ''),
                    _buildInfoRow("Branch", currentStudent.branch ?? ''),
                    _buildInfoRow("Class of", "${currentStudent.graduationYear}"),
                  ],
                ),
                const SizedBox(height: 20),

                // Roles & About
                _buildSectionCard(
                  title: "About",
                  icon: Icons.info_outline_rounded,
                  children: [
                    Text(
                      currentStudent.about ?? 'No information provided.',
                      style: GoogleFonts.inter(color: UltimateTheme.textSub, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (currentStudent.roles ?? []).map((role) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.primary,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Skills Section
                if (currentStudent.skills != null && currentStudent.skills!.isNotEmpty) ...[
                  _buildSectionHeader("Technical Skills"),
                  const SizedBox(height: 12),
                  ...currentStudent.skills!.map((skill) => _buildSkillProgress(skill.name ?? '', skill.level.toDouble())),
                  const SizedBox(height: 20),
                ],

                // Achievements Section
                if (currentStudent.achievements != null && currentStudent.achievements!.isNotEmpty) ...[
                  _buildSectionHeader("Achievements"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: currentStudent.achievements!.length,
                      itemBuilder: (context, index) => _buildAchievementCard(currentStudent.achievements![index]),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: UltimateTheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.textMain)),
            ],
          ),
          const Divider(height: 32),
          ...children,
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: UltimateTheme.textSub, fontWeight: FontWeight.w500)),
          Text(value, style: GoogleFonts.inter(color: UltimateTheme.textMain, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
    );
  }

  Widget _buildSkillProgress(String name, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: UltimateTheme.textMain)),
              Text("${level.toInt()}%", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: UltimateTheme.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: level / 100,
              backgroundColor: UltimateTheme.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(UltimateTheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UltimateTheme.primary.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.orangeAccent, size: 28),
          const Spacer(),
          Text(
            achievement.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: UltimateTheme.textSub),
          ),
        ],
      ),
    );
  }
}
