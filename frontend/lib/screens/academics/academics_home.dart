import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/user_bundle_provider.dart';

class AcademicsHome extends ConsumerWidget {
  const AcademicsHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) {
                final bundleState = ref.watch(userBundleProvider);
                final academics = bundleState.value?.academics?.acadmap;

                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildActionCard(
                        context,
                        title: "My Schedule",
                        icon: Icons.access_time_filled_rounded,
                        color: UltimateTheme.primary,
                        onTap: () => context
                            .push('/user_home/academics/personal_schedule'),
                      ),
                      _buildActionCard(
                        context,
                        title: "Timetable",
                        icon: Icons.calendar_month,
                        color: UltimateTheme.accent,
                        onTap: () =>
                            context.push('/user_home/academics/timetable'),
                      ),
                      _buildActionCard(
                        context,
                        title: "Courses",
                        icon: Icons.book,
                        color: UltimateTheme.secondary,
                        onTap: () =>
                            context.push('/user_home/academics/courses'),
                      ),
                      _buildActionCard(
                        context,
                        title: "Curriculum",
                        icon: Icons.account_tree,
                        color: UltimateTheme.navy,
                        onTap: () =>
                            context.push('/user_home/academics/curriculum'),
                      ),
                      if (academics != null) ...[
                        _buildActionCard(
                          context,
                          title: "${academics.selectedCourses.length} Registered",
                          icon: Icons.assignment_turned_in_rounded,
                          color: UltimateTheme.secondary,
                          onTap: () => context.push('/user_home/academics/courses?filter=registered'),
                        ),
                        _buildActionCard(
                          context,
                          title: "${academics.completedCourses.length} Completed",
                          icon: Icons.history_edu_rounded,
                          color: Colors.teal,
                          onTap: () => context.push('/user_home/academics/courses?filter=completed'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const Spacer(),
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
      ),
    );
  }
}
