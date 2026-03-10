import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/models/acad_curriculum.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';

class AcadCurriculumScreen extends ConsumerStatefulWidget {
  const AcadCurriculumScreen({super.key});

  @override
  ConsumerState<AcadCurriculumScreen> createState() =>
      _AcadCurriculumScreenState();
}

class _AcadCurriculumScreenState extends ConsumerState<AcadCurriculumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(acadmapProvider.notifier).fetchCurriculum();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(acadmapProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text("Error: ${state.error}"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.curriculum.length,
                  itemBuilder: (context, index) {
                    final curr = state.curriculum[index];
                    return _buildCurriculumExpansionTile(curr);
                  },
                ),
    );
  }

  Widget _buildCurriculumExpansionTile(AcadCurriculum curr) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: UltimateTheme.navy.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        title: Text(
          curr.branch,
          style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
        ),
        subtitle: Text(
          curr.degree,
          style: GoogleFonts.inter(fontSize: 12, color: UltimateTheme.textSub),
        ),
        leading: const Icon(Icons.school, color: UltimateTheme.navy),
        childrenPadding: const EdgeInsets.all(16),
        children: curr.semesters.map((sem) => _buildSemesterTile(sem)).toList(),
      ),
    );
  }

  Widget _buildSemesterTile(AcadSemester sem) {
    return ExpansionTile(
      title: Text("Semester ${sem.semester}"),
      trailing: Text("${sem.totalCredits} Credits"),
      children: sem.courses
          .map((course) => ListTile(
                title: Text(course.name,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text("${course.code} | ${course.credits} Credits"),
                trailing: course.category != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: UltimateTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.category!,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: UltimateTheme.primary),
                        ),
                      )
                    : null,
              ))
          .toList(),
    );
  }
}
