import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';

import 'package:smart_insti_app/provider/user_bundle_provider.dart';
import 'package:smart_insti_app/components/course_detail_sheet.dart';
import 'package:go_router/go_router.dart';

class AcadCoursesScreen extends ConsumerStatefulWidget {
  const AcadCoursesScreen({super.key});

  @override
  ConsumerState<AcadCoursesScreen> createState() => _AcadCoursesScreenState();
}

class _AcadCoursesScreenState extends ConsumerState<AcadCoursesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(acadmapProvider.notifier).fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(acadmapProvider);
    final bundleState = ref.watch(userBundleProvider);
    final academics = bundleState.value?.academics?.acadmap;

    final filter = GoRouterState.of(context).uri.queryParameters['filter'];

    List<dynamic> displayCourses = state.filteredCourses;

    if (filter != null && academics != null) {
      if (filter == 'registered') {
        displayCourses = state.filteredCourses
            .where((c) => academics.selectedCourses
                .any((code) => code == c.code || code.split('/').contains(c.code)))
            .toList();
      } else if (filter == 'completed') {
        displayCourses = state.filteredCourses
            .where((c) => academics.completedCourses
                .any((code) => code == c.code || code.split('/').contains(c.code)))
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: state.courseSearchController,
              onChanged: (value) =>
                  ref.read(acadmapProvider.notifier).searchCourses(value),
              decoration: InputDecoration(
                hintText: filter == 'registered'
                    ? "Search in registered courses..."
                    : filter == 'completed'
                        ? "Search in completed courses..."
                        : "Search courses by name or code...",
                prefixIcon: const Icon(Icons.search,
                    color: UltimateTheme.primary),
                filled: true,
                fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(child: Center(child: Text("Error: ${state.error}")))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: displayCourses.length,
                itemBuilder: (context, index) {
                  final course = displayCourses[index];
                  
                  bool isRegistered = academics?.selectedCourses.any((code) => code == course.code || code.split('/').contains(course.code)) ?? false;
                  bool isCompleted = academics?.completedCourses.any((code) => code == course.code || code.split('/').contains(course.code)) ?? false;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: UltimateTheme.primary.withValues(alpha: 0.1)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        course.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: UltimateTheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.code,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: UltimateTheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${course.credits} Credits",
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: UltimateTheme.textSub),
                              ),
                              const Spacer(),
                              if (isCompleted)
                                Text("✅ Completed", style: GoogleFonts.inter(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold))
                              else if (isRegistered)
                                Text("📌 Registered", style: GoogleFonts.inter(fontSize: 10, color: UltimateTheme.secondary, fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.department,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: UltimateTheme.textSub),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: UltimateTheme.textSub),
                      onTap: () => showCourseDetail(context, course),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

