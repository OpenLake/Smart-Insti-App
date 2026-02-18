
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/gamification_service.dart';

final leaderboardProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(gamificationServiceProvider).getLeaderboard();
});

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Leaderboard", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: leaderboardAsync.when(
        data: (students) {
            if (students.isEmpty) {
                return const Center(child: Text("No data yet"));
            }
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: students.length,
                itemBuilder: (context, index) {
                    final student = students[index];
                    final isTop3 = index < 3;
                    
                    return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isTop3 ? Colors.amber.withOpacity(0.1 + (0.1 * (3-index))) : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                            leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                    if (isTop3) Icon(Icons.star, size: 40, color: index == 0 ? Colors.amber : (index == 1 ? Colors.grey : Colors.brown)),
                                    Text(
                                        "${index + 1}", 
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold, 
                                            color: isTop3 ? Colors.white : Colors.black,
                                            fontSize: isTop3 ? 12 : 16
                                        )
                                    ),
                                ],
                            ),
                            title: Text(student['name'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            subtitle: Text("${student['xp']} XP • ${student['branch']}", style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                            trailing: CircleAvatar(
                                backgroundImage: student['profilePicURI'] != null ? NetworkImage(student['profilePicURI']) : null,
                                radius: 18,
                                child: student['profilePicURI'] == null ? Text(student['name'][0]) : null,
                            ),
                        ),
                    );
                },
            );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e"))
      ),
    );
  }
}
