import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../../provider/profile_edit_providers.dart';
import '../../components/profile/skills_edit_widget.dart';
import '../../components/profile/achievements_edit_widget.dart';
import '../../components/profile/about_edit_widget.dart';
import '../../provider/auth_provider.dart';
import 'dart:convert';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutControllerValue = ref.watch(aboutControllerProvider);
    final skills = ref.watch(skillsProvider);
    final achievements = ref.watch(achievementsProvider);

    String skillsJson = jsonEncode(skills);
    String achievementsJson = jsonEncode(achievements);

    return Scaffold(
      backgroundColor: UltimateTheme.background,
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: UltimateTheme.brandGradient,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 2),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Update Profile",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        "Refine your digital presence",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Edit Sections
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildEditSection(
                  title: "Professional Bio",
                  subtitle: "A brief summary of your background",
                  icon: Icons.person_pin_rounded,
                  child: AboutEditWidget(
                    aboutController:
                        TextEditingController(text: aboutControllerValue),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditSection(
                  title: "Core Skills",
                  subtitle: "Highlight what you're best at",
                  icon: Icons.bolt_rounded,
                  child: SkillsEditWidget(
                    skillsController: TextEditingController(text: skillsJson),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditSection(
                  title: "Key Achievements",
                  subtitle: "Showcase your milestones",
                  icon: Icons.emoji_events_rounded,
                  child: AchievementsEditWidget(
                    achievementsController:
                        TextEditingController(text: achievementsJson),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final profileData = {
            'about': ref.read(aboutControllerProvider),
            // In a more complex scenario, we'd map skills and achievements too
            // For now, let's just sync the 'about' field and basic fields if they were there
          };

          final success = await ref
              .read(authProvider.notifier)
              .updateProfile(context, profileData);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    success
                        ? 'Profile updated successfully'
                        : 'Failed to update profile',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                backgroundColor:
                    success ? UltimateTheme.primary : Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
            if (success) Navigator.of(context).pop();
          }
        },
        backgroundColor: UltimateTheme.primary,
        elevation: 4,
        icon: const Icon(Icons.check_rounded, color: Colors.white),
        label: Text(
          "Save Changes",
          style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(delay: 600.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildEditSection(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Widget child}) {
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
            offset: const Offset(0, 10),
          ),
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
                  color: UltimateTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: UltimateTheme.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: UltimateTheme.textMain,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: UltimateTheme.textSub,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }
}
