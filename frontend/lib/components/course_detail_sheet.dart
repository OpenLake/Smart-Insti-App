import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/models/acad_course.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailSheet extends StatelessWidget {
  final AcadCourse course;

  const CourseDetailSheet({super.key, required this.course});

  void _launchAcadmap() async {
    final url = Uri.parse('https://acadmap.openlake.in/courses/${course.code}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: UltimateTheme.textSub.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: UltimateTheme.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course.department,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: UltimateTheme.textSub,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.code,
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(
                      Icons.stars_rounded, "${course.credits} Credits"),
                  if (course.prerequisites != null &&
                      course.prerequisites!.isNotEmpty)
                    _buildInfoRow(Icons.list_alt_rounded,
                        "Prerequisites: ${course.prerequisites}"),
                  const SizedBox(height: 24),
                  if (course.syllabus.isNotEmpty) ...[
                    Text(
                      "Syllabus Preview",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...course.syllabus.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded,
                                  size: 16, color: UltimateTheme.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: UltimateTheme.textSub),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _launchAcadmap,
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(
                "View on Acadmap",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: UltimateTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: UltimateTheme.textSub),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: UltimateTheme.textMain,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showCourseDetail(BuildContext context, AcadCourse course) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CourseDetailSheet(course: course),
  );
}
