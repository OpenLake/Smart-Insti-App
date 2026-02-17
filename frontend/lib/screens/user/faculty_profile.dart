import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import '../../constants/constants.dart';

class FacultyProfile extends ConsumerWidget {
  const FacultyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress && context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    final Faculty currentFaculty = ref.read(authProvider).currentUser as Faculty;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // 1. Premium Header with SliverAppBar
          SliverAppBar(
            expandedHeight: 250,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                      ),
                    ).animate().fadeIn().scale(delay: 200.ms),
                    const SizedBox(height: 16),
                    Text(
                      currentFaculty.name,
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    Text(
                      (currentFaculty.department ?? '').toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
              ),
            ),
          ),

          // 2. Body Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Professional Info
                _buildSectionCard(
                  title: "Professional Details",
                  icon: Icons.badge_rounded,
                  children: [
                    _buildInfoRow("Email", currentFaculty.email ?? ''),
                    _buildInfoRow("Department", currentFaculty.department ?? ''),
                    _buildInfoRow("Cabin Number", currentFaculty.cabinNumber ?? ''),
                  ],
                ),
                const SizedBox(height: 24),

                // Courses
                if (currentFaculty.courses != null && currentFaculty.courses!.isNotEmpty) ...[
                  Text(
                    "Current Courses",
                    style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
                  ).animate().fadeIn(),
                  const SizedBox(height: 16),
                  ...currentFaculty.courses!.map((course) => _buildCourseCard(course)).toList(),
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

  Widget _buildCourseCard(course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course.courseCode,
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: UltimateTheme.primary, fontSize: 12),
                ),
              ),
              const Spacer(),
              Text("${course.credits} Credits", style: GoogleFonts.inter(fontSize: 12, color: UltimateTheme.textSub)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            course.courseName,
            style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: UltimateTheme.textSub),
              const SizedBox(width: 4),
              Text(course.primaryRoom, style: GoogleFonts.inter(fontSize: 13, color: UltimateTheme.textSub)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}
