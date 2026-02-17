import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../../provider/skills_edit_widget.dart';
import '../../provider/achievements_edit_widget.dart';
import '../../provider/about_Edit_widget.dart';
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
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // 1. Premium Header with SliverAppBar
          SliverAppBar(
            expandedHeight: 200,
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
                    const Icon(Icons.edit_note_rounded, color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      "Update Identity",
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Edit Sections
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildEditSection(
                  title: "Professional Bio",
                  icon: Icons.person_pin_rounded,
                  child: AboutEditWidget(
                    aboutController: TextEditingController(text: aboutControllerValue),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditSection(
                  title: "Core Skills",
                  icon: Icons.bolt_rounded,
                  child: SkillsEditWidget(
                    skillsController: TextEditingController(text: skillsJson),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditSection(
                  title: "Key Achievements",
                  icon: Icons.emoji_events_rounded,
                  child: AchievementsEditWidget(
                    achievementsController: TextEditingController(text: achievementsJson),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSection({required String title, required IconData icon, required Widget child}) {
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
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: UltimateTheme.textMain,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          child,
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
