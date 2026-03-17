import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/models/achievement.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/provider/user_bundle_provider.dart';
import 'edit_profile.dart';

class StudentProfile extends ConsumerWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.currentUser == null || authState.currentUser is! Student) {
      // Check if user needs onboarding
      if (authState.needsOnboarding && authState.sbUser != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/onboarding');
        });
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 64,
                  color: UltimateTheme.textSub.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'Profile not available',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: UltimateTheme.textSub,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login to view profile'),
              ),
            ],
          ),
        ),
      );
    }

    final Student currentStudent = authState.currentUser as Student;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Premium Profile Header
          SliverToBoxAdapter(
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                gradient: UltimateTheme.brandGradient,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                              width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          backgroundImage: currentStudent.profilePicURI != null
                              ? NetworkImage(currentStudent.profilePicURI!)
                              : null,
                          child: currentStudent.profilePicURI == null
                              ? const Icon(Icons.person_outline_rounded,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          curve: Curves.easeOutBack),
                      const SizedBox(height: 16),
                      Text(
                        currentStudent.name,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          currentStudent.rollNumber,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                  // Edit Action Button
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.edit_note_rounded,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen())),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Profile Content
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: UltimateTheme.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Academic Info Card
                    _buildSectionCard(
                      title: "Academic Profile",
                      icon: Icons.school_rounded,
                      children: [
                        _buildInfoRow(Icons.alternate_email_rounded, "Email",
                            currentStudent.email ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.account_tree_rounded, "Branch",
                            currentStudent.branch ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.calendar_today_rounded, "Class of",
                            "${currentStudent.graduationYear}"),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Roles & About
                    _buildSectionCard(
                      title: "About Me",
                      icon: Icons.person_search_rounded,
                      children: [
                        Text(
                          currentStudent.about ??
                              'Passionate student exploring the future of technology and innovation.',
                          style: GoogleFonts.inter(
                            color:
                                UltimateTheme.textMain.withValues(alpha: 0.7),
                            height: 1.6,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: (currentStudent.roles ?? [])
                              .map((role) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: UltimateTheme.primary
                                          .withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: UltimateTheme.primary
                                              .withValues(alpha: 0.1)),
                                    ),
                                    child: Text(
                                      role.toUpperCase(),
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: UltimateTheme.primary,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Skills Section
                    if (currentStudent.skills != null &&
                        currentStudent.skills!.isNotEmpty) ...[
                      _buildSectionHeader(
                          "Expertise & Skills", Icons.bolt_rounded),
                      const SizedBox(height: 20),
                      ...currentStudent.skills!.map((skill) =>
                          _buildSkillProgress(
                              skill.name ?? '', skill.level.toDouble())),
                      const SizedBox(height: 32),
                    ],

                    // Achievements Section
                    if (currentStudent.achievements != null &&
                        currentStudent.achievements!.isNotEmpty) ...[
                      _buildSectionHeader(
                          "Milestones & Rewards", Icons.emoji_events_rounded),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: currentStudent.achievements!.length,
                          itemBuilder: (context, index) =>
                              _buildAchievementCard(
                                  currentStudent.achievements![index], index),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Hub-Integrated Academic Progress
                    Consumer(
                      builder: (context, ref, child) {
                        final bundleState = ref.watch(userBundleProvider);

                        return bundleState.when(
                          data: (bundle) {
                            final acadmap = bundle?.academics?.acadmap;
                            if (acadmap == null) return const SizedBox.shrink();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader("Ecosystem Academic Status",
                                    Icons.auto_awesome_rounded),
                                const SizedBox(height: 20),
                                _buildSectionCard(
                                  title: "Registration Summary",
                                  icon: Icons.assignment_turned_in_rounded,
                                  children: [
                                    _buildInfoRow(Icons.layers_rounded,
                                        "Program", acadmap.program ?? 'N/A'),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                        Icons.history_edu_rounded,
                                        "Completed",
                                        "${acadmap.completedCourses.length} Courses"),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Completed Curriculum",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: UltimateTheme.textMain
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: acadmap.completedCourses
                                      .map((course) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withValues(alpha: 0.05),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.green
                                                      .withValues(alpha: 0.1)),
                                            ),
                                            child: Text(
                                              course,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, __) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: UltimateTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: UltimateTheme.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Text(title,
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: UltimateTheme.textMain)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(
                height: 1, thickness: 1, color: UltimateTheme.skeletonGrey),
          ),
          ...children,
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon,
            size: 16, color: UltimateTheme.textSub.withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.inter(
              color: UltimateTheme.textSub,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        const Spacer(),
        Text(value,
            style: GoogleFonts.inter(
              color: UltimateTheme.textMain,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: UltimateTheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: UltimateTheme.textMain),
        ),
      ],
    );
  }

  Widget _buildSkillProgress(String name, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: UltimateTheme.textMain.withValues(alpha: 0.9),
                    fontSize: 15,
                  )),
              Text("${level.toInt()}%",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w900,
                    color: UltimateTheme.primary,
                    fontSize: 14,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                height: 8,
                width: 300 * (level / 100), // Approximate proportional width
                decoration: BoxDecoration(
                  gradient: UltimateTheme.brandGradient,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: UltimateTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int index) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
          ),
          const Spacer(),
          Text(
            achievement.name ?? 'Accomplishment',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold,
              color: UltimateTheme.textMain,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            achievement.description ??
                'A significant milestone reached in the academic journey.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: UltimateTheme.textSub,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
