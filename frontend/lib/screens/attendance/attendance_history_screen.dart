
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/attendance_service.dart';

final attendanceHistoryProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(attendanceServiceProvider).getAttendanceHistory();
});

final attendanceStatsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(attendanceServiceProvider).getAttendanceStats();
});

class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(attendanceHistoryProvider);
    final statsAsync = ref.watch(attendanceStatsProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Attendance", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            Text("Overview", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            statsAsync.when(
                data: (stats) => stats.isEmpty 
                    ? _buildEmptyStats()
                    : SizedBox(
                        height: 140,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stats.length,
                            itemBuilder: (context, index) {
                                final stat = stats[index];
                                return _buildStatCard(stat);
                            },
                        ),
                    ),
                error: (err, stack) => Text("Error loading stats: $err"),
                loading: () => const Center(child: CircularProgressIndicator())
            ),

            const SizedBox(height: 24),
            
            // History Section
            Text("History", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            historyAsync.when(
                data: (history) => history.isEmpty
                    ? const Center(child: Text("No attendance records found"))
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                            final record = history[index];
                            return _buildHistoryItem(record);
                        },
                    ),
                error: (err, stack) => Text("Error loading history: $err"),
                loading: () => const Center(child: CircularProgressIndicator())
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
              context.push('/user_home/attendance/scan');
          },
          backgroundColor: UltimateTheme.primaryColor,
          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
          label: Text("Scan QR", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyStats() {
      return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: UltimateTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text("No stats available", style: GoogleFonts.outfit(color: Colors.grey))),
      );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
      final percentage = stat['percentage'] as num;
      Color color = percentage >= 75 ? Colors.green : (percentage >= 60 ? Colors.orange : Colors.red);

      return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: UltimateTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Text(stat['courseCode'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                   const SizedBox(height: 8),
                   Text("${percentage.toStringAsFixed(1)}%", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                   const SizedBox(height: 4),
                   Text("${stat['presentCount']}/${stat['totalSessions']} Sessions", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
              ],
          ),
      );
  }

  Widget _buildHistoryItem(Map<String, dynamic> record) {
      final date = DateTime.parse(record['date']);
      return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: UltimateTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
              children: [
                   Container(
                       padding: const EdgeInsets.all(10),
                       decoration: BoxDecoration(
                           color: UltimateTheme.primaryColor.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(10)
                       ),
                       child: const Icon(Icons.check_circle, color: UltimateTheme.primaryColor),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                       child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                               Text(record['course']['name'] ?? 'Unknown Course', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                               Text(DateFormat('MMM dd, yyyy • hh:mm a').format(date), style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                           ],
                       ),
                   ),
                   Container(
                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                       decoration: BoxDecoration(
                           color: Colors.green[50], 
                           borderRadius: BorderRadius.circular(8)
                       ),
                       child: Text("Present", style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                   )
              ],
          ),
      );
  }
}
