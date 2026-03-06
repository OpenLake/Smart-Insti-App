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
    final authState = ref.watch(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.sbUser != null &&
          ref.read(authProvider.notifier).tokenCheckProgress !=
              LoadingState.progress &&
          context.mounted) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(
            context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    if (authState.currentUser == null || authState.currentUser is! Faculty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Faculty currentFaculty = authState.currentUser as Faculty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Premium Faculty Header
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: UltimateTheme.brandGradient,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: Container(
                      width: 180,
                      height: 180,
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
                          child: const Icon(Icons.person_outline_rounded,
                              size: 50, color: Colors.white),
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          curve: Curves.easeOutBack),
                      const SizedBox(height: 20),
                      Text(
                        currentFaculty.name,
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
                          (currentFaculty.department ?? 'FACULTY')
                              .toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Body Content
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFFBFBFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Professional Info
                    _buildSectionCard(
                      title: "Professional Details",
                      icon: Icons.badge_rounded,
                      children: [
                        _buildInfoRow(Icons.alternate_email_rounded, "Email",
                            currentFaculty.email ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.business_rounded, "Department",
                            currentFaculty.department ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.meeting_room_rounded, "Office",
                            currentFaculty.cabinNumber ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Courses
                    if (currentFaculty.courses != null &&
                        currentFaculty.courses!.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.book_rounded,
                              color: UltimateTheme.primary, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            "Academic Courses",
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: UltimateTheme.textMain),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...currentFaculty.courses!
                          .asMap()
                          .entries
                          .map((entry) =>
                              _buildCourseCard(entry.value, entry.key))
                          .toList(),
                    ],
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
        color: Colors.white,
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
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F7)),
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

  Widget _buildCourseCard(course, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  course.courseCode,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w900,
                    color: UltimateTheme.primary,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("${course.credits} CREDITS",
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.amber.shade900)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            course.courseName,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: UltimateTheme.textMain,
              height: 1.2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F7)),
          ),
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  size: 16,
                  color: UltimateTheme.primary.withValues(alpha: 0.6)),
              const SizedBox(width: 8),
              Text(course.primaryRoom,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: UltimateTheme.textSub,
                    fontWeight: FontWeight.w600,
                  )),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: UltimateTheme.textSub.withValues(alpha: 0.3)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.05);
  }
}
