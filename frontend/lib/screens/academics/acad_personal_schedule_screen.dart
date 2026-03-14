import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/provider/user_bundle_provider.dart';
import 'package:smart_insti_app/utils/timetable_utils.dart';
import 'package:smart_insti_app/models/acad_course.dart';
import 'package:smart_insti_app/components/course_detail_sheet.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AcadPersonalScheduleScreen extends ConsumerStatefulWidget {
  const AcadPersonalScheduleScreen({super.key});

  @override
  ConsumerState<AcadPersonalScheduleScreen> createState() => _AcadPersonalScheduleScreenState();
}

class _AcadPersonalScheduleScreenState extends ConsumerState<AcadPersonalScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Set initial tab to today (clamped to Fri if it's Sat/Sun)
    int initialIndex = DateTime.now().weekday - 1;
    if (initialIndex > 4) initialIndex = 0;
    if (initialIndex < 0) initialIndex = 0;
    _tabController.index = initialIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bundleState = ref.watch(userBundleProvider);
    final acadmapState = ref.watch(acadmapProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Weekly Schedule",
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: UltimateTheme.textMain,
        bottom: TabBar(
          controller: _tabController,
          labelColor: UltimateTheme.primary,
          unselectedLabelColor: UltimateTheme.textSub,
          indicatorColor: UltimateTheme.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: _days.map((day) => Tab(text: day.substring(0, 3))).toList(),
        ),
      ),
      body: bundleState.when(
        data: (bundle) {
          if (bundle == null) return _buildCenterText("Please log in to view schedule");
          
          final selectedCodes = bundle.academics?.acadmap?.selectedCourses ?? [];
          if (selectedCodes.isEmpty) return _buildCenterText("No courses selected in Acadmap");

          final weeklySchedule = TimetableUtils.getWeeklyClasses(acadmapState.timetable, selectedCodes);

          return TabBarView(
            controller: _tabController,
            children: List.generate(5, (index) {
              final dayIndex = index + 1;
              final classes = weeklySchedule[dayIndex] ?? [];
              
              if (classes.isEmpty) {
                return _buildCenterText("No classes scheduled for ${_days[index]}");
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: classes.length,
                itemBuilder: (context, i) {
                  final item = classes[i];
                  final startTime = item['startTime'] as TimeOfDay;
                  final endTime = item['endTime'] as TimeOfDay;
                  final courseCode = item['timetable'].code;
                  
                  // Find course detail match
                  final course = acadmapState.courses.firstWhere(
                    (c) {
                      final catalogCodes = c.code
                          .toLowerCase()
                          .split('/')
                          .map((s) => s.trim());
                      final tCode = courseCode.toLowerCase().trim();
                      return catalogCodes.any((cc) => cc == tCode);
                    },
                    orElse: () => AcadCourse(
                        id: '',
                        code: courseCode,
                        title: item['timetable'].title,
                        department: item['timetable'].discipline,
                        credits: item['timetable'].credits,
                        syllabus: []),
                  );

                  return _buildClassTile(context, item, course, startTime, endTime, i);
                },
              );
            }),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildCenterText("Error: $e"),
      ),
    );
  }

  Widget _buildClassTile(BuildContext context, Map<String, dynamic> item, AcadCourse course, TimeOfDay start, TimeOfDay end, int index) {
    final timeStr = "${_formatTime(start)} - ${_formatTime(end)}";
    final type = item['type'] as String;
    final venue = item['venue'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UltimateTheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => showCourseDetail(context, course),
        contentPadding: const EdgeInsets.all(20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: UltimateTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeStr,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: UltimateTheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item['slot'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UltimateTheme.textSub.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              course.title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: UltimateTheme.textMain,
              ),
            ),
          ],
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: UltimateTheme.textSub),
                const SizedBox(width: 4),
                Text(
                  "$venue • $type",
                  style: GoogleFonts.inter(fontSize: 13, color: UltimateTheme.textSub),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: UltimateTheme.textSub.withValues(alpha: 0.3)),
      ),
    ).animate(delay: (index * 50).ms).fadeIn().slideY(begin: 0.1);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Widget _buildCenterText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: UltimateTheme.textSub),
        ),
      ),
    );
  }
}
