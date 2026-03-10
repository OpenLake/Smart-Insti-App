import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';

class AcadTimetableScreen extends ConsumerStatefulWidget {
  const AcadTimetableScreen({super.key});

  @override
  ConsumerState<AcadTimetableScreen> createState() =>
      _AcadTimetableScreenState();
}

class _AcadTimetableScreenState extends ConsumerState<AcadTimetableScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(acadmapProvider.notifier).fetchTimetable();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(acadmapProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: state.timetableSearchController,
              onChanged: (value) =>
                  ref.read(acadmapProvider.notifier).searchTimetable(value),
              decoration: InputDecoration(
                hintText: "Search by course or instructor...",
                prefixIcon:
                    const Icon(Icons.search, color: UltimateTheme.accent),
                filled: true,
                fillColor: UltimateTheme.accent.withValues(alpha: 0.05),
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
                itemCount: state.filteredTimetable.length,
                itemBuilder: (context, index) {
                  final item = state.filteredTimetable[index];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: UltimateTheme.accent.withValues(alpha: 0.1)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: UltimateTheme.accent
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.code,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: UltimateTheme.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.person_outline,
                              "Instructor: ${item.instructor}"),
                          _buildDetailRow(Icons.location_on_outlined,
                              "Lecture: ${item.lectureSlot} (${item.lectureVenue})"),
                          if (item.labSlot != "NA")
                            _buildDetailRow(Icons.biotech_outlined,
                                "Lab: ${item.labSlot} (${item.labVenue})"),
                          _buildDetailRow(Icons.school_outlined,
                              "Program: ${item.program} - ${item.discipline}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: UltimateTheme.textSub),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style:
                  GoogleFonts.inter(fontSize: 13, color: UltimateTheme.textSub),
            ),
          ),
        ],
      ),
    );
  }
}
