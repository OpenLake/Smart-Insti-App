
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/services/analytics_service.dart';

final analyticsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  return ref.read(analyticsServiceProvider).getDashboardStats();
});

class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Admin Dashboard", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: analyticsAsync.when(
        data: (data) {
            if (data.isEmpty) return const Center(child: Text("No data available"));
            final counts = data['counts'];
            final recentComplaints = data['recentComplaints'] as List;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("Overview", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
                    const SizedBox(height: 16),
                    GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                            _buildStatCard("Students", counts['students'].toString(), Icons.school, Colors.blue),
                            _buildStatCard("Faculty", counts['faculty'].toString(), Icons.person_pin, Colors.purple),
                            _buildStatCard("Active Polls", counts['polls'].toString(), Icons.poll, Colors.orange),
                            _buildStatCard("Events", counts['events'].toString(), Icons.event, Colors.green),
                        ],
                    ),
                    const SizedBox(height: 24),
                    Text("Complaints", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
                    const SizedBox(height: 16),
                    Row(
                        children: [
                            Expanded(child: _buildStatCard("Pending", counts['complaints']['pending'].toString(), Icons.pending_actions, Colors.redAccent)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatCard("Resolved", counts['complaints']['resolved'].toString(), Icons.check_circle, Colors.teal)),
                        ],
                    ),
                    const SizedBox(height: 24),
                    Text("Recent Complaints", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
                    const SizedBox(height: 12),
                    ...recentComplaints.map((c) => Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                            title: Text(c['title'], style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                            subtitle: Text(c['student']?['name'] ?? 'Unknown', style: GoogleFonts.outfit()),
                            trailing: Chip(
                                label: Text(c['status']),
                                backgroundColor: c['status'] == 'Pending' ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                labelStyle: GoogleFonts.outfit(color: c['status'] == 'Pending' ? Colors.orange : Colors.green),
                            ),
                        ),
                    )).toList(),
                ],
              ),
            );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
      return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: UltimateTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
              border: Border.all(color: color.withOpacity(0.2))
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Icon(icon, color: color, size: 28),
                  const Spacer(),
                  Text(value, style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: UltimateTheme.textColor)),
                  Text(title, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13)),
              ],
          ),
      );
  }
}
